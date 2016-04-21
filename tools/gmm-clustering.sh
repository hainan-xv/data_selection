#!/bin/bash

data_file=$1
num_gauss=$2
out_param=$3
savefolder=$4

echo $0 data_file num_gauss out_param [ optional_save_folder ]

if [ $# != 4 ]; then
  echo wrong number of parameters. require 4, see $#
  exit
fi

if [ "$savefolder" == "" ]; then
  savefolder=/tmp/hxu
fi

mkdir -p $savefolder

m=`head -n 1 $data_file | awk '{print NF}'`
n=`wc -l $data_file |awk '{print $1}'`

cat <<EOF > $savefolder/infofile
1
$m
$data_file $n
EOF

#echo writing to $out_params $3

~/tools/cluster-3.6.7/clust $num_gauss $savefolder/infofile $3 full
