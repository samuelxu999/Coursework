#!/bin/bash
if [ $# -ne 1 ]
then
	echo "Usage: $0 filename";
	exit -1
fi

filename=$1
egrep -o "\b[[:alpha:]]+\b" $filename | \
awk '{ count[$0]++ }
END{ 
	#printf("%-20s\t%s\t%s\t%s\n", "word", "probability", "count", "total");
	for(ind in count)
	{ sum=sum+count[ind];
		#printf("%d\t", sum);
	}
		#printf("%d\n",sum);
	for(ind in count)
	{ printf("%-20s\t%f\t%d\t%d\n",ind, (count[ind]/sum), count[ind], sum); }
}'
