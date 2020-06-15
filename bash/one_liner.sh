#!/bin/bash
tmpfile=$(mktemp $PWD/XXXX)
awk '/^>/ {printf("%s%s\t",(N>0?"\n":""),$0);N++;next;} \
    {printf("%s",$0);} END {printf("\n");}' < $1 > ${tmpfile} && mv ${tmpfile} $1
