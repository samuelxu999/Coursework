#!/bin/bash

if [ $# -ne 2 ]
then
	echo "Usage: $0 testfile result";
	exit -1
fi

testfile=$1
outfile=$2

`echo "-----------------------------------------------------------------" >> $outfile`
var_a=`./classify_naive_bayes_text.tcl tmp_learnt_A $testfile`
`echo "./classify_naive_bayes_text.tcl tmp_learnt_A $testfile:$var_a" >> $outfile`

var_b=`./classify_naive_bayes_text.tcl tmp_learnt_B $testfile`
`echo "./classify_naive_bayes_text.tcl tmp_learnt_B $testfile:$var_b" >> $outfile`

#output largest hypothesis
if [ $(echo "$var_a > $var_b" | bc) -eq 1 ];then
  `echo "Alice" >> $outfile`
else
  `echo "Bob" >> $outfile`
fi

