#!/usr/bin/env nextflow

/*
 *  Merge two GTF files
 */

process mergeGTF {

    tag "Merge GTF"
    publishDir "${params.outDir}", mode: 'copy'

    input:
    file gtfREF
    file gtfNOVEL
    file genomeREF

    output:
    file 'merged*'

    script:
    if( params.mergeTool == 'agat' ) {
    	"""
    	agat_sp_merge_annotations.pl --gff $gtfREF \
        	--gff $gtfNOVEL \
        	--output merged
    	"""
    } else if ( params.mergeTool == 'cuffmerge' ) {
		"""
        echo $gtfNOVEL > listGTF.txt

        cuffmerge -p $params.threads \
            --min-isoform-fraction $params.cuffmerge_min_isoform_fraction \
            --ref-gtf $gtfREF \
            --ref-sequence $genomeREF \
            -o . \
            listGTF.txt
        """
    } else if ( params.mergeTool == 'stringtie-merge' ) {
		"""
		echo TBA
		"""
    } else
		error "Invalid merging tool"
}
