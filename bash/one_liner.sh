#!/bin/bash

tmpfile=$(mktemp $PWD/XXXX)
perl -pe '$. > 1 and /^>/ ? print "\n" : chomp' $1 > ${tmpfile} && mv ${tmpfile} $1