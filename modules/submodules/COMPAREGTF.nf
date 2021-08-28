#!/usr/bin/env nextflow

include { gffCompare } from '../processes/stats/gffCompare.nf'

workflow COMPAREGTF {
    take:
        gtfREF
        gtfNOVEL

    main:
        gffCompare(gtfREF, gtfNOVEL)

}
