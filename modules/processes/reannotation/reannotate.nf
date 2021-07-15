#!/usr/bin/env nextflow

// Finished
process reannotate {

    tag "reannotate"
    publishDir "${params.outDir}/reannotation", mode: 'copy'

    input:
    file gtfREF
    file bamONT

    output:
    file "${params.reannotationTool}.gtf"
    path "${params.reannotationTool}.std*"

    script:
	if( params.reannotationTool == 'stringtie' ) {
    	"""
    	stringtie -L -m 50 -g 50 -c 1 -s 2 -j 1 \
        	-p $params.threads \
        	-G $gtfREF \
        	-o "${params.reannotationTool}.gtf" \
        	$bamONT \
             1> "${params.reannotationTool}.stdout" \
             2> "${params.reannotationTool}.stderr"

    	"""
    } else if ( params.reannotationTool == 'scallop' ) {
		"""
		scallop -i $bamONT \
        	-o "${params.reannotationTool}.gtf" \
        	--library_type unstranded \
            1> "${params.reannotationTool}.stdout" \
            2> "${params.reannotationTool}.stderr"
    	"""
    } else
        error "Invalid reannotation tool"
}
