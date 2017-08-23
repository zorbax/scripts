#!/usr/bin/python

from Bio import SeqIO
from itertools import count
import sys

fake_header = "M12345:001:00000000-AAAAA:{n}:{n:05}:{n:05}:{n:04} {r}:N:0:AATTGGCC+AATTGGCC"

with open(sys.argv[1], 'r') as forward:
    with open(sys.argv[2], 'r') as reverse:
        try:
            fw = open(sys.argv[3], 'w')
            rw = open(sys.argv[4], 'w')
        except IndexError:
            fw = rw = sys.stdout
        for fr, rv, ind in zip(SeqIO.parse(forward, 'fastq'), SeqIO.parse(reverse, 'fastq'), count()):
            fr.id = fr.name = fake_header.format(n=ind, r=1)
            rv.id = rv.name = fake_header.format(n=ind, r=2)
            fr.description = rv.description = ''
            SeqIO.write(fr, fw, 'fastq')
            SeqIO.write(rv, rw, 'fastq')  
