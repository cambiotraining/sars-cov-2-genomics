---
pagetitle: "SARS-CoV-2 Genomics"
---

# Extra Exercises

This set of exercises are provided as extra practice material that can be done outside of the course. 
It uses a larger set of data, which is more representative of what you may encounter in your own work.

All the exercises run from the data directory `homework`, so make sure you change into that directory. 
On our training machines this is `cd ~/Course_Materials/homework/`.

There are two sets of data, from two countries, one sequenced using Illumina and the other Nanopore platforms. 
Most of these exercises can be done on either dataset.
We advise that you pick one of the datasets (for example, the one that uses data that you are most likely to work with) and go through all the exercises. 
After you complete them, you can start again with the other dataset.


## Metadata {.tabset}

**This exercise uses the skills covered in [SARS-CoV-2 Genomic Surveillance](01-intro.html).**

Open the `homework` folder using the file browser <i class="fa-solid fa-folder"></i>.

1. Looking inside the each country's folder, open the `README.txt` file to understand what kind of sequencing platform was used for these samples.
1. Open the metadata sheet (`sample_info.csv`) for one of the countries and look at the dates when these samples were collected. 
1. Visit [outbreak.info](https://outbreak.info/location-reports) and look at the location report for the country you chose. What variants might you expect to be find in these data?

### South Africa

:::box
<details><summary>Answer</summary>

From the README we can see that using paired-end Illumina sequencing.
This will need to be considered when we run our consensus assembly workflow.

Double-clicking the `sample_info.csv` file opens it with our spreadsheet software (on our training machines this is LibreOffice, but Excel would also open CSV files).
The second column contains the sample collection dates, and we can see these samples are from Nov 2021 to Jan 2022. 

We visit [outbreak.info](https://outbreak.info/location-reports) and search for "South Africa". 
If we scroll down to the section "Tracked lineages over time in South Africa" we can see that in late 2021 and the start of 2022 we have mostly the "Omicron" SARS-CoV-2 variant circulating in the population. 
This suggests that our samples may mostly be this variant. 

</details>
:::

### Switzerland

:::box
<details><summary>Answer</summary>

From the README we can see that these samples were sequenced using a Nanopore MinION platform.
The raw Nanopore signal data was already processed to generate FASTQ files using Guppy. 
This will need to be considered when we run our consensus assembly workflow.

Double-clicking the `sample_info.csv` file opens it with our spreadsheet software (on our training machines this is LibreOffice, but Excel would also open CSV files).
The second column contains the sample collection dates, and we can see these samples are from Nov/Dec 2021 to Jan 2022. 

We visit [outbreak.info](https://outbreak.info/location-reports) and search for "Switzerland". 
If we scroll down to the section "Tracked lineages over time in Switzerland" we can see that around that period of 2021-2022 we had both Delta and Omicron variants circulating in the population, so we may expect to see these in our samples.

</details>
:::


## Unix {.tabset}

**This exercise uses the skills covered in [Introduction to Unix](02a-unix_intro.html).**

1. Open a terminal and change into either the `homework/switzerland/` or `homework/southafrica/` directory.
2. Create a new directory called `results`.
3. Use command line tools to find how many sequencing read files are available (these are found within the `data/fastq_pass` or `data/reads/` directories).

### South Africa 

:::box
<details><summary>Answer</summary>

To check how many samples we have, we can combine the `ls` (list files) and `wc` (word count) commands

For the South Africa samples we have paired-end Illumina data (i.e. two files per sample).
For this reason, we list all files that end with "_1.fastq.gz" using the `*` wildcard.
This way we ensure to only count each sample once:

```console
$ ls data/reads/*_1.fastq.gz | wc -l
```
```
48
```

We pipe the output of `ls` to the `wc` command using the option `-l` to count the number of lines coming out of the `ls` command. 

</details>
:::

### Switzerland

:::box
<details><summary>Answer</summary>

For the Switzerland samples we have Nanopore data. 
In this case, each sample's data is within its own directory, so all we have to do is count how many directories there are in `data/fastq_pass`:

```console
$ ls data/fastq_pass/ | wc -l
```
```
59
```

We pipe the output of `ls` to the `wc` command using the option `-l` to count the number of lines coming out of the `ls` command. 

</details>
:::


## FASTQ Quality Control {.tabset}

**This exercise uses the skills covered in [Introduction to NGS](03-intro_ngs.html).**

:::warning
This exercise can only be done on the South Africa samples. 
:::

The South Africa samples were sequenced on an Illumina platform.
We will run a basic quality control of these reads using FastQC and compile the results using MultiQC.

1. Runs FastQC on all the samples. Output the results to a directory called `results/fastqc/`. Make sure to create the directory first.
2. Compile the results of FastQC using MultiQC and output its results in a directory called `results/multiqc/`.
3. Analyse the reports and make a note of any samples that you worry about in terms of producing a high-quality assembly.

:::box
<details><summary>Answer</summary>

To check the data quality of our reads, we can use the following commands.
Make sure these commands are run from within the `homework/southafrica` directory.

```bash
# move to the directory
cd ~/Course_Materials/homework/southafrica/

# make directory
mkdir -p results/fastqc
mkdir -p results/multiqc

# run FastQC on all the files
# using 8 threads in parallel since we have 8 CPUs available
fastqc -t 8 --outdir results/fastqc/ data/reads/*.fastq.gz

# run MultiQC on the output of FastQC
multiqc --outdir results/multiqc/ results/fastqc/
```

This script starts by having some code to create the necessary output directories. 
The `-p` option ensures that we don't get an error in case the directory already exists. 

We then run `fastqc`, being careful to specify that we have 8 CPUs (with the `-t` option) to process the data in parallel. 
We also use the `*` _wildcard_ to pattern-match all the files ending with the file extension ".fastq.gz", so that FastQC will automatically process all the files. 

We then use the _output_ directory of the `fastqc` step as the _input_ for `multiqc`. 
This is just like a mini bioinformatics workflow or our own: outputs of one tool feeding into the next tool!

After looking at the quality report from `multiqc`, we can notice that:

- Some samples have a very low number of sequences. For example, sample SRR17461700 only has 46717 reads (you can open the individual FastQC report for this sample to see the exact number).
- Generally the read 2 files (file names ending `_2.fastq.gz`) have lower quality than the read 1 files. This is often seen in Illumina data. 
- In the "Adapter Content" section of the MultiQC report we can see that some of the reads contain some of the Illumina sequencing adapter within them. 

These last two points are generally solved with quality filtering and adapter removal, which is part of the consensus workflow we will use. 
However, it will still affect the quality of the assembly because by filtering low-quality reads we will, effectively be loosing data.

We should keep an eye on the samples with very low read numbers and check if they pass the QC thresholds from our consensus assembly workflow.

</details>
:::


## Consensus Assembly {.tabset}

**This exercise uses the skills covered in [Consensus Assembly](04-consensus.html).**

We will now produce a consensus assembly from our sequencing data using the `nf-core/viralrecon` Nextflow pipeline. 
Consult the [full documentation](https://nf-co.re/viralrecon/2.4.1) of this pipeline if you need to remind yourself what the different available options are. 

1. Write a command to run our samples through the pipeline. (Note: this may take a couple of hours to complete.)
    - The input CSV file with sample names and FASTQ file locations has already been prepared and is called `samplesheet.csv`.
    - Output the results to a directory called `results/viralrecon/`.
    - **Bonus:** Save the command used for your analysis in a script (create a `scripts/` folder and save it in there with a name of your choice).
1. How long did the pipeline take to run, and did it give any warnings?
1. Open the _MultiQC_ report file and explore the following questions: 
    - What can you say about the quality of the consensus sequences in terms of the fraction of the genome that is covered? What do you think are reasons why some samples may be better than others?
    - Do you detect any issues with amplicon dropouts? Does this affect all samples or some samples specifically?
    - What types of mutation variants do you get, and are most of them silent or missence mutations?

<details><summary>Hint</summary>
Some of the files you may want to use are: 

- The _MultiQC_ report:
  - Illumina pipeline: `results/viralrecon/multiqc_report.html`
  - Nanopore medaka pipeline: `results/viralrecon/medaka/multiqc_report.html`
- The mutation variants file: 
  - Illumina pipeline: `results/viralrecon/variants/ivar/variants_long_table.csv`
  - Nanopore medaka pipeline: `results/viralrecon/medaka/variants_long_table.csv`
- Open some of the BAM alignment files in IGV:
  - Illumina pipeline: `variants/bowtie2/*.ivar_trim.sorted.bam`
  - Nanopore medaka pipeline: `results/viralrecon/medaka/*.primertrimmed.rg.sorted.bam`
- The primer BED files can also be imported to IGV:
  - These are found in `resources/primers/artic_version3_pool1.bed` and `resources/primers/artic_version3_pool2.bed`.

</details>


### South Africa

:::box
<details><summary>Answer</summary>

**Question 1**

In order to run this pipeline, we need the following pieces of information: 

- The platform used for sequencing (illumina or nanopore). This information is given to us in the `README.txt` file.
- The primer set used and its version. This is also detailed in the `README.txt` file.
- For Illumina data we also need an input CSV file with 3 columns: name of the sample, location of FASTQ read 1 file, location of FASTQ read 2 file. We have this information in the file `samplesheet.csv`.

Our samples come from Illumina sequencing and used the ARTIC primer scheme version 3. 
Therefore, our command is: 

```bash
nextflow run nf-core/viralrecon \
  --input samplesheet.csv \
  --outdir results/viralrecon \
  --protocol amplicon \
  --genome 'MN908947.3' \
  --primer_set artic \
  --primer_set_version 3 \
  --skip_assembly \
  --platform illumina \
  -profile singularity
```

This step may take some hours to complete on our training machines, but we can see its progress printed on the console while it runs. 
Once it completes we should get a message printed on our screen, similar to: 

```
-[nf-core/viralrecon] 46/48 samples passed Bowtie2 1000 mapped read threshold:
    262615: ZA45
    225773: ZA32
    707111: ZA11
    292838: ZA35
    100358: ZA46
    2570: ZA43
    ..see pipeline reports for full list

-[nf-core/viralrecon] 2 samples skipped since they failed Bowtie2 1000 mapped read threshold:
    176: ZA12
    201: ZA09

-[nf-core/viralrecon] Pipeline completed successfully-
Waiting files transfer to complete (1 files)
Completed at: 04-May-2022 13:07:20
Duration    : 26m 56s
CPU hours   : 15.3
Succeeded   : 1'901
```

This tells us how long the pipeline took to run (in our example it was 26 minutes, but yours might be longer than this). 
We can also see a warning indicating that 2 samples were skipped due to an insufficient number of reads needed for downstream analysis. 
We will investigate this in the next question. 

**Question 2**

After our pipeline completes, we can open the _MultiQC_ report generated by the pipeline and located in `results/viralrecon/multiqc/multiqc_report.html`. 

One of the first things we can look at is the summary table "Variant Calling Metrics" at the top of the report. 
We can start by looking at the two samples that were skipped in the analysis - ZA09 and ZA12 - and see that while they had a moderate number of starting reads (>300 thousand), only around 200 reads were successfully mapped to the SARS-CoV-2 reference genome by `bowtie2`. 
Further looking at the table, we can see that this is because only a small percentage of reads - less than 2% - were non-host reads (i.e. non-human reads), which is determined by the _Kraken 2_ software. 

We can further explore this table to see that several other samples have very low % of non-human reads, suggesting several of these samples suffered from contamination of human DNA during preparation in the lab. 
We can see this in more detail in the section "PREPROCESS: Kraken 2". 

If we sort the table by the column "% Coverage > 10x", we can see that only 37 of the samples have this depth of coverage in more than 80% of the genome. 

The "Amplicon coverage heatmap" also shows how several samples have low depth of coverage across most of the amplicons. 
There are also some amplicons that seem to have lower depth of coverage across multiple samples. 

Finally, looking at the "Variants by Functional Class" section, we can disply the plot by as a percentage, which reveals most mutations are missense (i.e. they result in an amino acid change). 
Some samples have very low number of mutations (ZA10, ZA27, ZA30 and ZA31), making it difficult to draw conclusions from them.

</details>
:::


### Switzerland

:::box
<details><summary>Answer</summary>

**Question 1**

In order to run this pipeline, we need the following pieces of information: 

- The platform used for sequencing (illumina or nanopore). This information is given to us in the `README.txt` file.
- The primer set used and its version. This is also detailed in the `README.txt` file.
- For Nanopore data we also need an input CSV file with 2 columns: name of the sample, and the sample barcode number. We have this information in the file `samplesheet.csv`.
- For basecalled data we also need to specify a model for the `medaka` software, in the format `{pore}_{device}_{caller variant}_{caller version}` (see [documentation here](https://github.com/nanoporetech/medaka#models)). We are given this information in the `README.txt` file: R9.4.1 flowcell, MinION sequencer, high accuracy mode, Guppy version 3.6.0.

Because we are starting with basecalled data (FASTQ files), we will use the pipeline with the `medaka` variant caller. 
Therefore, our command is: 

```bash
nextflow run nf-core/viralrecon \
  --input samplesheet.csv \
  --outdir results/viralrecon \
  --protocol amplicon \
  --genome 'MN908947.3' \
  --primer_set artic \
  --primer_set_version 3 \
  --skip_assembly \
  --platform nanopore \
  --artic_minion_caller medaka \
  --artic_minion_medaka_model r941_min_high_g360 \
  --fastq_dir fastq_pass/ \
  -profile singularity
```

This step may take some hours to complete on our training machines, but we can see its progress printed on the console while it runs. 
Once it completes we should get a message printed on our screen, similar to: 

```
-[nf-core/viralrecon] Pipeline completed successfully-
Completed at: 04-May-2022 13:03:23
Duration    : 20m 2s
CPU hours   : 35.2
Succeeded   : 1'312
```

This tells us how long the pipeline took to run (in our example it was 20 minutes, but yours might be longer than this). 
We didn't get any warnings, indicating that all samples were processed successfully. 

**Question 2**

After our pipeline completes, we can open the _MultiQC_ report generated by the pipeline and located in `results/viralrecon/multiqc/medaka/multiqc_report.html`. 

One of the first things we can look at is the summary table "Variant Calling Metrics" at the top of the report. 
We can see that most samples had very good genome coverage at a depth > 10%. 
If we sort the table by the column "% Coverage > 10x", we can see that the lowest sample had 75% of the genome covered at this depth, which is still a good fraction. 

However, we can also note that two of the samples with the lowest genome coverage (CH07 and CH59) were not assigned a lineage by _Pangolin_, which suggests they did not pass the minimum thresholds for that program (we will explore more about lineage assignment in the next exercise). 
This may be due to a low number of reads, requiring re-sequencing these samples to achieve good genome coverage.

The "Amplicon coverage heatmap" shows an interesting pattern of amplicon dropout, with largely two groups of samples showing different patterns of amplicon depth of coverage. 
For example, amplicon "nCoV-2019_64" has extremely low depth of coverage in several samples such as CH20, CH43, CH24, CH40, CH44 amongst many others. 
Further investigation of this table reveals that these samples were classified as "Delta" by Nextclade. 
The other group of samples was classfied as "Omicron", which may suggest that mutations in each SARS-CoV-2 variant are causing issues amplifying some of the PCR amplicons using the ARTIC v3 protocol. 

A tip to explore these samples is to use the "highlight" button on MultiQC (on the right toolbar) and highlight certain samples of interest.

Further investigation of the amplicon dropout could be done by looking at the mutation file generated by the pipeline:

- Open the mutation variant file in a spreadhseet program - `results/viralrecon/medaka/variants_long_table.csv`.
- Sort the table by position ("POS" column).
- Check the location of the primers for amplicon "nCoV-2019_64", for example from the [BED file available online](https://github.com/artic-network/artic-ncov2019/blob/master/primer_schemes/nCoV-2019/V3/nCoV-2019.scheme.bed). We can see that these primers are in positions 19204-19232 and 19591-19616.
- Looking at the sorted table of variants we can see many samples have a SNP in position 19220, which overlaps the left primer. This could be a reason for this amplicon dropout.

Finally, looking at the "Variants by Functional Class" section, we can disply the plot by as a percentage, which reveals most mutations are missense (i.e. they result in an amino acid change). 
Three samples have 1 nonsense mutation each (i.e. causing a new stop codon), which tend to be quite disruptive. 
Looking back at our mutation table, we can look at mutations with EFFECT column = "stop_gained" and will see that two of the samples share the same mutation (position 28209). 
This could be an indication that this is a true mutation rather than an error (since the chance of the same error occurring twice independently is low). 
However, this should be confirmed with new experiments as sequencing errors can sometimes be biased. 

</details>
:::


## Cleaning FASTA files {.tabset}

**This exercise uses the skills covered in [Consensus Assembly - Cleaning FASTA Files](04-consensus.html#Cleaning_FASTA_Files).**

The `nf-core/viralrecon` pipeline generates a separate consensus sequence FASTA file for sample. 
However, for downstream analysis (variant analysis and phylogeny), it is more useful to have all the consensus sequecences combined into a single file. 

1. Using command-line tools, combine all the FASTA files into a single file. Save the resulting file as `results/clean_consensus_sequences.fa`. (Note: see the hint below if you need a reminder of where these files are and what commands you can use.)
2. (Bonus - advanced) Using the `sed` command line tool, clean the names of the sequences such that only the original sample name is present in the final FASTA file. For example:
      - An illumina sample named as `>ZA01 MN908947.3` should become `>ZA01`
      - A nanopore sample named as `>CH01/ARTIC/medaka MN908947.3` should become `>CH01`

<details><summary>Hint</summary>
The FASTA files can be found in different directories, depending on whether you are processing the Nanopore or Illumina data: 

- Illumina: fasta files are found in `results/viralrecon/variants/ivar/consensus/bcftools/` with `.fa` extension.
- Nanopore: fasta files are found in `results/viralrecon/medaka/` with `.fasta` extension.

Remember that all of the information about output files is [extensively detailed in the pipeline documentation](https://nf-co.re/viralrecon/2.4.1/output).

Some of the command-line tricks you can use to combine the files in this exercise include: 

- Using the `cat` command to combine text files
- Using the `*` wildcard to simultaneously select files matching a particular pattern in their name
- Using the `>` redirect operator to send the output of a command to a file (instead of printing it on the console). 

</details>

### South Africa

:::box
<details><summary>Answer</summary>

**Question 1**

For the South Africa samples (Illumina pipeline) the FASTA files can be found in the folder `results/viralrecon/variants/ivar/consensus/bcftools/`. 

We can list all the files ending with `.fa` extension found in this folder: 

```console
$ ls results/viralrecon/variants/ivar/consensus/bcftools/*.fa
```

```
results/viralrecon/variants/ivar/consensus/bcftools/ZA01.consensus.fa
results/viralrecon/variants/ivar/consensus/bcftools/ZA02.consensus.fa
results/viralrecon/variants/ivar/consensus/bcftools/ZA03.consensus.fa
results/viralrecon/variants/ivar/consensus/bcftools/ZA04.consensus.fa
results/viralrecon/variants/ivar/consensus/bcftools/ZA05.consensus.fa
[... more output not shown...]
```

We can also count how many files we have and confirm this matches the number of samples in this dataset:

```console
$ ls results/viralrecon/variants/ivar/consensus/bcftools/*.fa | wc -l
```

```
45
```

Finally, we can combine all the files using the `cat` command and redirecting the output with `>` to a new file:

```console
$ cat results/viralrecon/variants/ivar/consensus/bcftools/*.fa > results/clean_consensus_sequences.fa
```

We can confirm that all the samples are present in this file:

```console
$ cat results/clean_consensus_sequences.fa | grep ">" | wc -l
```

```
45
```

- We print the content of the file with `cat`.
- We find lines of the file that contain the `>` character (the sequence names in FASTA files always start with this character).
- We use the `wc -l` to count the number of lines in the output. 


**Question 2**

Looking at the content of one of the files using `head`, we can see how the sequences are named:

```console
$ head -n 3 results/viralrecon/variants/ivar/consensus/bcftools/ZA01.consensus.fa
```

```
>ZA01 MN908947.3
NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNAGATCT
GTTCTCTAAACGAACTTTAAAATCTGTGTGGCTGTCACTCGGCTGCATGCTTAGTGCACT
```

We can remove the " MN908947.3" text from the sample names using the `sed` text-replacement function. 
This would be our modified command to combine all samples and remove that text:

```console
$ cat results/viralrecon/medaka/*.fasta | sed 's/ MN908947.3//' > results/clean_consensus_sequences.fa
```

Some notes about the `sed` command: 

- The syntax to substitute text is `sed 's/old text/new text/'`.
- If we want to _remove_ text we can leave the new text field empty: `sed 's/old text//'`
- Notice that we want to also substitute the _space_ before "MN908947.3", so we include that in our pattern to substitute.

</details>
:::

### Switzerland

:::box
<details><summary>Answer</summary>

**Question 1**

For the Switzerland samples (Nanopore `medaka` pipeline) the FASTA files can be found in the folder `results/viralrecon/medaka/`. 

We can list all the files ending with `.fasta` extension found in this folder: 

```console
$ ls results/viralrecon/medaka/*.fasta
```

```
results/viralrecon/medaka/CH01.consensus.fasta
results/viralrecon/medaka/CH03.consensus.fasta
results/viralrecon/medaka/CH05.consensus.fasta
results/viralrecon/medaka/CH06.consensus.fasta
results/viralrecon/medaka/CH07.consensus.fasta
[... more output not shown...]
```

We can also count how many files we have and confirm this matches the number of samples in this dataset:

```console
$ ls results/viralrecon/medaka/*.fasta | wc -l
```

```
59
```

Finally, we can combine all the files using the `cat` command and redirecting the output with `>` to a new file:

```console
$ cat results/viralrecon/medaka/*.fasta > results/clean_consensus_sequences.fa
```

We can confirm that all the samples are present in this file:

```console
$ cat results/clean_consensus_sequences.fa | grep ">" | wc -l
```

```
59
```

- We print the content of the file with `cat`.
- We find lines of the file that contain the `>` character (the sequence names in FASTA files always start with this character).
- We use the `wc -l` to count the number of lines in the output. 


**Question 2**

Looking at the content of one of the files using `head`, we can see how the sequences are named:

```console
$ head -n 3 results/viralrecon/medaka/CH01.consensus.fasta
```

```
>CH01/ARTIC/medaka MN908947.3
NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNAGATCT
GTTCTCTAAACGAACTTTAAAATCTGTGTGGCTGTCACTCGGCTGCATGCTTAGTGCACT
```

We can remove the "/ARTIC/medaka MN908947.3" text from the sample names using the `sed` text-replacement function. 
This would be our modified command to combine all samples and remove that text:

```
cat results/viralrecon/medaka/*.fasta | sed 's/\/ARTIC\/medaka MN908947.3//' > results/clean_consensus_sequences.fa
```

Some notes about the `sed` command: 

- The syntax to substitute text is `sed 's/old text/new text/'.
- If we want to _remove_ text we can leave the new text field empty: `sed 's/old text//'`
- Because `/` is used to separate the different parts of the `sed` command, when we want to replace the actual "/" letter we need to prefix it `\` (this is called "escaping"). Therefore, we use "\/ARTIC\/medaka MN908947.3" as the text to replace.

</details>
:::

## Lineages & Variants {.tabset}

We will now investigate in more detail the SARS-CoV-2 lineages/clades and variants of concern in our samples. 

1. Looking at the _MultiQC_ report, answer the following:
    - How many different variants of concern were detected in your samples?
    - Looking at the _Pangolin_ analysis section, where there any problematic samples and, if so, what was the reason?
1. Run a full _Nextclade_ analysis using the web application: https://clades.nextstrain.org/. Upload the clean FASTA file you generated in the previous exercise.
    - What quality issues do you detect using this tool? Does it agree with your previous conclusions?

### South Africa

:::box
<details><summary>Answer</summary>

**Question 1**

There are two main tools used to assign consensus sequences to lineages/clades and classify them as variants of concern: _Nextclade_ and _Pangolin_.

We can look at the first table of the _MultiQC_ report and look at the column "Nextclade clade" to see which SARS-CoV-2 variants were detected using this tool. 
We can see that all samples were classified as Omicron, except one sample, which was not classified as a known variant of concern: ZA10 was assigned to _Nextclade_ clade 20C.

Looking at the section of the _MultiQC_ report called "VARIANTS: Pangolin" we can see what variants were detected with this tool (which uses `scorpio` to do the classification of variants of concern). 
Again, the analysis for this tool agrees with the _Nextclade_ analysis, in that all samples were classified as Omicron. 

However, _Pangolin_ seems to have a higher number of samples that were not classified, as they did not pass the minimum genome coverage threshold required for its analysis.
These are highlighted as "Fail" in the column "QC Status". 
In the column "Note" we can see the reason was a high proportion of missing data ("N"). 


**Question 2**

We go to https://clades.nextstrain.org/ and:

- Click **Select a file** to browse your computer and upload the FASTA file with the cleaned consensus sequences (`results/clean_consensus_sequences.fa`).
- Click **Run**

We are then presented with the _Nextclade_ interactive results panel, similar to the one shown in this picture:

![](images/nextclade_overview.svg)

We can sort the table by the column "QC" (quality control) to look at the most problematic samples. 
We can see the main reason for low QC score is a high proportion of missing data, which is in agreement with the information we previously looked at from _Pangolin_. 

However, other issues are also present in some of the samples:

- The occurrence of private mutations, which are mutations that are not present in any other sample and so could be due to sequencing errors.
- the occurrence of frame shifts, which are insertion/deletion mutations that change the translation frame of a protein. Such a mutation would be very disruptive and likely lethal, so it may also be caused by sequencing errors. 

</details>

### Switzerland

:::box
<details><summary>Answer</summary>

**Question 1**

There are two main tools used to assign consensus sequences to lineages/clades and classify them as variants of concern: _Nextclade_ and _Pangolin_.

We can look at the first table of the _MultiQC_ report and look at the column "Nextclade clade" to see which SARS-CoV-2 variants were detected using this tool. 
We can see that samples were either classified as Omicron or Delta.

Looking at the section of the _MultiQC_ report called "Pangolin" we can see what variants were detected with this tool (which uses `scorpio` to do the classification of variants of concern):

- The analysis for this tool agrees with the _Nextclade_ analysis, in that samples were classified either as Omicron or Delta. 
- However, some samples (CH22, CH47, CH58 and CH62) were classified as "Probable Omicron", suggesting that there were not enough known SNPs from these SARS-CoV-2 variants present in the consensus sequences. 
This is indicated by the column "S support", which has a lower score for these samples.
- Two samples (CH07 and CH59) were not classified. These are highlighted as "Fail" in the column "QC Status". In the column "Note" we can see the reason was a high proportion of missing data ("N"). 


**Question 2**

We go to https://clades.nextstrain.org/ and:

- Click **Select a file** to browse your computer and upload the FASTA file with the cleaned consensus sequences (`results/clean_consensus_sequences.fa`).
- Click **Run**

We are then presented with the _Nextclade_ interactive results panel, similar to the one shown in this picture:

![](images/nextclade_overview.svg)

We can sort the table by the column "QC" (quality control) to look at the most problematic samples. 
We can see the main reason for low QC score is a high proportion of missing data affecting many of the samples. 

Two samples (CH38 and CH26) have also been highlighted as having too many private mutations, which are mutations that are not present in any other sample and so could be due to sequencing errors.

</details>

