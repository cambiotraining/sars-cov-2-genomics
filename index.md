---
pagetitle: "SARS Genomic Surveillance"
author: "Tavares H, Bajuna S, Kumar A, Castle M, UKHSA New Variant Assessment Platform Team"
date: today
---

# Overview {.unnumbered} 

These materials provide a practical guide on analysing viral amplicon sequencing data for genomic surveillance, with a specific focus on SARS-CoV-2. 
While centered on SARS-CoV-2, the concepts and pipelines explored here are applicable to various viruses. 
The content includes the analysis of data from clinical isolates and wastewater samples. 
For clinical isolates, we illustrate how to create consensus sequences for upload to databases like GISAID and for downstream applications such as variant annotation and phylogeny. 
Wastewater sample analysis includes estimating variant and mutation frequencies.
For both applications we will use a standardized bioinformatic pipeline compatible with both Illumina and Nanopore data. 
The materials cover assigning sequences to lineages, identifying variants of interest and creating visualizations to effectively communicate findings. 
Throughout, you will acquire foundational bioinformatic skills, including Unix command line usage and scripting for reproducible analyses.

::: {.callout-tip}
#### Learning Objectives

- Recognise the uses of genomic surveillance to inform public health actions during a pandemic. 
- Assemble high-quality _SARS-CoV-2_ genome sequences starting with raw sequencing data from clinical isolates.
- Assign consensus sequences to lineages and identify variants of interest/concern.
- Capture high-quality metadata, recognising its impact on downstream analyses.
- Construct phylogenetic trees to contextualise new samples in a set of background samples.
- Estimate variant frequencies from mixed wastewater samples.
- Produce visualisations to communicate your findings and help inform public health action. 
:::


### Target Audience

These materials are aimed at life scientists and molecular lab technicians interested in the bioinformatic analysis of viral genomic data. 
In particular, it will benefit those working in SARS-CoV-2 sequencing facilities, such as public health labs.


### Prerequisites

We assume no prior bioinformatics experience or experience with the tools introduced in this course. 
An elementary knowledge of molecular and viral biology is assumed (concepts such as: DNA, RNA, PCR, primers, SNPs).


## Citation

<!-- We can do this at the end -->

Please cite these materials if:

- You adapted or used any of them in your own teaching.
- These materials were useful for your research work. For example, you can cite us in the methods section of your paper: "We carried our analyses based on the recommendations in Tavares et al. (2022).".

You can reference these materials as: 

> Tavares H., Salehe B., Kumar A., Castle M., UKHSA New Variant Assessment Platform (2024). SARS Genomic Surveillance URL: https://cambiotraining.github.io/sars-cov-2-genomics/

Or, in BibTeX format:

```
@misc{YourReferenceHere,
author = {Tavares, Hugo and Salehe, Bajuna and Kumar, Ankit and Castle, Matt and UKHSA New Variant Assessment Platform},
month = {3},
title = {SARS Genomic Surveillance},
url = {https://cambiotraining.github.io/sars-cov-2-genomics/},
year = {2024}
}
```

**Please make sure to include a link to the materials in the citation.** (we will add a DOI in due time)

The contributing members from University of Cambridge Bioinformatics Training Facility team are:

- Matt Castle, Bioinformatics Training Manager
- Hugo Tavares, Senior Teaching Associate
- Bajuna Salehe, Teaching Associate
- Ankit Kumar, Teaching Assistant

The UKHSA New Variant Assessment Platform team members that supported these materials are:

- Leena Inamdar, NVAP Programme Lead and Global Health Lead
- Babak Afrough, Senior Project Manager
- Angelika Kritz, Senior Bioinformatician
- Aude Wilhelm, Senior Epidemiology Scientist
- Richard Myers, Data Analytics Surveillance Head Bioinformatician
- Sam Sims, Bioinformatician
- Kate Edington, Bioinformatician
- Constantina Laou, Specialist Lab Advisor


## Acknowledgements

These materials have been developed as a collaboration between the [Bioinformatics Training Facility](https://bioinfotraining.bio.cam.ac.uk/) at the University of Cambridge and the [New Variant Assessment Platform (NVAP)](https://www.gov.uk/guidance/new-variant-assessment-platform) program from the _UK Health Security Agency_.

Our partners also include [COG Train](https://www.cogconsortium.uk/cog-train/about-cog-train/).
We also thank the wider community for publicly sharing training resources, including: 

- The [workshop video series from _CLIMB BIG DATA_](https://www.youtube.com/channel/UCdiGIIyryQL3x-Og5uiY1rw).
- The [Carpentries](https://carpentries.org/) project, in particular for their [Unix Shell](https://swcarpentry.github.io/shell-novice/) lesson, which we adapted for this workshop. 

