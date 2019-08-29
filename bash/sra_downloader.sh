#!/bin/bash
bandwidth_mbps_limit = 80
sra_files=(
  'SRR000000.sra'
  'SRR000001.sra'
  'SRR000002.sra'
  'SRR000003.sra'
  'SRR000004.sra'
)

for i in "${sra_files[@]}"
do
  echo "${i}"
  $HOME/.aspera/connect/bin/ascp -i $HOME/.aspera/connect/etc/asperaweb_id_dsa.openssh -k1 -QTr -l${bandwidth_mbps_limit}m anonftp@ftp-trace.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/${i:0:3}/${i:0:6}/${i%.sra}/${i} ./
  if [[ ! -e ${i%.sra}.aspx && ! -e ${i%.sra}.fastq.gz ]]; 
    then
      echo -n "SRA > FASTQ"
      /$HOME/bin/fastq-dump --split-spot --stdout --readids --defline-seq '@$ac.$si/$ri' --defline-qual '+' ${i} | pigz --best --processes 10 > ${i%.sra}.fastq.gz
      echo "DONE"
    else
      echo "Skip"
  fi
done
