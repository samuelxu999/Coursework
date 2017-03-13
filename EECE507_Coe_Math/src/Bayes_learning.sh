#!/bin/bash

if [ $# -ne 2 ]
then
	echo "Usage: $0 flie_a flie_b";
	exit -1
fi

train_doc="train_doc.txt"

#concatenate file A and B
echo "Collect training data $train_doc based on $1 and $2.`./create_training_doc.sh $1 $2 $train_doc`"

#Transfer all words in training data to lowercase.
echo "Transfer all words in $train_doc to lower case `tr '[:upper:]' '[:lower:]' < $train_doc > tmp | mv tmp $train_doc`"

#Transfer all words in file A to lowercase.
echo "`tr '[:upper:]' '[:lower:]' < $1 > tmp`"
echo "Create vocalbulary!`./create_vocalbulary.sh $train_doc tmp`"
echo "`rm tmp`"
echo "Calculate learn naive bayes distribution for $1`./learn_naive_bayes.tcl vocabulary target > tmp_learnt_A`"

#Transfer all words in file B to lowercase.
echo "`tr '[:upper:]' '[:lower:]' < $2 > tmp`"
echo "Create vocalbulary!`./create_vocalbulary.sh $train_doc tmp`"
echo "`rm tmp`"
echo "Calculate learn naive bayes distribution for $2`./learn_naive_bayes.tcl vocabulary target > tmp_learnt_B`"

#echo "Calculate learn naive bayes distribution for $2`./learn_naive_bayes.tcl vocabulary target > learn_$2`"

#exec `./classify_naive_bayes_text.tcl learn_B text_sample_B.txt` to test sample.

