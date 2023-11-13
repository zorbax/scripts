#!/bin/bash - 
set -o nounset

nb=$1

jupyter nbconvert --execute --to notebook --ExecutePreprocessor.timeout=1000 --inplace $nb
jupyter nbconvert --to html_toc --ExecutePreprocessor.timeout=1000 $nb

