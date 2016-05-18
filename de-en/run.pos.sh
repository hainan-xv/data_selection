#!/bin/bash

set -x

num_gauss=8

training_corpus=/export/a11/hxu/working_de/corpus/project-syndicate.truecased.1  # only the prefix
test_corpus=/export/a11/hxu/corpus_de/site-crawl-10.clean.short
test=site-crawl-10.clean.short

export LC_ALL=C

dir=/export/a11/hxu/data_selection/de-en/pos_tags_$test

gmmdir=gmm_${test}_$num_gauss

if [ ! True ]; then
cd /export/a11/hxu/data_selection/de-en/tools

mkdir -p $dir

iconv -c -f utf-8 -t ISO-8859-1 $training_corpus.de > $training_corpus.de.de

./compare_pos_de-en.sh $training_corpus.en $training_corpus.de.de \
    $dir/train.tagged.en $dir/train.tagged.de

wc -l $dir/train.tagged.en $dir/train.tagged.de

exit

cat $dir/train.tagged.en | head -n 10000 > $dir/hxu_sym.en
cat $dir/train.tagged.de | head -n 10000 > $dir/hxu_sym.de

cd ../

./_generate-pos-features.sh $dir/hxu_sym $dir/train.tagged 

fi

cd /export/a11/hxu/data_selection/de-en/tools

iconv -c -f utf-8 -t ISO-8859-1 /export/a11/hxu/corpus_de/${test}.de | sed "s=^ *$=ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ=g" > /export/a11/hxu/corpus_de/${test}.de.de

./compare_pos_de-en.sh /export/a11/hxu/corpus_de/${test}.en /export/a11/hxu/corpus_de/${test}.de.de \
    /export/a11/hxu/corpus_de/$test.tagged.en /export/a11/hxu/corpus_de/$test.tagged.de

wc -l /export/a11/hxu/corpus_de/$test.tagged.en /export/a11/hxu/corpus_de/$test.tagged.de

cd ..
./_generate-pos-features.sh $dir/hxu_sym /export/a11/hxu/corpus_de/$test.tagged 

exit

