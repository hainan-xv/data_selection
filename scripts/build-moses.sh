#!/bin/bash

cd $HOME/tools/

if [ ! -d mosesdecoder ]; then
  git clone https://github.com/moses-smt/mosesdecoder.git
fi

cd mosesdecoder
make -f contrib/Makefiles/install-dependencies.gmake -j 8

if [ ! -d $HOME/tools/mosesdecoder/installed ]; then
  ./compile.sh --prefix=$HOME/tools/mosesdecoder/installed --install-scripts
fi

cd $HOME/tools/

if [ ! -f boost_1_55_0.tar.gz ]; then
  wget http://downloads.sourceforge.net/project/boost/boost/1.55.0/boost_1_55_0.tar.gz
  tar zxvf boost_1_55_0.tar.gz
  cd boost_1_55_0/
  ./bootstrap.sh
  ./b2 -j4 --prefix=$PWD --libdir=$PWD/lib64 --layout=system link=static install || (echo BOOST installation failed; exit 1)
fi

cd $HOME/tools/mosesdecoder
./bjam --with-boost=$HOME/tools/boost_1_55_0 --with-cmph=/home/pkoehn/moses/cmph-2.0/install -j12

