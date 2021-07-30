#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

//gtfREF = Channel.fromPath( params.gtfREF, checkIfExists: true )
//feature = Channel.fromList( params.feature )
bamONT = Channel.fromPath( params.bamONT, checkIfExists: true )
genomeREF = Channel.fromPath( params.genomeREF, checkIfExists: true )
bamScRNA = Channel.fromPath( params.bamScRNA, checkIfExists: true )
rscripts = Channel.fromPath( './bin/R/*.R', checkIfExists: true, type: 'file')
bashscripts = Channel.fromPath( './bin/bash/*.sh', checkIfExists: true, type: 'file')
//rmd = Channel.fromPath( './bin/rmd_files', checkIfExists: true, type: 'dir')
rmd = Channel.fromPath( params.rmd )
//rds = Channel.fromPath( params.rds )
rds = Channel
        .fromPath( params.rds )
        .map { file -> tuple(file.simpleName, file) }
//matrix = Channel.fromPath( './data/counts.tsv.gz', checkIfExists: true )


log.info """\

    s c A n n o t a t i O N T    P I P E L I N E
    ===================================
    transcriptome: ${params.gtfREF}
    reads ONT    : ${params.bamONT}
    outdir       : ${params.outDir}
    threads      : ${params.threads}
    workflow     : ${params.workflow}
    feature      : ${params.feature}
    rds          : ${params.rds}

"""

/*
 *  Main script
 */

include { REANNOTATION } from './modules/submodules/REANNOTATION'
include { MERGEGTF } from './modules/submodules/MERGEGTF'
include { COMPAREGTF as COMPAREGTF_1 } from './modules/submodules/COMPAREGTF'
include { COMPAREGTF as COMPAREGTF_2 } from './modules/submodules/COMPAREGTF'
include { QUANTIF } from './modules/submodules/QUANTIF'
include { createRDS } from './modules/processes/single-cell-analyses/createRDS'
include { createRMarkdown } from './modules/processes/single-cell-analyses/createRMarkdown'
include { preprocessRDS } from './modules/processes/single-cell-analyses/preprocessRDS'


    workflow {

    main:
    if( params.workflow == 'reannotation' ){
        REANNOTATION(gtfREF, bamONT)
        COMPAREGTF_1(gtfREF, REANNOTATION.out)
        MERGEGTF(gtfREF, REANNOTATION.out, genomeREF)
        COMPAREGTF_2(gtfREF, MERGEGTF.out)
        QUANTIF(MERGEGTF.out, bamScRNA)
        QUANTIF.out.countMatrix.view()
        createRDS(rscripts.filter(~/.*createRDS.R/), matrix)
    } else if( params.workflow == 'reference' ){
        //featureCounts(gtfREF, bamScRNA, params.feature)
        QUANTIF(gtfREF, bamScRNA, params.feature)
        QUANTIF.out.countMatrix.view()
        createRDS(rscripts.filter(~/.*createRDS.R/), QUANTIF.out.countMatrix)
    } else if( params.workflow == 'scAnalyses' ) {
        createRMarkdown(rmd, rds)
        preprocessRDS(createRMarkdown.out, rds)
        //secondaryAnalyses
    } else {
        error "Please choose a proper worflow (e.g. reannotation, compare...)"
    }}
