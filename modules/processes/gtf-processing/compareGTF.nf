#!/usr/bin/env nextflow

// Finished

/*
 *  Compare 2 annotations files (GTF or GFF3)
 */

process compareGTF {

    tag "GffCompare"
    publishDir "${params.outDir}/gffcomp",
        mode: 'copy',
        pattern: 'gffcmp*'

    input:
    file gtfREF
    file gtfNOVEL

    output:
    file "gffcmp*"

    script:
    """
    gffcompare -r $gtfREF \
        -o gffcmp \
        $gtfNOVEL
    """
}
