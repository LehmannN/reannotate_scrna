#!/usr/bin/env nextflow

include { compareGTF } from '../processes/gtf-processing/compareGTF'

workflow COMPAREGTF {
    take:
        gtfREF
        gtfNOVEL

    main:
        compareGTF(gtfREF, gtfNOVEL)

}
