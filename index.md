---
pagetitle: "SARS-CoV-2 Genomics"
---

# Introduction to SARS-CoV-2 Genomics

:::highlight

This course will teach you how to analyse sequencing data from SARS-CoV-2 amplicon samples to generate consensus sequences ready to be uploaded to public databases such as GISAID and to be used in other downstream analysis such as variant annotation and phylogeny. We will teach the use of a standardised analysis pipeline (following the widely used ARTIC protocol), which can work with both Illumina and Nanopore data. We will also cover how to assign sequences to lineages, identify variants of interest/concern and build reports to communicate your findings. Along the way, you will gain basic bioinformatic skills, including the use of the Unix command line and learn to write simple scripts to ensure your analysis is reproducible. 

:::

**Learning Goals:**

- Recognise the uses of genomic surveillance to inform public health actions during a pandemic. 
- Assemble high-quality viral genome sequences from raw sequencing data.
- Assign consensus sequences to lineages and identify variants of interest/concern.
- Capture high-quality metadata, recognising its impact on downstream analyses.
- Produce reports to communicate these findings and help inform public health action. 

**Learning Objectives:**

By the end of this course, learners should be able to:

- Enumerate examples of how the genomic surveillance of SARS-CoV-2 has impacted public health decisions during the ongoing pandemic. 
- Contrast the different technologies and protocols commonly used for SARS-CoV-2 sequencing, including the pros and cons of each. 
- Understand the importance and uses of metadata such as geolocation, date of collection and protocols used. 
- Use the Unix command line to navigate a filesystem, manipulate files, launch programs and write scripts for reproducible analysis.
- Recognise the structure of common file formats in bioinformatics such as FASTA, FASTQ, FAST5 and BED.
- Explain the role of package and workflow managers in bioinformatics and make use of _Conda_ and _Nextflow_ for reproducible data analysis.
- Summarise the steps in the bioinformatic pipeline used for assembling SARS-CoV-2 genomes from high-throughput amplicon sequencing.
- Apply the `connor-lab/ncov2019-artic-nf` _Nextflow_ pipeline to generate a consensus sequence from Illumina and Nanopore data.
- Assess the quality of the consensus sequences in terms of their coverage, accuracy and contamination; identify high-quality sequences suitable for downstream analyses and submission to public databases.
- Perform sequence annotation using `pangolin` (assign Pango lineages) and `scorpio` (variants of interest/concern)
- Build static and/or interactive reports using tools such as _Civet_ and _Nextstrain_ to summarise and communicate the results from your analysis. 


## Target Audience

This course is aimed at life scientists interested in the bioinformatic analysis of SARS-CoV-2 genomic data. Those with prior experience in bioinformatics may also benefit from the later sessions of the course, which cover specific analysis of SARS-CoV-2 data (earlier sessions of the course cover basic skills such as the Unix command line and could be skipped by experienced bioinformaticians).


## Prerequisites

We assume no prior bioinformatics experience or experience with the tools introduced in this course. 
An elementary knowledge of molecular and viral biology is assumed (concepts such as: DNA, RNA, PCR, primers, SNPs).


## Schedule 

This is a very rough working draft:

| | Session | Duration |
|--:|:--|:--|
| Day 1 | Introduction to SARS-CoV-2 Genomics | 1h |
|| Introduction to the Unix Command Line | 2h |
|| Introduction to NGS Sequencing | 1.5h |
| Day 2 | SARS-CoV-2 Reference-based Consensus Assembly | 1.5h |
|| Quality Control of Consensus Sequences | 1.5h |
| Day 3 | Lineage Assignment and Variant Classification | 1.5h |
|| Reporting and Communication | 1.5h | 
| Day 4 | Managing and Installing Software | 1.5h |
|| Q&A | 1h |


## Acknowledgements

These materials have been developed as a collaboration between the Bioinformatics Training Facility (University of Cambridge) and the [New Variant Assessment Platform (NVAP)](https://www.gov.uk/guidance/new-variant-assessment-platform) from Public Health England.
Our partners also include [COG Train](https://www.cogconsortium.uk/cog-train/about-cog-train/).

We thank CLIMB BIG DATA for publicly sharing their [workshop videos](https://www.youtube.com/channel/UCdiGIIyryQL3x-Og5uiY1rw), which inspired some of these materials.
