#!/usr/bin/env nextflow

/*
 *  Merge novel annotation with reference (with AGAT)
 */

process cuffmerge {

    tag "Merge GTF (Cuffmerge)"
    publishDir "${params.outDir}/mergeGTF", mode: 'copy'

    input:
    file gtfListToMerge

    output:
    file "merged.gff"

    script:
    """
    cuffmerge -p $params.threads \
            --min-isoform-fraction $params.cuffmerge.min_isoform_fraction \
            --ref-gtf $gtfREF \
            --ref-sequence $params.refGenome \
            -o mergeGTF \
            $gtfListToMerge
    """
}
