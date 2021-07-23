#!/usr/bin/env nextflow


/*
 *  Get statistics on GTF file (number of genes, exons, transcripts...)
 */

process getStatsGTF {

    tag "getStats on GTF file"
    publishDir "${params.outDir}/stats", mode: 'copy'

    input:

    output:

    script:
    """
    """
}
