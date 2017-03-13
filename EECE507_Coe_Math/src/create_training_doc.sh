#!/bin/bash

if [ $# -ne 3 ]
then
	echo "Usage: $0 filename1 filename2 train_doc";
	exit -1
fi
cat $1 > $3
cat $2 >> $3


