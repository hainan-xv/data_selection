#!/bin/bash

input_en=$1
input_de=$2
output_en=$3
output_de=$4

if [ -f $output_en ]; then
  rm $output_en
fi

if [ -f $output_de ]; then
  rm $output_de
fi

TOOLS=/export/a11/hxu/data_selection/tools

#export LC_ALL=C
#LANG=C

$TOOLS/run-in-parallel.sh "$TOOLS/pos-tag.sh $TOOLS/stanford-postagger-full-2015-12-09/models/wsj-0-18-left3words-distsim.tagger" $input_en $output_en 40 `pwd`/../tmp_folder_en/ &
$TOOLS/run-in-parallel.sh "$TOOLS/pos-tag.sh $TOOLS/stanford-postagger-full-2015-12-09/models/german-fast-caseless.tagger"        $input_de $output_de 40 `pwd`/../tmp_folder_de/

wait
exit

cat $input_en | sed "s=[\.\?\!]=;=g" | sed "s=$= .=g" | sed "s=; \.$= .=g" > /tmp/hxu_en
cat $input_de | sed "s=[\.\?\!]=;=g" | sed "s=$= .=g" | sed "s=; \.$= .=g" > /tmp/hxu_de

$TOOLS/run-in-parallel.sh "$TOOLS/pos-tag.sh $TOOLS/stanford-postagger-full-2015-12-09/models/wsj-0-18-left3words-distsim.tagger" /tmp/hxu_en $output_en 40 `pwd`/../tmp_folder_en/ &
$TOOLS/run-in-parallel.sh "$TOOLS/pos-tag.sh $TOOLS/stanford-postagger-full-2015-12-09/models/german-dewac.tagger"          /tmp/hxu_de $output_de 40 `pwd`/../tmp_folder_de/

