---
pagetitle: "SARS-CoV-2 Genomics"
---

# Setup 

If you are attending one of our workshops, we will provide a virtual training environment with all of the required software and data pre-installed. 
If you want to setup your own computer to run the analysis demonstrated on this course, you can follow the instructions below. 

:::note
The `viralrecon` pipeline that we cover in this workshop can run on a regular desktop (e.g. with 8 threads and 16GB RAM). 
However, if you are processing hundreds of samples, it may take several hours or even days. 

For general bioinformatic applications, we recommend investing in a high-performance desktop workstation. 
The exact specifications depend on the application, but as a minimum at least 32 threads and 64GB RAM.
:::


## Install Linux

You will need a computer running a Linux distribution. 
The kind of distribution you choose is not critical, but we recommend Ubuntu if you are unsure. 

You can follow the [installation tutorial on the Ubuntu webpage](https://ubuntu.com/tutorials/install-ubuntu-desktop#1-overview). 

:::warning
Installing Ubuntu on the computer will remove any other operating system you had previously installed, and can lead to data loss. 
:::


## Software Setup

### Installing _Conda_

1. Open a terminal using the keyboard shortcut <kbd>Alt</kbd> + <kbd>Tab</kbd>.
1. Download the _Miniconda_ installer by running: `wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh`
1. Run the installation script just downloaded: `bash Miniconda3-latest-Linux-x86_64.sh`
1. Follow the installation instructions accepting default options (answering 'yes' to any questions)
1. Run `conda config --add channels defaults; conda config --add channels bioconda; conda config --add channels conda-forge; conda config --set channel_priority strict`.


### Install Software

Run the following block of code: 

```
conda create --name sars
conda install   -c bioconda   -n sars   nextflow
conda install   -c bioconda   -n sars   mafft
conda install   -c bioconda   -n sars   iqtree
conda install   -c bioconda   -n sars   treetime
```

This should install all the necessary software to run the `viralrecon` pipeline, as well as the phylogenetic analysis we demonstrate in these materials. 

When you want to run the analysis, make sure to activate the _Conda_ environment with the command `conda activate sars`. 


## Data

You can download the data used in this course from the following link: [Dropbox - Covid Bioinformatics (zip file) ](https://www.dropbox.com/s/7or0210elos3ril/covidbioinformaticsdata.zip?dl=0). 
Note that the file is 14GB big and will become 21GB after unzipping, so make sure you have enough space on your hard disk. 

Alternatively, you can run the following commands from the terminal (make sure you `cd` into the directory where you want to save the data): 

```
wget -O sarsbioinformatics.zip https://www.dropbox.com/s/7or0210elos3ril/covidbioinformaticsdata.zip?dl=1
unzip -d sars_genomics_workshop sarsbioinformatics.zip
rm sarsbioinformatics.zip
cd sars_genomics_workshop
```

From there, you should be able to follow the course materials to reproduce the analysis. 