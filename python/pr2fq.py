import argparse
import sys
from io import StringIO
from pathlib import Path

import pandas as pd
import requests
from tqdm import tqdm


def read_params():
    p = argparse.ArgumentParser(
        description="Download FASTQ files from ENA",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    p.add_argument("url", type=str, metavar="\b", help="[BioProject ID]")

    if len(sys.argv) == 1:
        p.print_help()
        p.exit()

    return p.parse_args()


def download_url(url: str, fname: str, chunk_size: int = 1024) -> None:
    r = requests.get(url, stream=True, allow_redirects=True)
    total = int(r.headers.get("Content-Length", 0))
    with open(fname, "wb") as file, tqdm(
        total=total,
        unit="iB",
        unit_scale=True,
        unit_divisor=1024,
    ) as bar:
        for data in r.iter_content(chunk_size=chunk_size):
            size = file.write(data)
            bar.update(size)


def ena_err(id_err: str) -> None:
    fields = (
        "study_accession,sample_accession,"
        "experiment_accession,run_accession,"
        "tax_id,scientific_name,fastq_ftp,sra_ftp"
    )

    r = requests.get(
        f"https://www.ebi.ac.uk/ena/portal/api/filereport?accession={id_err}"
        f"&result=read_run&fields={fields}&format=tsv&download=true"
    ).content.decode("utf-8")
    df = pd.read_csv(StringIO(r), sep="\t")
    df.to_csv(f"{id_err}.tsv", sep="\t", index=False)

    urls = df["fastq_ftp"].str.split(";").explode().tolist()
    out_dir = Path.cwd() / id_err
    out_dir.mkdir(parents=True, exist_ok=True)

    for url in urls:
        fname = url.split("/")[-1]
        if "://" in url:
            pass
        else:
            url = f"https://{url}"

        print(f"Downloading {fname}")

        download_url(url, str(out_dir / fname))


if "__main__" == __name__:
    args = read_params()
    err_id = args.url
    ena_err(err_id)
