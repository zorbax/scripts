#!/usr/bin/env python3

from pathlib import Path
import sys
import csv


def main():

    if len(sys.argv) != 2:
        print(f"\nUsage: ./{Path(sys.argv[0]).name}, file.csv",
              file=sys.stderr)
        sys.exit(1)

    input_file = open(sys.argv[1], 'r')
    output_file = open(Path(sys.argv[1]).stem + '.csv', 'w')

    tsvtable = csv.reader(input_file, dialect=csv.excel_tab)
    csvtable = csv.writer(output_file, dialect=csv.excel)

    for row in tsvtable:
        csvtable.writerow(row)


if __name__ == '__main__':
    main()
