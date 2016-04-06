#!/bin/bash

set -v

export LC_ALL=C

mkdir -p /tmp/hxu/

if [ ! True ]; then
cd /export/a11/hxu/data_selection/tools

./compare_pos.sh /export/a11/hxu/sample_corpus/train.en /export/a11/hxu/sample_corpus/train.fr \
    /export/a11/hxu/sample_corpus/train.tagged.en /export/a11/hxu/sample_corpus/train.tagged.fr


cat /export/a11/hxu/sample_corpus/train.tagged.en | head -n 10000 > /tmp/hxu_sym.en
cat /export/a11/hxu/sample_corpus/train.tagged.fr | head -n 10000 > /tmp/hxu_sym.fr
cd ../

./_generate-pos-features.sh /tmp/hxu_sym /export/a11/hxu/sample_corpus/train.tagged 

paste /export/a11/hxu/corpus/giga.en /export/a11/hxu/corpus/giga.fr | awk 'NF<162{print}' > /tmp/hxu/giga.short

cat /tmp/hxu/giga.short | awk -F '\t' '{print $1}' > /export/a11/hxu/corpus/giga.short.en
cat /tmp/hxu/giga.short | awk -F '\t' '{print $2}' > /export/a11/hxu/corpus/giga.short.fr

cd /export/a11/hxu/data_selection/tools
./compare_pos.sh /export/a11/hxu/corpus/giga.short.en /export/a11/hxu/corpus/giga.short.fr \
    /export/a11/hxu/corpus/giga.tagged.en /export/a11/hxu/corpus/giga.tagged.fr

cd ..
fi

./_generate-pos-features.sh /tmp/hxu_sym /export/a11/hxu/corpus/giga.tagged 
