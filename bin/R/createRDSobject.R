#!/usr/bin/env Rscript

#*********************************
# Define arguments
#*********************************

library("optparse")
option_list = list(make_option(c("-f", "--file"),
							   type = "character",
							   default = NULL,
							   help="Dataset file name",
							   metavar="character"),
				   make_option(c("-o", "--output"),
							   type = "character",
							   default = "matrix.rds",
							   help="Output file name [default= %default]",
							   metavar="character"))
opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)

if (is.null(opt$file)){
	print_help(opt_parser)
	stop("At least one argument must be supplied (input file).n", call.=FALSE)
}

#*********************************
# Libraries
#*********************************

library(dplyr)
library(tidyr)
library(data.table)
library(parallel)
library(Matrix)
library(Seurat)


#*********************************
# UMI-tools output -> Matrix
#*********************************
counts_long <- fread(opt$file,
					 header = TRUE,
					 nThread = detectCores()/2)

counts_wide <- as.data.frame(pivot_wider(counts_long,
										 names_from = cell,
										 values_from = count,
										 values_fill = 0))
rownames(counts_wide) <- counts_wide[,1]
counts_wide[,1] <- NULL

#*********************************
# Matrix -> SeuratObject
#*********************************
data_seurat <- CreateSeuratObject(counts_wide, min.cells = 0, min.features = 0)
saveRDS(data_seurat, file = opt$output)
