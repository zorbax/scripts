#!/usr/bin/env python3

import sys,gzip
from Bio import SeqIO
from itertools import count

fake_header = "NS500502:001:HT3KMBGXY:{n}:{n:05}:{n:05}:{n:04} {r}:N:0:CTGAAGCT+AGGATAGG"

with gzip.open(sys.argv[1], 'rt', encoding='utf-8') as forward:
    with gzip.open(sys.argv[2], 'rt', encoding='utf-8') as reverse:
        try:
            fw = gzip.open(sys.argv[3], 'wt')
            rw = gzip.open(sys.argv[4], 'wt')
        except IndexError:
            fw = rw = sys.stdout
        for fr, rv, ind in zip(SeqIO.parse(forward, 'fastq'), SeqIO.parse(reverse, 'fastq'), count()):
            fr.id = fr.name = fake_header.format(n=ind, r=1)
            rv.id = rv.name = fake_header.format(n=ind, r=2)
            fr.description = rv.description = ''
            SeqIO.write(fr, fw, 'fastq')
            SeqIO.write(rv, rw, 'fastq')
