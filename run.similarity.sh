#!/bin/bash

dir=similarity
oldgmmdir=gmm_site-crawl-10.clean.short_8
num_gauss=10

set -v

mkdir -p $dir
corpus=/export/a11/hxu/corpus/site-crawl-10.clean.short

if [ ! True ]; then
python tools/unigram-similarity.py ~/working/evaluation/site-crawl.output.2 ~/corpus/site-crawl-10.clean.short.en > $dir/scores

cat $dir/scores -n | awk '{print $1-1, $2}' | sort -k2 -g -r > $dir/scores.sorted

cat $dir/scores.sorted | head -n 1000000 | awk '{print $1}' > $dir/top1000000

tools/get-lines $dir/top1000000 $corpus.en > $dir/train.en
tools/get-lines $dir/top1000000 $corpus.fr > $dir/train.fr

python tools/unigram-similarity.py ~/working/evaluation/site-crawl.output.2 ~/corpus/site-crawl-10.clean.short.en > $dir/scores

python tools/unigram-similarity.py ~/working/evaluation/site-crawl.output.7 /export/a11/hxu/corpus/europarl/clean.en > $dir/scores.euro

gmmdir=gmm_MT_score
mkdir -p $gmmdir

n=`wc -l $dir/scores.euro | awk '{print $1}'`
k=30000

tools/get-rand-index $n $k > $gmmdir/lines
tools/get-lines $gmmdir/lines $dir/scores.euro > $gmmdir/train.small.txt
time tools/gmm-clustering.sh $gmmdir/train.small.txt $num_gauss $gmmdir/params $gmmdir/tmp

~/tools/cluster-3.6.7/classify $gmmdir/params $dir/scores > $gmmdir/test.gmm.scores

cat $gmmdir/test.gmm.scores | awk '{print $3}' | grep . | \
      awk '{print NR-1, $1}' | sort -g -k2 -r > $gmmdir/sorted

head -n 1000000 $gmmdir/sorted | awk '{print$1}' > $gmmdir/top1000000
tools/get-lines $gmmdir/top1000000 $corpus.en > $gmmdir/train.en
tools/get-lines $gmmdir/top1000000 $corpus.fr > $gmmdir/train.fr

fi

posdir=pos_tags_site-crawl-10.clean.short
gmmdir=gmm_MT_score_POS
mkdir -p $gmmdir

n=`wc -l $dir/scores.euro | awk '{print $1}'`
k=30000

if [ True ]; then

#cat $posdir/train.tagged.count.en | awk '{a=0;for(i=1;i<=NF;i++)a+=$i;print a}' > $gmmdir/train.length.en.txt
#cat $posdir/train.tagged.count.fr | awk '{a=0;for(i=1;i<=NF;i++)a+=$i;print a}' > $gmmdir/train.length.fr.txt
#paste $gmmdir/train.length.en.txt $posdir/train.tagged.count.en | awk '{printf($1" ");for(i=2;i<=NF;i++)printf(($i/$1)" ");print}' > $gmmdir/train.feats.en
#paste $gmmdir/train.length.fr.txt $posdir/train.tagged.count.fr | awk '{printf($1" ");for(i=2;i<=NF;i++)printf(($i/$1)" ");print}' > $gmmdir/train.feats.fr

cat /export/a11/hxu/corpus/site-crawl-10.clean.short.tagged.count.en | awk '{a=0;for(i=1;i<=NF;i++)a+=$i;if(a>0)print a;else print -0.0001}' > $gmmdir/test.length.en.txt
cat /export/a11/hxu/corpus/site-crawl-10.clean.short.tagged.count.fr | awk '{a=0;for(i=1;i<=NF;i++)a+=$i;if(a>0)print a;else print -0.0001}' > $gmmdir/test.length.fr.txt

paste $gmmdir/test.length.en.txt /export/a11/hxu/corpus/site-crawl-10.clean.short.tagged.count.en | awk '{printf($1" ");for(i=2;i<=NF;i++)printf(($i/$1)" ");print}' > $gmmdir/test.feats.en
paste $gmmdir/test.length.fr.txt /export/a11/hxu/corpus/site-crawl-10.clean.short.tagged.count.fr | awk '{printf($1" ");for(i=2;i<=NF;i++)printf(($i/$1)" ");print}' > $gmmdir/test.feats.fr


paste $gmmdir/train.feats.en $gmmdir/train.feats.fr $dir/scores.euro > $gmmdir/train.txt
paste $gmmdir/test.feats.en $gmmdir/test.feats.fr $dir/scores > $gmmdir/test.txt

tools/get-rand-index $n $k > $gmmdir/lines
tools/get-lines $gmmdir/lines $gmmdir/train.txt > $gmmdir/train.small.txt
time tools/gmm-clustering.sh $gmmdir/train.small.txt $num_gauss $gmmdir/params $gmmdir/tmp

fi

~/tools/cluster-3.6.7/classify $gmmdir/params $gmmdir/test.txt > $gmmdir/test.gmm.scores

cat $gmmdir/test.gmm.scores | awk '{print $3}' | grep . | \
      awk '{print NR-1, $1}' | sort -g -k2 -r > $gmmdir/sorted

head -n 1000000 $gmmdir/sorted | awk '{print$1}' > $gmmdir/top1000000
tools/get-lines $gmmdir/top1000000 $corpus.en > $gmmdir/train.en
tools/get-lines $gmmdir/top1000000 $corpus.fr > $gmmdir/train.fr
