#!/usr/bin/env nextflow

/*
 * Compare 2 annotations files (GTF)
 */

process gffcompare {

    tag "GffCompare"
    publishDir "${params.outDir}/step3_gffcomp",
        mode: 'copy',
        pattern: 'gffcmp*'

    input:
    file ref
    file gtf

    output:
    file "gffcmp*"

    script:
    """
    gffcompare -r $ref \
        -o gffcmp \
        $gtf
    """
}
