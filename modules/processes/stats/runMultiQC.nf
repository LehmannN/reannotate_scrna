#!/usr/bin/env nextflow


/*
 *  Run MultiQC
 */

process runMultiQC {

    publishDir "${params.outDir}/stats", mode: 'copy'

    input:
    file('*')

    output:
    path "multiqc_*"

    script:
    """
    multiqc .
    """
}
