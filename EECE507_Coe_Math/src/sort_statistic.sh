#!/bin/bash
#more statistics.txt | sort -k1,1n | head -300
#more statistics.txt | wc -l
if [ $# -ne 1 ]
then
echo "Usage: $0 filename";
exit -1
fi

./word_statistics.sh $1 | sort -k2,2nr | awk -F" " '{print $1, $3, $4}';
