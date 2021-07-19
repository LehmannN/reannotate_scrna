#!/usr/bin/env nextflow


/*
 *  Preprocess single-cell count matrix (filter cells, dimension reduction...)
 */

process preprocessRDS {

    tag "preprocessRDS"
    publishDir "${params.outDir}/single-cell-analyses", mode: 'copy'

    input:
    file rds

    output:
    path rmd

    script:
    """
    Rscript --vanilla preprocessRDS.R --input rds
    """
}
