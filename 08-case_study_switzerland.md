---
pagetitle: "SARS-CoV-2 Genomics"
---

# Case Study: Switzerland (Nanopore)

:::highlight
This section demonstrates a start-to-finish analysis of a dataset sequenced on a _Nanopore_ platform, using the concepts and tools covered in previous sections. 
You can download the data from this link: [Switzerland Case Study - Data](TODO).

By the end of this section, you should be able to:

- Prepare all the files necessary to run the consensus pipeline.
- Run the _viralrecon_ pipeline to generate FASTA consensus from raw FASTQ files. 
- Assess and collect several quality metrics for the consensus sequences. 
- Clean output files, in preparation for other downstream analysis.
- Assign sequences to lineages using _Nextclade_. 
- Contextualise your sequences in other background data and cluster them based on phylogenetic analysis. 
- Integrate the metadata and analysis results to generate timeseries visualisations of your data. 
:::

We will analyse data from 48 samples collected in Switzerland between Nov 2021 and Jan 2022. 
The samples were sequenced on a _GridION_ platform using pore version 9.4.1. 

Our main objective is to produce a report of the analysis, which is available here: [Switzerland Analysis Report](TODO). 
In summary, the report addresses the following: 

- What was the quality of the consensus sequence obtained?
- What lineage/clade was each of our samples assigned to? 
- How many clusters of samples did we identify?
- How did the detected lineages change over the time of collection?

We should also produce several essential output files, which would usually be necessary to upload our data to public repositories: 

- Metadata (CSV)
- Consensus sequences (FASTA)
- Consensus sequence quality metrics (CSV)
- Variants (CSV)


## Pipeline Overview

Our analysis starts with **FASTQ files**, which will be used with the **`nf-core/viralrecon` _Nextflow_ pipeline**.
This will give us several **quality control** metrics essential for our downstream analysis and reporting. 

Critical files output by the pipeline will need to be further processed, including combining our **consensus FASTA files** and obtaining a list of **filtered SNP/indel variants**. 
Using these clean files, we can then proceed to downstream analysis, which includes assigning each sample to the most up-to-date **Pango lineage**, **Nextclade clade** and **WHO designation**. 
Finally, we can do more advanced analysis, including the idenfication of **sample clusters** based on phylogenetic analysis, or produce timeseries visualisations of mutations or variants of concern. 
With all this information together, we will have the necessary pieces to submit our results to **public repositories** and write **reports** to inform public health decisions. 

![](images/analysis_overview.png)


## Preparing Files

Before we start our work, it's always a good idea to setup our directory structure, so we keep our files organised as the analysis progresses. 
We have the following directories: 

- `data` --> contains the sequencing data in a sub-directory called `fast_pass`. 
- `results` --> results of the analysis. 
- `scripts` --> _bash_ and _R_ scripts used to run the analysis. 
- `report` --> files and documents that we report to our colleagues or upload to public repositories. 
- `resources` --> files that were downloaded from public repositories. 

You can create directories from the command line using the `mkdir` command, for example these would create all the directories we needed: 

```bash
mkdir data
mkdir results
mkdir scripts
mkdir report
mkdir resources
```

### Data

We start our analysis from FASTQ files generated using the software _Guppy_ v6.1.5 ran in "fast" mode. 
This software outputs the files to a directory called **`fastq_pass`**, with further sub-directories for each sample barcode. 
This is how it looks like in this case: 

```bash
$ ls data/fastq_pass
```

```
barcode01  barcode09  barcode17  barcode25  barcode33  barcode41  barcode49  barcode57
barcode02  barcode10  barcode18  barcode26  barcode34  barcode42  barcode50  barcode58
barcode03  barcode11  barcode19  barcode27  barcode35  barcode43  barcode51  barcode59
barcode04  barcode12  barcode20  barcode28  barcode36  barcode44  barcode52  barcode60
barcode05  barcode13  barcode21  barcode29  barcode37  barcode45  barcode53  barcode61
barcode06  barcode14  barcode22  barcode30  barcode38  barcode46  barcode54  barcode62
barcode07  barcode15  barcode23  barcode31  barcode39  barcode47  barcode55  barcode63
barcode08  barcode16  barcode24  barcode32  barcode40  barcode48  barcode56
```


### Metadata

Metadata for these samples is available in the file `sample_info.csv`. 
Here is some of the information we have available for these samples: 

