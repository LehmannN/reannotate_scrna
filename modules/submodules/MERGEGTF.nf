#!/usr/bin/env nextflow

include { mergeGTF } from '../processes/reannotation/mergeGTF'

workflow MERGEGTF {
    take:
        gtfREF
        gtfNOVEL
        genomeREF

    main:
        mergeGTF(gtfREF, gtfNOVEL, genomeREF)

    emit:
        gtfNOVEL = mergeGTF.out

}
