#!/usr/bin/env nextflow

params.help = ""
params.annotation = "$baseDir/data/annotation/*.gtf"
params.threads = 1
params.output = "./output"

genome = file(params.genome)
threads = params.threads

if(params.help) {
    log.info ''
    log.info 'Starter Template'
    log.info ''
    log.info 'Usage: '
    log.info '    nextflow run . -profile template [options]'
    log.info ''
    log.info 'Script Options: '
    log.info '    --threads		INT	Number of threads to use'
    log.info '    --output		DIR	Directory to write output files'
    log.info '    --help		BOOL	Display help message'
    log.info ''

    return
}
