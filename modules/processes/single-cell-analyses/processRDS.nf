#!/usr/bin/env nextflow


/*
 *  Process single-cell count matrix (pre-processing and analyses)
 */

process processRDS {

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
