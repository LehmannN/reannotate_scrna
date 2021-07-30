#!/usr/bin/env nextflow


/*
 *  Preprocess single-cell count matrix (filter cells, dimension reduction...)
 */

process preprocessRDS {

    tag "preprocessRDS"
    publishDir "${params.outDir}/${rdsID}/scRNA", mode: 'copy'

    input:
    file scRNA
    tuple val(rdsID), file(rdsFile)

    output:
    file '*'

    script:
    """
    bash _build.sh $rdsFile $rdsID
    """
}
