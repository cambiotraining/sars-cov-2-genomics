#!/bin/bash

# create outut directories
mkdir results/mafft
mkdir results/iqtree

# combine sequences
cat report/consensus.fa resources/eqa_collaborators/eqa_consensus.fa > results/mafft/unaligned_consensus.fa

# alignment
mafft --6merpair --maxambiguous 0.2 --addfragments results/mafft/unaligned_consensus.fa resources/reference/sarscov2.fa > results/mafft/alignment.fa

# tree inference
iqtree2 -s results/mafft/alignment.fa --prefix results/iqtree/consensus
