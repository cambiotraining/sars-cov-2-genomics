---
pagetitle: "SARS Genomic Surveillance"
---

# Workflow Cheatsheet


## Before you start

Make sure you have the following information available:

- **Viral load:** was was the Ct number from RT-qPCR? Samples with low viral load (Ct > 30) should not be sequenced. 
- **Primer scheme:** what set of primers was used to prepare the library? Make sure to have access to a BED file of primers, either online or request it from the company. 

Further, depending on your sequencing platform, make sure to have information about:

:::{.panel-tabset group=platform}
### Illumina

- Device name.
- Library preparation kit.


### Nanopore 

- Device name.
- Library preparation kit.
- Flowcell version (R9.4.1, R10.4.1).
- Basecaller software used (Guppy or Dorado) and its version.
- Basecalling mode used (e.g. fast, high accuracy, super accuracy)

:::


## Prepare files

### Samplesheet

- Put your sequencing data in a separate folder. For example a folder called `data`.
  If you have a shared storage server with sequencing data, you can leave the data there. 
- Use _Excel_ to prepare a "samplesheet" CSV file matching your sample IDs (of your choice) with the respective sequencing files (Illumina) or barcode numbers (ONT).
  See [viralrecon's documentation](https://nf-co.re/viralrecon/2.6.0/docs/usage#samplesheet-format) for details of this file format.


