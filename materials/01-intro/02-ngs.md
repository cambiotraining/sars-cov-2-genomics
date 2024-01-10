---
pagetitle: "SARS Genomic Surveillance"
---

# Introduction to NGS

:::{.callout-tip}
#### Learning Objectives

- Describe differences between sequencing data produced by Illumina and Nanopore platforms. 
- Recognise the structure of common file formats in bioinformatics, in particular FASTA and FASTQ files.
- Use FastQC to produce a quality report for Illumina sequences.
- Use MultiQC to produce a report compiling multiple quality statistics.
- Examine quality reports to identify problematic samples. 

:::


:::{.callout-note}
#### Slides

This section has an accompanying <a href="https://docs.google.com/presentation/d/1tYPnCci7C4Gmsy1O7YhGVDbm_Pib6jA3O411cLA5EFs/edit?usp=sharing" target="_blank">slide deck</a>.
:::

## Next Generation Sequencing

The sequencing of genomes has become more routine due to the [rapid drop in DNA sequencing costs](https://www.genome.gov/about-genomics/fact-sheets/DNA-Sequencing-Costs-Data) seen since the development of Next Generation Sequencing (NGS) technologies in 2007. 
One main feature of these technologies is that they are _high-throughput_, allowing one to more fully characterise the genetic material in a sample of interest. 

There are three main technologies in use nowadays, often referred to as 2nd and 3rd generation sequencing: 

- Illumina's sequencing by synthesis (2nd generation)
- Oxford Nanopore, shortened ONT (3rd generation)
- Pacific Biosciences, shortened PacBio (3rd generation)

The video below from the iBiology team gives a great overview of these technologies.

<p align="center"><iframe width="560" height="315" src="https://www.youtube.com/embed/mI0Fo9kaWqo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></p>

### Illumina Sequencing

Illumina's technology has become a widely popular method, with many applications to study transcriptomes (RNA-seq), epigenomes (ATAC-seq, BS-seq), DNA-protein interactions (ChIP-seq), chromatin conformation (Hi-C/3C-Seq), population and quantitative genetics (variant detection, GWAS), de-novo genome assembly, amongst [many others](https://emea.illumina.com/content/dam/illumina-marketing/documents/products/research_reviews/sequencing-methods-review.pdf). 

An overview of the sequencing procedure is shown in the animation video below. 
Generally, samples are processed to generate so-called _sequencing libraries_, where the genetic material (DNA or RNA) is processed to generate fragments of DNA with attached oligo adapters necessary for the sequencing procedure (if the starting material is RNA, it can be converted to DNA by a step of reverse transcription). 
Each of these DNA molecule is then sequenced from both ends, generating pairs of sequences from each molecule, i.e. _paired-end sequencing_ (single-end sequencing, where the molecule is only sequenced from one end is also possible, although much less common nowadays). 

This technology is a type of _short-read sequencing_, because we only obtain short sequences from the original DNA molecules.
Typical protocols will generate 2x50bp to 2x250bp sequences (the 2x denotes that we sequence from each end of the molecule). 

<p align="center"><iframe width="560" height="315" src="https://www.youtube.com/embed/fCd6B5HRaZ8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></p>

The main advantage of Illumina sequencing is that it produces very high-quality sequence reads (current protocols generate reads with an error rate of less than <1%) at a low cost. 
However, the fact that we only get relatively short sequences means that there are limitations when it comes to resolving particular problems such as long sequence repeats (e.g. around centromeres or transposon-rich areas of the genome), distinguishing gene isoforms (in RNA-seq), or resolving haplotypes (combinations of variants in each copy of an individual's diploid genome).


### Nanopore Sequencing

Nanopore sequencing is a type of _long-read sequencing_ technology. 
The main advantage of this technology is that it can sequence very long DNA molecules (up to megabase-sized), thus overcoming the main shortcoming of short-read sequencing mentioned above. 
Another big advantage of this technology is its portability, with some of its devices designed to work via USB plugged to a standard laptop. 
This makes it an ideal technology to use in situations where it is not possible to equip a dedicated sequencing facility/laboratory (for example, when doing field work).

![Overview of Nanopore sequencing showing the highly-portable MinION device. The device contains thousands of nanopores embeded in a membrane where current is applied. As individual DNA molecules pass through these nanopores they cause changes in this current, which is detected by sensors and read by a dedicated computer program. Each DNA base causes different changes in the current, allowing the software to convert this signal into base calls.](https://media.springernature.com/full/springer-static/image/art%3A10.1038%2Fs41587-021-01108-x/MediaObjects/41587_2021_1108_Fig1_HTML.png?as=webp)

One of the bigger challenges in effectively using this technology is to produce sequencing libraries that contain high molecular weight, intact, DNA. 
Another disadvantage is that, compared to Illumina sequencing, the error rates at higher, at around 5%. 

:::{.callout-note}
#### Illumina or Nanopore for SARS-CoV-2 sequencing?

Both of these platforms have been widely popular for SARS-CoV-2 sequencing. 
They can both generate data with high-enough quality for the assembly and analysis of SARS-CoV-2 genomes. 
Mostly, which one you use will depend on what sequencing facilities you have access to. 

While Illumina provides the cheapest option per sample of the two, it has a higher setup cost, requiring access to the expensive sequencing machines. 
On the other hand, Nanopore is a very flexible platform, especially its portable MinION devices. 
They require less up-front cost allowing getting started with sequencing very quickly in a standard molecular biology lab.
:::


## Sequencing Analysis

In this section we will demonstrate two common tasks in sequencing data analysis: sequence quality control and mapping to a reference genome. 
There are many other tasks involved in analysing sequencing data, but looking at these two examples will demonstrate the principles of running bioinformatic programs.
We will later see how bioinformaticians can automate more complex analyses in the [consensus assembly section](../02-isolates/01-consensus.md).

One of the main features in bioinformatic analysis is the use of standard file formats.
It allows software developers to create tools that work well with each other. 
For example, the raw data from Illumina and Nanopore platforms is very different: Illumina generates images; Nanopore generates electrical current signal. 
However, both platforms come with software that converts those raw data to a standard text-based format called **FASTQ**. 


### FASTQ Files

FASTQ files are used to store nucleotide sequences along with a quality score for each nucleotide of the sequence. 
These files are the typical format obtained from NGS sequencing platforms such as Illumina and Nanopore (after basecalling). 

The file format is as follows:

```
@SEQ_ID                   <-- SEQUENCE NAME
AGCGTGTACTGTGCATGTCGATG   <-- SEQUENCE
+                         <-- SEPARATOR
%%).1***-+*''))**55CCFF   <-- QUALITY SCORES
```

In FASTQ files each sequence is always represented across 4 lines. 
The quality scores are encoded in a compact form, using a single character. 
They represent a score that can vary between 0 and 40 (see [Illumina's Quality Score Encoding](https://support.illumina.com/help/BaseSpace_OLH_009008/Content/Source/Informatics/BS/QualityScoreEncoding_swBS.htm)). 
The reason single characters are used to encode the quality scores is that it saves space when storing these large files. 
Software that work on FASTQ files automatically convert these characters into their score, so we don't have to worry about doing this conversion ourselves.

The quality value in common use is called a _Phred score_ and it represents the probability that the respective base is an error. 
For example, a base with quality 20 has a probability $10^{-2} = 0.01 = 1\%$ of being an error. 
A base with quality 30 has $10^{-3} = 0.001 = 0.1\%$ chance of being an error. 
Typically, a Phred score threshold of >20 or >30 is used when applying quality filters to sequencing reads. 

Because FASTQ files tend to be quite large, they are often _compressed_ to save space. 
The most common compression format is called _gzip_ and uses the extension `.gz`.
To look at a _gzip_ file, we can use the command `zcat`, which decompresses the file and prints the output as text. 

For example, we can use the following command to count the number of lines in a compressed FASTQ file:

```console
$ zcat sequences.fq.gz | wc -l
```

If we want to know how many sequences there are in the file, we can divide the result by 4 (since each sequence is always represented across four lines).


### FASTQ Quality Control

One of the most basic tasks in Illumina sequence analysis is to run a quality control step on the FASTQ files we obtained from the sequencing machine. 

The program used to assess FASTQ quality is called _FastQC_. 
It produces several statistics and graphs for each file in a nice report that can be used to identify any quality issues with our sequences. 

The basic command to run _FastQC_ is:

```bash
fastqc --outdir PATH_TO_OUTPUT_DIRECTORY   PATH_TO_SEQUENCES
```

FastQC can process several samples at once, and often we can use the `*` wildcard to do this. 
We will see an example of this in the following exercise. 

Each FastQC HTML report contains a section with a different quality assessment plot.
Each of these are explained in the online documentation:

* [Basic statistics](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/1%20Basic%20Statistics.html)
* [Per base sequence quality](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/2%20Per%20Base%20Sequence%20Quality.html)
* [Per sequence quality scores](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/3%20Per%20Sequence%20Quality%20Scores.html)
* [Per base sequence content](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/4%20Per%20Base%20Sequence%20Content.html)
* [Per sequence GC content](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/5%20Per%20Sequence%20GC%20Content.html)
* [Per base N content](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/6%20Per%20Base%20N%20Content.html)
* [Sequence length distribution](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/7%20Sequence%20Length%20Distribution.html)
* [Sequence duplication levels](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/8%20Duplicate%20Sequences.html)
* [Overrepresented sequences](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/9%20Overrepresented%20Sequences.html)
* [Adapter content](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/10%20Adapter%20Content.html)
* [Per tile sequence quality](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/12%20Per%20Tile%20Sequence%20Quality.html)

For example, looking at the "Per base sequence quality" section for one of our samples, we can see a very high quality score, which is typical of Illumina data nowadays.

![Sequence quality plot from FastQC for one of our samples. The blue line shows the average across all samples. This sample is very high quality as all sequences have quality > 20 across the entire length of the reads.](images/fastqc_quality.png)

:::{.callout-note}
#### Quality Control Nanopore Reads

Although FastQC can run its analysis on any FASTQ files, it has mostly been designed for Illumina data. 
You can still run FastQC on basecalled Nanopore data, but some of the output modules may not be as informative. 
FastQC can also run on FAST5 files, using the option `--nano`. 

You can also use [MinIONQC](https://github.com/roblanf/minion_qc), which takes as input the `sequence_summary.txt` file, which is a standard output file from the Guppy software used to convert Nanopore electrical signal to sequence calls. 
:::


### Read Mapping

A common task in processing sequencing reads is to align them to a reference genome, which is typically referred to as **read mapping** or **read alignment**. 
We will continue exemplifying how this works for Illumina data, however the principle is similar for Nanopore data (although the software used is often different, due to the higher error rates and longer reads typical of these platforms). 

Generally, these are the steps involved in read mapping (figure below):

- **Genome Indexing |** Because reference genomes can be quite long, most mapping algorithms require that the genome is pre-processed, which is called genome indexing. You can think of a genome index in a similar way to an index at the end of a textbook, which tells you in which pages of the book you can find certain keywords. Similarly, a genome index is used by mapping algorithms to quickly search through its sequence and find a good match with the reads it is trying to align against it. Each mapping software requires its own index, but we **only have to generate the genome index once**. 
- **Read mapping |** This is the actual step of aligning the reads to a reference genome. There are different popular read mapping programs such as `bowtie2` or `bwa`. The input to these programs includes the genome index (from the previous step) and the FASTQ file(s) with reads. The output is an alignment in a file format called SAM (text-based format - takes a lot of space) or BAM (compressed binary format - much smaller file size). 
- **BAM Sorting |** The mapping programs output the sequencing reads in a random order (the order in which they were processed). But, for downstream analysis, it is good to _sort_ the reads by their position in the genome, which makes it faster to process the file. 
- **BAM Indexing |** This is similar to the genome indexing we mentioned above, but this time creating an index for the alignment file. This index is often required for downstream analysis and for visualising the alignment with programs such as IGV. 

![Diagram illustrating the steps involved in mapping sequencing reads to a reference genome. Mapping programs allow some differences between the reads and the reference genome (red mutation shown as an example). Before doing the mapping, reads are usually filtered for high-quality and to remove any sequencing adapters. The reference genome is also indexed before running the mapping step. The mapped file (BAM format) can be used in many downstream analyses. See text for more details.](images/ngs_mapping.svg)

We have already prepared the SARS-CoV-2 genome index for the `bowtie2` aligner. 
We have also prepared a shell script with the code to run the three steps above as an example.
Let's look at the content of this file (you can open it with `nano scripts/mapping.sh`):

```bash
# mapping
bowtie2 -x resources/reference/bowtie2/sarscov2 -1 data/reads/ERR6129126_1.fastq.gz -2 data/reads/ERR6129126_2.fastq.gz --threads 5 | samtools sort -o results/bowtie2/ERR6129126.bam -

# index mapped file
samtools index results/bowtie2/ERR6129126.bam

# obtain some mapping statistics
samtools stats results/bowtie2/ERR6129126.bam > results/bowtie2/ERR6129126.stats.txt
```

In the first step, mapping, we are using two tools: `bowtie2` and `samtools`. 
`bowtie2` is the mapping program and `samtools` is a program used to manipulate SAM/BAM alignment files. 
In this case we used the `|` pipe to send the output of `bowtie2` directly to `samtools`:

- `-x` is the prefix of the reference genome index.
- `-1` is the path to the first read in paired-end sequencing.
- `-2` is the path to the second read in paired-end sequencing.
- ` --threads 5` indicates we want to use 5 CPUs (or threads) to do parallel processing of the data.
- `|` is the pipe that sends the output from `bowtie2` to `samtools sort`.
- `-o` is the name of the output file. By setting the file extension of this file to `.bam`, `samtools` will automatically save the file in the compressed format (which saves a lot of space).
- The `-` symbol at the end of the `samtools` command indicates that the input is coming from the `|` pipe. 

We also have a step that creates an index file for the BAM file using `samtools index`. 
This creates a file with the same name and `.bai` extension. 

Finally, the script also contains a step that collects some basic statistics from the alignment, which we save in a text file.
We will see how this file can be used to produce a quality control report below. 


### Visualising BAM Files in IGV

One thing that can be useful is to visualise the alignments produced in this way. 
We can use the program _IGV_ (Integrative Genome Viewer) to do this:

- Open _IGV_ and go to <kbd>File → Load from file...</kbd>. 
- In the file browser that opens go to the folder `results/bowtie2/` and select the file `ERR6129126.bam` to open it.
- Go back to <kbd>File → Load from file...</kbd> and this time load the BED files containing the primer locations. These can be found in `resources/primers/artic_primers_pool1.bed` and `resources/primers/artic_primers_pool2.bed`.

There are several ways to search and browse through our alignments, exemplified in the figure below. 

![Screenshot IGV program. The search box at the top can be used to go to a specific region in the format "CHROM:START-END". In the case of SARS-CoV-2 there is only one "chromosome" called NC_045512.2 (this is the name of the reference genome), so if we wanted to visualise the region between positions 21563 and 25384 (the Spike gene) we would write "NC_045512.2:21563-25384".](images/igv_overview.svg)


### Quality Reports

We've seen the example of using the program _FastQC_ to assess the quality of our FASTQ sequencing files.
And we have also seen an example of using the program `samtools stats` to obtain some quality statistics of our read mapping step. 

When processing multiple samples at once, it can become hard to check all of these quality metrics individually for each sample. 
This is the problem that the software _MultiQC_ tries to solve. 
This software automatically scans a directory and looks for files it recognises as containing quality statistics. 
It then compiles all those statistics in a single report, so that we can more easily look across dozens or even hundreds of samples at once. 

Here is the command to run MultiQC and compile several quality statistics into a single report:

```bash
mkdir results/multiqc
multiqc --outdir results/multiqc/  results/
```

_MultiQC_ generates a report, in this example in `results/multiqc/multiqc_report.html`.
From this report we can get an overview of the quality across all our samples. 

![Snapshot of some of the report sections from MultiQC. In this example we can see the "General Statistics" table and the "Sequence Quality Histograms" plot. One of the samples has lower quality towards the end of the read compared to other samples (red line in the bottom panel).](images/multiqc.svg)

For example, from the section "General Statistics" we can see that the number of reads varies a lot between samples. 
Sample ERR5926784 has around 0.1 million reads, which is substantially lower than other samples that have over 1 million reads. 
This may affect the quality of the consensus assembly that we will do afterwards. 

From the section "Sequence Quality Histograms", we can see that one sample in particular - ERR5926784 - has lower quality in the second pair of the read. 
We can open the original FastQC report and confirm that several sequences even drop below a quality score of 20 (1% change of error). 
A drop in sequencing quality towards the end of a read can often happen, especially for longer reads. 
Usually, analysis workflows include a step to remove reads with low quality so these should not affect downstream analysis too badly. 
However, it's always good to make a note of potentially problematic samples, and see if they produce lower quality results downstream.


## Bioinformatic File Formats

Like we said above, bioinformatics uses many standard file formats to store different types of data.
We have just seen two of these file formats: FASTQ for sequencing reads and BAM files to store reads mapped to a genome.

Another very common file format is the FASTA file, which is the format that our reference genome is stored as.
The consensus sequences that we will generate are also stored as FASTA files. 
We detail this format below, but there are many other formats. 
Check out our appendix page on [File Formats](../appendices/file_formats.md) to learn more about them.


### FASTA Files

Another very common file that we should consider is the FASTA format.
FASTA files are used to store nucleotide or amino acid sequences.

The general structure of a FASTA file is illustrated below:

```
>sample01                 <-- NAME OF THE SEQUENCE
AGCGTGTACTGTGCATGTCGATG   <-- SEQUENCE ITSELF
```

Each sequence is represented by a name, which always starts with the character `>`, followed by the actual sequence.

A FASTA file can contain several sequences, for example:

```
>sample01
AGCGTGTACTGTGCATGTCGATG
>sample02
AGCGTGTACTGTGCATGTCGATG
```

Each sequence can sometimes span multiple lines, and separate sequences can always be identified by the `>` character. For example, this contains the same sequences as above:

```
>sample01      <-- FIRST SEQUENCE STARTS HERE
AGCGTGTACTGT
GCATGTCGATG
>sample02      <-- SECOND SEQUENCE STARTS HERE
AGCGTGTACTGT
GCATGTCGATG
```

To count how many sequences there are in a FASTA file, we can use the following command:

```console
grep ">" sequences.fa | wc -l
```

In two steps:

* find the lines containing the character ">", and then
* count the number of lines of the result.

We will see FASTA files several times throughout this course, so it's important to be familiar with them. 


## Exercises

:::{.callout-exercise}
#### Sequence quality control: FASTQC

In the course materials directory `02-ngs/` we have several FASTQ files that we will use to assemble SARS-CoV-2 genomes.
But first, we will run FastQC to check the quality of these files. 

This is the basic command we could use in our samples:

```bash
fastqc --outdir results/fastqc data/reads/*.fastq.gz
```

- Create the output directory for the analysis (`results/fastqc`).
<details><summary>Hint</summary>
The command to create directories is `mkdir`. 
By default, the `mkdir` directory only creates one directory at a time. 
In this case we need to create first the `results` directory and then the `results/fastqc` within it. 
Alternatively, both directories can be created at once using the `-p` option.
</details>
- Modify the `fastqc` command shown above to add an option to run the analysis using 8 threads in parallel (or CPUs). Check the tool's help (`fastqc --help`) to see what the option to do this is called.
- Run the command. You will know it is running successfully because it prints progress of its analysis on the screen.


:::{.callout-answer}

First, we can create a directory to output our results:

```bash
mkdir -p results/fastqc
```

The `-p` option ensures that both directories are created in one step. 
Otherwise, since the parent directory `results` did not exist, `mkdir` would throw an error. 

To check the options available with _FastQC_ we can run `fastqc --help` to get the complete documentation. 
As we scroll through the options, we can see the relevant one for running the analysis in parallel:

```
-t --threads    Specifies the number of files which can be processed
                simultaneously.  Each thread will be allocated 250MB of
                memory so you shouldn't run more threads than your
                available memory will cope with, and not more than
                6 threads on a 32 bit machine
```

Although the documentation is a little technical, this means that if we have multiple CPUs available on our computer, we can set this option to allow multiple files to be processed in parallel. 
Our training machines have 8 CPUs, so we can run the command as follows:

```bash
fastqc -t 8 --outdir results/fastqc data/reads/*.fastq.gz
```

The analysis report generated by FastQC is given as a `.html` file (opens in a web browser). 
We will go through the details of this below. 

:::
:::


## Summary

:::{.callout-tip}
#### Key Points

- Illumina sequencing produces short reads (50bp - 200bp), typically from both ends of a DNA fragment. It is a comparatively cheap sequencing platform which produces very high-quality sequences.
- Nanopore sequencing produces very long reads (typically hundreds of kilobases long). It is comparatively more expensive and has higher error rates. However, it is more flexible with some of its platforms being fully portable. 
- Sequencing reads are stored in a file format called FASTQ. This file contains both the nucleotide sequence and quality of each base. 
- The quality of Illumina sequence reads can be assessed using the software _FastQC_. 
- One common task in bioinformatics is to align or map reads to a reference genome. This involves:
  - Creating a genome index - this only needs to be done once.
  - Mapping the reads to the reference genome (e.g. using `bowtie2`) - the output is in SAM format.
  - Sorting the reads in the mapped file (using `samtools sort`) - the output is in BAM format.
  - Indexing the BAM alignment file (using `samtools index`).
- The software _MultiQC_ can be used to generate a single reports that compiles statistics across several samples. 
- Bioinformatics uses many standard file formats. One of the most common ones is the FASTA format, which is used to store nucleotide or amino acid sequences (no quality information is contained in these files). This is a standard format that assembled genomes are stored as. 
:::

