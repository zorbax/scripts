#!/bin/bash

samtools quickcheck -v ./*.bam > bad_bams.fofn && echo 'all ok' || echo 'some files failed check, see bad_bams.fofn'

