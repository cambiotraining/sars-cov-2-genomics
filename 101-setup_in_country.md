# Installation Instructions for IT Staff

Please follow these instructions to setup the participant's computers for our workshop. 


## Hardware

Minimum requirements: 

| | |
| :- | :- |
| Processor | Intel Core i7 (9th generation or later) with a minimum of 4 cores |
| Memory | 16GB RAM |
| Graphics Card | Not essential |
| Hard Drive | 512GB SSD |
| Operating System | Ubuntu Linux 20.04 LTS |


## Software & Setup

Please create an account for the participants with `sudo` permissions. 
Then, follow these instructions, which will install all the necessary dependencies: 

- Login to the machine using the participant account.
- Open a terminal. 
- Run the following command to install all the software dependencies (please type your password when asked for it): `wget -q -O - https://raw.githubusercontent.com/cambiotraining/sars-cov-2-genomics/main/setup_environment.sh | bash`
- Finally, test the installation by running: 
    ```bash
    source $HOME/.bashrc
    wget -O test_data.tar.gz https://www.dropbox.com/sh/8ju1xe0tosyyc0n/AADoWQawL33K2BJsFifRkxN8a/test_data.tar.gz?dl=1
    tar -xzvf test_data.tar.gz
    cd test_data
    bash test_pipeline.sh
    ```

The last command will run our analysis and produce a file called `test_pipeline.log`. 
Please send this file to us, so that we can check that the pipeline ran successfully. 
