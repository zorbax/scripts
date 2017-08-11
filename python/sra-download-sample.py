#!/usr/bin/env python
"""
Get run accession numbers and SRA download urls for given SRA sample name.

2013 Martijn Vermaat <m.vermaat.hg@lumc.nl>
"""


import argparse
import sys
import lxml.etree

from Bio import Entrez
Entrez.email = 'otto94@gmail.com'


def error(message):
    sys.stderr.write(message + '\n')
    sys.exit(1)


def get_runs(sample):
    handle = Entrez.esearch(db='sra', term=sample)
    record = Entrez.read(handle)

    if not len(record['IdList']) == 1:
        error('Found %d entries in SRA for "%s" instead of the expected 1'
              % (len(record['IdList']), sample))
    result = record['IdList'][0]

    handle = Entrez.efetch(db='sra', id=result)
    entry = lxml.etree.parse(handle)
    return entry.xpath('//EXPERIMENT_PACKAGE_SET/EXPERIMENT_PACKAGE/RUN_SET/RUN/@accession')


def get_url(run):
    # ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByRun/sra/ERR/ERR006/ERR006600/ERR006600.sra
    url_template = 'ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByRun/sra/{leading3}/{leading6}/{all}/{all}.sra'
    return url_template.format(leading3=run[:3], leading6=run[:6], all=run)


def main(sample):
    for run in get_runs(sample):
        print '%s %s' % (run, get_url(run))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__.split('\n\n')[0])
    parser.add_argument('sample', metavar='SAMPLE',
                        help='SRA sample name (or any search term)')
    args = parser.parse_args()
    main(args.sample)
