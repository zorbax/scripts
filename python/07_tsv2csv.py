#!/usr/bin/env python3

from pathlib import Path
import sys
import os
import csv


def main():

    if len(sys.argv) != 2:
        print('\nUsage: ./%s file.csv'
              % os.path.basename(sys.argv[0]), file=sys.stderr)
        sys.exit(1)

    input_file = open(sys.argv[1], 'r')
    # output_file = open(sys.argv[2], 'w')
    # output_file = open(os.path.splitext(sys.argv[1])[0]+'.csv', 'w')
    output_file = open(Path(sys.argv[1]).stem + '.csv', 'w')

    tsvtable = csv.reader(input_file, dialect=csv.excel_tab)
    csvtable = csv.writer(output_file, dialect=csv.excel)

    for row in tsvtable:
        csvtable.writerow(row)


if __name__ == '__main__':
    main()
