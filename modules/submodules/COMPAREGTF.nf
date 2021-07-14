params.outDir = 'output'

include { gffcompare } from '../processes/gffcompare'

workflow COMPAREGTF {
    take:
        ref
        gtf

    main:
        gffcompare(ref, gtf)

}
