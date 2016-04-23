#!/bin/bash

dir=similarity

mkdir -p $dir

python tools/unigram-similarity.py ~/working/evaluation/site-crawl.output.2 ~/corpus/site-crawl-10.clean.short.en > $dir/scores

cat $dir/scores -n | awk '{print $1-1, $2}' | sort -k2 -g -r > $dir/scores.sorted

cat $dir/scores.sorted | head -n 1000000 | awk '{print $1}' > $dir/goodlines.txt
