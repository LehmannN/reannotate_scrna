#!/usr/bin/env nextflow

/*
 *  Sort BAM
 */

process sortBAMFiles {

    tag "Sort BAM Files"
    publishDir "${params.outDir}/sortBAM", mode: 'copy'

    input:
    file bam

    output:
    file '*.bam'
    file '*.bam.bai'

    script:
    """
	samtools sort -@ ${params.threads} $bam -o featureCountsBAMsorted.bam
	samtools index -@ ${params.threads} featureCountsBAMsorted.bam
    """
}
