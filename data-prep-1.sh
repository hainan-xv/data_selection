#!/bin/bash

#set -v

k=100000000

mkdir -p syn

if [ ! True ]; then
  echo "This should not appera"
  exit
  zcat /home/pkoehn/statmt/data/site-crawl/syn/*/v1.en-fr.sent.gz | head -n $k | gzip > syn/raw$k.gz

  zcat syn/raw$k.gz | awk -F '\t' '{printf("%s\t%s\t%s\n",$5,$3,$4)}' | sort -k1 -g -u | gzip > syn/raw$k.sorted.txt.gz
fi












false && zcat syn/raw$k.sorted.txt.gz | grep -v "「" | awk -F '\t' '{print $2}' \
     | grep -v '[^[:punct:]a-zA-Z0-9\t ]' \
     | sed 's=[\!\.\?]=;=g' | sed 's=$= .=g' | sed 's=; .$= .=g' | awk 'NF<160{print}' \
     | head -n 10000 \
     > syn/test_pos.en.txt

#cat syn/test_pos.en.txt | tools/collect-letter-counts - | sort -n -k2 -r > syn/letter.count
