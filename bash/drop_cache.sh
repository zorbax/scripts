#!/bin/bash

sudo=$(which sudo)

if [ "$(whoami)" == "root" ]; then
  root=true
fi

if [ ! "$(which sudo)" ] && [ !$root ]; then
    echo "Not Superuser, and sudo not found!"
    exit 1
fi

memfree=$(grep MemFree /proc/meminfo | awk '{ print $2 }')
freemem=$(echo "$memfree/1024.0" | bc)

if [ "$?" != "0" ]; then
    echo "Something went wrong. Run again."
    exit 1
fi

if [ $root ]; then
    free -h && sync
    echo 3 > /proc/sys/vm/drop_caches > /dev/null && free -h
else
    free -h && $sudo sync
    echo 3 | $sudo tee /proc/sys/vm/drop_caches > /dev/null && free -h
fi

after=$(grep MemFree /proc/meminfo | awk '{ print $2 }')
after=$(echo "$after/1024.0" | bc)

echo -e "\nThis freed $(echo "$after - $freemem" | bc) Mb."
exit 0
