#!/bin/bash

sort -R --random-source=/dev/random $1 > tmp1
sort -R --random-source=/dev/random $2 > tmp2
paste -d'#' tmp1 tmp2 > tmp3
cat tmp3 | sed 's/#/\t/g' > files_students
rm  tmp*



