#!/bin/bash

false && for i in 3 4 5; do
  mkdir -p rand_$i
  tools/get-rand-index 10000000 1000000 > rand_$i/index
  tools/get-lines rand_$i/index ~/corpus/site-crawl-10.clean.short.en > rand_$i/site-crawl.en
  tools/get-lines rand_$i/index ~/corpus/site-crawl-10.clean.short.fr > rand_$i/site-crawl.fr
done

for n in 500000 1000000 2000000 3000000 5000000 7000000 10000000; do
  for i in 1 2; do
    dir=rand_$n/i$i
    mkdir -p $dir
    tools/get-rand-index 10000000 $n > $dir/index
    tools/get-lines $dir/index ~/corpus/site-crawl-10.clean.short.en > $dir/site-crawl.en
    tools/get-lines $dir/index ~/corpus/site-crawl-10.clean.short.fr > $dir/site-crawl.fr
  done
done
