#!/bin/bash

#set -x

#k=10000000000

mkdir -p site-crawl
mkdir -p ~/corpus/de-en/

false && (
if [ -f site-crawl/concat.txt ]; then
  rm site-crawl/concat.txt
fi

for i in `ls /export/b09/pkoehn/site-crawl/data/ | head -n 30`; do
  for f in /export/b09/pkoehn/site-crawl/data/$i/*/v1.en-de.sent*; do
    ls -lh $f
    zcat $f | awk -F '\t' '{if($3=="" || $4==""){}else{print}}' | awk 'NF<160{print}' \
                                                    | awk -F '\t' '{printf("%s\t%s\n",$3,$4)}' | uniq | sort -u >> site-crawl/concat.txt
  done
done

cat site-crawl/concat.txt | head -n 25000000 | awk -F '\t' '{print$1}' > ~/corpus/de-en/site-crawl-25.en
cat site-crawl/concat.txt | head -n 25000000 | awk -F '\t' '{print$2}' > ~/corpus/de-en/site-crawl-25.de

cd ~/corpus/de-en/

for i in en de; do
  ~/data_selection/tools/raw-to-clean.sh $i site-crawl-25.$i site-crawl-25.clean.$i
done

) 

cd ~/corpus/de-en/

~/mosesdecoder/scripts/training/clean-corpus-n.perl \
    site-crawl-25.clean de en \
    site-crawl-25.clean.short 1 80

cd ~/corpus/de-en/

head site-crawl-25.clean.short.en -n 10000000 > site-crawl-10.clean.short.en
head site-crawl-25.clean.short.de -n 10000000 > site-crawl-10.clean.short.de
