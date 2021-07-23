#!/usr/bin/env Rscript

#*********************************
# Define arguments
#*********************************

library("optparse")
option_list = list(make_option(c("-i", "--input"),
							   type = "character",
							   default = "counts.tsv.gz",
							   help="Input UMI-tools count matrix [default = %default]",
							   metavar="character"),
				   make_option(c("-o", "--output"),
							   type = "character",
							   default = "matrix.rds",
							   help="Output file name [default = %default]",
							   metavar="character"))
opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)

if (is.null(opt$input)){
	print_help(opt_parser)
	stop("At least one argument must be supplied (input file).", call.=FALSE)
}


#*********************************
# Input: UMI-tools output (long format only)
# Output: R data.frame
#*********************************
counts_long <- data.table::fread(opt$input,
					 header = TRUE,
					 nThread = parallel::detectCores()/2)

counts_wide <- as.data.frame(tidyr::pivot_wider(counts_long,
										 names_from = cell,
										 values_from = count,
										 values_fill = 0))
rownames(counts_wide) <- counts_wide[,1]
counts_wide[,1] <- NULL

#*********************************
# Input: R data.frame
# Output: SeuratObject stored in an RDS object
#*********************************
data_seurat <- Seurat::CreateSeuratObject(counts_wide, min.cells = 0, min.features = 0)
saveRDS(data_seurat, file = opt$output)
