#!/bin/bash

tmpfile=$(mktemp $PWD/XXXX)
perl -pe 'if(/\>/){s/$/\t/}; s/\n//g; s/\>/\n\>/g' $1 | \
    perl -pe 's/\t/\n/g' ${tmpfile} && mv ${tmpfile} $1
