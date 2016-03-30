#!/bin/bash

set -v

cd /export/a11/hxu/data_selection/tools
#'''
./compare_pos.sh /export/a11/hxu/sample_corpus/train.en /export/a11/hxu/sample_corpus/train.fr \
    /export/a11/hxu/sample_corpus/train.tagged.en /export/a11/hxu/sample_corpus/train.tagged.fr

cat /export/a11/hxu/sample_corpus/train.tagged.en | head -n 10000 > /tmp/hxu_sym.en
cat /export/a11/hxu/sample_corpus/train.tagged.fr | head -n 10000 > /tmp/hxu_sym.fr
#''' 2>/dev/null
cd ../

./_generate-pos-features.sh /tmp/hxu_sym /export/a11/hxu/sample_corpus/train.tagged 
