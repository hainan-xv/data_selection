#!/bin/bash

corpus=/export/a11/hxu/corpus/site-crawl-10.clean.short
dir=gmm_site-crawl-10.clean.short_10_pruned

set -x

#for i in 100000 200000 500000 1000000 2000000 3000000 5000000; do
for i in 800000; do
  head -n $i $dir/sorted | awk '{print $1}' > $dir/top$i

  tools/get-lines $dir/top$i $corpus.en > $dir/train.top$i.en
  tools/get-lines $dir/top$i $corpus.fr > $dir/train.top$i.fr
done
