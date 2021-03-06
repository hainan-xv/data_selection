#!/bin/bash

ref_corpus=$1
corpus=$2

set -x

for lang in en de; do
  python ~/data_selection/tools/tags-stats.py $ref_corpus.$lang - | sort -n -k2 -r | awk '{print$1}' | head -n 10 > $ref_corpus.pos.list.$lang
  python ~/data_selection/tools/collect-tags.py $ref_corpus.pos.list.$lang $corpus.$lang - | awk '{for(i=2;i<=NF;i+=2)printf("%s ",$i);print""}' > $corpus.count.$lang
done
