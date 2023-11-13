#!/usr/bin/env python

import argparse
import hashlib
import shutil
import sys
from io import StringIO
from pathlib import Path
from typing import Dict, List, Tuple

import pandas as pd
import requests
from psutil import cpu_count
from tqdm import tqdm
from tqdm.contrib.concurrent import thread_map


def read_params():
    p = argparse.ArgumentParser(
        description="Download FASTQ files from ENA",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    p.add_argument(
        "-i", "--bioproject", type=str, metavar="", required=True, help="BioProject ID"
    )
    p.add_argument(
        "-p",
        "--cpus",
        type=int,
        default=cpu_count(),
        metavar="",
        required=False,
        help="Threads",
    )

    if len(sys.argv) == 1:
        p.print_help()
        p.exit()

    return p.parse_args()


def download_url(input_file: Tuple[str, str, Path]) -> None:
    fname, url, output_dir = input_file[0], input_file[1], input_file[2]
    r = requests.get(url, stream=True, allow_redirects=True, timeout=20)
    file_size = int(r.headers.get("Content-Length", 0))

    with tqdm.wrapattr(r.raw, "read", total=file_size, desc=fname) as r_raw:
        with open(output_dir / fname, "wb") as file:
            shutil.copyfileobj(r_raw, file)


def fix_urls(urls: list) -> Dict[str, str]:
    urls_dict = {}
    for url in urls:
        filename = url.split("/")[-1]
        if "://" in url:
            pass
        else:
            url = f"https://{url}"
        urls_dict[filename] = url

    return urls_dict


def ena_urls(id_err: str) -> Dict[str, str]:
    fields = (
        "study_accession,sample_accession,"
        "experiment_accession,run_accession,"
        "tax_id,scientific_name,fastq_ftp,fastq_md5"
    )

    r = requests.get(
        f"https://www.ebi.ac.uk/ena/portal/api/filereport?accession={id_err}"
        f"&result=read_run&fields={fields}&format=tsv&download=true",
        timeout=20,
    ).content.decode("utf-8")
    df = pd.read_csv(StringIO(r), sep="\t")
    df.to_csv(f"{id_err}.tsv", sep="\t", index=False)

    urls = df["fastq_ftp"].str.split(";").explode().tolist()

    return fix_urls(urls)


def md5_hash(filename, block_size=2**20):
    md5 = hashlib.md5()
    with open(filename, "rb") as file:
        while True:
            data = file.read(block_size)
            if not data:
                break
            md5.update(data)
    return md5.hexdigest()


def thread_map_urls(url_dict: Dict[str, str], outdir: Path, cpu: int) -> None:
    iter_url = [(k, v, outdir) for k, v in url_dict.items()]
    thread_map(download_url, iter_url, max_workers=cpu)


def checksums(id_err: str, output_dir: Path, file_lst: List[str], threads: int) -> None:
    df = pd.read_csv(f"{id_err}.tsv", sep="\t")[["fastq_ftp", "fastq_md5"]]

    dfmd5 = pd.concat([df[x].str.split(";").explode() for x in df.columns], axis=1)
    dfmd5["file"] = dfmd5["fastq_ftp"].str.split("/").str[-1]

    chk = set(dfmd5["file"].to_list()) - set(file_lst)

    def compare_lists(
        df_md5: pd.DataFrame, test_list: List[str], outdir: Path, n_cpus: int
    ) -> None:
        compare = df_md5["file"].isin(test_list)
        missing_files = fix_urls(df_md5[compare]["fastq_ftp"].to_list())
        thread_map_urls(missing_files, outdir, n_cpus)

    if len(chk) > 0:
        compare_lists(dfmd5, list(chk), output_dir, threads)

    urls_dict = dict(zip(dfmd5["file"], zip(dfmd5["fastq_md5"], dfmd5["fastq_ftp"])))
    md5_failed = [
        f for f in urls_dict.keys() if urls_dict[f][0] != md5_hash(output_dir / f)
    ]
    compare_lists(dfmd5, md5_failed, output_dir, threads)


if "__main__" == __name__:
    args = read_params()
    err_id = args.bioproject
    cpus = args.cpus

    out_dir = Path.cwd() / err_id
    out_dir.mkdir(parents=True, exist_ok=True)

    files = [x.name for x in Path.glob(out_dir, "*.fastq.gz")]

    if len(files) > 0:
        print("Checking files...")
        checksums(err_id, out_dir, files, cpus)
    else:
        err_urls = ena_urls(err_id)
        thread_map_urls(err_urls, out_dir, cpus)
