#!/usr/bin/env nextflow


/*
 *  Build RDS object out of single-cell count matrix
 */

process createRDS {

    publishDir "${params.outDir}/scAnalyses", mode: 'copy'

    input:
    file script
    file counts

    output:
    file 'matrix.rds'

    script:
    """
    Rscript --vanilla $script --input $counts --output matrix.rds
    """
}
