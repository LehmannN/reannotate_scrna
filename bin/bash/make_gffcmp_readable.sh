#!/usr/bin/env bash

# **************************************************************************** #
# Define and check command line arguments
# **************************************************************************** #
usage() {
	echo "Usage: $0
	[-i gffcompare stats file (default: 'gffcmp.stats')]
	[-o output directory (default: '.')]
	"
	1>&2; exit 1;
}
i='gffcmp.stats'
o='.'
while getopts ":o:i:" opt; do
	case "${opt}" in
		i)
			i=${OPTARG} ;;
		o)
			o=${OPTARG} ;;
		h)
			usage ;;
		*)
			usage ;;
	esac
done
shift $((OPTIND-1))
if [ -z "$i" ] || [ -z "$o" ] ; then
	usage
fi

# **************************************************************************** #
# Make gffCompare stats file readable computationaly
# **************************************************************************** #

if [ -f $i ]; then
	sed -n -e 5,6p -e 8,9p -e 11,27p $i | \
	sed -e '1s/= Summary for dataset//g' | \
	sed -e 's/#//g' -e '2,4s/ in//g' -e '2,4s/ loci//g' -e 's/multi-exon.*//g'| \
	sed -e 's/|//g' -e 's/://g' -e 's/^ *//g' -e 's/   */\t/g' -e '/^$/d' -e '14,21s/\//\t/g' | \
	tr -d '(%)' | \
	tr -s '\t' '\t' | \
	sed -e 's/\t */\t/g' -e 's/[[:blank:]]*$//' > ${o}/${i}.txt
else
	echo "Error: gffCompare stat file not found"
	usage
fi
