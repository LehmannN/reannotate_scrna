#!/usr/bin/env nextflow

process stringtie {

    tag "StringTie2"
    publishDir "${params.outDir}/step1_stringtie", mode: 'copy'

    input:
    file ref
    file bamONT

    output:
    file 'stringtie.gtf'

    script:
    """
    stringtie -L -m 50 -g 50 -c 1 -s 2 -j 1 \
        -p $params.threads \
        -G $ref \
        -o stringtie.gtf \
        $bamONT
    """
}
