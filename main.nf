#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

log.info """\

s c A n n o t a t i O N T    P I P E L I N E
===================================
    transcriptome: ${params.ref}
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

	ref = channel.fromPath( params.ref, checkIfExists: true )
	bamONT = channel.fromPath( params.bamONT, checkIfExists: true )

    main:
    if( params.workflow == 'reannotation' ){
        REANNOTATE(ref, bamONT)
        COMPAREGTF(ref, REANNOTATE.out)
    }
    else if( params.workflow = 'compare' )
        COMPAREGTF(ref, params.ref2)
    else
        error "Please choose a proper worflow (e.g. reannotation, compare...)"

}
