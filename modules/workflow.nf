#!/usr/bin/env nextflow


/*
 * 3. Compare with reference
 */

process compareNovelAndRef {

    tag "GffCompare between $params.refAnnotation and $novelAnnotationOnt"

    input:
    path novelAnnotMerged from mergedGTF_ch

    output:
    publishDir "${params.outDir}/step3_gffcomp",
        mode: 'copy',
        pattern: 'gffcmp*'
    path "gffcmp*" into gffcmp_ch

    script:
    """
    gffcompare -r $params.refAnnotation \
        -o gffcmp \
        $novelAnnotMerged
    """
}

/*
 * 5. Count features
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

/*
 * 6. Sort BAM
 */

process sortBamFiles{

    tag "Sort BAM Files"

    input:
    path featureCountsBAM from featureCountsBAM_ch

    output:
    publishDir "${params.outDir}/step6_sortBAM",
        mode: 'copy'
    path "featureCountsBAMsorted.bam" into featureCountsBAMsorted_ch
    path "featureCountsBAMsorted.bam.bai" into featureCountsBAIsorted_ch

    script:
    """
	samtools sort -@ ${params.threads} $featureCountsBAM \
        -o featureCountsBAMsorted.bam
	samtools index -@ ${params.threads} featureCountsBAMsorted.bam
    """
}

/*
 * 7. Build single-cell count matrix
 */

process buildCountMatrix{

    tag "Build single-cell count matrix with UMI-tools count"

    input:
    path featureCountsBAMsorted from featureCountsBAMsorted_ch
    path featureCountsBAIsorted from featureCountsBAIsorted_ch

    output:
    publishDir "${params.outDir}/step7_buildCountMatrix",
        mode: 'copy'
    path "*.tsv.gz" into countMatrix_ch

    script:
    """
	umi_tools count --per-gene \
		--gene-tag=XT \
		--assigned-status-tag=XS \
		--per-cell \
		--method=directional \
		-L umicount.log \
		-I $featureCountsBAMsorted \
		-S counts.tsv.gz
    """
}
