---
pagetitle: "SARS-CoV-2 Genomics"
---

# Managing Bioinformatics Software

::: highlight

## Questions

- How can I install and manage bioinformatics software?
- How can I download and configure _Nextflow_ pipelines?

## Learning Objectives

- Use the Conda package manager to manage and install software.
  - `conda create`, `conda env create -f env.yml`, `conda install`, `conda activate`
- Pull a _Nextflow_ pipeline from a public repository and edit configuration files for your needs.

:::

<!--
## The `conda` Package Manager

Often you may want to use software packages that are not be installed by default on the servers available to you.
There are several ways you could manage your own software installation, but in this course we will be using _Conda_, which gives you access to a large number of scientific packages.

There are two main software distributions that you can download and install, called _Anaconda_ and _Miniconda_.  
_Miniconda_ is a lighter version, which includes only base Python, while _Anaconda_ is a much larger bundle of software that includes many other packages (see the [Documentation Page](https://docs.conda.io/projects/conda/en/latest/user-guide/install/download.html#anaconda-or-miniconda) for more information).

One of the strengths of using _Conda_ to manage your software is that you can have different versions of your software installed alongside each other, organised in **environments**. 
Organising software packages into environments is extremely useful, as it allows to have a _reproducible_ set of software versions that you can use and resuse in your projects. 

![Illustration of _Conda_ environments.](images/conda_environments.svg)


### Installing _Conda_

To start with, let's install _Conda_. 
In this course we will install the _Miniconda_ bundle, as it's lighter and faster to install:

1. Make sure you've ssh'd to the training computer and are in the home directory (`cd ~`).
1. download the _Miniconda_ installer by running: `wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh`
1. run the installation script just downloaded: `bash Miniconda3-latest-Linux-x86_64.sh`
1. follow the installation instructions accepting default options (answering 'yes' to any questions)
1. run `conda config --add channels conda-forge; conda config --add channels bioconda`.
This adds two *channels* (sources of software) useful for bioinformatics and data science applications.

:::note
_Anaconda_ and _Miniconda_ are also available for Windows and Mac OS. 
See the [Conda Installation Documents](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html#regular-installation) for instructions. 

However, many of the packages used in bioinformatics are specific for Linux, so will not work on those other operating systems. 
However, _Conda_ may still be useful to manage software that works across platforms (e.g. Python packages).
:::


### Installing Software Using `conda`

The command used to install and manage software is called `conda`. 
Although we will only cover the basics in this course, it has an [excellent documentation](https://docs.conda.io/projects/conda/en/latest/user-guide/) and a useful [cheatsheet](https://docs.conda.io/projects/conda/en/latest/_downloads/1f5ecf5a87b1c1a8aaf5a7ab8a7a0ff7/conda-cheatsheet.pdf).

The first thing to do is to create a software environment for our project. 
Although this is optional (you could instead install everything in the "base" default environment), it is a good practice as it means the software versions remain stable within each project. 

To create an environment we use:

```console
$ conda create --name ENV
```

Where "ENV" is the name we want to give to that environment. 
Once the environment is created, we can install packages using:

```console
$ conda install --name ENV PROGRAM
```

Where "PROGRAM" is the name of the software we want to install. 

:::note
One way to organise your software environments is to create an environment for each kind of analysis that you might be doing regularly. 
For example, you could have an environment named `imaging` with software that you use for image processing (e.g. Python's scikit-image or the ImageMagick package) and another called `deeplearn` with software you use for deep learning applications (e.g. Python's Keras). 

In bioinformatics you may create an environment for analysis of specific kinds of data, for example `rnaseq` or `metagenomics`. 
We will see an example of this in the context of SARS-CoV-2 sequence analysis in a later section.
:::

To search for the software packages that are available through `conda`:

- go to [anaconda.org](https://anaconda.org).
- in the search box search for a program of your choice. For example: "bwa".
- the results should be listed as `CHANNEL/PROGRAM`, where *CHANNEL* will the the source channel from where the software is available. Usually scientific/bioinformatics software is available through the `conda-forge` and `bioconda` channels.

If you need to install a program from a different channel than the defaults, you can specify it during the install command using the `-c` option. 
For example `conda install --chanel CHANNEL --name ENV PROGRAM`.

Let's see this with an example, where we create a new environment called "scipy", where we install the python scientific packages:

```console
$ conda install --name scipy --channel conda-forge numpy matplotlib
```


### Loading _Conda_ Environments

Once your packages are installed in an environment, you can load that environment by using `source activate ENV`, where "ENV" is the name of your environment. 
For example, we can activate our previously created environment with:

```console
$ source activate scipy
```

If you chech which `python` executable is being used now, you will notice it's the one from this new environment:

```console
$ which python
```

```
~/miniconda3/envs/scipy/bin/python
```

:::note
**Tip**

If you forget which environments you have created, you can use `conda env list` to get a list of them. 
:::


:::exercise

**Q1**

- Create a new _Conda_ environment called `qc` and install the software FastQC and MultiQC, which we will use to check the sequencing quality of our Illumina reads.
- Once installation completes, activate the environment and check that both packages were installed successfully by running `fastqc --version` and `multiqc --version`. 

<details><summary>Hint</summary>

- Go to [anaconda.org](https://anaconda.org/) to search for these software packages and see which channels they are available from.
- The command to create a new environment is `conda create --name ENV` (replace "ENV" by a name of your choice for the new environment).
- The command to install packages into an environment is `conda install --name ENV PROGRAM` (replace "PROGRAM" with the name of the software package you wish to install).

**THIS TAKES QUITE A WHILE TO RUN! MAYBE NEED TO INTRODUCE MAMBA AS WELL**

</details>

**Q2**

- Create a new shell script named `read_quality_control.sh` on your `scripts` folder. Copy/paste the following code into the script (fix the code where "FIXME" appears). 

```bash
#!/bin/bash

# activate conda environment
source activate qc

# create output directories
mkdir -p results/fastqc
mkdir -p results/multiqc

# run FastQC on all the reads
fastqc --threads 8 --outdir FIXME data/illumina/*.fastq.gz

# compile statistics using multiqc
multiqc --outdir FIXME results/fastqc
```

- Run the new shell script using `bash`. Redirect the output to a file named `logs/read_quality_control.log`.

<details><summary>Hint</summary>

- To redirect output from a script use `bash name_of_script > standard_output.log 2>&1`

<details>

<details><summary>Answer</summary>

Create the environment with:

```
$ conda create --name qc
```

We can then install the necessary software on this environment: 

```
$ conda install --name qc fastqc multiqc
```

After _Conda_ determines the software dependencies it needs to download and install, it will list them all and ask to confirm the installation. 
You can type "y" and press Enter to confirm. 
The installation process may take some time. 

Finally, we can activate our new environment: 

```
$ source activate qc
```

We can quickly check that the software was installed successfully by trying the following commands:

```
$ fastqc --version
$ multiqc --version
```

Each of these commands should result in the version of the software being printed on the console. 



</details>

:::

:::note
**Quality Control for ONT Data**

FastQC is designed for Illumina data. 
For ONT data, you can use [MinIONQC](https://github.com/roblanf/minion_qc), which is essentially an R script that you can run to generate a series of plots such as read length and quality distributions. 

:::


## Nextflow

- installation
- `nextflow pull`
- config files
- `nextflow run`, `nextflow --help`

Install nextflow, using conda:

`conda create --name nextflow -c bioconda nextflow`

General information about nextflow commands can be obtained by running it with no other options: 

```console
$ nextflow
```

```
Commands:
  clean         Clean up project cache and work directories
  clone         Clone a project into a folder
  cloud         Manage Nextflow clusters in the cloud
  config        Print a project configuration
  console       Launch Nextflow interactive console
  drop          Delete the local copy of a project
  help          Print the usage help for a command
  info          Print project and system runtime information
  kuberun       Execute a workflow in a Kubernetes cluster (experimental)
  list          List all downloaded projects
  log           Print executions log and runtime info
  pull          Download or update a project
  run           Execute a pipeline project
  self-update   Update nextflow runtime to the latest available version
  view          View project script file(s)
```

:::note
**This was a note to self - can probably be removed from here**
Making a local copy of the nextflow repository can be done in a few ways:

- `nextflow pull` - downloads the repo and puts it in a global cache (see https://www.nextflow.io/docs/latest/cli.html#pull)
- `nextflow clone` - downloads the repo to the local directory. This is equivalent to running `git clone`. 

- Need to check how commits are managed (to ensure consistent versions of the pipeline are used)
- If the pipeline fails due to an error, can be resumed by adding the flag `nextflow run -resume`

:::

To download the pipeline, we run: 

```console
$ nextflow pull connor-lab/ncov2019-artic-nf
```

This will automatically download the workflow from the [project's GitHub page](https://github.com/connor-lab/ncov2019-artic-nf) into our home directory (under `~/.nextflow/assets/`). 

The following step is to set configuration options necessary for our setup. 
This can be done on a project-by-project basis, or we can set options that are always used on the machine we are working from.

- Edit a file named `nextflow.config` on the project's directory.
- Edit the file in `~/.nextflow/config`.

I have edited a file in the project's directory with the following: 

```
process {
  executor = 'local'
}
params {
  max_memory = 32.GB
  max_cpus = 8
  max_time = 12.h
}
conda {
  useMamba = true
  createTimeout = '1 h'
}
```

And this has successfully ran the pipeline with mamba. 


## SLURM

SLURM configuration can be specified depending on your setup. 
For example, I have: 

```
process {
  executor = 'slurm'
  clusterOptions = '-A LEYSER-SL2-CPU -p icelake,cclake -t 05:00:00' 
}
params {
  max_memory = 192.GB
  max_cpus = 56
  max_time = 12.h
}
```


## Help 

`nextflow run ncov2019-artic-nf/ --help`


## Conda, Docker, Singularity

With `-profile conda`, I've ran into the problem mentioned here: 
 - https://github.com/nf-core/rnaseq/issues/517 
 - https://github.com/nextflow-io/nextflow/issues/1081 

It seems to be a timeout issue. 
One possibility is to use `mamba`, which can be achieved by adding the following to one of the config files:

```
conda {
    useMamba = true
    createTimeout = '1 h'
}
```

This is detailed here: https://www.nextflow.io/docs/edge/config.html#scope-conda

Also, it may be worth thinking about setting the `NXF_CONDA_CACHEDIR` variable as suggested in the first link above, in case users are sharing environments. 

I have also ran into another error:

```
  Failed to create Conda environment
  command: conda env create --prefix /rds/user/hm533/hpc-work/btf/nvap_artic_pipeline/work/conda/artic-e06b476df23ea11f5d0c7435111cb143 --file /rds/user/hm533/hpc-work/btf/nvap_artic_pipeline/ncov2019-artic-nf/environments/nanopore/environment.yml
  status : 143
  message:
```

This one I could not seem to fix... 


Finally, I get this error with the first step of the pipeline (articDownloadScheme), coming from a `git clone` command:

```
Cloning into 'primer-schemes'...
  /usr/local/software/archive/linux-scientific7-x86_64/gcc-9/git-2.26.0-jtc5jb2p7skqq7zohvhh6cs6tgoy5lyj/libexec/git-core/git-remote-https: symbol lookup error: /lib64/libk5crypto.so.3: undefined symbol: EVP_KDF
_ctrl, version OPENSSL_1_1_1b
```

This seems to be a system-specific error (only occurs on compute nodes of the HPC, not login nodes), which hopefully disappears on the training machine.
My workaround is to cd to the working directory and run `bash .command.run`. 
Then re-launch the workflow with `-resume`.



## Running at Scale

Need to check:

- is it possible to use `nextflow pull` to a path common to multiple users on a HPC? 
- is it possible to still have specific config files even when using `nextflow pull` from the general cache? 
  - Should be: https://www.nextflow.io/docs/latest/config.html 


## Troubleshooting 

Nextflow works by creating temporary files in a directory called `work`. 
When an error occurs, Nextflow informs us of what the working directory was and several (hidden) files can be found there. 
The most informative are:

- `.command.run` - this is the bash script that is essentially submitted to slurm.
- `.command.sh` - this is the bash script that is usually called by the previous script. 
- `.command.log` - log file where errors might be found. 


## Summary

:::highlight

**Key Points**

- one
- two

:::
-->
