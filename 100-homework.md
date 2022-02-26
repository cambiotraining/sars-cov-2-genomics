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


## Metadata

**This exercise uses the skills covered in [SARS-CoV-2 Genomic Surveillance](01-intro.html).**

Open the `homework` folder using the file browser <i class="fa-solid fa-folder"></i>.

1. Looking inside the each country's folder, open the `README.txt` file to understand what kind of sequencing platform was used for these samples.
1. Open the metadata sheet for one of the countries and look at the dates when these samples were collected. 
1. Visit [outbreak.info](https://outbreak.info/location-reports) and look at the location report for the country you chose. What variants might you expect to be find in these data?

:::box
<details><summary>Answer</summary>

**South Africa**

From the README we can see that using paired-end Illumina sequencing.
This will need to be considered when we run our consensus assembly workflow.

Double-clicking the `sample_metadata.csv` file opens it with our spreadsheet software (on our training machines this is LibreOffice, but Excel would also open CSV files).
The second column contains the sample collection dates, and we can see these samples are from Nov 2021 to Jan 2022. 

We visit [outbreak.info](https://outbreak.info/location-reports) and search for "South Africa". 
If we scroll down to the section "Tracked lineages over time in South Africa" we can see that in late 2021 and the start of 2022 we have mostly the "Omicron" SARS-CoV-2 variant circulating in the population. 
This suggests that our samples may mostly be this variant. 

----

**India**

From the README we can see that using Nanopore sequencing.
This will need to be considered when we run our consensus assembly workflow.

Double-clicking the `sample_metadata.csv` file opens it with our spreadsheet software (on our training machines this is LibreOffice, but Excel would also open CSV files).
The second column contains the sample collection dates, and we can see these samples are from Jan to Feb 2021. 

We visit [outbreak.info](https://outbreak.info/location-reports) and search for "India". 
If we scroll down to the section "Tracked lineages over time in South Africa" we can see that around that period of 2021 we had both Alpha and Delta variants circulating in the population, so we may expect to see these in our samples.

</details>
:::


## Unix

**This exercise uses the skills covered in [Introduction to Unix](02a-unix_intro.md).**

1. Open a terminal and change into either the `homework/india/` or `homework/southafrica/` directory.
2. Create a new directory called `results`.
3. Use command line tools to find how many sequencing read files are available (these are found within the `data/reads/` directory).

:::box
<details><summary>Answer</summary>

To check how many samples we have, we can combine the `ls` (list files) and `wc` (word count) commands

**South Africa**

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

----

**India**

For the India samples we have Nanopore data. 
In this case, each sample's data is within its own directory, so all we have to do is count how many directories there are in `data/reads`:

```console
$ ls india/data/reads/ | wc -l
```
```
47
```

We pipe the output of `ls` to the `wc` command using the option `-l` to count the number of lines coming out of the `ls` command. 

</details>
:::

<!--
## FASTQ Quality Control

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

To check the data quality of our reads, we can write a shell script including all the commands that we want to run.
Make sure these commands are run from within the `homework/southafrica` directory.

```bash
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

We then run `fastqc`, being careful to specify that we have 8 CPUs (with the `-t` option). 
We also use the `*` _wildcard_ to pattern-match all the files ending with the file extension ".fastq.gz", so that FastQC will automatically process all the files in parallel. 

We then use the _output_ directory of the `fastqc` step as the _input_ for `multiqc`. 
This is just like a mini-workflow or our own! Outputs of one tool feeding into the next tool.

After looking at the quality report from `multiqc`, we can notice that:

- Some samples have a very low number of sequences. For example, sample SRR17461700 only has 46717 reads (you can open the individual FastQC report for this sample to see the exact number).
- Generally the read 2 files (file names ending `_2.fastq.gz`) have lower quality than the read 1 files. This is often seen in Illumina data. 
- In the "Adapter Content" section of the MultiQC report we can see that some of the reads contain some of the Illumina sequencing adapter within them. 

These last two points are generally solved with quality filtering and adapter removal, which is part of the consensus workflow we will use. 
However, it will still affect the quality of the assembly because by filtering low-quality reads we will, effectively be loosing data.

We should keep an eye on the samples with very low read numbers and check if they pass the QC thresholds from our consensus assembly workflow.

</details>
:::


## Consensus Assembly

**This exercise uses the skills covered in [Consensus Assembly](04-artic_nextflow.html).**

We will now produce a consensus assembly from our sequencing data.

- Write a command to run these samples through the `ncov2019-artic-nf` Nextflow workflow. (Note: this may take 10-20 minutes to run.)
  - Output the results to a directory called `results/consensus/`.
  - **Bonus:** Save the command used for your analysis in a script (create a `scripts/` folder and save it in there with a name of your choice). 
- Once complete, open the QC CSV file produced by the pipeline and check how many samples pass the default quality thresholds. Do you agree that all these samples should be used in downstream analysis? How many samples would you keep for uploading to public databases and lineage assignment?
- **Bonus:** Use some commands to count how many samples passed the default quality control thresholds of the workflow.


:::box
<details><summary>Answer</summary>

**South Africa**

To produce consensus sequences for our South Africa samples, we run our nextflow workflow with the `--illumina` option and `--directory` to specify the directory where all our files are located in:

```bash
nextflow run ncov2019-artic-nf -with-report -with-dag -profile conda --outdir results/consensus/ --prefix southafrica --schemeVersion V3 --directory data/reads/ --illumina
```

This step takes quite a while to complete (around 2h with 8 CPUs), but we can see its progress printed on the console while it runs. 
Once it completes, we should get several directories within `/results/consensus/`. 
We also get a file named `southafrica.qc.csv`, which contains all the QC metrics from our assembled consensus sequences. 

If we open that file, we can see several quality metrics, which we detailed in the [course materials](04-artic_nextflow.html#Output_Files). 

As a bonus, to find out how many samples pass quality thresholds, we can use the `grep` command (used to find text patterns within files) combined with `wc`:

```console 
$ grep "TRUE" results/consensus/southafrica.qc.csv | wc -l
```
```
38
```

----

**India**

To process the samples from India, we run our workflow with the `--medaka` option and the `--basecalled_fastq` option to specify the directory where all our FASTQ files are located in:

```bash
nextflow run ncov2019-artic-nf -with-report -with-dag -profile conda --outdir results/consensus/ --prefix india --schemeVersion V3 --basecalled_fastq data/reads/ --medaka
```

The workflow should take around 30m to run, and will produce several directories as detailed in the [course materials](04-artic_nextflow.html#Output_Files). 

We can explore the QC file to identify any problematic samples. 

As a bonus, to find out how many samples pass quality thresholds, we can use the `grep` command (used to find text patterns within files) combined with `wc`:

```console 
$ grep "TRUE" results/consensus/india.qc.csv | wc -l
```
```
47
```

</details>
:::


## Lineages & Variants

-->

