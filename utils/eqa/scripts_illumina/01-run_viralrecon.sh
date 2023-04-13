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
  --skip_pangolin \
  --skip_nextclade \
  --platform illumina