#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

log.info """\

s c A n n o t a t i O N T    P I P E L I N E
===================================
    transcriptome: ${params.gtfREF}
    reads ONT    : ${params.bamONT}
    outdir       : ${params.outDir}
    threads      : ${params.threads}
    workflow     : ${params.workflow}

"""

/*
 *  Main script
 */

include { REANNOTATION } from './modules/submodules/REANNOTATION'
include { MERGEGTF } from './modules/submodules/MERGEGTF'
include { COMPAREGTF as COMPAREGTF_1 } from './modules/submodules/COMPAREGTF'
include { COMPAREGTF as COMPAREGTF_2 } from './modules/submodules/COMPAREGTF'
include { QUANTIF } from './modules/submodules/QUANTIF'

workflow {

	gtfREF = channel.fromPath( params.gtfREF, checkIfExists: true )
	bamONT = channel.fromPath( params.bamONT, checkIfExists: true )
	genomeREF = channel.fromPath( params.genomeREF, checkIfExists: true )
	bamScRNA = channel.fromPath( params.bamScRNA, checkIfExists: true )

    main:
    if( params.workflow == 'reannotation' ){
        REANNOTATION(gtfREF, bamONT)
        COMPAREGTF_1(gtfREF, REANNOTATION.out)
        MERGEGTF(gtfREF, REANNOTATION.out, genomeREF)
        COMPAREGTF_2(gtfREF, MERGEGTF.out)
        QUANTIF(MERGEGTF.out, bamScRNA)
        QUANTIF.out.countMatrix.view()
    } else if( params.workflow = 'compare' )
        COMPAREGTF(gtfREF, params.ref2)
    else
        error "Please choose a proper worflow (e.g. reannotation, compare...)"
}
