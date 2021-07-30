#!/usr/bin/env bash

nextflow run main_references.nf -profile standard \
	-w work_ref \
	-c nextflow_references.config \
	-params-file params_references.yml \
	--workflow scAnalyses