- `sample` --> the sample ID.
- `collection_date` --> the date of collection for the sample in the format YYYY-MM-DD.
- `country` --> the country of origin for this sample.
- `latitude`/`longitude` --> coordinates for sample location (optional).
- `sequencing_instrument` --> the model for the sequencing instrument used (e.g. NovaSeq 6000, MinION, etc.).
- `sequencing_protocol_name` --> the type of protocol used to prepare the samples (e.g. ARTIC).
- `amplicon_primer_scheme` --> for amplicon protocols, what version of the primers was used (e.g. V3, V4.1)
- Specific columns for Oxford Nanopore data, which are essential for the bioinformatic analysis: 
  - `ont_pore` --> the version of the pores. 
  - `ont_guppy_version` --> the version of the _Guppy_ software used for basecalling.
  - `ont_guppy_mode` --> the basecalling mode used with _Guppy_.


## Consensus Assembly

The next step in the analysis is to run the `nf-core/viralrecon` pipeline. 
But first we need to prepare our input files. 

### Samplesheet

For _Nanopore_ data, we need a samplesheet CSV file with two columns, indicating sample name (first column) and the respective barcode number (second column). 

We produced this table in _Excel_ and saved it as a CSV file. 
Here are the top few rows of the file: 

```bash
$ head samplesheet.csv
```

```
CH01,1
CH02,2
CH03,3
CH04,4
CH05,5
CH06,6
CH07,7
CH08,8
CH09,9
CH10,10
```


### Running Viralrecon

Now we are ready to run the `nf-core/viralrecon` pipeline. 
We saved our command in a script (`scripts/01-run_viralrecon.sh`), which we created with nano. 
This ensures that our analysis is **reproducible** and **traceable** (we can go back to the script to see how the analysis was run). 

Here is the content of the script: 

```bash
#!/bin/bash 

nextflow run nf-core/viralrecon -profile singularity \
  --max_memory '16.GB' --max_cpus 8 \
  --input samplesheet.csv \
  --outdir results/viralrecon \
  --platform nanopore \
  --protocol amplicon \
  --genome 'MN908947.3' \
  --primer_set artic \
  --primer_set_version 3 \
  --skip_assembly \
  --fastq_dir data/fastq_pass/ \
  --artic_minion_caller medaka \
  --artic_minion_medaka_model r941_min_fast_g507
```

In this case, we used the medaka model `r941_min_fast_g507`, because that is the latest one available (even though our _Guppy_ version is 6.1.5). 
We also restricted our `--max_memory` and `--max_cpus` due to the size of our processing computers. 
If a larger computer was available, we could have used higher values for these parameters. 


### Consensus Quality

We used the _MultiqQC_ report to assess the initial quality of our samples, focusing on: 
The quality report can be found in `results/viralrecon/multiqc/medaka/multiqc_report.html`. 

We opened both of these files to assess the quality of our samples, paying particular attention to:

- Number of reads mapped to the reference genome.
- Median depth of coverage.
- Percentage of the genome with missing bases ('N'). 
- Number of SNP + Indel variants.

We noted that:

- 9 samples had more than 15% missing bases.
- All samples had median depth of coverage greater than 20x.
- There was some systematic dropout for some amplicons, in particular `nCoV-2019_64` had very low amplification in several of the samples. 
  Of note was also `nCoV-2019_73`, and other neighbouring amplicons. 

Besides the _MultiQC_ report, the pipeline also outputs a CSV file with collected summary metrics (equivalent to the first table on the report): `results/viralrecon/multiqc/medaka/summary_variants_metrics_mqc.csv`.
We used this file to initiate a new file where we collected metrics of particular interest, saved in `report/consensus_metrics.csv`. 
This file could have been created in _Excel_, for example. 
But we used the _R_ software to achieve this programmatically (detailed in "Data Integration", below). 


## Clean Output Files

After the pipeline, we created a new script to achieve three things: 

- Combine all our FASTA consensus sequences into a single file and clean the sequence names. 
- Create a table of SNP/indel variants. 
- Create a table of missing bases present in each consensus sequence.

Here is the script we wrote to do this: 

```bash
#!/bin/bash 

# combine and clean FASTA files
cat results/viralrecon/medaka/*.consensus.fasta | sed 's/\/ARTIC\/medaka MN908947.3//' > report/consensus.fa

# create CSV file with variants
cat results/viralrecon/medaka/variants_long_table.csv | cut -d "," -f 1,3,4,5 > report/variants.csv

# create missing bases TSV file
seqkit locate --ignore-case --only-positive-strand --hide-matched -r -p "N+" report/consensus.fa | cut -f 1,5,6 > report/consensus_miss_intervals.tsv
```

This generated 3 new files in the `report` directory: 

- `consensus.fa` -- all consensus sequences combined into a single FASTA file, with cleaner names (removed "/ARTIC/medaka MN908947.3" from the sequence names). 
- `variants.csv` -- all the SNP/indel variants identified with: sample name, position, reference allele and alternative allele. 
- `consensus_miss_intervals.csv` -- intervals of missing data in each sample, which we obtained with the `seqkit` software.

