---
pagetitle: "SARS-CoV-2 Genomics"
---

# Introduction to SARS-CoV-2 Genomics

:::warning
**Dev note:** some of these can probably be moved to the relevant sections later on. 
This section can be written at the end, but for now it's useful to drop down notes.
This will most likely not be a "practical" session, but rather a presentation (the materials serve as complementary reading material to the slides).
:::

:::highlight

**Questions**

- How can genomic surveillance help with public health action?
- What protocols and technologies are used for SARS-Cov-2 genome sequencing?
- What factors should be considered when collecting samples for sequencing?
- What is the difference between a strain, a lineage, a clade and a variant?
- What are some of the main SARS-CoV-2 data repositories and projects?

**Learning Objectives**

- Enumerate some examples of how the genomic surveillance of SARS-CoV-2 has impacted public health decisions during the ongoing pandemic. 
- Contrast different sequencing technologies (e.g. Illumina and Nanopore) and protocols (e.g. amplicon, metagenomic, RNA-seq) commonly used for SARS-CoV-2 sequencing, including the pros and cons of each. 
- Understand the steps involved in the widespread ARTIC protocol and the differences between its versions. 
- List key metadata fields needed with each sample to make best use of the data and recognise some limitations related to privacy.
- Recognise what the main steps are in processing raw sequencing data to generate consensus genome sequences, including sequence alignment, primer trimming and consensus generation. 
- Distinguish between the concept of a strain, a lineage, a clade and a variant (and describe why the concept of a variant is sometimes ambiguous).
- Describe the sources of information that can be obtained from GISAID, Pango, Nextstrain and the WHO nomenclature systems. 
- Describe what a variant of concern (VOC) is and how it differs from a variant of interest (VOI). 

:::

<!--
## What is SARS-CoV-2?

Very brief and general intro to coronavirus biology (see: https://www.nature.com/articles/s41586-021-04188-6)

- genus betacoronavirus
- phylogenetic context in relation to other viruses
- SARS-CoV-2 spike protein (binds to human ACE2); its structure, e.g. receptor binding domain, furin-cleavage site
  - mutations in spike protein might cause immune escape and/or vaccine inefficiency
- current pandemic overview


## Genomic Surveillance

Figure 3 from this paper may be helpful: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7097748/

- Applications from molecular epidemiology (see https://youtu.be/R4EoTEiAQNE)
- Identification of variants of interest and variants of concern
  - First notable mutation was A23403G (D614G AA substitution in the spike protein)   - increased virus infectivity and transmissibility
  - Alpha (UK), Beta (South Africa), Gamma (Brasil), Delta (India), Omicron (South Africa)
  - These variants often show reduced neutralisation against vaccine-elicited antibodies
  - General description of these variants in Box 2 of https://www.nature.com/articles/s41586-021-04188-6#Sec11

- SARS-CoV-2 sequencing is the largest genomic sequencing of a pathogen ever
  - shed light on global (and local) transmission patterns
  - factors associated with the fitness of the virus 
  - identification of new variants of concern - affecting public health policy and travel restrictions 
  - bias in sequencing efforts (UK + US contribute ~50% of all sequences)


## GISAID (and others?)


Variant classification: 

- WHO (see their definition of VOC): https://www.who.int/en/activities/tracking-SARS-CoV-2-variants/


## SARS-CoV-2 Sequencing

- 29800bp genome
- 2 mutations per month (probably replication errors)
- Amplicon sequencing, Metagenomic approach, RNA-seq
- Platforms: Illumina, Nanopore (pros and cons)

First sequence and assembly: https://www.nature.com/articles/s41586-020-2012-7

### ARTIC protocol

The Artic Network aims at providing the community with a standardized set of tools and operating procedures to process viral sequence data. 
In particular, the community developed a pipeline to try and standardise the processing of SARS-CoV-2 variants. 

- Overview of the ARTIC project 
- ARTIC sample prep protocol (amplicon sequencing; primer versions)
  - Nice fig 1 to illustrate library prep https://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-020-07283-6
  - Nanopore or Illumina? 
    - Nanopore is fast, relatively cheap, up to 96 samples per flowcell, portable; contamination risk (if washing and re-running)
    - Illumina is higher-throughput, lower error rates, cheaper per sample


## Brief Intro to Sequencing

Maybe a brief overview of the pipeline (only intuitive, no tools mentioned) to motivate the steps that come after.


## Sample Collection

Which samples to sequence? 

- Samples with Ct > 30 may not be worth sequencing as their genome completeness is likely going to be low (see plot at [12:30 of this video](https://youtu.be/Fb-SID2DlB0?t=760))
- Negative controls 


### Metadata

- This manuscript indicates which metadata is needed for public databases: https://www.preprints.org/manuscript/202008.0220/v1 
  - The accompanying repository has useful templates and mappings between the fields for different databases (e.g. GISAID, GENBANK, SRA)
  - There's a bunch of protocols.io for submitting to each of these databases
- not all metadata needs to be shared publicly - this may help collaborators share information if they know that some of those data will not be publicly shared 

Minimal metadata: 

- Geolocation
- Date of collection
- Date of sequencing
- Ct value (proxy for viral load); Ct > 30 is very high (low virus amount resulting in low coverage)

Metadata is crucial for example for epidemiological analysis (without known "person, place, time" it's hard to infer anything about the dynamics of transmission of the virus from the genomic data)


## Nomenclature 

Need to clarify (see [notes](notes.md) on Aine O'Toole's talk): 

- Strain
- Clades
- Lineages
- Variants
  - this one is a little ambiguous and we should clarify


## Key Bioinformatic Skills 

To link with next sessions, cover the main bioinformatic skills we need to acquire in order to achieve our main goal of producing an actionable report for SARS-CoV-2 genomic surveillance.

- Unix 
- Conda and Nextflow
- ARTIC pipeline


## Summary

:::highlight
**Key Points**

- one
- two
- three

:::
-->
