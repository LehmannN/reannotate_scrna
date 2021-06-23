# scAnnotatiONT tool and pipeline

## Introduction

## Pipeline summary

| Step | Tool | Input | Output |
| -------- | -------- | -------- | -------- |
| 1. Construct novel annotation | [StringTie2](https://ccb.jhu.edu/software/stringtie/) <br> [Scallop](https://github.com/Kingsford-Group/scallop) <br> [groHMM](https://www.bioconductor.org/packages/release/bioc/html/groHMM.html) <br> scAnnotatiONT-tool  | `BAM` <br> `GTF` | `GTF` |
| 2. Merge novel and reference annotations | [cuffmerge](http://cole-trapnell-lab.github.io/cufflinks/cuffmerge/) | `GTF` | `GTF` |
| 3. Compare novel annotations with reference | [GffCompare](https://ccb.jhu.edu/software/stringtie/gffcompare.shtml) | `GTF` | `summary.txt` |
| 4. Extract more statistics from novel annotation | Rscript | `GTF` | `report_stats_annotation.txt` |
| 5. Build UCSC trackhub | bash script | `BAM` <br> `GTF` | `UCSC trackhub folder` <br> `bigWig` <br> `bigGenePred` |
| 6. Assign reads to genes | [featureCounts](http://subread.sourceforge.net/) | `BAM` <br> `GTF` | `BAM` |
| 6. Sort and index BAM file | [Samtools](http://www.htslib.org/) | `BAM` | `BAM` <br> `BAI` |
| 7. Count unique reads per genes per cell | [UMI-tools](https://github.com/CGATOxford/UMI-tools) | `BAM` | `count_matrix.txt` |
| 8. Run MultiQC | [MultiQC](https://multiqc.info/) | `BAM` <br> `GTF` | `multiqc_report.html` |
| 9. Create RDS object (Seurat, SCE or CDS) | Rscript | `BAM` | `raw_seurat.rds` <br> `raw_sce.rds` <br> `raw_cds.rds` |
| 10. scRNA-seq data preprocessing and filtering | Rscript | `RDS object` | `RDS object` <br> `report_preprocessing.html` |
| 11. scRNA-seq data standard analysis (clustering, differential expression...) | Rscript | `RDS object` | `RDS object` <br> `report_analysis.html` |

## Quickstart

### Prerequisites
  - Nextflow
  - Java 1.7+
  - Docker

### Usage

```bash
$ nextflow run . -profile template --threads 4 --output output
```
### Pipeline Options

Option | Description
--------- | -----------
`help` | Display help message
`threads` | Number of threads to use for each process
`output` | Directory to write output files to

## Citation
