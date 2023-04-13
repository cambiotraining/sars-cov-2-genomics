#!/bin/bash

# alignment
mkdir -p results/mafft
mafft --6merpair --maxambiguous 0.2 --addfragments report/consensus.fa resources/reference/sarscov2.fa > results/mafft/alignment.fa

# tree inference
mkdir -p results/iqtree
iqtree2 -s results/mafft/alignment.fa --prefix results/iqtree/consensus
