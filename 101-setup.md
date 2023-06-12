---
pagetitle: "SARS-CoV-2 Genomics"
---

# Setup 

If you are attending one of our workshops, we will provide a virtual training environment with all of the required software and data pre-installed. 
If you want to setup your own computer to run the analysis demonstrated on this course, you can follow the instructions below. 

:::note
The `viralrecon` pipeline that we cover in this workshop can run on a regular desktop (e.g. with 4 CPUs and 16GB RAM). 
However, if you are processing hundreds of samples, it may take several hours or even days. 

For general bioinformatic applications, we recommend investing in a high-performance desktop workstation. 
The exact specifications depend on the application, but as a minimum at least 32 threads and 64GB RAM.
:::


## Install Linux {.tabset}

### Fresh Installation

The recommendation for bioinformatic analysis is to have a dedicated computer running a Linux distribution. 
The kind of distribution you choose is not critical, but we recommend **Ubuntu** if you are unsure. 

You can follow the [installation tutorial on the Ubuntu webpage](https://ubuntu.com/tutorials/install-ubuntu-desktop#1-overview). 

:::warning
Installing Ubuntu on the computer will remove any other operating system you had previously installed, and can lead to data loss. 
:::

### Windows WSL

The **Windows Subsystem for Linux (WSL2)** runs a compiled version of Ubuntu natively on Windows. 

There are detailed instructions on how to install WSL on the [Microsoft documentation page](https://learn.microsoft.com/en-us/windows/wsl/install). 
But briefly:

- Click the Windows key and search for  _Windows PowerShell_, open it and run the command: `wsl --install`.
- Restart your computer. 
- Click the Windows key and search for _Ubuntu_, which should open a new terminal. 
- Follow the instructions to create a username and password (you can use the same username and password that you have on Windows, or a different one - it's your choice). 
- You should now have access to a Ubuntu Linux terminal. 
  This (mostly) behaves like a regular Ubuntu terminal, and you can install apps using the `sudo apt install` command as usual. 

After WSL is installed, it is useful to create shortcuts to your files on Windows. 
Your `C:\` drive is located in `/mnt/c/` (equally, other drives will be available based on their letter). 
For example, your desktop will be located in: `/mnt/c/Users/<WINDOWS USERNAME>/Desktop/`. 
It may be convenient to set shortcuts to commonly-used directories, which you can do using _symbolic links_, for example: 

- **Documents:** `ln -s /mnt/c/Users/<WINDOWS USERNAME>/Documents/ ~/Documents`
  - If you use OneDrive to save your documents, use: `ln -s /mnt/c/Users/<WINDOWS USERNAME>/OneDrive/Documents/ ~/Documents`
- **Desktop:** `ln -s /mnt/c/Users/<WINDOWS USERNAME>/Desktop/ ~/Desktop`
- **Downloads**: `ln -s /mnt/c/Users/<WINDOWS USERNAME>/Downloads/ ~/Downloads`


### Virtual Machine

Another way to run Linux within Windows (or macOS) is to install a Virtual Machine.
However, this is mostly suitable for practicing and **not suitable for real data analysis**.

We give instructions to install a VM using Oracle's Virtual Box on [our tutorial](101-setup_installation_instructions.html).

## {.unlisted .unnumbered}


After making a fresh install of Ubuntu, open a terminal and run the following commands to update your system and install some essential packages: 

```bash
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt install -y git
```

## Software Setup

### _Conda_

We recommend using the _Conda_ package manager to install your software. 
To install _Conda_, run the following commands from the terminal:

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b
rm Miniconda3-latest-Linux-x86_64.sh
export PATH="$HOME/miniconda3/bin/:$PATH"
conda init # adds conda to .bashrc
conda config --add channels defaults; conda config --add channels bioconda; conda config --add channels conda-forge
```

Restart your terminal and confirm that your shell now starts with the word `(base)`.

We also install the `mamba` package, which is a faster implementation of the `conda` command: 

```bash
conda install -y mamba
```


### Singularity

We highly recommend that you install _Singularity_ and use the `-profile singularity` option when running _Nextflow_ (instead of `-profile conda`). 
On Ubuntu, you can install _Singularity_ using the following commands: 

```bash
sudo apt install -y runc cryptsetup-bin
CODENAME=$(lsb_release -cs)
wget -O singularity.deb https://github.com/sylabs/singularity/releases/download/v3.10.2/singularity-ce_3.10.2-${CODENAME}_amd64.deb
sudo dpkg -i singularity.deb
rm singularity.deb
```

If you have a different Linux distribution, you can find more detailed instructions on the [_Singularity_ documentation page](https://docs.sylabs.io/guides/3.0/user-guide/installation.html#install-on-linux). 


### Nextflow

We recommend that you install _Nextflow_ within a conda environment. 
You can do that with the following command:

```bash
mamba create -n nextflow -y nextflow
```

When you want to use _Nextflow_ make sure to activate this software environment by running `conda activate nextflow`. 

You can also run the following command to create a configuration file to setup _Nextflow_:

```bash
echo "
conda {
  useMamba = true
  createTimeout = '1 h'
  cacheDir = \"$HOME/.nextflow-conda-cache/\"
}
singularity {
  enabled = true
  pullTimeout = '1 h'
  cacheDir = \"$HOME/.nextflow-singularity-cache/\"
}
" >> $HOME/.nextflow/config
```

### Bioinformatics Software

Run the following commands to create an environment with the software we used in the workshop: 

```bash
mamba create -n sars -y igv mafft iqtree treetime figtree
```

Whenever you want to use any of these packages, make sure to activate the _Conda_ environment with the command `conda activate sars`.

In addition to these packages, you can also install _AliView_ (which unfortunately is not available through _Conda_):

```bash
# AliView installation
wget https://ormbunkar.se/aliview/downloads/linux/linux-version-1.28/aliview.tgz
tar -xzvf aliview.tgz
rm aliview.tgz
echo "alias aliview='java -jar $HOME/aliview/aliview.jar'" >> $HOME/.bashrc
```
 
To run these tools, open a terminal and use the commands `igv`, `figtree` or `aliview`, which will launch each of the programs. 
