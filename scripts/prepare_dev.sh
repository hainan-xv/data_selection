#!/bin/bash

mkdir -p ~/corpus

cd ~/corpus
wget http://www.statmt.org/wmt12/dev.tgz
tar zxvf dev.tgz

#cd ~/corpus
~/mosesdecoder/scripts/tokenizer/tokenizer.perl -l en \
    < dev/news-test2008.en > news-test2008.tok.en
~/mosesdecoder/scripts/tokenizer/tokenizer.perl -l fr \
    < dev/news-test2008.fr > news-test2008.tok.fr
~/mosesdecoder/scripts/recaser/truecase.perl --model ~/sample_corpus/truecase-model.en \
    < news-test2008.tok.en > news-test2008.true.en
~/mosesdecoder/scripts/recaser/truecase.perl --model ~/sample_corpus/truecase-model.fr \
    < news-test2008.tok.fr > news-test2008.true.fr
