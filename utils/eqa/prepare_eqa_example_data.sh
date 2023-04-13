#!/bin/bash

set -e  # exit on error

cd ~/Documents

# download all the example EQA datasets
wget -O temp.zip "https://www.dropbox.com/sh/qh3f76bgwi9ipyx/AACyBcWllHF2VNWKMcMA09eqa?dl=1"

# unzip - there should be 4 Illumina and 4 nanopore folders
unzip temp.zip
rm temp.zip

# make a copy for the pre-processed data
mkdir .trainers
cp -r eqa* .trainers
cd .trainers

# process each of them
for i in eqa_illumina_dataset*
do 
  cd $i
  
  mkdir results
  mkdir report
  
  # run all scripts
  wget -O scripts/01-run_viralrecon.sh https://raw.githubusercontent.com/cambiotraining/sars-cov-2-genomics/main/utils/eqa/scripts_illumina/01-run_viralrecon.sh
  bash scripts/01-run_viralrecon.sh
  
  wget -O scripts/02-clean_fasta.sh https://raw.githubusercontent.com/cambiotraining/sars-cov-2-genomics/main/utils/eqa/scripts_illumina/02-clean_fasta.sh
  bash scripts/02-clean_fasta.sh
  
  wget -O scripts/03-missing_intervals.sh https://raw.githubusercontent.com/cambiotraining/sars-cov-2-genomics/main/utils/eqa/scripts_illumina/03-missing_intervals.sh
  bash scripts/03-missing_intervals.sh
  
  wget -O scripts/04-lineages.sh https://raw.githubusercontent.com/cambiotraining/sars-cov-2-genomics/main/utils/eqa/scripts_illumina/04-lineages.sh
  bash scripts/04-lineages.sh
  
  wget -O scripts/05-phylogeny.sh https://raw.githubusercontent.com/cambiotraining/sars-cov-2-genomics/main/utils/eqa/scripts_illumina/05-phylogeny.sh
  bash scripts/05-phylogeny.sh

  wget -O scripts/06-civet.sh https://raw.githubusercontent.com/cambiotraining/sars-cov-2-genomics/main/utils/eqa/scripts_illumina/06-civet.sh
  bash scripts/06-civet.sh
  
  Rscript scripts/07-data_integration.R
  
  # clean nextflow work directory to save space
  rm -r work .nextflow*
  cd ..
  
  echo "------------"
  echo "PROCESSED $i"
  echo "------------"
done


for i in eqa_nanopore_dataset*
do 
  cd $i
  
  mkdir results
  mkdir report
  
  # run all scripts
  wget -O scripts/01-run_viralrecon.sh https://raw.githubusercontent.com/cambiotraining/sars-cov-2-genomics/main/utils/eqa/scripts_nanopore/01-run_viralrecon.sh
  bash scripts/01-run_viralrecon.sh
  
  wget -O scripts/02-clean_fasta.sh https://raw.githubusercontent.com/cambiotraining/sars-cov-2-genomics/main/utils/eqa/scripts_nanopore/02-clean_fasta.sh
  bash scripts/02-clean_fasta.sh
  
  wget -O scripts/03-missing_intervals.sh https://raw.githubusercontent.com/cambiotraining/sars-cov-2-genomics/main/utils/eqa/scripts_nanopore/03-missing_intervals.sh
  bash scripts/03-missing_intervals.sh
  
  wget -O scripts/04-lineages.sh https://raw.githubusercontent.com/cambiotraining/sars-cov-2-genomics/main/utils/eqa/scripts_nanopore/04-lineages.sh
  bash scripts/04-lineages.sh
  
  wget -O scripts/05-phylogeny.sh https://raw.githubusercontent.com/cambiotraining/sars-cov-2-genomics/main/utils/eqa/scripts_nanopore/05-phylogeny.sh
  bash scripts/05-phylogeny.sh

  wget -O scripts/06-civet.sh https://raw.githubusercontent.com/cambiotraining/sars-cov-2-genomics/main/utils/eqa/scripts_nanopore/06-civet.sh
  bash scripts/06-civet.sh
  
  Rscript scripts/07-data_integration.R
  
  # clean nextflow work directory to save space
  rm -r work .nextflow*
  cd ..
  
  echo "------------"
  echo "PROCESSED $i"
  echo "------------"
done