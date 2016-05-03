#!/bin/bash

corpus=/export/a11/hxu/corpus/site-crawl-10.clean.short
dir=gmm_site-crawl-10.clean.short_10_pruned

set -v

if [ ! True ]; then
head -n 500000 $dir/top1000000 > $dir/top500000

tools/get-lines $dir/top500000 $corpus.en > $dir/train.w.en
tools/get-lines $dir/top500000 $corpus.fr > $dir/train.w.fr

wc $dir/train.w.??

dir=/export/a11/hxu/data_selection/bow/gmm_bow_score_POS

head -n 450000 $dir/top1000000 > $dir/top450000

tools/get-lines $dir/top450000 $corpus.en > $dir/train.w.en
tools/get-lines $dir/top450000 $corpus.fr > $dir/train.w.fr

wc $dir/train.w.??
fi

dir=/export/a11/hxu/data_selection/gmm_MT_score
head -n 1220000 $dir/sorted | awk '{print$1}' > $dir/top1220000

tools/get-lines $dir/top1220000 $corpus.en > $dir/train.w.en
tools/get-lines $dir/top1220000 $corpus.fr > $dir/train.w.fr

wc $dir/train.w.??
