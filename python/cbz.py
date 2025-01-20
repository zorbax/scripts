#!/usr/bin/env python
import argparse
import shutil
from pathlib import Path
from zipfile import ZipFile


class CbxManager:
    def __init__(
        self,
        input_path: str,
        verbose: bool,
    ):
        self.verbose = verbose
        self.input_path = Path(input_path)

    def parse_dir(self, input_dir: Path):
        input_dir = Path(input_dir)
        path_deconstruct = list(input_dir.parts)
        folder = path_deconstruct[-1]

        if self.verbose:
            print(f"Parsing folder: {folder}")

        out_cbz = input_dir.with_suffix(".cbz")
        images = [".png", ".jpg", ".jpeg"]

        with ZipFile(out_cbz, "w") as myzip:
            for file in sorted(input_dir.iterdir()):
                if file.suffix.lower() in images:
                    if self.verbose:
                        print(f"        Adding {file}")
                    myzip.write(file, arcname=file.name)
            if self.verbose:
                print(f"    CBZ created: {out_cbz}")

    def parse_cbz(self, input_file: Path):
        input_file = Path(input_file)
        cbr_file = input_file.name
        path_out = input_file.with_suffix("")

        if self.verbose:
            print(f"Parsing CBZ file: {cbr_file}")

        with ZipFile(input_file, "r") as myzip:
            files_to_extract = myzip.namelist()
            path_out.mkdir(exist_ok=True)
            for tmp_file in files_to_extract:
                name = Path(tmp_file).name
                dest_file = path_out / name
                if self.verbose:
                    print(f"        Extracting {dest_file}")
                with open(dest_file, "wb") as tmp_img:
                    tmp_img.write(myzip.read(tmp_file))
            if self.verbose:
                print(f"    CBZ extracted to {path_out}")

    @staticmethod
    def rename_chapter(chapt_path: Path) -> None:
        patterns = [".png", ".jpg", ".jpeg"]
        for f in chapt_path.iterdir():
            if f.suffix in patterns:
                print(f"Renaming {chapt_path.name}/{f.name}")
                new_name = (
                    chapt_path.parent
                    / f"{chapt_path.name.replace(' ', '_')}_{f.stem}{f.suffix}"
                )
                f.rename(new_name)
            else:
                print(f"{chapt_path} is empty")
        shutil.rmtree(chapt_path)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Process folders to CBZ",
        formatter_class=argparse.RawTextHelpFormatter,
    )
    parser.add_argument("input_data", help="Path to the folder or CBZ")
    parser.add_argument(
        "-n",
        action="store_true",
        default=False,
        help="Rename chapters for each Volume",
    )
    parser.add_argument("-v", action="store_true", default=True, help="verbose")
    args = parser.parse_args()

    input_data = Path(args.input_data).resolve()

    cbx = CbxManager(input_path=input_data, verbose=args.v)

    if args.n:
        tomos_path = input_data

        chapters = [x for x in tomos_path.iterdir() if x.is_dir()]
        if not chapters:
            print("No Chapters in the folder")
        for chapter in chapters:
            cbx.rename_chapter(chapter)
    else:
        if not isinstance(input_data, list):
            input_data = [input_data]
        for volume in input_data:
            volume_path = Path(volume)
            if volume_path.suffix == ".cbz":
                cbx.parse_cbz(volume_path)
            elif volume_path.is_dir():
                cbx.parse_dir(volume_path)
            else:
                print(f"Do not know what it is: {volume_path}")