From this analysis we note that two samples -- _CH07_ and _CH59_ -- both have a continuous interval of 5130 missing bases between positions 19580 and 24709. 
This includes part of the _ORF1a_ gene and nearly all of the _S_ (_Spike_) gene. 


## Downstream Analyses

Based on the clean consensus sequences, we then perform several downstream analysis. 


### Lineage Assignment

Although the _Viralrecon_ pipeline runs _Pangolin_ and _Nextclade_ on our samples, it does not use the latest version of these programs (because lineages evolve so fast, the nomenclature constantly changes). 
An up-to-date run of both of these tools can be done using each of their web applications:

- [clades.nextstrain.org](https://clades.nextstrain.org/)
- [pangolin.cog-uk.io](https://pangolin.cog-uk.io/)

However, for **automation** and **reproducibility** purposes, we used the command line versions of these tools, and included their analysis in a script (`scripts/03-lineage_assignment.sh): 

```bash
#!/bin/bash

# get nextclade data
nextclade dataset get --name sars-cov-2 --output-dir resources/nextclade_dataset

# run nextclade
nextclade run --input-dataset resources/nextclade_dataset/ --output-all results/nextclade report/consensus.fa

# run pangolin
# first make sure to update it with
# conda update pangolin
pangolin --outdir results/pangolin/ --outfile switzerland_report.csv report/consensus.fa
```

We created this script using `nano` and then ran it using `bash scripts/03-lineage_assignment.sh`. 
Note that we first download the latest version of the _Nextclade_ background data using `nextclade dataset` and then use `nextclade run` using that up-to-date version. 

With `pangolin` we needed to ensure that we use the latest version, which we installed using the _Conda_ package manager. 

Each of these tools output files with the results of the analysis, which can be open in _Excel_. 
We further compile (and visualise) this information using the software _R_ in the section "Data Integration", detailed below.


### Clustering

We identified groups of similar sequences in our data using the software _civet_ (Cluster Investigation and Virus Epidemiology Tool). 
This software compares our samples with a background dataset of our choice, which givus us more context for our analysis. 
In our case, we chose to use European samples as background data, which we downloaded from GISAID following the instructions on the [_civet_ documentation](https://cov-lineages.org/resources/civet/walkthrough.html#background_dataset) (you need an account on GISAID to achieve this). 

We already have our _civet_ data prepared in `resources/civet_data`, and we ran our analysis using the following command, stored in the script `scripts/04-civet.sh`: 

```bash
#!/bin/bash

# run civet analysis
civet -i sample_info.csv \
  -f report/consensus.fa \
  -icol sample \
  -idate sample_collection_date \
  -d resources/civet_data/ \
  -o results/civet \
  -bicol modified_strain
```

The result of this analysis includes an interactive HTML report (in `results/civet/civet.html`) and also a CSV file (`results/civet/master_metadata.csv`), which includes the catchment that each sample was assigned to. 
We will use the CSV file later to integrate this information with other parts of our analysis, in R. 


### Phylogeny

Although tools such as _Nextclade_ and _civet_ can place our samples in a phylogeny, sometimes it may be convient to build our own phylogenies.
This requires three steps: 

- Producing a multiple sequence alignment from all consensus sequences.
- Tree inference.
- Tree visualisation and annotation.

We performed the first two steps with the following script: 

```bash
#!/bin/bash

# alignment
mkdir -p results/mafft
mafft --6merpair --maxambiguous 0.2 --addfragments report/consensus.fa resources/reference/sarscov2.fa > results/mafft/alignment.fa

# tree inference
mkdir -p results/iqtree
iqtree2 -s results/mafft/alignment.fa --prefix results/iqtree/consensus
```

The output of _iqtree_ includes a tree file, which can be visualised using FigTree or online using [Microreact](https://microreact.org/upload). 


## Integration & Visualisation

At this point in our analysis, we have several tables with different pieces of information: 

- `sample_info.csv` --> the original table with metadata for our samples. 
- `results/viralrecon/multiqc/medaka/summary_variants_metrics_mqc.csv` --> quality metrics from the _MultiQC_ report generated by the _viralrecon_ pipeline.
- `results/civet/master_metadata.csv` --> the results from the _civet_ analysis, namely the catchment (or cluster) that each of our samples was grouped into.

To consolidate our analysis, we **tidied and integrated** the information from across these different files, into a single table using the software _R_. 
The script used to do this is in `scripts/06-data_integration.R`. 
Because this is an _R_ script, we opened it in _RStudio_ to execute the code. 

The output of our script is a new table, which we saved in `report/consensus_metrics.csv`, and contains the following columns: 

- `sample`
- TODO

This final table was then used to produce different visualisations of our analysis. 
These visualisations were also done using the _R_ software (`scripts/07-visualisation.R`), and integrated into a report, shown below. 

TODO - embed PDF?
