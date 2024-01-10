# Introduction to SARS-CoV-2 Sequencing Data Analysis

:construction: **These materials are under active development and not ready to be used for teaching.** :construction:

## Build Website Locally
### Requirements
* R - [https://www.r-project.org/](https://www.r-project.org/)
* pandoc - [https://pandoc.org/installing.html](https://pandoc.org/installing.html)

### Step 1
First you need to install `rmarkdown` package. To install run:
```bash
Rscript -e 'install.packages("rmarkdown")'
```
> Note: On Windows make sure that R is added to Windows PATH. 

### Step 2
To build the website run:
```bash
Rscript -e 'rmarkdown::render_site()'
```
If there is no error then you will see a `_site` directory, under which you will find all the html files.

## License

These materials have been developed under a contract between the [Bioinformatics Training Facility (University of Cambridge)](https://bioinfotraining.bio.cam.ac.uk/) and the [New Variant Assessment Platform (NVAP)](https://www.gov.uk/guidance/new-variant-assessment-platform) from Public Health England.

If you want to use these materials please get in touch with us at `bioinfotraining @ bio.cam.ac.uk`.
