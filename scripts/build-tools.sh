#!/bin/bash

# now building moses
./build-moses.sh

if [ ! -d giza-pp ]; then
  git clone https://github.com/moses-smt/giza-pp.git
  cd giza-pp
  make
  cd ..
fi

if [ ! -d mosesdecoder/tools ]; then
  cd ~/tools/mosesdecoder
  mkdir tools
  cp ~/tools/giza-pp/GIZA++-v2/GIZA++ ~/tools/giza-pp/GIZA++-v2/snt2cooc.out ~/tools/giza-pp/mkcls-v2/mkcls tools
fi

