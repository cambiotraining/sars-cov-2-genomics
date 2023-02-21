---
pagetitle: "SARS-CoV-2 Genomics"
---

# Setup 

**Note:** This page is under revision.

If you are attending one of our workshops, we will provide a virtual training environment with all of the required software and data pre-installed. 
If you want to setup your own computer to run the analysis demonstrated on this course, you can follow the instructions below. 

:::note
The `viralrecon` pipeline that we cover in this workshop can run on a regular desktop (e.g. with 4 CPUs and 16GB RAM). 
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

Run the following commands from the terminal:

```bash
wget -q -O - https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b
rm Miniconda3-latest-Linux-x86_64.sh
conda init
conda config --add channels defaults; conda config --add channels bioconda; conda config --add channels conda-forge; conda config --set channel_priority strict
conda install -y mamba
```

Restart your terminal and confirm that your shell now starts with the word `(base)`.


### Install Bioinformatics Software

Run the following commands to create an environment with the software we used in the workshop: 

```bash
mamba create -n sars -y nextflow mafft iqtree treetime
```

This should install all the necessary software to run the `viralrecon` pipeline, as well as the phylogenetic analysis we demonstrate in these materials. 

When you want to run the analysis, make sure to activate the _Conda_ environment with the command `conda activate sars`. 

You may also want to install _IGV_, _FigTree_ and _AliView_:

```bash
# IGV and FigTree are available from Conda
mamba install -n base igv figtree

# AliView installation
wget https://ormbunkar.se/aliview/downloads/linux/linux-version-1.28/aliview.tgz
tar -xzvf aliview.tgz
rm aliview.tgz
echo "alias aliview='java -jar $HOME/aliview/aliview.jar'" >> $HOME/.bashrc
```

To run these tools, open a terminal and use the commands `igv`, `figtree` or `aliview`, which will launch each of the programs. 


### Install Singularity

We highly recommend that you install _Singularity_ and use the `-profile singularity` option when running _Nextflow_ (instead of `-profile conda`). 
On Ubuntu, you can install _Singularity_ using the following commands: 

```bash
sudo apt update && sudo apt upgrade && sudo apt install runc
CODENAME=$(lsb_release -c | sed 's/Codename:\t//')
wget -O singularity.deb https://github.com/sylabs/singularity/releases/download/v3.10.2/singularity-ce_3.10.2-${CODENAME}_amd64.deb
sudo dpkg -i singularity.deb
rm singularity.deb
```

If you have a different Linux distribution, you can find more detailed instructions on the [_Singularity_ documentation page](https://docs.sylabs.io/guides/3.0/user-guide/installation.html#install-on-linux). 


## Data

You can download the data used in this course from the following link: [Dropbox - Covid Bioinformatics (zip file) ](https://www.dropbox.com/s/7or0210elos3ril/covidbioinformaticsdata.zip?dl=0). 
Note that the file is 14GB big and will become 21GB after unzipping, so make sure you have enough space on your hard disk. 

Alternatively, you can run the following commands from the terminal (make sure you `cd` into the directory where you want to save the data): 

```bash
wget -O sarsbioinformatics.zip https://www.dropbox.com/s/7or0210elos3ril/covidbioinformaticsdata.zip?dl=1
unzip -d sars_genomics_workshop sarsbioinformatics.zip
rm sarsbioinformatics.zip
cd sars_genomics_workshop
```

From there, you should be able to follow the course materials to reproduce the analysis. 
