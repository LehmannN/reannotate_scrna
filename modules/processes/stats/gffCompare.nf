#!/usr/bin/env nextflow

/*
 *  Compare 2 annotations files (GTF or GFF3)
 */

process gffCompare {

    publishDir "${params.outDir}/gffcomp",
        mode: 'copy',
        pattern: 'gffcmp*'

    input:
    file gtfREF
    file gtfNOVEL
    file script

    output:
    file "gffcmp*"

    script:
    """
    gffcompare -r $gtfREF \
        -o gffcmp \
        $gtfNOVEL \
        1> gffcmp.stdout \
        2> gffcmp.stderr
    bash $script
    """
}
