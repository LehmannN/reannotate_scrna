#!/usr/bin/env nextflow

/*
 * Count features
 */

process countFeatures {

    tag "FeatureCounts"

    input:
    path novelAnnotMerged from mergedGTF_ch

    output:
    publishDir "${params.outDir}/step5_featureCounts",
        mode: 'copy'
    path "*featureCounts.bam" into featureCountsBAM_ch
    path "*featureCounts.gtf*" into featureCountsGTF_ch

    script:
    """
	featureCounts -T ${params.threads} \
        -F GTF \
        -R BAM \
        -t gene \
        -g gene_id \
        -s 1 \
        -a $novelAnnotMerged \
        -o featureCounts.gtf \
        ${params.bamScrna}
    """
}
