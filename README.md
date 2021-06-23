# scAnnotatiONT tool and pipeline

## Introduction

## Pipeline summary

| Step | Tool | Input | Output |
| -------- | -------- | -------- | -------- |
| Transcript assembly | - StringTie2 | BAM + GTF | BAM |
| | - Scallop | | |
| Compare novel annotations with reference | gffcompare | GTF | summary.txt |
| Create bigWig coverage files | BEDTools | BAM + GTF | BAM |
| Assign reads to genes | featureCounts | BAM + GTF | BAM |
| Count unique reads per genes per cell | UMI-tools | BAM | count_matrix.txt |
| Create Seurat object | Rscript | BAM | count_matrix.txt |

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
