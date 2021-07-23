#!/usr/bin/env nextflow


/*
 *  Fix GTF
 */

process fixGTF {

    tag "fixGTF"
    publishDir "${params.outDir}/gtf-processing", mode: 'copy'

    input:

    output:

    script:
    """
    """
}
