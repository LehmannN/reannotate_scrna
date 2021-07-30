#!/bin/sh

rds=$1
gtf=$2

set -ev
Rscript -e "bookdown::render_book('00-Index.Rmd', 'bookdown::gitbook', params = list(rds = '$rds', gtf = '$gtf'))"

# Uncomment next line if you wish to generate a PDF version of the report
#Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
