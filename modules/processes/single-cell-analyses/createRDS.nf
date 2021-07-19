#!/usr/bin/env nextflow


/*
 *  Build RDS object out of single-cell count matrix
 */

process createRDS {

    tag "createRDS"
    publishDir "${params.outDir}/single-cell-analyses", mode: 'copy'

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
