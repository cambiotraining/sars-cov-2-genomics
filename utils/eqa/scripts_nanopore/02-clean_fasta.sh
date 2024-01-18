#!/bin/bash

cat results/viralrecon/medaka/*.consensus.fasta | sed 's|/ARTIC/medaka MN908947.3||' > report/consensus.fa