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

These materials are made available under a [Creative Commons Attribution license](https://creativecommons.org/licenses/by/4.0/). 
This means that you can share and adapt these materials, as long as you give credit to the original materials and authors. 

## Acknowledgements

These materials have been developed as a collaboration between the [Bioinformatics Training Facility (University of Cambridge)](https://bioinfotraining.bio.cam.ac.uk/) and the [New Variant Assessment Platform (NVAP)](https://www.gov.uk/guidance/new-variant-assessment-platform) from Public Health England.
Our partners also include [COG Train](https://www.cogconsortium.uk/cog-train/about-cog-train/).

We thank CLIMB BIG DATA for publicly sharing their [workshop videos](https://www.youtube.com/channel/UCdiGIIyryQL3x-Og5uiY1rw), which inspired some of these materials.
