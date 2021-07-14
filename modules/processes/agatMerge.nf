#!/usr/bin/env nextflow

/*
 *  Merge novel annotation with reference (with AGAT)
 */

process agatMerge {

    tag "Merge GTF (AGAT)"
    publishDir "${params.outDir}/mergeGTF", mode: 'copy'

    input:
    file gtfNOVEL

    output:
    path 'merged'

    script:
    """
    agat_sp_merge_annotations.pl --gff $gtfREF \
        --gff $gtfNOVEL \
        --output merged
    """
}
