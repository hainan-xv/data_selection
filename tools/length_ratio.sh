#!/bin/bash

en=$1
fr=$2

en_out=$3
fr_out=$4

low=$5
high=$6

unique_id=$7

cat $en | awk '{print NF}' > tmp.1.$unique_id
cat $fr | awk '{print NF}' > tmp.2.$unique_id

paste tmp.1.$unique_id tmp.2.$unique_id | awk -v low=$low -v high=$high '{a=(0.1+$1)/(0.1+$2);if(a>=low && a<=high) print NR-1}' > index$unique_id

/export/a04/hxu_mt/tools/getLines index$unique_id $en > $en_out
/export/a04/hxu_mt/tools/getLines index$unique_id $fr > $fr_out

rm index$unique_id tmp.1.$unique_id tmp.2.$unique_id

