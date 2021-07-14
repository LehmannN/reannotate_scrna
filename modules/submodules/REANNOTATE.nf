params.outDir = 'output'

include { stringtie } from '../processes/stringtie'

workflow REANNOTATE {
    take:
        ref
        bamONT

    main:
        stringtie(ref, bamONT)

    emit:
        novelGTF = stringtie.out

}
