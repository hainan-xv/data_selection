#!/bin/bash

set -x

corpus=/export/a11/hxu/corpus/site-crawl-10.clean.short
num_gauss=10

training_corpus=/export/a11/hxu/working/corpus/project-syndicate.truecased.1  # only the prefix
test_corpus=/export/a11/hxu/corpus/site-crawl-10.clean.short
test=site-crawl-10.clean.short

export LC_ALL=C

olddir=/export/a11/hxu/data_selection/pos_tags_$test

dir=${olddir}_pruned

gmmdir=gmm_${test}_${num_gauss}_pruned

mkdir -p $dir
mkdir -p $gmmdir

ln -s $olddir/train.tagged.en $dir/train.tagged.en
ln -s $olddir/train.tagged.fr $dir/train.tagged.fr

if [ ! True ]; then
cat $olddir/train.tagged.en | head -n 10000 > $dir/hxu_sym.en
cat $olddir/train.tagged.fr | head -n 10000 > $dir/hxu_sym.fr

./_generate-pos-features.sh $dir/hxu_sym $dir/train.tagged 

ln -s /export/a11/hxu/corpus/$test.tagged.en /export/a11/hxu/corpus/$test.tagged.pruned.en
ln -s /export/a11/hxu/corpus/$test.tagged.fr /export/a11/hxu/corpus/$test.tagged.pruned.fr

./_generate-pos-features.sh $dir/hxu_sym /export/a11/hxu/corpus/$test.tagged.pruned

echo processing europarl
./tools/run-bow.sh ~/working/model/lex.1.f2e ~/working/corpus/project-syndicate.clean.1.fr ~/working/corpus/project-syndicate.clean.1.en > $gmmdir/train.scores.f2e
./tools/run-bow.sh ~/working/model/lex.1.e2f ~/working/corpus/project-syndicate.clean.1.en ~/working/corpus/project-syndicate.clean.1.fr > $gmmdir/train.scores.e2f

echo processing site-crawl
./tools/run-bow.sh ~/working/model/lex.1.f2e /export/a11/hxu/corpus/site-crawl-10.clean.short.fr /export/a11/hxu/corpus/site-crawl-10.clean.short.en > $gmmdir/test.scores.f2e
./tools/run-bow.sh ~/working/model/lex.1.e2f /export/a11/hxu/corpus/site-crawl-10.clean.short.en /export/a11/hxu/corpus/site-crawl-10.clean.short.fr > $gmmdir/test.scores.e2f

python tools/non-word-agreement.py ~/working/corpus/project-syndicate.clean.1.en ~/working/corpus/project-syndicate.clean.1.fr > $gmmdir/train.scores.agreement

python tools/non-word-agreement.py /export/a11/hxu/corpus/site-crawl-10.clean.short.en /export/a11/hxu/corpus/site-crawl-10.clean.short.fr > $gmmdir/test.scores.agreement

cat ~/working/corpus/project-syndicate.clean.1.en | awk '{print NF}' > $gmmdir/train.length.en
cat ~/working/corpus/project-syndicate.clean.1.fr | awk '{print NF}' > $gmmdir/train.length.fr

cat /export/a11/hxu/corpus/site-crawl-10.clean.short.en | awk '{print NF}' > $gmmdir/test.length.en
cat /export/a11/hxu/corpus/site-crawl-10.clean.short.fr | awk '{print NF}' > $gmmdir/test.length.fr

paste $gmmdir/train.length.en $dir/train.tagged.count.en | awk '{for(i=2;i<=NF;i++)printf($i/$1" ");print""}' > $gmmdir/train.pos.en
paste $gmmdir/train.length.fr $dir/train.tagged.count.fr | awk '{for(i=2;i<=NF;i++)printf($i/$1" ");print""}' > $gmmdir/train.pos.fr

paste $gmmdir/test.length.en /export/a11/hxu/corpus/$test.tagged.pruned.count.en | awk '{for(i=2;i<=NF;i++)printf($i/$1" ");print""}' > $gmmdir/test.pos.en
paste $gmmdir/test.length.fr /export/a11/hxu/corpus/$test.tagged.pruned.count.fr | awk '{for(i=2;i<=NF;i++)printf($i/$1" ");print""}' > $gmmdir/test.pos.fr
 
for i in train test; do
  paste $gmmdir/$i.length.en $gmmdir/$i.length.fr $gmmdir/$i.pos.en $gmmdir/$i.pos.fr $gmmdir/$i.scores.agreement $gmmdir/$i.scores.e2f $gmmdir/$i.scores.f2e > $gmmdir/$i.feats.txt
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
tools/get-lines $gmmdir/top1000000 $corpus.fr > $gmmdir/train.fr

fi

cat /export/a11/hxu/corpus/europarl/clean.en $gmmdir/train.en > $gmmdir/train.merged.en
cat /export/a11/hxu/corpus/europarl/clean.fr $gmmdir/train.fr > $gmmdir/train.merged.fr
