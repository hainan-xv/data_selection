#!/bin/bash


if [ ! -f ~/corpus/europarl/freq.fr.sorted.txt ]; then
  for i in en fr; do
    cat ~/corpus/europarl/clean.$i | awk '{for(i=1;i<=NF;i++) m[$i]++}END{for(i in m) print i,m[i]}' > ~/corpus/europarl/freq.$i.txt
    cat ~/corpus/europarl/freq.$i.txt | sort -k2 -n -r > ~/corpus/europarl/freq.$i.sorted.txt
  done
fi


