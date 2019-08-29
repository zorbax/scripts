#!/bin/bash
tmpfile=$(mktemp $PWD/XXXX)
perl -pe 'if(/\>/){s/\n/\t/}; s/\n//; s/\>/\n\>/' $1 | \
         perl -pe 's/\t/\n/' | tail -n+2 > ${tmpfile} && mv ${tmpfile} $1
