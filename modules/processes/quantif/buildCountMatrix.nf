#!/usr/bin/env nextflow

/*
 *  Build single-cell count matrix
 */

process buildCountMatrix{

    publishDir "${params.outDir}/quantif", mode: 'copy'

    input:
    file bam
    file bai

    output:
    file 'counts.tsv.gz'
    file 'umicount.log'

    script:
    """
	umi_tools count --per-gene \
		--gene-tag=XT \
		--assigned-status-tag=XS \
		--per-cell \
		--method=directional \
		-L umicount.log \
		-I $bam \
		-S counts.tsv.gz
    """
}
