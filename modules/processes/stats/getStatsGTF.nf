#!/usr/bin/env nextflow


/*
 *  Get statistics on GTF file (number of genes, exons, transcripts...)
 */

process getStatsGTF {

    publishDir "${params.outDir}/stats", mode: 'copy'

    input:
    file gtf

    output:
    file "*_stats.tsv"


    script:
    """
    filename=$(basename -- "$gtf")
    mikado util stats $gtf ${filename%.*}_stats.tsv
    """
}
