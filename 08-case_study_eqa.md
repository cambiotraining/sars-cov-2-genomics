---
pagetitle: "SARS-CoV-2 Genomics"
---

:::warning

This page is under active development -- not to be used for teaching.

:::

# Case Study: EQA

:::highlight
This section is an **extended self-paced practice** applying the concepts covered in previous sections. 
By the end of this practice, you should be able to:

- Prepare all the files necessary to run the consensus pipeline.
- Run the _viralrecon_ pipeline to generate FASTA consensus from raw FASTQ files. 
- Assess and collect several quality metrics for the consensus sequences. 
- Clean output files, in preparation for other downstream analysis.
- Assign sequences to lineages using _Nextclade_. 
- Contextualise your sequences in other background data and cluster them based on phylogenetic analysis. 
- Integrate the metadata and analysis results to generate timeseries visualisations of your data. 
:::

<img src="https://genqa.org/userfiles/logo.png" alt="GenQA logo" style="float:right;width:20%">

_External Quality Assessment_ (EQA) is a procedure that allows laboratories to assess the quality of the data they produce, including its analysis. 
For genomic analysis of SARS-CoV-2, a standard panel of samples has been developed by the [GenQA](https://genqa.org/) consortium, which is part of [UK NEQAS](https://ukneqas.org.uk/), a non-profit that designs EQA protocols for a range of applications. 
_GenQA_'s panel of samples includes lab-cultured SARS-CoV-2 samples of known origin, enabling laboratories to assess whether their sequencing and bioinformatic pipelines correctly identify expected mutations and lineage assignments for each of the samples in the panel. 

In this case study, we are going to analyse samples from the _GenQA_ panel, to helps us assess the quality of our bioinformatic analysis and extract key pieces of information to be reported.
The panel we will work with includes the following samples: 

- 2x Alpha
- 2x Gamma
- 1x Omicron
- 1x Delta
- 1x Adenovirus (negative control)

From the sequencing data analysis, we will address the following: 

- What was the quality of the consensus sequence obtained?
- What lineage/clade was each of our samples assigned to? Did we identify the correct (expected) lineage?
- Which of the expected mutations were we able to detect? Where there any "false positives" or "false negatives"?
- How many clusters of samples do we identify?

We should also produce several essential output files, which would usually be necessary to upload our data to public repositories: 

- Metadata (CSV)
- Consensus sequences (FASTA)
- Consensus sequence quality metrics (CSV)
- Variants (CSV)


## Pipeline Overview

We will start our analysis with **FASTQ files** produced by our sequencing platforms (Illumina and Nanopore are considered here). 
These FASTQ files will be used with the **`nf-core/viralrecon` _Nextflow_ pipeline**, allowing us to automate the generation of consensus sequences and produce several **quality control** metrics essential for our downstream analysis and reporting. 

Critical files output by the pipeline will need to be further processed, including combining our **consensus FASTA files** and obtaining a list of **filtered SNP/indel variants**. 
Using these clean files, we can then proceed to downstream analysis, which includes assigning each sample to the most up-to-date **Pango lineage**, **Nextclade clade** and **WHO designation**. 
Finally, we can do more advanced analysis, including the idenfication of **sample clusters** based on phylogenetic analysis, or produce timeseries visualisations of mutations or variants of concern. 
With all this information together, we will have the necessary pieces to submit our results to **public repositories** and write **reports** to inform public health decisions. 

![](images/analysis_overview.png)


## Preparing Files

Before we start our work, it's always a good idea to setup our directory structure, so we keep our files organised as the analysis progresses. 
There is no standard way to do this, but here are some suggested directories: 

- `data` --> contains the sequencing data for the particular run or project you are working on. 
  Data may sometimes be stored in a separate server, in which case you may not need to create this directory. 
  Generally, you should _leave the original data unmodified_, in case something goes wrong during your analysis, you can always re-run it from the start. 
- `results` --> to save results of the analysis. 
- `scripts` --> to save scripts used to run the analysis. 
  You should always try to save all the commands you run in a script, this way you will have a record of what was done to produce the results, and it makes your life easier if you want to run the analysis again on a new set of data. 
- `report` --> to save the final files and documents that we report to our colleagues or upload to public repositories. 
- `resources` --> files that you download from the internet could be saved here. 
  For example, the reference genome sequence, background data used for phylogenetics, etc. 
  Sometimes you may share these resources across multiple projects, in which case you could have this folder somewhere else that you can access across multiple projects. 

On our computers, we have a directory in `~/Documents/eqa_workshop`, where we will do all our analysis. 
We already included a directory called `data` with the results of the sequencing of the EQA samples that we will analyse (the data are detailed below). 

:::exercise

Your first task is to **create the directories** detailed above in your project folder. 
You can do this either using the file explorer <i class="fa-solid fa-folder"></i> or from the command line (using the `mkdir` command). 

:::


### Data {.tabset}

Regardless of which platform you used to sequence your samples, the analysis starts with FASTQ files (if you need a reminder of what a FASTQ file is, look at the [Intro to NGS > FASTQ](03-intro_ngs.html#FASTQ_Files) section of the materials). 
However, the organisation of these files is slightly different depending on the platform, and is detailed below. 

#### Nanopore

Typically, Nanopore data is converted to FASTQ format using the program _Guppy_. 
This software outputs the files to a directory called **`fastq_pass`**.
Within this directory, it creates further sub-directories for each sample barcode, which are named `barcodeXX` (`XX` is the barcode number). 
Finally, within each barcode directory there is one (or sometimes more) FASTQ files corresponding to that sample. 

#### Illumina

The Illumina files come as compressed FASTQ files (`.fq.gz` format) and there's two files per sample, corresponding to read 1 and read 2. 
This is indicated by the file name suffix: 

- `*_1.fq.gz` for read 1
- `*_2.fq.gz` for read 2


### Metadata

A critical step in any analysis is to make sure that our samples have all the relevant metadata associated with them. 
This is important to make sense of our results and produce informative reports at the end. 
There are many types of information that can be collected from each sample (revise the [Genomic Surveillance > Metadata](01-intro.html#Metadata) section of the materials to learn more about this). 
For effective genomic surveillance, we need at the very minimum three pieces of information:

- **When**: date when the sample was collected (not when it was sequenced!).
- **Where**: the location where the sample was collected (not where it was sequenced!).
- **How**: how the sample was sequenced (sequencing platform and protocol used).

Of course, this is the _minimum_ metadata we need for a useful analysis. 
However, the more information you collect about each sample, the more questions you can ask from your data -- so always remember to record as much information as possible for each sample. 

:::exercise

<!-- 
TODO
Create sample_metadata.csv file. 
-->

Your next task it to complete the metadata for our samples. 
Open the `sample_metadata.csv` file found in our project directory, and complete the table with the relevant information about your samples (if some of the columns don't apply to your data, you can leave them blank): 

- `sample` --> the sample ID.
- `collection_date` --> the date of collection for the sample in the format YYYY-MM-DD.
- `collection_year`, `collection_month`, `collection_day` --> same information as above but in separate columns (read the warning box below this exercise).
- `country` --> the country of origin for this sample.
- `latitude`/`longitude` --> coordinates for sample location (optional).
- `ct` --> Ct value from qPCR viral load quantification.
- `sequencing_instrument` --> the model for the sequencing instrument used (e.g. NovaSeq 6000, MinION, etc.).
- `sequencing_protocol_name` --> the type of protocol used to prepare the samples (e.g. ARTIC).
- `amplicon_primer_scheme` --> for amplicon protocols, what version of the primers was used (e.g. V3, V4.1)
- Specific columns for Oxford Nanopore data, which are essential for the bioinformatic analysis: 
  - `ont_nanopore` --> the version of the pores used (e.g. `9.4.1` or `10.4.1`). 
  - `ont_guppy_version` --> the version of the _Guppy_ software used for basecalling.
  - `ont_guppy_mode` --> the basecalling mode used with _Guppy_ (usually "fast", "high", "sup" or "hac").
:::

:::warning
**Dates in Spreadsheet Programs**

Note that programs such as _Excel_ often convert date columns to their own format, and this can cause problems when analysing data later on. 
For example, GISAID wants dates in the format YYYY-MM-DD, but by default _Excel_ displays dates as DD/MM/YYYY.  
You can change how _Excel_ displays dates by highlighting the date column, right-clicking and selecting <kbd>Format cells</kbd>, then select "Date" and pick the format that matches YYYY-MM-DD. 
However, every time you open the CSV file, _Excel_ annoyingly converts it back to its default format!

To make sure no date information is lost due to _Excel_'s behaviour, it's a good idea to store information about year, month and day in separate columns (stored just as regular numbers).
:::


## Consensus Assembly

At this point we are ready to start our analysis with the first step: generating a consensus genome for our samples. 
We will use a standardised pipeline called _viralrecon_, which automates most of this process for us, helping us be more efficient and reproducible in our analysis. 

If you need to revise how the `nf-core/viralrecon` pipeline works, please consult the [Consensus Assembly](04-consensus.html) section of the materials.


### Samplesheet

The first step in this process is to prepare a CSV file with information about our sequencing files, which will be used as the input to the _viralrecon_ pipeline.  
The pipeline's documentation gives details about the format of this samplesheet, depending on whether you are working with Illumina or Nanopore data: https://nf-co.re/viralrecon/2.5/usage. 

:::exercise

Using _Excel_, produce the input samplesheet for `nf-core/viralrecon`, making sure that you save it as a CSV file (<kbd>File</kbd> --> <kbd>Save As...</kbd> and choose "CSV" as the file format).  

If you are working with Illumina data, you should check the tip below. 

<details><summary>Illumina samplesheet: saving time with the command line!</summary>
You can save some time (and a lot of typing!) in making the Illumina samplesheet using the command line to get a list of file paths. 
For example, if your files are saved in a folder called `data`, you could do: 

```bash
# list read 1 files and save output in a temporary file
ls data/*_1.fq.gz > read1_filenames.txt

# list read 2 files and save output in a temporary file
ls data/*_2.fq.gz > read2_filenames.txt

# initiate a file with column names
echo "fastq_1,fastq_2" > samplesheet.csv

# paste the two files together, using comma as a delimiter
paste -d "," read1_filenames.txt read2_filenames.txt >> samplesheet.csv

# remove the two temporary files
rm read1_filenames.txt read2_filenames.txt
```

Now, you can open this file in _Excel_ and continue editing it to add a new column of sample names. 

</details>
:::


### Running Viralrecon {.tabset}

The next step in our analysis is to run the `nf-core/viralrecon` pipeline. 
The way the command is structured depends on which kind of data we are working with. 
There are [many options](https://nf-co.re/viralrecon/2.5/parameters) that can be used to customise the pipeline, but typical commands are shown below for each platform. 


#### Nanopore

```
nextflow run nf-core/viralrecon -profile singularity \
  --max_memory '16.GB' --max_cpus 8 \
  --input SAMPLESHEET_CSV \
  --outdir results/viralrecon \
  --protocol amplicon \
  --genome 'MN908947.3' \
  --primer_set artic \
  --primer_set_version PRIMER_VERSION \
  --skip_assembly \
  --platform nanopore \
  --artic_minion_caller medaka \
  --artic_minion_medaka_model MEDAKA_MODEL \
  --fastq_dir fastq_pass/
```

You need to check which model the _medaka_ software should use to process the data. 
You need three pieces of information to determine this:

- The version of the nanopores used (usually 9.4.1 or 10.4.1).
- The sequencing device model (MinION, GridION or PromethION).
- The mode used in the _Guppy_ software for basecalling ("fast", "high", "sup" or "hac").
- The version of the _Guppy_ software. 

Once you have these pieces of information, you can see how the model is specified based on the model files available on the [`medaka` GitHub repository](https://github.com/nanoporetech/medaka/tree/master/medaka/data). 
For example, if you used a flowcell with chemistry 9.4.1, sequenced on a _MinION_ using the "fast" algorithm on _Guppy_ version 5.0.7, the model used should be `r941_min_fast_g507`.  
Note that in some cases there is no model for recent versions of _Guppy_, in which case you use the version for the latest version available. 
In our example, if our version of _Guppy_ was 6.1.5 we would use the same model above, since that's the most recent one available. 


#### Illumina

```
nextflow run nf-core/viralrecon -profile singularity \
  --max_memory '16.GB' --max_cpus 8 \
  --input SAMPLESHEET_CSV \
  --outdir results/viralrecon \
  --protocol amplicon \
  --genome 'MN908947.3' \
  --primer_set artic \
  --primer_set_version PRIMER_VERSION \
  --skip_assembly \
  --platform illumina
```


### {.unlisted .unnumbered}

:::exercise

Your next task is to run the pipeline on your data. 
However, rather than run the command directly from the command line, let's save it in a **shell script** -- for reproducibility and as a form of documenting our analysis.

Using a text editor, create a shell script and save it in `scripts/01-run_viralrecon.sh`. 
You can either use the command-line text editor `nano` or use _Gedit_, which comes installed with Ubuntu. 

In this script, include the Nextflow command based on the typical command shown above, adjusting it to fit your input files and type of data. 
Once your command is ready, save the script and run it from the command line using `bash scripts/01-run_viralrecon.sh`.

If you need a reminder of how to work with shell scripts, revise the [Shell Scripts section](02d-unix_pipes.html#Shell_Scripts) of the materials. 
:::


:::note
**Maximum Memory and CPUs**

In our _Nextflow_ command above we have set `--max_memory '16.GB' --max_cpus 8` to limit the resources used in the analysis. 
This is suitable for the computers we are using in this workshop. 
However, make sure to set these options to the maximum resources available on the computer where you process your data. 
:::


### Consensus Quality

Once your workflow is complete, it's time to assess the quality of the initial assembly. 
At this stage we want to identify issues such as:

- Any samples which have critically low coverage. There is no defined threshold, but samples with less than 85% coverage should be considered carefully.
- Any problematic regions that systematically did not get amplified (amplicon dropout).

We will also collect several critical quality metrics that we will use to produce a supplementary file to our final analysis report. 

:::exercise
To assess the quality of our assemblies, we can use the **_MultiQC_ report** generated by the pipeline, which compiles several pieces of information about our samples. 
If you need a reminder of where to find this file, consult the [Consensus > Output Files](04-consensus.html#Output_Files) section of the materials, or the [Viralrecon output documentation](https://nf-co.re/viralrecon/2.5/output).

Open the quality report and try to answer the following questions: 

- Were there any samples with more than 15% missing bases ('N's)?
- Were there any samples with a median depth of coverage <20x?
- Were there any problematic amplicons with low depth of coverage across multiple samples?

To record some of this information, use a spreadsheet program (_Excel_ or _LibreOffice_) to **create a new CSV file in `report/consensus_metrics.csv`**.  
Open the file `summary_variants_metrics_mqc.csv` (in the _MultiQC_ report folder from _Viralrecon_), and copy/paste the relevant information to your new table using the following column names: 

- `sample` --> the sample name.
- `n_mapped_reads` --> number of reads mapped to the reference genome.
- `median_depth` --> median depth of coverage.
- `pct_missing` --> percentage of the genome with missing bases ('N'). (Note: In the _MultiQC_ report, the column named `# Ns per 100kb consensus` can be converted to a percentage by dividing its value by 1000.)
- `pct_coverage` --> percentage of the genome that was sufficiently covered.
- `n_variants` --> number of SNP + Indel variants.
:::

:::highlight
**Reporting Checkpoint!**

The `consensus_metrics.csv` file is the first of several files that you will generate to report your results. 
Make sure to keep this file open, since you will add other pieces of information to it as you continue with your analysis. 
:::


## Clean Output Files

In this section we will clean some of the resulting output files from running our pipeline. 
We will do three things: 

- Combine all our FASTA consensus sequences into a single file. 
- Create a table of (filtered) SNP/indel variants. 
- Create a table of gaps (missing bases) present in each consensus sequence.


### FASTA

The _viralrecon_ pipeline outputs each of our consensus sequences as individual FASTA files for each sample (look at the [FASTA Files](03-intro_ngs.html#FASTA_Files) section if you need a reminder of what these files are). 
However, by default, the sample names in this file have extra information added to them, which makes some downstream analysis less friendly (because the names will be too long and complicated). 

To clean up these files, we will do two things: 

- Combine all the individual FASTA files together.
- Remove the extra text from the sequence names.

:::exercise
Use the command line to achieve these two tasks and save the ouput file in `report/consensus.fa`. 
Look at the [Consensus > Cleaning FASTA Files](04-consensus.html#Cleaning_FASTA_Files_(Optional)) section of the materials to revise how you can achieve this using the `cat` and `sed` commands together. 

If you need a reminder of where to find the FASTA consensus files from _viralrecon_, consult the [Consensus > Output Files](04-consensus.html#Output_Files) section of the materials, or the [Viralrecon output documentation](https://nf-co.re/viralrecon/2.5/output).

Once your command is running, make sure to save it in a new script file: `scripts/02-clean_files.sh`.  
This is to make sure you can use it later if you do this analysis again!
:::


### Variants

The _viralrecon_ pipeline outputs a table with information about SNP/Indel variants as a CSV file named `variants_long_table.csv`. 
It is important to inspect the results of this file, to identify any mutations with severe effects on annotated proteins, or identify samples with an abnormal high number of "mixed" bases. 

The way to inspect this table varies depending on which pipeline you use. 

:::exercise
Open the `variants_long_table.csv` file and answer the following questions: 

- How many variants have allele frequency < 75%? 
- Does any of the samples have a particularly high number of these low-frequency variants, compared to other samples? (This could indicate cross-contamination of samples)
- Investigate if there are any predicted non-synonymous mutations in the Spike protein in your samples.

If you need a reminder of the meaning of the columns in this file, consult the [Consensus > Mutation/Variant Analysis](04-consensus.html#MutationVariant_Analysis) section of the materials.

Save a copy of this table in `report/variants.csv` including only the following columns: 

- `SAMPLE`
- `POS`
- `REF`
- `ALT`

**For _Illumina_ data only:**  
Filter the table to include only variants with AF >= 0.75 and DP >= 10, as only those variants are retained in the final consensus sequences. 
Do not do this filtering for the _Nanopore_ table, as all the variants in the table are included in the consensus FASTA. 
:::

<!-- 
TODO - add solution with command line
# nanopore is easy
cat results/viralrecon/medaka/variants_long_table.csv | cut -d "," -f 1,3,4,5

# illumina is bit more involved because of filtering step
cat results/viralrecon/variants/ivar/variants_long_table.csv | awk -F "," 'NR==1; NR>1{ if (($10 >= 0.75) && ($7 >= 10)) {print} }' | cut -d "," -f 1,3,4,5
-->


### Missing Bases

When we generate our consensus assembly, there are regions for which we did not have enough information (e.g. due to amplicon dropout) or where there were mixed bases. 
These regions are effectively missing data, and are denoted as 'N' in our sequences. 
Although we already determined the percentage of each sequence that is missing, we don't have the _intervals_ of missing data, which can be a useful quality metric to have. 
In particular, we may want to know what is the largest continuous stretch of missing data in each sample. 

:::exercise

We will use the software tool `seqkit` to find intervals where the 'N' character occurs. 
This tool has several functions available, one of which is called `locate`. 

Here is the command that would be used to locate intervals containing _one or more_ 'N' characters: 

```bash
seqkit locate --ignore-case --only-positive-strand --hide-matched -r -p "N+" report/consensus.fa
```

Run this command to see what it outputs. 

The output of the command includes several "columns" that are not so interesting for us. 
Try adding this other command at the end, after a pipe: `cut -f 1,5,6`.  
Can you understand what the `cut` command does?

Finally, redirect the output of both commands to a file called `report/consensus_miss_intervals.tsv`. 
The final file should look similar to this: 

```
seqID   start   end
CH13    1       54
CH13    1218    1218
CH13    2569    2850
CH13    6248    6495
CH13    6847    7058
CH13    7672    7968
CH13    13115   13115
CH13    15225   15503
CH13    16805   17087
```

:::

:::exercise

Open the file you created in the previous step (`report/consensus_miss_intervals.tsv`) in a spreadsheet program. 
Create a new column with the length of each start-end interval. 

Check which of the intervals is the longest for each sample and add this informationas to a new column named called "longest_miss_interval" in your `report/consensus_metrics.csv` file.

:::


:::highlight
**Reporting Checkpoint!**

The files generated in this section will also be part of your reported results. 

The **FASTA consensus** file could be used, for example, to upload to public repositories such as GISAID. 
We will also use it for some of our downstream analysis.  

The **variants CSV** file is important if later you want to check for the increase of new mutations in the population. 
In the case of the EQA sample panel, it can be used to assess whether all expected mutations were detected.

Finally, the **missing intervals CSV** file is useful as a quality assessment metric.  
:::


## Downstream Analyses

Now that we have our consensus sequences, we are ready to do further downstream analysis, using the clean FASTA files. 
We will focus on three main things: 

- **Lineage assignment:** identify if our samples come from known lineages from the _Pangolin_ consortium.
- **Clustering:** assess how many clusters of sequences we have, based on a phylogenetic analysis.
- **Phylogeny:** produce an annotated phylogenetic tree of our samples.
- **Integration & Visualisation:** cross-reference different results tables and produce visualisations of how variants changed over time.


### Lineage Assignment

Although the _Viralrecon_ pipeline runs _Pangolin_ and _Nextclade_ on our samples, it does not use the latest version of these programs (because lineages evolve so fast, the nomenclature constantly changes). 
Therefore, it is good practice to re-run our samples through these tools, to make sure we get the most up-to-date lineage assignment. 
Although it is possible to [configure _viralrecon_](https://nf-co.re/viralrecon/2.5/usage#updating-containers) to use more recent versions of these tools, it requires more advanced use of configuration files with the pipeline. 
An easier alternative is to use the **_Nextclade_ web application**.

:::exercise
Go to [clades.nextstrain.org](https://clades.nextstrain.org/) and run _Nextclade_ on the clean FASTA file you created earlier (`report/consensus.fa`).  
If you need a reminder about this tool, see the [Lineages & Variants > Nextclade](05-lineage_analysis.html#Nextclade) section of the materials.

Once the analysis complete, pay particular attention to the quality control column, to see what problems your samples may have (in particular those classified as "bad" quality). 

Use the "download" button (top-right) and download the file `nextclade.tsv` (tab-delimited file), which contains the results of the analysis. 
Save it in a new folder called `results/nextclade`. 
Open the file and copy the following columns to your `report/consensus_metrics.csv` (rename them as shown):

- `qc_status` = `qc.overallStatus` --> quality category as determined by _nextclade_.
- `pango` = `Nextclade_pango` --> _pango_ lineage assignment.
- `nextclade` = `clade_nextstrain` --> _nextclade_ clade assignment.
- `voc_who` = `clade_who` --> variant of concern name (WHO nomenclature).
- `substitutions` = `totalSubstitutions` --> total number of substitutions (SNPs).
- `deletions` = `totalDeletions` --> total deletions' length (in basepairs), relative to the reference genome.
- `insertions` = `totalInsertions` --> total insertions' length (in basepairs), relative to the reference genome.

:::

:::highlight
**Reporting Checkpoint!**

At this stage, your `report/consensus_metrics.csv` table should look similar to this (example samples shown here): 

TODO

:::


### Clustering

<!-- 
TODO - move this to its own (new) section.
-->

The software _civet_ (Cluster Investigation and Virus Epidemiology Tool) can be used to produce a report on the phylogenetic relationship between viral samples, using a background dataset to contextualise them (e.g. a global or regional sample of sequences) as well as metadata information to enable the identification of emerging clusters of samples. 

_Civet_ works in several stages, in summary:

- Each input sequence is assigned to a "catchment" group.
  These are groups of samples that occur at a given genetic distance (number of SNP differences) from each other. 
- Within each catchment group, a phylogeny is built (using the _iqtree2_ software with the HKY substitution model). 
- The phylogeny is annotated with user-input metadata (e.g. location, collection date, etc.). 
  The results are displayed in an interactive HTML report. 

One of the critical pieces of information needed by _civet_ is the background data, to which the input samples will be compared with. 
These background data could be anything the user wants, but typically it's a good idea to use samples from the local geographic area from where the samples were collected. 
For example, a national centre may choose to have their background data composed of all the samples that have been sequenced in the country so far. 
Or perhaps all the samples in its country and other neighbouring countries. 

One way to obtain background data is to download it from GISAID. 
An example of how to do this is detailed in the [_civet_ documentation](https://cov-lineages.org/resources/civet/walkthrough.html#background_dataset). 
We have already downloaded the data from GISAID, so we can go straight to running our _civet_ analysis. 

:::exercise
As background data for _civet_, we have pre-downloaded samples from GISAID for all major world regions, which is stored in `resources/background_data/`. 
Before running our samples through _civet_, we need to prepare this background data. 

1. Inspect the files in `resources/background_data/`, looking at the sub-directory that fits your country of residence. 
  In particular, look at the metadata file that comes with the background data, to identify the column name that contains the sample IDs and collection date. 
2. Using the information from the previous step, adjust the following _civet_ command (save this command in a new script in `scripts/02-prepare_civet_data.sh`):
  ```bash
  civet -bd align_curate \
    -bd-seqs <PATH_TO_BACKGROUND_FASTA> \
    -bd-metadata <PATH_TO_BACKGROUND_METADATA> \
    --sequence-id-column <METADATA_COLUMN_WITH_IDS>
  ```
3. Once you've created your new script, run it using `bash`. 

Note: you only need to do this step once for each version of the background data. 
If you have a new version of the background data (for example, revised monthly), then you need to run the `civet -bd align_curate` command again. 
:::

:::exercise
Now that you have prepared the background data, you are ready to run the _civet_ analysis on your consensus sequences. 
Create a new script in `scripts/03-run_civet.sh`, with the following command, adjusted to fit your files: 

```bash
civet -i <PATH_TO_YOUR_SAMPLE_METADATA> \
  -f <PATH_TO_YOUR_CONSENSUS_FASTA> \
  -icol <COLUMN_NAME_FOR_YOUR_SAMPLE_IDS> \
  -idate <COLUMN_NAME_FOR_YOUR_COLLECTION_DATE> \
  -d <PATH_TO_CIVET_DATA> \
  -o results/civet \
  -bicol <COLUMN_NAME_FOR_THE_BACKGROUND_METADATA_SAMPLE_IDS>
```

Once your script is ready, run it with `bash`. 

After the analysis completes, open the HTML output file in `results/civet` and answer the following questions:

- How many catchments do your samples fall into? 
- Create a new column in your `report/consensus_metrics.csv` file called "civet_catchment" with the catchment number for each sample. 

<!-- 
```bash
civet -i report/metadata.csv -f report/consensus.fa -icol sample -idate date -d resources/civet_data/asia -o results/civet -bicol modified_strain
```
 -->
:::


### Phylogeny

Although tools such as _Nextclade_ and _civet_ can place our samples in a phylogeny, sometimes it may be convient to build our own phylogenies.
This requires three steps: 

- Producing a multiple sequence alignment from all consensus sequences.
- Tree inference.
- Tree visualisation and annotation.

:::exercise

<!-- TODO -->

- Run MSA using `mafft`.
- Infer tree using `iqtree2`.
- Visualise the tree using FigTree. 
  - Annotate the tree with the results from your `report/consensus_metrics.csv` table. 
  - Highlight clades corresponding to WHO variants of concern. 

If you need a reminder of how to run these tools, consult the relevant sections in the [Phylogeny](06-phylogeny.html) lesson.

```bash
mafft --6merpair --maxambiguous 0.2 --addfragments report/consensus.fa resources/sarscov2.fa > results/mafft/consensus_alignment.fa
iqtree2 -s results/mafft/consensus_alignment.fa --prefix results/iqtree/consensus
```

:::


### Integration & Visualisation

At this point in our analysis, we have several tables with different pieces of information: 

- `metadata.csv` --> information about our samples such as date of collection, location, protocol details, etc.
- `consensus_metrics.csv` --> information about the quality and lineage assignment of our consensus sequences.
- `variants.csv` --> the SNP/indel variants detected in each of our samples.
- `missing_intervals.csv` --> the intervals with 'N' ambiguous (missing) bases. 

Each of these tables stores different pieces of information, and it would be great if we could _integrate_ them together, to further enrich our analysis. 
In particular, two kinds of visualisations can be useful
We will demonstrate how this analysis can be done using the R software, which is a popular programming language used for data analysis and visualisation. 

Check the [Quick R Intro](TODO) section to get an idea of how to work with R and RStudio.


### EQA Panels

The analysis we have done so far is applicable to any new sequences that you want to process. 
However, we have also been using a pre-defined panel of samples to be used as part of an _External Quality Assurance_ (EQA) process. 
This allows us to assess whether our bioinformatic analysis identified all the expected mutations in these samples, as well as assigned them to the correct lineages. 

To do this, requires to compare the mutations we detected in our EQA samples to the expected mutations provided to us. 

:::exercise

TODO -this could be done in R

:::


## Reporting

Finally, we have come to the end of our analysis. 
So, all that is left is to report our results in the most informative way to our colleagues and decision-makers. 
You may already have established reporting templates in your institution, and if that's the case, you should use those. 
Alternatively, we will look at a suggested template, based on the reports done by the UK Health Security Agency (UKHSA). 

:::exercise
Open our shared [report template](TODO) document and download it as a _Word_ document (<kbd>File</kbd> --> <kbd>Download</kbd> --> <kbd>Microsoft Word (.docx)</kbd>). 
Save the file in `report/YYYY-MM-DD_analysis_report.docx` (replace `YYYY-MM-DD` by today's date).

Open the file and complete fill the missing fields with the information you collected throughout your analysis. 
You should be able to get all this information from the files in your `report/` directory.

:::

