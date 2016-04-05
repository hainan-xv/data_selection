#!/bin/bash

set -v

export LC_ALL=C

mkdir -p /tmp/hxu/

#if [  True ]; then
cd /export/a11/hxu/data_selection/tools
#'''

#cat /export/a11/hxu/sample_corpus/train.en | perl -p -i -e "s=[^[:punct:][:space:]a-zA-Z0-9àâäèéêëîïôœùûüÿçÀÂÄÈÉÊËÎÏÔŒÙÛÜŸÇ]==g" > /export/a11/hxu/sample_corpus/train.en.clean
#cat /export/a11/hxu/sample_corpus/train.fr | perl -p -i -e "s=[^[:punct:][:space:]a-zA-Z0-9àâäèéêëîïôœùûüÿçÀÂÄÈÉÊËÎÏÔŒÙÛÜŸÇ]==g" > /export/a11/hxu/sample_corpus/train.fr.clean

#diff /export/a11/hxu/sample_corpus/train.fr /export/a11/hxu/sample_corpus/train.fr.clean | head

./compare_pos.sh /export/a11/hxu/sample_corpus/train.en /export/a11/hxu/sample_corpus/train.fr \
    /export/a11/hxu/sample_corpus/train.tagged.en /export/a11/hxu/sample_corpus/train.tagged.fr

#for f in /export/a11/hxu/sample_corpus/train.tagged.en /export/a11/hxu/sample_corpus/train.tagged.fr; do
#  cat $f | perl -p -i -e "s=\n= =g" | perl -p -i -e "s=SentenceID=\nSentenceID=g" > ${f}.adjusted
#done

cat /export/a11/hxu/sample_corpus/train.tagged.en | head -n 10000 > /tmp/hxu_sym.en
cat /export/a11/hxu/sample_corpus/train.tagged.fr | head -n 10000 > /tmp/hxu_sym.fr
#''' 2>/dev/null
cd ../

./_generate-pos-features.sh /tmp/hxu_sym /export/a11/hxu/sample_corpus/train.tagged 
#exit

#paste /export/a11/hxu/corpus/giga.en /export/a11/hxu/corpus/giga.fr | grep -v '[^[:punct:][:alnum:]0-9\t ]' > /tmp/hxu_pasted
#paste /export/a11/hxu/corpus/giga.en /export/a11/hxu/corpus/giga.fr | grep -v '[^[:punct:][:space:]a-zA-Z0-9àâäèéêëîïôœùûüÿçÀÂÄÈÉÊËÎÏÔŒÙÛÜŸÇ]' | awk 'NF<161{print}' > /tmp/hxu_pasted
#paste /export/a11/hxu/corpus/giga.en /export/a11/hxu/corpus/giga.fr | python scripts/character-cleaning.py - > /tmp/hxu_pasted

#cat /tmp/hxu_pasted | awk -F '\t' '{print$1}' > /export/a11/hxu/corpus/giga.clean.en
#cat /tmp/hxu_pasted | awk -F '\t' '{print$2}' > /export/a11/hxu/corpus/giga.clean.fr

#fi

#cat /export/a11/hxu/corpus/giga.clean.en | awk '{printf("SentenceID %s : ",NR); print}' > /export/a11/hxu/corpus/giga.clean.en.withid
#cat /export/a11/hxu/corpus/giga.clean.fr | awk '{printf("SentenceID %s : ",NR); print}' > /export/a11/hxu/corpus/giga.clean.fr.withid
paste /export/a11/hxu/corpus/giga.en /export/a11/hxu/corpus/giga.fr | awk 'NF<162{print}' > /tmp/hxu/giga.short

cat /tmp/hxu/giga.short | awk -F '\t' '{print $1}' > /export/a11/hxu/corpus/giga.short.en
cat /tmp/hxu/giga.short | awk -F '\t' '{print $2}' > /export/a11/hxu/corpus/giga.short.fr

cd /export/a11/hxu/data_selection/tools
./compare_pos.sh /export/a11/hxu/corpus/giga.short.en /export/a11/hxu/corpus/giga.short.fr \
    /export/a11/hxu/corpus/giga.tagged.en /export/a11/hxu/corpus/giga.tagged.fr

#for f in /export/a11/hxu/corpus/giga.tagged.en /export/a11/hxu/corpus/giga.tagged.fr; do
#  cat $f | perl -p -i -e "s=\n= =g" | perl -p -i -e "s=SentenceID=\nSentenceID=g" > ${f}.adjusted
#done

./_generate-pos-features.sh /tmp/hxu_sym /export/a11/hxu/corpus/tagged.tagged 
