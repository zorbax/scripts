#!/usr/bin/env python
import argparse
import os
import shutil
from pathlib import Path
from zipfile import ZipFile


class CbxManager:
    def __init__(
        self,
        input_path: str,
        verbose: bool,
        sep: str = os.sep,
    ):
        self.verbose = verbose
        self.sep = sep
        self.input_path = input_path

    def parse_dir(self, input_dir):
        path_deconstruct = [x for x in input_dir.split(self.sep) if x != ""]
        folder = path_deconstruct[-1]

        if self.verbose:
            print(f"Parsing folder: {folder}")
        path_deconstruct[-1] += ".cbz"
        print(path_deconstruct, folder)
        out_cbz = os.path.join(*path_deconstruct)  # Note: list to args=*
        if input_dir[0] == self.sep:
            out_cbz = self.sep + out_cbz

        images = ["png", "jpg", "jpeg"]

        with ZipFile(out_cbz, "w") as myzip:
            for files in sorted(os.listdir(input_dir)):
                ext = files[-3:].lower()
                if ext in images:
                    file_to_add = os.path.join(input_dir, files)
                    if self.verbose:
                        print(f"        Adding {file_to_add}")
                    myzip.write(file_to_add, arcname=files)
            if self.verbose:
                print(f"    CBZ created: {out_cbz}")

    def parse_cbz(self, input_file: str):
        path_deconstruct = [x for x in input_file.split(self.sep) if x != ""]
        cbr_file = path_deconstruct[-1]
        path_out = input_file.replace(".cbz", "")
        if self.verbose:
            print(f"Parsing cbr files: {cbr_file}")
        with ZipFile(input_file, "r") as myzip:
            files_to_extract = myzip.namelist()
            try:
                os.mkdir(path_out)
            except OSError:
                pass
            for tmp_file in files_to_extract:
                name = tmp_file.split(self.sep)[-1]
                if self.verbose:
                    print(f"        Extracting {path_out}{self.sep}{name}")
                with open(f"{path_out}{self.sep}{name}", "wb") as tmp_img:
                    tmp_img.write(myzip.read(tmp_file))
            if self.verbose:
                print(f"    CBZ extracted to {path_out}")

    @staticmethod
    def rename_chapter(chapt_path: Path) -> None:
        patterns = [".png", ".jpg", "jpeg"]
        for f in chapt_path.iterdir():
            if f.suffix in patterns:
                print(f"Renaming {chapt_path.name}/{f.name}")
                f.rename(
                    chapt_path.parent
                    / f"{chapt_path.name.replace(' ', '_')}_{f.stem}{f.suffix}"
                )
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

    input_data = args.input_data

    cbx = CbxManager(input_path=input_data, verbose=args.v)

    if args.n:
        tomos_path = Path(input_data).resolve()

        chapters = [x for x in tomos_path.iterdir() if x.is_dir()]
        if not chapters:
            print("No Chapters in the folder")
        for i in chapters:
            cbx.rename_chapter(i)
    else:
        if not isinstance(input_data, list):
            input_data = [input_data]
        for volume in input_data:
            if volume[-4:] == ".cbz":
                cbx.parse_cbz(volume)
            elif os.path.isdir(volume):
                cbx.parse_dir(volume)
            else:
                print(f"Do not know what it is: {volume}")
