#!/bin/bash
XRR_file=$1

base_url=anonftp@ftp.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra
key="$HOME/.aspera/connect/etc/asperaweb_id_dsa.openssh"

while read line
do
  srr_prefix=${line:0:6}
  xrr=${line:0:3}
  fasp_url=${base_url}/${xrr}/${srr_prefix}/${i}/${i}.sra

  if [[ ! -e ${i%.sra}.aspx && ! -e ${i%.sra}.fastq.gz ]];
    echo "${i}.sra already exists, skip..."
    echo "SRA > FASTQ"
    fastq-dump --split-files --readids --defline-seq '@$ac.$si/$ri' \
                 --defline-qual '+' --gzip ${i}.sra
  else
    echo "Downloading ${i}"
    ascp -i ${key} -k3 -T -l20m -m1k --policy=fair ${fasp_url} .
    echo "SRA > FASTQ"
    fastq-dump --split-files --readids --defline-seq '@$ac.$si/$ri' \
               --defline-qual '+' --gzip ${i}.sra
  fi
done < ${XRR_file}
