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

include { REANNOTATE } from './modules/submodules/REANNOTATE'
include { COMPAREGTF } from './modules/submodules/COMPAREGTF'

workflow {

	gtfREF = channel.fromPath( params.ref, checkIfExists: true )
	bamONT = channel.fromPath( params.bamONT, checkIfExists: true )

    main:
    if( params.workflow == 'reannotation' ){
        REANNOTATE(gtfREF, bamONT)
        COMPAREGTF(gtfREF, REANNOTATE.out)
    }
    else if( params.workflow = 'compare' )
        COMPAREGTF(gtfREF, params.ref2)
    else
        error "Please choose a proper worflow (e.g. reannotation, compare...)"

}
