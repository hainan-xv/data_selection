#!/bin/bash 
test=false

mkdir -p sample_corpus
cd sample_corpus 

if [ ! -f training-parallel-nc-v8.tgz ]; then
  wget http://www.statmt.org/wmt13/training-parallel-nc-v8.tgz
  tar zxvf training-parallel-nc-v8.tgz
fi
cd ..

if [ ! -f ~/sample_corpus/news-commentary-v8.fr-en.tok.en ]; then
  ~/mosesdecoder/scripts/tokenizer/tokenizer.perl -l en \
    < ~/sample_corpus/training/news-commentary-v8.fr-en.en    \
    > ~/sample_corpus/news-commentary-v8.fr-en.tok.en &

  ~/mosesdecoder/scripts/tokenizer/tokenizer.perl -l fr \
    < ~/sample_corpus/training/news-commentary-v8.fr-en.fr    \
    > ~/sample_corpus/news-commentary-v8.fr-en.tok.fr

  wait
fi

if [ ! -f ~/sample_corpus/truecase-model.en ]; then
  ~/mosesdecoder/scripts/recaser/train-truecaser.perl \
      --model ~/sample_corpus/truecase-model.en --corpus     \
      ~/sample_corpus/news-commentary-v8.fr-en.tok.en &
  ~/mosesdecoder/scripts/recaser/train-truecaser.perl \
      --model ~/sample_corpus/truecase-model.fr --corpus     \
          ~/sample_corpus/news-commentary-v8.fr-en.tok.fr

  wait
fi

if [ ! -f ~/sample_corpus/news-commentary-v8.fr-en.true.en ]; then
  ~/mosesdecoder/scripts/recaser/truecase.perl \
    --model ~/sample_corpus/truecase-model.en         \
    < ~/sample_corpus/news-commentary-v8.fr-en.tok.en \
    > ~/sample_corpus/news-commentary-v8.fr-en.true.en &
  ~/mosesdecoder/scripts/recaser/truecase.perl \
    --model ~/sample_corpus/truecase-model.fr         \
    < ~/sample_corpus/news-commentary-v8.fr-en.tok.fr \
      > ~/sample_corpus/news-commentary-v8.fr-en.true.fr

  wait
fi

if [ ! -f ~/sample_corpus/news-commentary-v8.fr-en.clean.fr ]; then
  ~/mosesdecoder/scripts/training/clean-corpus-n.perl \
    ~/sample_corpus/news-commentary-v8.fr-en.true fr en \
    ~/sample_corpus/news-commentary-v8.fr-en.clean 1 80
fi

mkdir -p ~/sample_lm/
if [ ! -f ~/sample_lm/news-commentary-v8.fr-en.arpa.en ]; then
  ~/mosesdecoder/bin/lmplz -o 3 <~/sample_corpus/news-commentary-v8.fr-en.true.en > ~/sample_lm/news-commentary-v8.fr-en.arpa.en
fi

if [ ! -f ~/sample_lm/news-commentary-v8.fr-en.blm.en ]; then
  ~/mosesdecoder/bin/build_binary \
    ~/sample_lm/news-commentary-v8.fr-en.arpa.en \
    ~/sample_lm/news-commentary-v8.fr-en.blm.en
fi

if [ "$test" ]; then
  echo "is this an English sentence ?" | ~/mosesdecoder/bin/query sample_lm/news-commentary-v8.fr-en.blm.en
fi

mkdir -p ~/sample_working
cd ~/sample_working

if [ ! -f training.out ]; then
  nohup nice ~/mosesdecoder/scripts/training/train-model.perl -root-dir train \
    -corpus ~/sample_corpus/news-commentary-v8.fr-en.clean                             \
    -f fr -e en -alignment grow-diag-final-and -reordering msd-bidirectional-fe \
    -lm 0:3:$HOME/sample_lm/news-commentary-v8.fr-en.blm.en:8                          \
    -external-bin-dir ~/mosesdecoder/tools >& training.out &
fi
