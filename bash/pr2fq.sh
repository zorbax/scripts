#!/bin/bash

file_report="https://www.ebi.ac.uk/ena/portal/api/filereport?accession="
options="&result=read_run&fields=fastq_ftp&download=true"
id="$1"
links=$(curl --silent "${file_report}""${id}""${options}" | tail -n+2 | cut -f2 | sed 's/;/\n/')
mkdir -p 00_raw/
for i in ${links}
do
    name=$(basename "${i}")
    echo "${name%%.*}"
    cd 00_raw/ && { curl --silent -o "${name}" -O "${i}" ; cd - > /dev/null || return; }
done
