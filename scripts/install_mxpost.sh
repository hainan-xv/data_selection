#!/bin/bash

if [ ! -d mxpost ]; then
  mkdir mxpost
  cd mxpost
  wget ftp://ftp.cis.upenn.edu/pub/adwait/jmx/jmx.tar.gz
  tar xzf jmx.tar.gz 
  echo '#!/bin/ksh' > mxpost
  echo "export CLASSPATH=$HOME/tools/mxpost/mxpost.jar" >> mxpost
  echo "java -mx30m tagger.TestTagger $HOME/tools/mxpost/tagger.project" >> mxpost
fi
