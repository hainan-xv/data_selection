#!/bin/bash

input=$1
output=$2

nj=100

rm /tmp/hxu/sortanduniq/ -r
mkdir -p /tmp/hxu/sortanduniq

split -d -n l/$nj $input /tmp/hxu/sortanduniq/s

for i in `ls /tmp/hxu/sortanduniq`; do
  cat /tmp/hxu/sortanduniq/$i | sort -u > //tmp/hxu/sortanduniq/sorted.$i
done

cat /tmp/hxu/sortanduniq/sorted* | uniq -u > $output
  
