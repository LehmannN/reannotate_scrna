#!/usr/bin/env nextflow

include { reannotate } from '../processes/reannotation/reannotate'

workflow REANNOTATION {
    take:
        gtfREF
        bamONT

    main:
        reannotate(gtfREF, bamONT)

   emit:
        gtfNOVEL = reannotate.out[0]

}
