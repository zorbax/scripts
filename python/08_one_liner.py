#!/usr/bin/env python3
import sys
import re


def argsCheck(numArgs):
    if len(sys.argv) != numArgs:
        print("Convert multiline FASTA to single line FASTA\n")
        print("Usage: " + sys.argv[0] + " [sequence.fasta]")
        exit(1)


argsCheck(2)

input_file = sys.argv[1]
output_file = input_file

with open(input_file, "r") as fasta_file:
    fasta_data = fasta_file.read()
    sequences = re.findall(">[^>]+", fasta_data)

with open(output_file, "w") as fasta:
    for i in sequences:
        header, seq = i.split("\n", 1)
        header += "\n"
        seq = seq.replace("\n", "") + "\n"
        fasta.write(header + seq)

fasta.close()
