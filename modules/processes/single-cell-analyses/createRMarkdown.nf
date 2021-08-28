#!/usr/bin/env nextflow


/*
 *  Create RMarkdown repository (in the style of cookiecutter_R and bookdown)
 */

process createRMarkdown {

    publishDir "${params.outDir}/${rdsID}", mode: 'copy'

    input:
    path rmdFiles
    tuple val(rdsID), file(rdsFile)

    output:
    file 'scRNA/*'

    script:
    """
    mkdir -p scRNA
    cp -r $rmdFiles/* scRNA/
    """
}
