#!/bin/bash

nextflow run nf-core/viralrecon -profile singularity \
  --max_memory '12.GB' --max_cpus 4 \
  --input samplesheet.csv \
  --outdir results/viralrecon \
  --protocol amplicon \
  --genome 'MN908947.3' \
  --primer_set artic \
  --primer_set_version 3 \
  --skip_assembly \
  --platform nanopore \
  --artic_minion_caller medaka \
  --artic_minion_medaka_model r941_min_hac_g507 \
  --skip_pangolin \
  --skip_nextclade \
  --fastq_dir data/fastq_pass