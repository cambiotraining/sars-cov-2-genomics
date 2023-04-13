#!/bin/bash

# run civet analysis
civet -i sample_info.csv \
  -f report/consensus.fa \
  -icol sample \
  -idate collection_date \
  -d resources/civet_background_data/ \
  -o results/civet