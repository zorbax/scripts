#!/usr/bin/python
from __future__ import print_function
import subprocess

srrs = [ "SRR5921431", "SRR5888364", "SRR5888413",
        "SRR5932688", "SRR5921432", "SRR5921441", "SRR5921437"]

with open('acc.txt', 'r') as srrid:
    srrs = srrid.read().split("\n")

for i in srrs:
    print("Downloading %s" % i)
    subprocess.call('fastq-dump -I --gzip --split-files %s' % i, shell=True)


for acc in accs:
    subprocess.call('srst2 --input_se %s_1.fastq %s_2.fastq --log --gene_db gene.db --output %s' % (acc, acc, acc), shell=True)
    subprocess.call('rm %s_1.fastq %s_2.fastq' % (acc, acc), shell=True)
