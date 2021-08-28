#!/usr/bin/env nextflow


/*
 *  Convert GTF to GFF3
 */

process convertGTFtoGFF3 {

    publishDir "${params.outDir}/gtf-processing", mode: 'copy'

    input:
    file gtf

    output:
    file gff3

    script:
    """
    filename=$(basename -- "$gtf")
    gffread -E --keep-genes $gtf -o- > ${filename%.*}.gff3
    """
}
