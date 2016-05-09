#!/bin/bash

set -v

corpus=/export/a11/hxu/corpus/site-crawl-10.clean.short
binary=/export/a11/hxu/mosesdecoder/mert/bin/gcc-4.7/release/link-static/threading-multi/sentence-bleu

if [ ! True ]; then
  dir=bleu
  mkdir -p $dir

  $binary ~/corpus/site-crawl-10.clean.short.en < ~/working/evaluation/site-crawl.output.2 > $dir/bleu-scores.txt

  cat $dir/bleu-scores.txt | awk '{print NR-1,$1}' | sort -g -k2 -r | tee $dir/scores.sorted.txt | awk '{print $1}' > $dir/sorted

  for i in 100 100000 200000 500000 1000000 2000000 3000000 5000000; do
    head -n $i $dir/sorted | awk '{print $1}' > $dir/top$i

    tools/get-lines $dir/top$i $corpus.en > $dir/train.top$i.en
    tools/get-lines $dir/top$i $corpus.fr > $dir/train.top$i.fr
  done

mkdir -p $dir

cd $dir
ln -s ../bleu/bleu-scores.txt test.bleu.scores

cd ../

$binary /export/a11/hxu/corpus/europarl/clean.en < ~/working/evaluation/site-crawl.output.7 > $dir/train.bleu.scores

fi
dir=bleu_length_gmm
cd $dir

for i in `ls ../gmm_site-crawl-10.clean.short_10_pruned/ | grep length`; do
  ln -s ../gmm_site-crawl-10.clean.short_10_pruned/$i 
done

for i in train test; do
  paste $i.bleu.scores $i.length.en $i.length.fr > $i.feat
done

cd ..

gmmdir=bleu_length_gmm
num_gauss=10

n=`wc -l $gmmdir/train.feat | awk '{print $1}'`
k=50000

tools/get-rand-index $n $k > $gmmdir/lines
tools/get-lines $gmmdir/lines $gmmdir/train.feat > $gmmdir/train.small

time tools/gmm-clustering.sh $gmmdir/train.small $num_gauss $gmmdir/params $gmmdir/tmp

~/tools/cluster-3.6.7/classify $gmmdir/params $gmmdir/test.feat > $gmmdir/test.gmm.scores

cat $gmmdir/test.gmm.scores | awk '{print $3}' | grep . | \
      awk '{print NR-1, $1}' | sort -g -k2 -r > $gmmdir/sorted

for i in 100000 200000 500000 1000000 2000000 3000000 5000000; do
  head -n $i $gmmdir/sorted | awk '{print$1}' > $gmmdir/top$i
  tools/get-lines $gmmdir/top$i $corpus.en > $gmmdir/train.top$i.en
  tools/get-lines $gmmdir/top$i $corpus.fr > $gmmdir/train.top$i.fr
done
