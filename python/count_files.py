#!/usr/bin/env python3

from pathlib import Path
import sys


def main():
    if len(sys.argv) != 2:
        basename = Path(__file__).name
        print(f"\nUsage: {basename} <extension>\n", file=sys.stderr)
        sys.exit(1)

    def count_files(extension):
        ext = f'*{extension}'
        return len(list(Path.cwd().glob(ext)))

    print(count_files(sys.argv[1]))


if __name__ == '__main__':
    main()
