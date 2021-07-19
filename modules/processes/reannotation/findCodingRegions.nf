#!/usr/bin/env nextflow


/*
 *  Find coding regions (with TRANSDECODER)
 */

process findCodingRegions {

    tag "findCodingRegions"
    publishDir "${params.outDir}/reannotation", mode: 'copy'

    input:

    output:

    script:
    """
    """
}
