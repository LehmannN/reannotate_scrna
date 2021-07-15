#!/usr/bin/env nextflow

include { featureCounts } from '../processes/quantif/featureCounts'
include { sortBAMFiles } from '../processes/utilities/sortBAMFiles'
include { buildCountMatrix } from '../processes/quantif/buildCountMatrix'

workflow QUANTIF {
    take:
        gtf
        bam

    main:
        featureCounts(gtf, bam)
        sortBAMFiles(featureCounts.out.flatten().last())
        buildCountMatrix(sortBAMFiles.out[0], sortBAMFiles.out[1])

    emit:
        countMatrix = buildCountMatrix.out[0]

}
