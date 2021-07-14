params.outDir = 'output'

include { stringtie } from '../processes/stringtie'

workflow REANNOTATE {
    take:
        gtfREF
        bamONT

    main:
        stringtie(gtfREF, bamONT)

    emit:
        gtfNOVEL = stringtie.out

}
