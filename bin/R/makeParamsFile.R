#!/usr/bin/env Rscript

#*********************************
# Define arguments
#*********************************

library("dplyr")
library("optparse")
option_list = list(make_option(c("-i", "--input"),
							   type = "character",
							   default = "params.tsv",
							   help="TSV file with all the parameters without header \
							   (each column is an argument type, each line is a unique argument) \
							   [default = %default]",
							   metavar="character"),
				   make_option(c("-o", "--output"),
							   type = "character",
							   default = "params_full.tsv",
							   help="Output file name [default = %default]",
							   metavar="character"),
				   make_option(c("-d", "--outdir"),
							   type = "character",
							   default = "outputDir_",
							   help="Output directory name [default = %default]",
							   metavar="character"),
				   make_option(c("-w", "--workdir"),
							   type = "character",
							   default = "workDir_",
							   help="Work directory name [default = %default]",
							   metavar="character"))
opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)

if (is.null(opt$input)){
	print_help(opt_parser)
	stop("At least one argument must be supplied (input file).", call.=FALSE)
}


#*********************************
# Input: TSV file with all unique parameters
# Output: TSV file with all possible parameters combinations
#*********************************
params_df <- read.table(opt$input,
						header = FALSE,
						fill = TRUE)

params_vec <- lapply(X = params_df,
					 FUN = function(x) {
						 as.vector(x[which(x != "")])
					 })

params_out <- do.call(data.table::CJ, params_vec)
params_out <- params_out %>% mutate(out = paste0(opt$outdir,
												 seq(1, nrow(params_out))))
params_out <- params_out %>% mutate(work = paste0(opt$workdir,
												 seq(1, nrow(params_out))))

write.table(x = params_out,
			file = opt$output,
			quote = FALSE,
			col.names = FALSE,
			row.names = FALSE)
