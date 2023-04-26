#!/bin/bash

: <<'END'
This script change the names of the
headers of the consesus sequences of 
the previous workshop to anonyimize the
institutions  they originated/sequenced.

Each sequence after the '>' in the header 
starts with the name of the institution or 
country. This will be replaced with 'country' string
followed by number starting from 1 and technology 
to sequence like Illumina or Oxford nanopore

After changing header, the final file will
be renamed to eqa_consesus.fa and copied to
each individual 'eqa_collaborator' folder as 
outlined on issue #31 on github repo.
END

sed s/CARPHA/country1_illumina/ <samples.fa >samples_new.fa

sed s/Carrington/country2_ONT/ <samples_new.fa >samples_new1.fa

sed s/Chile/country3_illumina/ <samples_new1.fa >samples_new2.fa

sed s/Cayman/country4_ONT/ <samples_new2.fa >samples_new3.fa

mv samples_new3.fa  eqa_consensus.fa

## for illumina dataset
for dir in eqa_illumina_dataset*

do
	cp eqa_consensus.fa  ${dir}/resources/eqa_collaborator/ 
done

## for nanopore dataset
for dir in eqa_nanopore_dataset*

do
	cp eqa_consensus.fa ${dir}/resources/eqa_collaborator/
done

## clean the folder from the temp fasta files  starting with the name 'samples'
rm samples*.fa
