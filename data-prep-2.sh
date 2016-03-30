#!/bin/bash

set -v

k=1000000000

mkdir site-crawl

zcat /export/b09/pkoehn/site-crawl/data/[0-3]*/*/v1.en-fr.sent* | grep -v function.imagecreatefromjpeg | \
  awk -F '\t' '{if($3 ~ /\/.*\/.*\/.*/){}else{print}}' | awk -F '\t' '{if($3=="" || $4==""){}else{print}}' \
                                                | head -n $k | uniq | gzip > site-crawl/raw$k.gz

#zcat site-crawl/raw$k.gz | awk -F '\t' '{printf("%s\t%s\t%s\n",$5,$3,$4)}' | sort -k1 -g -u > site-crawl/raw$k.sorted.gz
