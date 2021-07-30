#!/usr/bin/env bash

nextflow run main.nf -profile condor \
	-w work \
	-params-file params.yml \
	--workflow reference

nextflow run main.nf -profile standard \
	-w work \
	--workflow scAnalyses
