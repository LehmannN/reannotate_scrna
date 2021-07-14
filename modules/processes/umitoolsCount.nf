#!/usr/bin/env nextflow

nextflow.enable.dsl=2

/*
 * 0. Channels declaration
 */

annotStrategy = 'stringtie'
mergeStrategy = 'agat'

/*
 * 1. Construct novel annotation
 */

process createNovelAnnotationONT {

    tag "Create novel annotation with $annotStrategy"

    output:
    publishDir "${params.outDir}/step1_createAnnotation",
        mode: 'copy'
    path "novelAnnotationOnt.gtf" into novelAnnot_ch

    script:
    if( annotStrategy == 'stringtie' )
        """
        stringtie -L -m 50 -g 50 -c 1 -s 2 -j 1 \
            -p $params.threads \
            -G $params.refAnnotation \
            -o novelAnnotationOnt.gtf \
            $params.bamOnt
        """
    else if( annotStrategy == 'scallop' )
        """
        scallop -i $params.bamOnt \
            -o novelAnnotationOnt.gtf \
            $params.config.scallop
        """
    else
        error "Invalid annotation strategy"

}

/*
 * 1.bis cat 
 */

process createListGTF {

    tag "Create listGTF"

    input:
    path novelAnnotationOnt from novelAnnot_ch

    output:
    publishDir "${params.outDir}/step1_createAnnotation",
        mode: 'copy'
    path "listGTFs.txt" into listGTFs_ch

    script:
    """
    echo "${PWD}/${params.outDir}/step1_createAnnotation/$novelAnnotationOnt" > listGTFs.txt
    """

}


/*
 * 2. Merge novel with ref
 */

process mergeNovelAndRef {

    tag "Merge $params.refAnnotation and $novelAnnotationOnt"

    input:
    path novelAnnotationOnt from novelAnnot_ch
    path listGTFs from listGTFs_ch

    output:
    publishDir "${params.outDir}/step2_mergeGTF",
        mode: 'copy'
    path "merged.gff" into mergedGTF_ch

    script:
    if( mergeStrategy == 'agat' )
        """
        agat_sp_merge_annotations.pl --gff $params.refAnnotation \
            --gff $novelAnnotationOnt \
            --output merged
        """
    else if( mergeStrategy == 'cuffmerge' )
        """
        cuffmerge -p $params.threads \
            --min-isoform-fraction 0.05 \
            --ref-gtf $params.refAnnotation \
            --ref-sequence $params.refGenome \
            -o step2_mergeGTF \
            $listGTFs
        """
    else
        error "Invalid merging strategy"

}

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
