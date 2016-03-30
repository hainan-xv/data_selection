#!/bin/bash

tagger=$1
input=$2
output=$3

/export/a11/hxu/tools/stanford-postagger-full-2015-12-09/stanford-postagger.sh $tagger $input > $output
