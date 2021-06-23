# scAnnotatiONT tool and pipeline

## Introduction

## Pipeline summary

| Step | Tool | Input | Output |
| -------- | -------- | -------- | -------- |
| Transcript assembly | [StringTie2](https://ccb.jhu.edu/software/stringtie/) <br> [Scallop](https://github.com/Kingsford-Group/scallop) | `BAM` <br> `GTF` | `GTF` |
| Compare novel annotations with reference | [GffCompare](https://ccb.jhu.edu/software/stringtie/gffcompare.shtml) | `GTF` | `summary.txt` |
| Create bigWig coverage files | [BEDTools](https://bedtools.readthedocs.io/en/latest/) | `BAM` <br> `GTF` | `bigWig` |
| Assign reads to genes | [featureCounts](http://subread.sourceforge.net/) | `BAM` <br> `GTF` | `BAM` |
| Count unique reads per genes per cell | [UMI-tools](https://github.com/CGATOxford/UMI-tools) | `BAM` | `count_matrix.txt` |
| Create rds object (Seurat, SCE or CDS) | Rscript | BAM | `raw_seurat.rds` <br> `raw_sce.rds` <br> `raw_cds.rds` |

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
help | `Display help message.`
threads | `Number of threads to use for each process.`
output | `Directory to write output files to.`

## Citation
