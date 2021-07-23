#!/usr/bin/env nextflow


/*
 *  Fix orientation of long-reads (only for ONT data)
 */

process fixOrientationONT {

    tag "fixOrientationONT"
    publishDir "${params.outDir}/reannotation", mode: 'copy'

    input:

    output:

    script:
    """
    """
}
