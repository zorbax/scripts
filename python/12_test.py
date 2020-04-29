#!/usr/bin/env python3

__version__ = 0.1

from os import EX_OK
import sys
from typing import List
from typing import Optional
from argparse import Namespace
from argparse import ArgumentParser
from argparse import ArgumentDefaultsHelpFormatter


def test(args: Namespace) -> int:
    return EX_OK


def parse_args(args: List[str]) -> Namespace:
    description = __doc__.splitlines()[0].partition(": ")[2]
    parser = ArgumentParser(description=description,
                            formatter_class=ArgumentDefaultsHelpFormatter)

    version = f"%(prog)s {__version__}"
    parser.add_argument("--version", action="version", version=version)

    return parser.parse_args(args)


def main(argv=None) -> int:
    if argv is None:
        argv = sys.argv[1:]
    arg = parse_args(argv)
    return test(args)


if __name__ == "__main__":
    sys.exit(main())