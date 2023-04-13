#!/bin/bash

# get nextclade data
nextclade dataset get --name sars-cov-2 --output-dir resources/nextclade_background_data

# run nextclade
nextclade run --input-dataset resources/nextclade_background_data/ --output-all results/nextclade report/consensus.fa

# update pangolin data
pangolin --update-data

# run pangolin
pangolin --outdir results/pangolin/ --outfile report.csv report/consensus.fa
