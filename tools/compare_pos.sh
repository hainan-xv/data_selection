#!/bin/bash

input_en=$1
input_fr=$2
output_en=$3
output_fr=$4

if [ -f $output_en ]; then
  rm $output_en
fi

if [ -f $output_fr ]; then
  rm $output_fr
fi

TOOLS=/export/a11/hxu/data_selection/tools
cat $input_en | sed "s=[\.\?\!]=;=g" | sed "s=$= .=g" | sed "s=; \.$= .=g" > /tmp/hxu_en
cat $input_fr | sed "s=[\.\?\!]=;=g" | sed "s=$= .=g" | sed "s=; \.$= .=g" > /tmp/hxu_fr

$TOOLS/run-in-parallel.sh "$TOOLS/pos-tag.sh $TOOLS/stanford-postagger-full-2015-12-09/models/wsj-0-18-left3words-distsim.tagger" /tmp/hxu_en $output_en 40 `pwd`/../tmp_folder_en/ &
$TOOLS/run-in-parallel.sh "$TOOLS/pos-tag.sh $TOOLS/stanford-postagger-full-2015-12-09/models/french.tagger"                      /tmp/hxu_fr $output_fr 40 `pwd`/../tmp_folder_fr/

