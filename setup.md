# Data & Software {.unnumbered}

:::{.callout-tip level=2}
#### Workshop Attendees

If you are attending one of our workshops, we will provide a training environment with all of the required software and data. You do not need to download or install anything ahead of the workshop.  
If you want to setup your own computer to run the analysis demonstrated on this course, you can follow the instructions below.
:::

## Software

The software installation for this course is quite complex and detailed in a [separate section](TODO).

## Data

Different datasets are used throughout these materials. 
This page provides links to download each dataset, with a brief description for each of them. 
We have split the data between sequencing platforms. 

## Illumina 

### UK Sequences

These samples were downloaded from SRA and include samples collected in the UK. 
These data are used in the following sections of the materials: [Consensus Assembly](materials/02-isolates/01-consensus.md), [Lineages and Variants](materials/02-isolates/02-lineages.md) and [Building Phylogenies](materials/02-isolates/03-phylogeny.md).

- [<i class="fa-solid fa-download"></i> Download (zip file)]()

<details><summary>Click here to see details of how the data was downloaded from public repositories</summary>

We obtained these data from the SRA repository, using the `fastq-dump` command as follows:

```bash
fastq-dump --split-3 --gzip ERR5728910 ERR5728911 ERR5728913 ERR5742126 ERR5742297 ERR5742457 ERR5742549 ERR5742553 ERR5761182 ERR5761193 ERR5765358 ERR5770082 ERR5855061 ERR5855065 ERR5855555 ERR5914874 ERR5921129 ERR5921248 ERR5921268 ERR5921355 ERR5921612 ERR5925864 ERR5926784 ERR5932087 ERR5932097 ERR5932290 ERR5932412 ERR5932418 ERR5932680 ERR5932985 ERR5933082 ERR5933090 ERR6106244 ERR6083647 ERR6085882 ERR6086247 ERR6104816 ERR6105221 ERR6105244 ERR6105337 ERR6105341 ERR6106514 ERR6106801 ERR6107074 ERR6128896 ERR6128978 ERR6129122 ERR6129126
```
</details>
</br>


### South Africa

These samples were downloaded from SRA and include samples collected between Nov and Dec 2021 in South Africa. 
These data are used in the worked example [South Africa (Illumina)](materials/03-case_studies/02-southafrica.md).

We provide two versions of the data: the full data includes 24 samples (more realistic sample size), whereas the small version includes only 8 samples (quicker processing time for practising).

