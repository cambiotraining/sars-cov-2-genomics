---
pagetitle: "SARS-CoV-2 Genomics"
---

# Consensus Assembly Pipeline

::: highlight

**Questions**

- What are the steps involved in assembling SARS-CoV-2 genome from amplicon sequencing (Illumina and Nanopore)?
- How can I do reference-based assembly of SARS-CoV-2 genomes?

**Learning Objectives**

- Summarise the steps in the bioinformatic pipeline used for reference-based assembly of SARS-CoV-2 genomes from high-throughput amplicon sequencing.
- Recognise the differences between Illumina and Nanopore pipelines.
- Apply the `connor-lab/ncov2019-artic-nf` _Nextflow_ pipeline to generate a consensus sequence from Illumina and Nanopore data.
- Troubleshoot issues when running a _Nextflow_ pipeline and resume the pipeline in case of a failure.
- Check basic data quality metrics on the assembled sequences and prepare sequences for downstream analyses.

:::

<!--
## Nextflow Workflows

Brief intro to the concept of a bioinformatics pipeline/workflow and how it can be effectively managed with something like Nextflow. 
We will cover how to download and configure Nextflow workflows in a later session. 

To see all the options available with this pipeline, we run: 

```console
$ nextflow run ncov2019-artic-nf --help
```


## `ncov2019-artic-nf` Pipeline {.tabset}

Below, we give a brief summary of the steps involved in this pipeline, depending on whether we are using Illumina or Nanopore data.

### Illumina

Steps overview: 

- Trimming with `trim_galore` (as far as I can tell with default options)
- Mapping with `bwa mem` (default options) + `samtools sort`
- Trim primers with `ivar trim` (first remove unmapped reads with `samtools -F4`)
  - more information here: https://andersen-lab.github.io/ivar/html/manualpage.html
  - this uses a BED file with primer locations - this is downloaded from from https://github.com/artic-network/artic-ncov2019/blob/master/primer_schemes/nCoV-2019/
  - reads are retained if they are at least 30bp after clipping
  - also, a quality threshold of 20 is used for clipping
  - these defaults (30bp and quality threshold) can be adjusted with `--illuminaKeepLen` and `--illuminaQualThreshold`
  - There is an option `--allowNoprimer`, which should be set depending on the protocol used: ligation == false, tagmentation == true (default: true)
- Threshold for calling a base is 10x; we generally don't want to go lower than this

To run our pipeline, we use the following command:

```console
nextflow run ncov2019-artic-nf \
  -with-report -with-dag \
  -profile conda \
  --illumina \
  --outdir results/consensus/ \
  --prefix uk \
  --schemeVersion V3 \
  --directory data/uk_illumina/
```

### Nanopore

- Uses Artic tools, which are themselves wrappers around other tools (at least partially)
- There are two ways to run this pipeline:
  - using `nanopolish` - when starting with FAST5 files
  - using `medaka` - when starting with FASTQ files
- `medaka`
  - needs a "model" (see details [here](https://github.com/nanoporetech/medaka) - section entitled "Models")
  - files need to end in `.fastq`, not `.fastq.gz`! The pipeline simply fails saying "Couldn't detect whether your Nanopore run was barcoded or not. Use --basecalled_fastq to point to the unmodified guppy output directory.", which is rather unhelfpul.
- Threshold of 20 coverage to call a base
  - this is already a lower bound for nanopore data; below that the models used by nanopolish don't perform so well, so we really don't want to lower this threshold


Some notes about FAST5 files: 
- https://github.com/mw55309/EG_MinION_2016/blob/master/02_Data_Extraction_QC.md

To run our pipeline, we use the following command:

```console
nextflow run ncov2019-artic-nf \
  -with-report -with-dag \
  -profile conda \
  --medaka \
  --outdir results/consensus/ \
  --prefix india \
  --schemeVersion V3 \
  --directory data/india_nanopore/
```

## {.unlisted .unnumbered}

The first few arguments used are generic options for Nextflow:

- `-with-report` generates a report about the resources used at different steps in the pipeline (e.g. how long each step took to run, how much memory was used, etc.).
- `-with-dag` produces a "directed acyclic graph", which shows how the different steps of the pipeline link to each other. 
- `-profile conda` uses the _Conda_ package manager to automatically install all the necessary software used by this pipeline. 

The following arguments are specific to this pipeline:

- `--illumina` or `--medaka` indicates whether want to use the pipeline steps developed for Illumina or Nanopore data, respectively.
- `--outdir results` indicates that we want the results of the pipeline to be saved in the directory `results`.
- `--prefix run1` is a prefix that Nextflow will use to name some of the output files. This is useful if we had multiple runs in the same project and wanted to run the pipeline multiple times on each run. 
- `--schemeVersion V3` indicates the Artic primer version used when preparing the sequencing libraries. 
- `--directory data/run1` is the directory where all the data is stored. The pipeline will automatically recognise files with suffix "_1.fastq.gz" or "_2.fastq.gz" as being paired-end data.


:::exercise

In the `case_study_1` directory of our course materials, you will find data for a series of samples that were sequenced to investigate the prevalence of different SARS-CoV-2 variants in the UK between the period of May to June 2021. 

These samples were sequenced on an Illumina sequencer, to produce 300bp paired-end reads (the data given here was already pre-processed to remove illumina adapters and so the reads are in reality shorter at around 250bp).

- Using command-line tools determine how many samples we have data for.
- Assess the read quality of these samples using FastQC.
  - Output the results to a directory called `results/fastqc/`.
  - Compile the results of FastQC using MultiQC and store its results in a directory called `results/multiqc/`
  - Make a note of any samples that you worry about in terms of producing a high-quality assembly.
- Run the samples through the `ncov2019-artic-nf` Nextflow pipeline. (Note: this will take a around XX minutes to run).

Make sure you keep a record of all the relevant commands you ran in a shell script (create a directory called `scripts` to save this).

<details><summary>Answer</summary>

```console
$ ls data/run1/*_1.fastq.gz | wc -l
$ wc -l metadata.csv
```

```bash
#!/bin/bash

# make directory
mkdir -p results/fastqc
mkdir -p results/multiqc

# run FastQC on all the files
# using 8 threads in parallel since we have 8 CPUs available
fastqc -t 8 --outdir results/fastqc/ data/run1/*.fastq.gz

# run MultiQC on the output of FastQC
multiqc --outdir results/multiqc/ results/fastqc/
```

```bash
nextflow run ncov2019-artic-nf \
  -with-report -with-dag \
  -profile conda \
  --illumina \
  --outdir results \
  --prefix run1 \
  --schemeVersion V3 \
  --directory data/run1/
```

</details>

:::


## Quality Control 

Check output of the workflow in terms of QC checks. 


## Why Use a Standardised Pipeline?

- Generating consensus sequence (need to look at this in more detail): 
  - Trimming primer sequences - that's the main source of errors
- Some pipelines use the reference allele to fill in missing positions, which can lead to a false SNP in a population of samples (e.g. nanopolish when run with certain options)
- Indels are ignored in phylogeny (although small indels are called)
  - large deletions have been observed, so it's not that they do not exist
  - bioinformatically there are some challenges in calling indels (need to elaborate on this)
  - when uploading to public databases, best to use a more "standard" pipeline, because that is what is expected - in fact GISAID will automatically reject anything that has an indel against the reference (where did I get this information? We have several samples with indels, e.g. at position 11,290)


## Summary

:::highlight

**Key Points**

- one
- two

:::
-->
