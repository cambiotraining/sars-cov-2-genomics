---
pagetitle: "SARS-CoV-2 Genomics"
---

# Lineage Assignment and Variant Classification

::: highlight

**Questions**

- What are the main variant annotation conventions for SARS-CoV-2?
- How can I assign sequences to lineages and classify them as VOI/VOC?
- How can I visually explore the results of my variant analysis?

**Learning Objectives**

- Understand variant annotation conventions used by Gisaid, Pango, Nextstrain and WHO and how they relate to each other. 
- Understand the difference between a variant of interest (VOI) and variant of concern (VOC).
- Assign sequences to Pango lineages using `pangolin`.
- Interactively explore mutations in the assembled genomes and their phylogenetic context using _Nexstrain_'s tools.

:::

<!--
## Pango Lineages

We perform this step using Pangolin. 

First, we setup a conda environment with the software, following instructions from the tool's documentation: 

```bash
mamba create --name pangolin -c bioconda pangolin
```

After installation, we need to activate our Conda environment:

```bash
conda activate pangolin
```

Finally, we are ready to run our analysis. 
At the very least, `pangolin` needs as input a FASTA file with our consensus sequences. 

However, our `ncov2019-artic-nf` Nextflow pipeline gave us a single FASTA file for each consensus sequence. 

:::exercise

- Using command-line tools, concatenate all sequences into a single file. 
- **Bonus (advanced)**
  - The FASTA sequences are named as "Consensus_SAMPLE.primertrimmed.consensus_threshold_0.75_quality_20" were "SAMPLE" is the name of our sample (same as we have in our metadata table). To make sure the name of the sequences in the FASTA file matches the name in the metadata table, use the command-line tool `sed` to remove "Consensus_" and ".primertrimmed.consensus_threshold_0.75_quality_20" from the sequence names.

<details><summary>Answer</summary>

```bash
# make output directory
mkdir -p results/pangolin/
cat results/qc_pass_climb_upload/run1/*/*.fa | \
  sed 's/Consensus_//' | \
  sed 's/.primertrimmed.consensus_threshold_0.75_quality_20//' > \
  results/pangolin/all_sequences.fa
```

</details>

:::

To run _Pangolin_ we can use the following command:

```bash
pangolin \
  --alignment \
  --usher \
  --outdir results/pangolin/ \
  --outfile run1_report.csv \
  --threads 8 \
  results/pangolin/all_sequences.fa
```

_Pangolin_ uses a series of tools and models internally, and it is useful to know which versions are being used in the current analysis.
To do this, we can run the command `pangolin --all-versions`, which will print:

```
pangolin: 3.1.17
pangolearn: 2021-11-25
constellations: v0.0.30
scorpio: 0.3.15
pango-designation used by pangoLEARN/Usher: v1.2.101
pango-designation aliases: 1.2.112
```

**NOTE:** which reference is used by pangolin? There's [Wuhan-Hu-1](https://www.ncbi.nlm.nih.gov/nuccore/1798174254), which I think was the first assembled genome (this is the reference used by Nextclade). GISAID uses [WIV04](https://www.ncbi.nlm.nih.gov/nuccore/MN996528) as their reference. Maybe it doesn't make a difference if they are identical.

## USHER vs pangLEARN

- USHER uses a parsimony method
  - this can have the disadvantage that when there are multiple equally parsimonious solutions, it will just pick one (confirm?)
- pangoLEARN 
  - doesn't deal well with missing data and uncertainty
  - faster than USHER (but probably not in a significant way)

:::exercise

Re-run `pangolin` using the `--usher` option?

:::


## Nextclade

Another system of clade assignment and lineage classification is provided by [_Nextclade_](https://clades.nextstrain.org/). 

:::exercise

Go to https://clades.nextstrain.org/ and upload your FASTA file with all consensus sequences. 


:::


## Summary

:::highlight

**Key Points**

- one
- two

:::
-->
