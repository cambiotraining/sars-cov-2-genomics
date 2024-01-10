# Installation Instructions for IT Staff

Please follow these instructions to setup the participant's computers for our workshop. 


## Hardware

Minimum requirements: 

| | |
| :- | :- |
| Processor | Intel Core i7 (9th generation or later) with a minimum of 4 cores |
| Memory | 16GB RAM minimum (ideally higher) |
| Graphics Card | Not essential |
| Hard Drive | 512GB SSD |
| Operating System | Ubuntu Linux 20.04 LTS or 22.04 LTS |


## Software & Setup

Please create an account for the participants with `sudo` permissions. 
Then, follow these instructions, which will install all the necessary dependencies: 

- Login to the machine using the participant account.
- Open a terminal. 
- Run the following command to install all the software dependencies (please type your password when asked for it): `wget -q -O - https://raw.githubusercontent.com/cambiotraining/sars-cov-2-genomics/main/setup_environment.sh | bash`
- Check the following software versions are correct:
  - `pangolin --all-versions` should indicate `pangolin: 4.1.3` (or later)
  - `civet --version` should indicate `civet 3.0.1` (or later)
- Download the data for the practical:
    ```bash
    cd $HOME
    wget -O eqa_practical.zip https://www.dropbox.com/sh/v7vbvf28gn1vd34/AAAQ1PYf1uYSNcubrRZqF8P-a?dl=1
    mkdir Documents/eqa_practical
    unzip -d Documents/eqa_practical/ eqa_practical.zip
    ```
- Test the installation by running: 
    ```bash
    cd $HOME
    source $HOME/.bashrc
    wget -O test_data.tar.gz https://www.dropbox.com/sh/8ju1xe0tosyyc0n/AADoWQawL33K2BJsFifRkxN8a/test_data.tar.gz?dl=1
    tar -xzvf test_data.tar.gz
    cd test_data
    bash test_pipeline.sh
    ```

The last command will run our analysis and produce a file called `test_pipeline.log`. 
Please send this file to us, so that we can check that the pipeline ran successfully. 
