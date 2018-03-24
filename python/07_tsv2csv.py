#!/usr/bin/env python3

import sys,csv

def main():

    input_file  = open(sys.argv[1], 'r')
    output_file = open(sys.argv[2], 'w')

    tsvtable = csv.reader(input_file, dialect=csv.excel_tab)
    csvtable = csv.writer(output_file, dialect=csv.excel)

    for row in tsvtable:
        csvtable.writerow(row)

if __name__ == '__main__':
    main()
