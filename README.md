# scAnnotatiONT tool and pipeline

## Introduction

## Pipeline summary

| Step | Tool | Input | Output |
| -------- | -------- | -------- | -------- |
| 1. Construct novel annotation | [StringTie2](https://ccb.jhu.edu/software/stringtie/) <br> [Scallop](https://github.com/Kingsford-Group/scallop)  | `BAM` <br> `GTF` | `GTF` |
| 2. Merge novel and reference annotations | [cuffmerge](http://cole-trapnell-lab.github.io/cufflinks/cuffmerge/) | `GTF` | `GTF` |
| 3. Compare novel annotations with reference | [GffCompare](https://ccb.jhu.edu/software/stringtie/gffcompare.shtml) | `GTF` | `summary.txt` |
| 4. Extract more statistics from novel annotation | Rscript | `GTF` | `report_stats_annotation.txt` |
| 5. Build UCSC trackhub | bash script | `BAM` <br> `GTF` | `UCSC trackhub folder` <br> `bigWig` <br> `bigGenePred` |
| 6. Assign reads to genes | [featureCounts](http://subread.sourceforge.net/) | `BAM` <br> `GTF` | `BAM` |
| 7. Sort and index BAM file | [Samtools](http://www.htslib.org/) | `BAM` | `BAM` <br> `BAI` |
| 8. Count unique reads per genes per cell | [UMI-tools](https://github.com/CGATOxford/UMI-tools) | `BAM` | `count_matrix.txt` |
| 9. Run MultiQC | [MultiQC](https://multiqc.info/) | `BAM` <br> `GTF` | `multiqc_report.html` |

## Quickstart

### Prerequisites
  - Nextflow
  - Java 1.7+
  - Singularity

### Usage

```bash
$ nextflow run . -profile singularity --threads 4 --output output
```
### Pipeline Options

Option | Description
--------- | -----------
`help` | Display help message
`threads` | Number of threads to use for each process
`output` | Directory to write output files to

## Citation
