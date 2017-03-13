#!/bin/bash
if [ $# -ne 1 ]
then
echo "Usage: $0 filename";
exit -1
fi

filename=$1
egrep -o "\b[[:alpha:]]+\b" $filename | \
awk '{ count[$0]++ }
END{ printf("%-14s%s\n", "word", "count");
for(ind in count)
{ printf("%d\t%-20s\n", count[ind], ind); }
}'