- [<i class="fa-solid fa-download"></i> Full data - 24 samples (zip file)](https://www.dropbox.com/sh/6jnpv7ui2xm8f9h/AAC0MRuPfSsNmBlCNvI-wiKna?dl=1)
- [<i class="fa-solid fa-download"></i> Small data - 8 samples (zip file)](https://www.dropbox.com/sh/2u0svuq7rre8261/AACisGtF21x3Ou7Xrj_W4DaRa?dl=1)

<details><summary>Click here to see details of how the data was downloaded from public repositories</summary>

We obtained these data from the SRA repository, using the `fastq-dump` command as follows:

```bash
fastq-dump --split-3 --gzip SRR17051908 SRR17051923 SRR17051916 SRR17051953 SRR17051951 SRR17051935 SRR17051932 SRR17054503 SRR17088930 SRR17088928 SRR17088924 SRR17088917 SRR17461712 SRR17461700 SRR17712997 SRR17712994 SRR17712779 SRR17701841 SRR17712711 SRR17701832 SRR17701890 SRR17712607 SRR17712594 SRR17712442 SRR17712435 SRR17712343 SRR17712341 SRR17712321 SRR17712313 SRR17712312 SRR17712387 SRR17970983 SRR17973983 SRR17973948 SRR17973937 SRR17973974 SRR17974004 SRR17974001 SRR17974000 SRR17973999 SRR17973998 SRR17973997 SRR17973996 SRR17973995 SRR17973992 SRR17973991 SRR17973989 SRR17973988
```
</details>
</br>

### EQA panels

The standard panels for _External Quality Assessment_ provided by NEQAS were sequenced on an Illumina platform by UKHSA and used to generate four sets of data for training purposes. 
These data can be used for the extended exercise: [EQA (Exercise)](materials/03-case_studies/03-eqa.md).

We provide a link to each of the four datasets below (the datasets are very similar to each other):

- [<i class="fa-solid fa-download"></i> Dataset 1 (zip file)](https://www.dropbox.com/sh/rd06rcx0b1fa72w/AABbTg0oZMWbXgPAC82h9KDUa?dl=1)
- [<i class="fa-solid fa-download"></i> Dataset 2 (zip file)](https://www.dropbox.com/sh/sy5r7y5798a5wz6/AADd82iQAvwQOvBCIoAHJSARa?dl=1)
- [<i class="fa-solid fa-download"></i> Dataset 3 (zip file)](https://www.dropbox.com/sh/qpdvv04ipulajd9/AADc981PvWIfGEj0qeLCI7O3a?dl=1)
- [<i class="fa-solid fa-download"></i> Dataset 4 (zip file)](https://www.dropbox.com/sh/zeyd7qyj3fw74s5/AAAvcI0LCIHvtgX-sNy3PORZa?dl=1)


## Nanopore

### India

These samples were downloaded from SRA and include samples collected in India and sequenced by the [National Institute of Mental Health and Neurosciences](https://nimhans.ac.in/). 
These data are used for the exercises in the following sections of the materials: [Consensus Assembly](materials/02-isolates/01-consensus.md), [Lineages and Variants](materials/02-isolates/02-lineages.md) and [Building Phylogenies](materials/02-isolates/03-phylogeny.md).

- [<i class="fa-solid fa-download"></i> Download (zip file)]()
  - Platform: MinION
  - Nanopore chemistry: not specified (we assumed 9.4.1)
  - Primer set: not specified (we assumed ARTIC primers v3)
  - Guppy version: not specified (we assumed 3.6 or higher)
  - Basecalling mode: not specified (we assumed "high")

Note that several details needed to run the `medaka` pipeline were not provided in the public repository. 
We arbitrarily picked parameters as detailed above, but this is for demonstration purposes only. 

<details><summary>Click here to see details of how the data was downloaded from public repositories</summary>

We obtained these data from the SRA repository, using the `fastq-dump` command as follows:

```bash
fastq-dump --split-3 --gzip SRR14494107 SRR14493634 SRR14493632 SRR14493631 SRR14493707 SRR14493705 SRR14493730 SRR14493729 SRR14493728 SRR14493727 SRR14493726 SRR14493725 SRR14493724 SRR14493723 SRR14493722 SRR14493721 SRR14493719 SRR14493718 SRR14493717 SRR14493716 SRR14493715 SRR14493714 SRR14493713 SRR14493712 SRR14493711 SRR14494106 SRR14494095 SRR14494092 SRR14494091 SRR14494090 SRR14494089 SRR14494088 SRR14494087 SRR14494086 SRR14494105 SRR14494104 SRR14494103 SRR14494102 SRR14494101 SRR14494100 SRR14493626 SRR14494099 SRR14494098 SRR14494097 SRR14494096 SRR14494094 SRR14494093
```
</details>
</br>

### Switzerland

These samples were downloaded from SRA and include samples collected between Nov 2021 and Jan 2022 in Switzerland and sequenced by the Institute for Infectious Diseases, University of Bern. 
These data are used in the worked example [Switzerland (Nanopore)](materials/03-case_studies/01-switzerland.md).

We provide two versions of the data: the full data includes 65 samples (more realistic sample size), whereas the small version includes only 10 samples (quicker processing time for practising).

- [<i class="fa-solid fa-download"></i> Full data - 65 samples (zip file)](https://www.dropbox.com/sh/heqhpg64azfvmlp/AACH-IHDioCfYU4RShCd2QRBa?dl=1)
- [<i class="fa-solid fa-download"></i> Small data - 10 samples (zip file)](https://www.dropbox.com/sh/2k5c8g4zdqy3quu/AABr6EiWYXVGIDyvtn-10k9ra?dl=1)
  - Platform: GridION
  - Nanopore chemistry: not specified (we assumed 9.4.1)
  - Primer set: ARTIC primers v3
  - Guppy version: not specified (we assumed 3.6 or higher)
  - Basecalling mode: not specified (we assumed "fast")

Note that several details needed to run the `medaka` pipeline were not provided in the public repository. 
We arbitrarily picked parameters as detailed above, but this is for demonstration purposes only. 

<details><summary>Click here to see details of how the data was downloaded from public repositories</summary>

We obtained these data from the SRA repository, using the `fastq-dump` command as follows:

```bash
fastq-dump --split-3 --gzip ERR8971298 ERR8961150 ERR8961147 ERR8961133 ERR8961130 ERR8961129 ERR8961128 ERR8961124 ERR8961123 ERR8961116 ERR8961115 ERR8961114 ERR8961112 ERR8961110 ERR8961065 ERR8961062 ERR8961333 ERR8959962 ERR8959961 ERR8959960 ERR8959959 ERR8959958 ERR8959957 ERR8959956 ERR8959955 ERR8959953 ERR8959952 ERR8959950 ERR8959949 ERR8959948 ERR8959946 ERR8959945 ERR8959943 ERR8959942 ERR8959940 ERR8959939 ERR8959938 ERR8959937 ERR8959936 ERR8959934 ERR8959933 ERR8959931 ERR8959927 ERR8959926 ERR8959925 ERR8959912 ERR8959911 ERR8959905 ERR8959901 ERR8959892 ERR8960229 ERR8960215 ERR8960216 ERR8960217 ERR8960218 ERR8960219 ERR8960220 ERR8960221 ERR8960223 ERR8959343 ERR8959341 ERR8959330 ERR8959327
```
</details>
</br>


### EQA panels

The standard panels for _External Quality Assessment_ provided by NEQAS were sequenced on an ONT platform by TODO. 
These data can be used for the extended exercise: [EQA (Exercise)](materials/03-case_studies/03-eqa.md).

We provide a link to datasets corresponding to two different runs:

- [<i class="fa-solid fa-download"></i> Dataset 1 (zip file)](https://www.dropbox.com/sh/yjfpkynpxb0o3yk/AAA8rou-NANPqbNo_6cYbrOxa?dl=1) 
  - Platform: PromethION
  - Nanopore chemistry: 9.4.1
  - Primer set: midnight
  - Guppy version: 6.6
  - Basecalling mode: "fast"
- [<i class="fa-solid fa-download"></i> Dataset 2 (zip file)](https://www.dropbox.com/sh/024zw4u710tiit4/AACpqnjYsVODHdc_ZNCvOe_Na?dl=1)
  - Platform: GridION
  - Nanopore chemistry: 9.4.1
  - Primer set: 4.1
  - Guppy version: 6.6
  - Basecalling mode: "high"

We thank the collaborating institutions for sharing their trainining data with us. 
