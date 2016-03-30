#!/bin/bash

input_en=$1
input_fr=$2
output_en=$3
output_fr=$4

./run-in-parallel.sh "$HOME/tools/stanford-postagger-full-2015-12-09/stanford-postagger.sh $HOME/tools/stanford-postagger-full-2015-12-09/models/wsj-0-18-left3words-distsim.tagger" $input_en $output_en 40 tmp_en
./run-in-parallel.sh "$HOME/tools/stanford-postagger-full-2015-12-09/stanford-postagger.sh $HOME/tools/stanford-postagger-full-2015-12-09/models/french.tagger" $input_fr $output_fr 40 tmp_fr
