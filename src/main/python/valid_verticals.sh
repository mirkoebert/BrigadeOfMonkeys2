#!/bin/sh

if [ $# -eq 1 ]; then
    DATA=$1
    awk 'BEGIN { FS=","; OFS=","; } {print $9}' ${DATA} \
    | sort \
    | uniq \
    | sed "s/\"//g"
else
    echo "usage: valid_verticals.sh <data_file>"
fi





