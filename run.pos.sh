#!/bin/bash

set -x

num_gauss=8

training_corpus=/export/a11/hxu/working/corpus/project-syndicate.truecased.1  # only the prefix
test_corpus=/export/a11/hxu/corpus/site-crawl-10.clean.short
test=site-crawl-10.clean.short

export LC_ALL=C

dir=/export/a11/hxu/data_selection/pos_tags_$test

gmmdir=gmm_${test}_$num_gauss

if [ ! True ]; then
cd /export/a11/hxu/data_selection/tools

mkdir -p $dir

./compare_pos.sh $training_corpus.en $training_corpus.fr \
    $dir/train.tagged.en $dir/train.tagged.fr

cat $dir/train.tagged.en | head -n 10000 > $dir/hxu_sym.en
cat $dir/train.tagged.fr | head -n 10000 > $dir/hxu_sym.fr

cd ../

./_generate-pos-features.sh $dir/hxu_sym $dir/train.tagged 

exit

cd /export/a11/hxu/data_selection/tools
./compare_pos.sh /export/a11/hxu/corpus/${test}.en /export/a11/hxu/corpus/${test}.fr \
    /export/a11/hxu/corpus/$test.tagged.en /export/a11/hxu/corpus/$test.tagged.fr

cd ..
./_generate-pos-features.sh $dir/hxu_sym /export/a11/hxu/corpus/$test.tagged 

exit

mkdir -p $gmmdir

paste $dir/train.tagged.count.en $dir/train.tagged.count.fr > $gmmdir/train.txt

n=`wc -l $gmmdir/train.txt | awk '{print $1}'`
k=30000

tools/get-rand-index $n $k > $gmmdir/lines
tools/get-lines $gmmdir/lines $gmmdir/train.txt > $gmmdir/train.small.txt

time tools/gmm-clustering.sh $gmmdir/train.small.txt $num_gauss $gmmdir/params $gmmdir/tmp



paste /export/a11/hxu/corpus/site-crawl-10.clean.short.tagged.count.en /export/a11/hxu/corpus/site-crawl-10.clean.short.tagged.count.fr > $gmmdir/test.txt
~/tools/cluster-3.6.7/classify $gmmdir/params $gmmdir/test.txt > $gmmdir/test.gmm.scores

cat $gmmdir/test.gmm.scores | awk '{print $3}' | grep . | \
      awk '{print NR-1, $1}' | sort -g -k2 -r > $gmmdir/sorted

fi

head -n 1000000 $gmmdir/sorted | awk '{print$1}' > $gmmdir/top1000000
tools/get-lines $gmmdir/top1000000 $test_corpus.en > $gmmdir/train.en
tools/get-lines $gmmdir/top1000000 $test_corpus.fr > $gmmdir/train.fr

tail -n 1000000 $gmmdir/sorted | awk '{print$1}' > $gmmdir/bottom1000000
tools/get-lines $gmmdir/bottom1000000 $test_corpus.en > $gmmdir/bottom_train.en
tools/get-lines $gmmdir/bottom1000000 $test_corpus.fr > $gmmdir/bottom_train.fr

