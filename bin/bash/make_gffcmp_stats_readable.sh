#!/usr/bin/env bash

dir=$1
if [ -f $dir/gffcmp.stats ]; then
	sed -n -e 5,6p -e 8,9p -e 11,27p $dir/gffcmp.stats | \
		sed -e '1s/= Summary for dataset//g' | \
		sed -e 's/#//g' -e '2,4s/ in//g' -e '2,4s/ loci//g' -e 's/multi-exon.*//g'| \
		sed -e 's/|//g' -e 's/://g' -e 's/^ *//g' -e 's/   */\t/g' -e '/^$/d' -e '14,21s/\//\t/g' | \
		tr -d '()' | \
		tr -s '\t' '\t' | \
		sed -e 's/\t */\t/g' -e 's/[[:blank:]]*$//' > $dir/gffcmp.stats.txt
else
	echo "Error: file gffcmp.stats not found in $dir"
fi
