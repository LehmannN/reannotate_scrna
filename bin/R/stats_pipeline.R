#!/usr/bin/env Rscript

library(tidyr)
library(dplyr)
library(ggplot2)
library(GenomicFeatures)
library(tidyverse)
library(viridis)
library(scales)
library(knitr)

#args = commandArgs(trailingOnly=TRUE)
#if (length(args)==0) {
#	stop("At least one argument must be supplied (input file).n", call.=FALSE)
#}
#print(args[1])

#files <- list.files(args[1])
#print(files)
#dlist = list()
#for (i in 1:length(files)){
#	print(files[i])
#}

filePath <- "../../output/pipeline_annot/scallop_LR_20200525/"
fileName <- "gffcmp.stats.txt"
df <- read.delim(file = paste0(filePath, fileName),
				 header = FALSE,
				 col.names = c('Level', 'Sensitivity', 'Precision', 'Tool', 'Reads', 'Merge'))
pathData <- str_split(string = filePath, pattern = '/')[[1]]
for (i in 1:length(filePath)){
	if (grepl(x = filePath[i], pattern = 'stringtie|scallop')){
		toolIndex <- i
	} else if (grepl(x = filePath[i], pattern = 'merge')){
		mergeIndex <- i
	}
	if (mergeIndex) # does not exist
}
fileTool <- str_split(string = metadata[toolIndex], pattern = '_')[[1]][1]
fileRead <- str_split(string = metadata[toolIndex], pattern = '_')[[1]][2]
fileMerge <- str_split(string = metadata[mergeIndex], pattern = '_')[[1]][1]
print(fileTool)
print(fileRead)
print(fileMerge)


#for (f in files){
#	df <- read.table(f, sep = '\t')
#	df$V4 <- 'StringTie2 ONT' # name cut f1
#	names(df) <- c('Level', 'Sensitivity', 'Precision', 'Annotation')
#	df$Sequencing <- 'LR' # name cut f2
#	dlist[[1]] <- df
#}
#df <- dplyr::bind_rows(dlist)
#saveRDS(df, 'output/pipeline_annot_rds/')
