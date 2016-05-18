#!/bin/bash

corpus=/export/a11/hxu/corpus/site-crawl-10.clean.short
dir=gmm_site-crawl-10.clean.short_10_pruned

set -x

#for i in 100000 200000 500000 1000000 2000000 3000000 5000000; do
false && for i in 800000; do
  head -n $i $dir/sorted | awk '{print $1}' > $dir/top$i

  tools/get-lines $dir/top$i $corpus.en > $dir/train.top$i.en
  tools/get-lines $dir/top$i $corpus.fr > $dir/train.top$i.fr
done

gmmdir=$dir
dir=method_26_variation

mkdir -p $dir
false && (cd $dir

ln -s ../similarity/scores.euro train.MT.score
ln -s ../similarity/scores test.MT.score

cd ..

for i in train test; do
  paste $gmmdir/$i.length.en $gmmdir/$i.length.fr $gmmdir/$i.pos.en $gmmdir/$i.pos.fr $gmmdir/$i.scores.agreement $dir/$i.MT.score > $dir/$i.feats.txt
done

n=`wc -l $dir/train.feats.txt | awk '{print $1}'`
k=50000
num_gauss=10

tools/get-rand-index $n $k > $dir/lines
tools/get-lines $dir/lines $dir/train.feats.txt > $dir/train.small.txt

time tools/gmm-clustering.sh $dir/train.small.txt $num_gauss $dir/params $dir/tmp

~/tools/cluster-3.6.7/classify $dir/params $dir/test.feats.txt > $dir/test.gmm.scores

cat $dir/test.gmm.scores | awk '{print $3}' | grep . | \
      awk '{print NR-1, $1}' | sort -g -k2 -r > $dir/sorted
)

for i in 100000 200000 500000 1000000 2000000 3000000 5000000; do
  head -n $i $dir/sorted | awk '{print $1}' > $dir/top$i

  tools/get-lines $dir/top$i $corpus.en > $dir/train.top$i.en
  tools/get-lines $dir/top$i $corpus.fr > $dir/train.top$i.fr
done
