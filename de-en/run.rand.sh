#!/bin/bash

set -v

for n in 500000 1000000 2000000 3000000 5000000 7000000 10000000; do
  for i in 1 2; do
    dir=rand_$n/i$i
    mkdir -p $dir
    tools/get-rand-index 10000000 $n > $dir/index
    tools/get-lines $dir/index ~/corpus/de-en/site-crawl-10.clean.short.en > $dir/site-crawl.en
    tools/get-lines $dir/index ~/corpus/de-en/site-crawl-10.clean.short.de > $dir/site-crawl.de
  done
done
