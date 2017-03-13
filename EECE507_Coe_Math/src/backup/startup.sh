#!/bin/bash

if [ $# -ne 3 ]
then
	echo "Usage: $0 filename testline type-A/B";
	exit -1
fi
#echo "Test strings $2 lines from $1: `head -$2 $1 > tmp.txt | ./sort_statistic.sh tmp.txt`"
#echo "Test strings $2 lines from $1: `head -$2 $1 > tmp.txt | ./sort_statistic.sh tmp.txt | ./make_bayes_plus.tcl "$3"`" 
echo "Test strings $2 lines from $1: `head -$2 $1 > tmp.txt | ./sort_statistic.sh tmp.txt | ./make_bayes.tcl "$3"`"
