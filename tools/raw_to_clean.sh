#!/bin/bash

lang=$1  # en or fr for now
raw=$2
clean=$3

echo convert raw corpus to tokenized, true-cased, clean text

if [ ! $# -eq 3 ]; then
  echo $0 lang raw clean
  exit 1
fi

set -v

mkdir -p ./raw_tmp/

~/mosesdecoder/scripts/tokenizer/tokenizer.perl -l $lang \
    -threads 16                                          \
    < $raw                                               \
    > ./raw_tmp/${raw}.tokenized

if [ ! -f ~/corpus/truecase-model.$lang ]; then
~/mosesdecoder/scripts/recaser/train-truecaser.perl \
    --model ./raw_tmp/truecase-model.$lang --corpus     \
    ./raw_tmp/${raw}.tokenized

fi

~/mosesdecoder/scripts/recaser/truecase.perl \
    --model ./raw_tmp/truecase-model.$lang    \
    < ./raw_tmp/${raw}.tokenized                 \
    > $clean
