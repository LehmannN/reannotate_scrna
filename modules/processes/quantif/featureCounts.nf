#!/usr/bin/env nextflow

/*
 * Count features
 */

process featureCounts {

    tag "FeatureCounts"
    publishDir "${params.outDir}/featureCounts", mode: 'copy'

    input:
    file gtfNOVEL
    file bamScRNA

    output:
    path "*featureCounts.*"

    script:
    """
	featureCounts -T ${params.threads} \
        -F GTF \
        -R BAM \
        -t exon \
        -g gene_id \
        -s 1 \
        -a $gtfNOVEL \
        -o featureCounts.gtf \
        $bamScRNA \
        1> featureCounts.stdout \
        2> featureCounts.stderr
    """
}
