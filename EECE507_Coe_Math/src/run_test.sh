#!/bin/bash

outfile="result.txt"
samplepath="./sample"
resultpaht="./result"

`rm $resultpaht/$outfile`

`./Bayes_classifier.sh $samplepath/text_Alice.txt $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/text_Bob.txt $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/test_Alice.txt $resultpaht/$outfile`
`./Bayes_classifier.sh $samplepath/test_Bob.txt $resultpaht/$outfile`



