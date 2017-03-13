#!/bin/bash
if [ $# -ne 2 ]
then
	echo "Usage: $0 train_doc target_doc ";
	exit -1
fi

train_doc=$1
target_doc=$2
vocabulary="vocabulary"
target="target"
echo "Calculate Vocabulary data and saved to $vocabulary based on $1 `./sort_statistic.sh $train_doc > $vocabulary`"
echo "Calculate target data and saved to $target based on $2 `./sort_statistic.sh $target_doc > $target`"

