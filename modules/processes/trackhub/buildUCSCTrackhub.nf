#!/usr/bin/env nextflow


/*
 *  buildUCSCTrackhub
 */

process buildUCSCTrackhub {

    tag "UCSC trackhub"
    publishDir "${params.outDir}/trackhub", mode: 'copy'

    input:

    output:

    script:
    """
    """
}
