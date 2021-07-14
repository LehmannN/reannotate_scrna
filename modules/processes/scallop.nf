#!/usr/bin/env nextflow

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
