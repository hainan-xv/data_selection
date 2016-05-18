#!/bin/bash

set -x

corpus=/export/a11/hxu/corpus/de-en/site-crawl-10.clean.short
num_gauss=10

training_corpus=/export/a11/hxu/working_de/corpus/project-syndicate.truecased.1  # only the prefix
test_corpus=/export/a11/hxu/corpus/de-en/site-crawl-10.clean.short
test=site-crawl-10.clean.short

export LC_ALL=C

olddir=/export/a11/hxu/data_selection/de-en/pos_tags_$test

dir=${olddir}_pruned

gmmdir=gmm_${test}_${num_gauss}_pruned

mkdir -p $dir
mkdir -p $gmmdir

ln -s $olddir/train.tagged.en $dir/train.tagged.en
ln -s $olddir/train.tagged.de $dir/train.tagged.de

if [ ! True ]; then
cat $olddir/train.tagged.en | head -n 10000 > $dir/hxu_sym.en
cat $olddir/train.tagged.de | head -n 10000 > $dir/hxu_sym.de

./_generate-pos-features.sh $dir/hxu_sym $dir/train.tagged 

ln -s /export/a11/hxu/corpus/de-en/$test.tagged.en /export/a11/hxu/corpus/de-en/$test.tagged.pruned.en
ln -s /export/a11/hxu/corpus/de-en/$test.tagged.de /export/a11/hxu/corpus/de-en/$test.tagged.pruned.de

./_generate-pos-features.sh $dir/hxu_sym /export/a11/hxu/corpus/de-en/$test.tagged.pruned

if [ ! True ]; then

echo processing europarl
./tools/run-bow.sh ~/working_de/model/lex.1.f2e ~/working_de/corpus/project-syndicate.clean.1.de ~/working_de/corpus/project-syndicate.clean.1.en > $gmmdir/train.scores.f2e
./tools/run-bow.sh ~/working_de/model/lex.1.e2f ~/working_de/corpus/project-syndicate.clean.1.en ~/working_de/corpus/project-syndicate.clean.1.de > $gmmdir/train.scores.e2f

echo processing site-crawl
./tools/run-bow.sh ~/working_de/model/lex.1.f2e /export/a11/hxu/corpus/de-en/site-crawl-10.clean.short.de /export/a11/hxu/corpus/de-en/site-crawl-10.clean.short.en > $gmmdir/test.scores.f2e
./tools/run-bow.sh ~/working_de/model/lex.1.e2f /export/a11/hxu/corpus/de-en/site-crawl-10.clean.short.en /export/a11/hxu/corpus/de-en/site-crawl-10.clean.short.de > $gmmdir/test.scores.e2f

python tools/non-word-agreement.py ~/working_de/corpus/project-syndicate.clean.1.en ~/working_de/corpus/project-syndicate.clean.1.de > $gmmdir/train.scores.agreement

python tools/non-word-agreement.py /export/a11/hxu/corpus/de-en/site-crawl-10.clean.short.en /export/a11/hxu/corpus/de-en/site-crawl-10.clean.short.de > $gmmdir/test.scores.agreement

cat ~/working_de/corpus/project-syndicate.clean.1.en | awk '{print NF}' > $gmmdir/train.length.en
cat ~/working_de/corpus/project-syndicate.clean.1.de | awk '{print NF}' > $gmmdir/train.length.de

cat /export/a11/hxu/corpus/de-en/site-crawl-10.clean.short.en | awk '{print NF}' > $gmmdir/test.length.en
cat /export/a11/hxu/corpus/de-en/site-crawl-10.clean.short.de | awk '{print NF}' > $gmmdir/test.length.de

paste $gmmdir/train.length.en $dir/train.tagged.count.en | awk '{for(i=2;i<=NF;i++)printf($i/$1" ");print""}' > $gmmdir/train.pos.en
paste $gmmdir/train.length.de $dir/train.tagged.count.de | awk '{for(i=2;i<=NF;i++)printf($i/$1" ");print""}' > $gmmdir/train.pos.de

fi


paste $gmmdir/test.length.en /export/a11/hxu/corpus/de-en/$test.tagged.count.en | awk '{for(i=2;i<=NF;i++)printf($i/$1" ");print""}' > $gmmdir/test.pos.en
paste $gmmdir/test.length.de /export/a11/hxu/corpus/de-en/$test.tagged.count.de | awk '{for(i=2;i<=NF;i++)printf($i/$1" ");print""}' > $gmmdir/test.pos.de
 
for i in train test; do
  paste $gmmdir/$i.length.en $gmmdir/$i.length.de $gmmdir/$i.pos.en $gmmdir/$i.pos.de $gmmdir/$i.scores.agreement $gmmdir/$i.scores.e2f $gmmdir/$i.scores.f2e > $gmmdir/$i.feats.txt
done

n=`wc -l $gmmdir/train.feats.txt | awk '{print $1}'`
k=50000

tools/get-rand-index $n $k > $gmmdir/lines
tools/get-lines $gmmdir/lines $gmmdir/train.feats.txt > $gmmdir/train.small.txt

time tools/gmm-clustering.sh $gmmdir/train.small.txt $num_gauss $gmmdir/params $gmmdir/tmp

~/tools/cluster-3.6.7/classify $gmmdir/params $gmmdir/test.feats.txt > $gmmdir/test.gmm.scores

cat $gmmdir/test.gmm.scores | awk '{print $3}' | grep . | \
      awk '{print NR-1, $1}' | sort -g -k2 -r > $gmmdir/sorted

head -n 1000000 $gmmdir/sorted | awk '{print$1}' > $gmmdir/top1000000
tools/get-lines $gmmdir/top1000000 $corpus.en > $gmmdir/train.en
tools/get-lines $gmmdir/top1000000 $corpus.de > $gmmdir/train.de
fi

#for i in 100000 200000 500000 2000000 3000000 5000000; do
for i in 800000; do
  head -n $i $gmmdir/sorted | awk '{print $1}' > $gmmdir/top$i

  tools/get-lines $gmmdir/top$i $corpus.en > $gmmdir/train.top$i.en
  tools/get-lines $gmmdir/top$i $corpus.de > $gmmdir/train.top$i.de
done

exit
