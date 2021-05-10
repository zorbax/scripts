#!/usr/bin/env python3

import os
import sys
import gzip
from Bio import SeqIO
from itertools import count


seqid = 'NS500502:001:HT3KMBGXY'
fake_header = seqid + ":{n}:{n:05}:{n:05}:{n:04} {r}:N:0:CTGAAGCT+AGGATAGG"


def main():
    if len(sys.argv) != 3:
        basename = os.path.basename(sys.argv[0])
        print(f"\nUsage: ./{basename} <forward.fastq.gz> <revers.fastq.gz>\n",
              file=sys.stderr)
        sys.exit(1)

    with gzip.open(sys.argv[1], 'rt', encoding='utf-8') as forward:
        with gzip.open(sys.argv[2], 'rt', encoding='utf-8') as reverse:
            try:
                fw = gzip.open(sys.argv[3], 'wt')
                rw = gzip.open(sys.argv[4], 'wt')
            except IndexError:
                fw = rw = sys.stdout
            for fr, rv, ind in zip(SeqIO.parse(forward, 'fastq'),
                                   SeqIO.parse(reverse, 'fastq'),
                                   count()):
                fr.id = fr.name = fake_header.format(n=ind, r=1)
                rv.id = rv.name = fake_header.format(n=ind, r=2)
                fr.description = rv.description = ''
                SeqIO.write(fr, fw, 'fastq')
                SeqIO.write(rv, rw, 'fastq')


if __name__ == '__main__':
    main()
