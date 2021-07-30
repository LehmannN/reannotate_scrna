#!/usr/bin/env Rscript

#*********************************
# Define arguments
#*********************************

library("dplyr")
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
							   metavar="character"),
				   make_option(c("-g", "--genename"),
							   type = "character",
							   default = FALSE,
							   help="Turn gene ID to gene Name [default = %default]",
							   metavar="character"),
					make_option(c("-b", "--biomart"),
							   type = "character",
							   default = "martquery.txt",
							   help="Biomart table with gene ID and gene Name, compulsory --genename TRUE [default = %default]",
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

if (opt$genename == TRUE) {
	if (file.exists(opt$biomart)) {
		biomart <- read.table(file = opt$biomart, header = TRUE, sep = '\t')
		biomart <- biomart %>% mutate(gene = Gene.stable.ID.version)
		id <- match(counts_wide$gene, biomart$Gene.stable.ID.version)
		counts_wide <- counts_wide %>%
			left_join(biomart[id,c("gene", "Gene.name")]) %>%
			mutate(row_names = ifelse(Gene.name == "",
									  gene, Gene.name)) %>%
			mutate(row_names_dup = ifelse(duplicated(row_names) |
									   duplicated(row_names, fromLast=TRUE ),
								   gene, row_names))
	}
	# else print error
}

counts_wide <- counts_wide %>%
			left_join(mart[,c("gene", "Gene.name")]) %>%
			mutate(row_names = ifelse(Gene.name != "", Gene.name, gene)) %>%
			mutate(row_names = ifelse(duplicated(row_names) | duplicated(row_names, fromLast=TRUE ), gene, row_names))

rownames(counts_wide) <- counts_wide[,'row_names_dup']
counts_wide[,c('gene', 'Gene.name', 'row_names', 'row_names_dup')] <- NULL

#*********************************
# Input: R data.frame
# Output: SeuratObject stored in an RDS object
#*********************************
data_seurat <- Seurat::CreateSeuratObject(counts_wide, min.cells = 0, min.features = 0)
saveRDS(data_seurat, file = opt$output)
