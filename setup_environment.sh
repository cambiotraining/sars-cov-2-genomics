#!/bin/bash
set -e

if [ "${EUID:-$(id -u)}" -eq 0 ]; then
  echo "Please do not run this script as root - run it from the participant's user account."
  exit 0
fi

cd $HOME

# Update user's path
echo "
export PATH=$HOME/bin/:\$PATH
" >> $HOME/.bashrc

# system updates and install git
echo "Updating apt packages..."
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt install -y git


#### Conda ####
echo "Installing conda..."

# remove any previous installation
rm -rf miniconda3

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b
rm Miniconda3-latest-Linux-x86_64.sh
export PATH="$HOME/miniconda3/bin/:$PATH"
conda init # adds conda to .bashrc

# setup conda channels
conda config --add channels defaults; conda config --add channels bioconda; conda config --add channels conda-forge


#### Bioinformatic Packages ####
echo "Installing bioinfo packages..."

# mamba for fast installation
conda install -y mamba

# conda packages
# mamba install -y bcftools=1.15.1 mafft=7.505 iqtree=2.2.0.3 treetime=0.9.1 fastqc=0.11.9 multiqc=1.13a bowtie2=2.4.5 tbb=2020.2 igv=2.13.2 figtree=1.4.4 seqkit=2.3.0
mamba install -y datrie
pip install biopython
pip install snakemake==7.16.0
mamba install -y mafft iqtree treetime igv figtree seqkit minimap2 
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



# # CIVET
# git clone https://github.com/artic-network/civet.git
# cd civet
# mamba env create -f environment.yml
# mamba install -y -n civet snakemake-minimal=7.16.0
# source activate civet
# pip install .
# civet --version
# conda deactivate
# cd ../
# rm -rf civet

# AliView
wget https://ormbunkar.se/aliview/downloads/linux/linux-version-1.28/aliview.tgz
tar -xzvf aliview.tgz
rm aliview.tgz
echo "alias aliview='java -jar $HOME/aliview/aliview.jar'" >> $HOME/.bashrc


#### Singularity ####
echo "Installing singularity (requires sudo password)..."

sudo apt install -y runc cryptsetup-bin
CODENAME=$(lsb_release -cs)
wget -O singularity.deb https://github.com/sylabs/singularity/releases/download/v3.10.2/singularity-ce_3.10.2-${CODENAME}_amd64.deb
sudo dpkg -i singularity.deb
rm singularity.deb


#### Nextflow ####
echo "Installating Nextflow..."
# Java
sudo apt install -y curl
curl -s https://get.sdkman.io | bash && source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install java

# Nextflow
wget -qO- https://get.nextflow.io | bash
chmod +x nextflow
mkdir bin && mv nextflow bin/

# setup nextflow
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


#### R + RStudio ####
echo "Installing R and RStudio..."

# Install R: https://cloud.r-project.org/bin/linux/ubuntu
sudo apt install -y --no-install-recommends software-properties-common dirmngr
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
sudo apt install -y r-base r-base-dev libcurl4-openssl-dev libssl-dev libxml2-dev
sudo Rscript -e "install.packages(c('tidyverse', 'janitor'))"

# Download and install RStudio
sudo apt install -y libclang-dev libpq5 libssl-dev # dependencies

if [ $CODENAME = "jammy" ]
then
  wget -O rstudio.deb https://download1.rstudio.org/desktop/jammy/amd64/rstudio-2022.07.2-576-amd64.deb
else
  wget -O rstudio.deb https://download1.rstudio.org/desktop/bionic/amd64/rstudio-2022.07.2-576-amd64.deb
fi
sudo dpkg -i rstudio.deb
rm rstudio.deb

echo "Successfully installed all dependencies"
