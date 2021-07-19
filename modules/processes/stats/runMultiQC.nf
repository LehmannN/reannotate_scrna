#!/usr/bin/env nextflow


/*
 *  Run MultiQC
 */

process runMultiQC {

    tag "MultiQC"
    publishDir "${params.outDir}/stats", mode: 'copy'

    input:

    output:

    script:
    """
    """
}
