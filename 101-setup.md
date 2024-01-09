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

- Click the Windows key and search for  _Windows PowerShell_, right-click on the app and choose **Run as administrator** 
- Answer "Yes" when it asks if you want the App to make changes on your computer.
- A terminal will open; run the command: `wsl --install`.
  - This should start installing "ubuntu"
  - It may ask for you to restart your computer. 
- After restart, click the Windows key and search for _Ubuntu_, click on the App ant it should open a new terminal. 
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

Also see the section below "Docker for Windows" for further setup.


### Virtual Machine

Another way to run Linux within Windows (or macOS) is to install a Virtual Machine.
However, this is mostly suitable for practicing and **not suitable for real data analysis**.

We give instructions to install a VM using Oracle's Virtual Box on [our tutorial](101-setup_installation_instructions.html).

## {.unlisted .unnumbered}


After making a fresh install of Ubuntu, open a terminal and run the following commands to update your system and install some essential packages: 

```bash
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt install -y git
sudo apt install -y default-jre
```


## _Conda_ 

We recommend using the _Conda_ package manager to install your software. 
In particular, the newest implementation called _Mamba_. 

To install _Mamba_, run the following commands from the terminal: 

```bash
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b -p $HOME/miniforge3
rm Miniforge3-$(uname)-$(uname -m).sh
$HOME/miniforge3/bin/mamba init
```

Restart your terminal (or open a new one) and confirm that your shell now starts with the word `(base)`.
Then run the following commands: 

Restart your terminal (or open a new one) and confirm that your shell now starts with the word `(base)`.
Then run the following commands: 

```bash
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set remote_read_timeout_secs 1000
```


## Nextflow

We recommend that you install _Nextflow_ within a conda environment.
You can do that with the following command:

```bash
mamba create -n nextflow -y nextflow
```

When you want to use _Nextflow_ make sure to activate this software environment by running `mamba activate nextflow`. 

Also run the following command to create a configuration file to setup _Nextflow_ correctly (make sure to copy all the code from top to bottom):

```bash
mkdir -p $HOME/.nextflow
echo "
conda {
  conda.enabled = true
  singularity.enabled = false
  docker.enabled = false
  useMamba = true
  createTimeout = '4 h'
  cacheDir = '$HOME/.nextflow-conda-cache/'
}
singularity {
  singularity.enabled = true
  conda.enabled = false
  docker.enabled = false
  pullTimeout = '4 h'
  cacheDir = '$HOME/.nextflow-singularity-cache/'
}
docker {
  docker.enabled = true
  singularity.enabled = false
  conda.enabled = false
}
" >> $HOME/.nextflow/config
```


## Bioinformatics Software

Run the following commands to create an environment with the software we used in the workshop: 

```bash
mamba create -n sars -y igv mafft iqtree treetime igv figtree seqkit
```

Whenever you want to use any of these packages, make sure to activate the _Conda_ environment with the command `mamba activate sars`.

In addition to these packages, you can also install _AliView_ (which unfortunately is not available through _Conda_):

```bash
# AliView installation
wget https://ormbunkar.se/aliview/downloads/linux/linux-version-1.28/aliview.tgz
tar -xzvf aliview.tgz
rm aliview.tgz
echo "alias aliview='java -jar $HOME/aliview/aliview.jar'" >> $HOME/.bashrc
```

To run these graphical tools, open a terminal and use the commands `igv`, `figtree` or `aliview`, which will launch each of the programs. 


### Pangolin/Nextclade/Civet

These SARS-specific tools are more challenging to install. 
In theory they should all be available via `mamba`, but in practice they have some dependency issues when using this package manager.
The following commands should work, if you followed our previous instructions: 

```bash
mamba activate sars
mamba install -y datrie minimap2
pip install biopython
pip install snakemake==7.16.0
mamba install -y cov-ert::jclusterfunk 
mamba install -y gofasta=0.0.5 ucsc-fatovcf 
mamba install -y usher
mamba install -y git-lfs
mamba install -y nextclade

pip install git+https://github.com/cov-lineages/scorpio.git
pip install git+https://github.com/cov-lineages/constellations.git
pip install git+https://github.com/cov-lineages/pangolin-data.git
pip install git+https://github.com/artic-network/civet.git
pip install git+https://github.com/cov-lineages/pangolin.git
```

After this, you should be able to use the stand-alone versions of `pangolin`, `nextclade` and `civet`.


## Software Image Containers

### Singularity

We recommend that you install _Singularity_ and use the `-profile singularity` option when running _Nextflow_ pipelines. 
On Ubuntu/WSL2, you can install _Singularity_ using the following commands: 

```bash
sudo apt install -y runc cryptsetup-bin uidmap
wget -O singularity.deb https://github.com/sylabs/singularity/releases/download/v4.0.2/singularity-ce_4.0.2-$(lsb_release -cs)_amd64.deb
sudo dpkg -i singularity.deb
rm singularity.deb
```

If you have a different Linux distribution, you can find more detailed instructions on the [_Singularity_ documentation page](https://docs.sylabs.io/guides/3.0/user-guide/installation.html#install-on-linux). 

If you have issues running _Nextflow_ pipelines with _Singularity_, then you can follow the instructions below for _Docker_ instead. 


### Docker {.tabset} 

#### Windows WSL

When using WSL2 on Windows, running _Nextflow_ pipelines with `-profile singularity` sometimes doesn't work. 

As an alternative you can instead use _Docker_, which is another software containerisation solution. 
To set this up, you can follow the full instructions given on the Microsoft Documentation: [Get started with Docker remote containers on WSL 2](https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-containers#install-docker-desktop).

We briefly summarise the instructions here (but check that page for details and images): 

- Download [_Docker_ for Windows](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe).
- Run the installer and install accepting default options. 
- Restart the computer.
- Open Docker and go to **Settings > General** to tick "Use the WSL 2 based engine".
- Go to **Settings > Resources > WSL Integration** to enable your Ubuntu WSL installation.

Once you have _Docker_ set and installed, you can use `-profile docker` when running your _Nextflow_ command.

#### Linux

For Linux, here are the installation instructions: 

```bash
sudo apt install curl
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
sudo groupadd docker
sudo usermod -aG docker $USER
```

After the last step, you will need to **restart your computer**. 
From now on, you can use `-profile docker` when you run _Nextflow_

## {.unlisted .unnumbered}