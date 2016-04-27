#!/bin/bash

for i in 3 4 5; do
  mkdir -p rand_$i
  tools/get-rand-index 10000000 1000000 > rand_$i/index
  tools/get-lines rand_$i/index ~/corpus/site-crawl-10.clean.short.en > rand_$i/site-crawl.en
  tools/get-lines rand_$i/index ~/corpus/site-crawl-10.clean.short.fr > rand_$i/site-crawl.fr
done
