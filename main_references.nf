#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/*
 *  External scripts
 */
scripts_R = Channel.fromPath( './bin/R/*.R',
    checkIfExists: true,
    type: 'file')
scripts_bash = Channel.fromPath( './bin/bash/*.sh',
    checkIfExists: true,
    type: 'file')

/*
 *  Workflow dynamic inputs
 */
GTF_ref = Channel.fromPath( params.GTF_references,
    checkIfExists: true,
    type: 'file')
RMarkdown = Channel.fromPath( params.RMarkdown,
    checkIfExists: true,
    type: 'dir')
RDS = Channel
        .fromPath( params.RDS )
        .map { file -> tuple(file.simpleName, file) }


/*
 *  Workflow static inputs
 */
params.BAM_scRNA = "./data/bam/full/sc.bam"

/*
 *  Workflow parameters
 */
//feature = Channel.fromList( params.feature )
//params.feature = 'exon'
//params.threads = 30
//params.output_dir = 'output'

/*
 *  Log info
 */
log.info """\

    s c A n n o t a t i O N T    P I P E L I N E
    ===================================
    workflow         : ${params.workflow}
    outdir           : ${params.output_dir}
    threads          : ${params.threads}
    scRNA (BAM)      : ${params.BAM_scRNA}
    transcriptome    : ${params.GTF_references}
    RDS file (matrix): ${params.RDS}
    RMardown path    : ${params.RMarkdown}

"""

/*
 *  Main script
 */
include { COMPAREGTF as COMPAREGTF_1 } from './modules/submodules/COMPAREGTF'
include { COMPAREGTF as COMPAREGTF_2 } from './modules/submodules/COMPAREGTF'
include { QUANTIF } from './modules/submodules/QUANTIF'
include { createRDS } from './modules/processes/single-cell-analyses/createRDS'
include { createRMarkdown } from './modules/processes/single-cell-analyses/createRMarkdown'
include { processRDS } from './modules/processes/single-cell-analyses/processRDS'


workflow {
    main:
    if( params.workflow == 'reference' ){
        //featureCounts(GTF_refs, BAM_scRNA, params.feature)
        QUANTIF(GTF_refs, BAM_scRNA, params.feature)
        QUANTIF.out.countMatrix.view()
        createRDS(rscripts.filter(~/.*createRDS.R/), QUANTIF.out.countMatrix)
    } else if( params.workflow == 'scAnalyses' ) {
        createRMarkdown(RMarkdown, RDS)
        processRDS(createRMarkdown.out, RDS)
    } else {
        error "Please choose a proper worflow (e.g. reannotation, compare...)"
}}
