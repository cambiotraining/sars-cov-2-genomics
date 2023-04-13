#!/bin/bash

seqkit locate --ignore-case --only-positive-strand --hide-matched -r -p "N+" report/consensus.fa > report/missing_intervals.tsv