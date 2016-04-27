#!/bin/bash

mkdir -p bow
corpus=/export/a11/hxu/corpus/site-crawl-10.clean.short
num_gauss=10

echo processing europarl
#./tools/run-bow.sh ~/working/model/lex.1.f2e ~/working/corpus/project-syndicate.clean.1.fr ~/working/corpus/project-syndicate.clean.1.en > bow/train.scores

echo processing site-crawl
./tools/run-bow.sh ~/working/model/lex.1.f2e /export/a11/hxu/corpus/site-crawl-10.clean.short.fr /export/a11/hxu/corpus/site-crawl-10.clean.short.en > bow/test.scores

dir=bow
gmmdir=bow/gmm_bow_score
mkdir -p $gmmdir

n=`wc -l $dir/train.scores | awk '{print $1}'`
k=30000

tools/get-rand-index $n $k > $gmmdir/lines
tools/get-lines $gmmdir/lines $dir/train.scores > $gmmdir/train.small.txt
time tools/gmm-clustering.sh $gmmdir/train.small.txt $num_gauss $gmmdir/params $gmmdir/tmp

~/tools/cluster-3.6.7/classify $gmmdir/params $dir/test.scores > $gmmdir/test.gmm.scores

cat $gmmdir/test.gmm.scores | awk '{print $3}' | grep . | \
      awk '{print NR-1, $1}' | sort -g -k2 -r > $gmmdir/sorted

head -n 1000000 $gmmdir/sorted | awk '{print$1}' > $gmmdir/top1000000
tools/get-lines $gmmdir/top1000000 $corpus.en > $gmmdir/train.en
tools/get-lines $gmmdir/top1000000 $corpus.fr > $gmmdir/train.fr

posdir=pos_tags_site-crawl-10.clean.short
gmmdir=gmm_MT_score_POS
newgmmdir=bow/gmm_bow_score_POS
mkdir -p $newgmmdir

n=`wc -l $dir/train.scores | awk '{print $1}'`
k=30000



paste $gmmdir/train.feats.en $gmmdir/train.feats.fr $dir/train.scores > $newgmmdir/train.txt
paste $gmmdir/test.feats.en $gmmdir/test.feats.fr $dir/test.scores > $newgmmdir/test.txt

gmmdir=$newgmmdir

tools/get-rand-index $n $k > $gmmdir/lines
tools/get-lines $gmmdir/lines $gmmdir/train.txt > $gmmdir/train.small.txt
time tools/gmm-clustering.sh $gmmdir/train.small.txt $num_gauss $gmmdir/params $gmmdir/tmp

~/tools/cluster-3.6.7/classify $gmmdir/params $gmmdir/test.txt > $gmmdir/test.gmm.scores

cat $gmmdir/test.gmm.scores | awk '{print $3}' | grep . | \
      awk '{print NR-1, $1}' | sort -g -k2 -r > $gmmdir/sorted

head -n 1000000 $gmmdir/sorted | awk '{print$1}' > $gmmdir/top1000000
tools/get-lines $gmmdir/top1000000 $corpus.en > $gmmdir/train.en
tools/get-lines $gmmdir/top1000000 $corpus.fr > $gmmdir/train.fr
