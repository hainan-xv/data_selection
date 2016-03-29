#!/bin/bash

set -v

k=100000000

zcat /home/pkoehn/statmt/data/site-crawl/syn/*/v1.en-fr.sent.gz | head -n $k | gzip > raw$k.gz

zcat raw$k.gz | awk -F '\t' '{printf("%s\t%s\t%s\n",$5,$3,$4)}' | sort -k1 -g -u > raw$k.sorted.gz
