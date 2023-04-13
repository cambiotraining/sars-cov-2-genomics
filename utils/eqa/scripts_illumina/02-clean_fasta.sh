#!/bin/bash

cat results/viralrecon/variants/ivar/consensus/bcftools/*.consensus.fa | sed 's/ MN908947.3//' > report/consensus.fa