#!/usr/bin/env bash

command=$1
logfile=$2

if [[ "$logfile" == "" ]]; then
  logfile="/dev/null"
fi

export command

nohup bash -c 'START=$(date +%s) && echo "START TIME: $(date +%T)" && \
      if [[ -x "$command" ]]; then $command; else chmod +x $command && $command; fi && \
      END=$(date +%s) && DIFF=$(( $END - $START )) && \
      echo "RUN TIME = $(( $DIFF / 60 )) min. and $(( $DIFF % 60 )) secs."' \
      > ${logfile} 2>&1 & echo $! > $PWD/run.pid
