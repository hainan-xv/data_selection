#!/bin/bash

# now building moses
#./build-moses.sh

if [ ! -d giza-pp ]; then
  git clone https://github.com/moses-smt/giza-pp.git
  cd giza-pp
  make
  cd ..
fi

if [ ! -d irstlm ]; then
  git clone https://github.com/luispedro/irstlm.git
  cd irstlm
  ./regenerate-makefiles.sh
  ./configure --prefix=`pwd`/installed
  make -j 4
  make install -j 4
  cd ..
fi

if [ ! -d fast_align ]; then
  git clone https://github.com/clab/fast_align.git
  cd fast_align
  mkdir -p build
  cd build
  cmake ..
  make
fi

if [ ! -d mosesdecoder/tools ]; then
  cd ~/tools/mosesdecoder
  mkdir tools
  cp ~/tools/giza-pp/GIZA++-v2/GIZA++ ~/tools/giza-pp/GIZA++-v2/snt2cooc.out ~/tools/giza-pp/mkcls-v2/mkcls ~/tools/fast_align/build/fast_align tools
fi

