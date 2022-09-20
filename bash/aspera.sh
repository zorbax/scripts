#!/bin/bash

if [ -f "$1" ]; then
    XRR_file=$(cat $1)
else
    XRR_file=( "$@" )
fi

base_url=anonftp@ftp.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra
key="$HOME/.aspera/connect/etc/asperaweb_id_dsa.openssh"

while read -r i
do
    srr_prefix=${i:0:6}
    xrr=${i:0:3}
    fasp_url=${base_url}/${xrr}/${srr_prefix}/${i}/${i}.sra

    bw_mbps_limit=80

    if [[ ! -e ${i%.sra}.aspx && ! -e ${i%.sra}.fastq.gz ]]; then
        echo "${i}.sra already exists, skip..."
        echo "SRA > FASTQ"
        fastq-dump --split-files --readids --defline-seq '@$ac.$si/$ri' \
                 --defline-qual '+' --gzip ${i}.sra
    else
        echo "Downloading ${i}"
        ascp -i ${key} -k3 -T -l${bw_mbps_limit}m -m1k --policy=fair ${fasp_url} .
        echo "SRA > FASTQ"
        fastq-dump --split-files --readids --defline-seq '@$ac.$si/$ri' \
               --defline-qual '+' --gzip ${i}.sra
    fi
done < "${XRR_file[@]}"
