params.outDir = 'output'

include { gffcompare } from '../processes/gffcompare'

workflow COMPAREGTF {
    take:
        gtfREF
        gtfNOVEL

    main:
        gffcompare(gtfREF, gtfNOVEL)

}
