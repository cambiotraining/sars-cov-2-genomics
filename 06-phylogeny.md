---
pagetitle: "SARS-CoV-2 Genomics"
---

# Building a Phylogenetic Tree

::: highlight

**Questions**

- How can I align my consensus sequences against the reference genome?
- How can I build a phylogenetic tree from my consensus sequences?
- How can I place my consensus sequences in the global phylogeny?

**Learning Objectives**

- Use the _MAFFT_ software to produce a multiple sequence alignment from the consensus sequences.
- Understand the basics of how phylogeny trees are constructed using maximum likelihood methods.
- Describe what branch lengths represent in typical SARS-CoV-2 phylogenetic tree. 
- Recognise the limitations and challenges in building phylogenies for SARS-CoV-2.
- Use the `fasttree` software to produce a tree from a modest number of sequences.
- Use _UShER_ to place sequences in the global phylogeny. 

:::


<!--
## SARS-CoV-2 Phylogeny

:::warning
What we are covering in this section should be seen as an exploratory analysis and not overly interpreted. 
Phylogenetic analysis involves the use of models of evolution, which can impact the outcome of the analysis. 
What we cover here is based on recommendations from ...
:::

![](https://raw.githubusercontent.com/roblanf/sarscov2phylo/master/tree_image.jpg)

We can download latest phylogeny [here](https://github.com/roblanf/sarscov2phylo/releases)

There are two popular programs for building phylogenetic trees: `fasttree` and `iqtree`. 
As an input, these programs need a FASTA file of the aligned sequences. 
For now we can use the alignment we previously obtained from `pangolin`, but we will see alternatives and other considerations later on.

One of the things to consider is to use the Wuhan reference sequence as an outgroup to root the tree. 
Optionally, we can also add a collection of sequences from around the world (and across time) to contextualise our own samples in the global diversity. 

### IQ-Tree

From [here](https://github.com/roblanf/sarscov2phylo/issues/20#issuecomment-855319059):

```bash
iqtree2 -s aln.fasta -t NJ-R -n 0 -m GTR+R4 -nt 8 -blmin 0.00000000001
```

Although if we run with default options, it will use _ModelFinder Plus_ to identify best model (based on AIC):

```bash
iqtree -s aln.fasta -nt 8 -blmin 0.00000000001
```

This takes quite a while to run though. 


### FastTree

From [here](https://github.com/roblanf/sarscov2phylo/commit/55cbb8ddaddaceb2ecd0577f105a3fd37f13d304), I think these are run with performance in mind:

```bash
fasttree -nt -gamma -nosupport \
  -sprlength 500 -nni 0 -spr 5 \
  -refresh 0.8 -topm 1.5 -close 0.75 -noml \
  "$INPUT_FASTA" > "$INPUT_FASTA"'1.multi.fasttree'
    
fasttree -nt -gamma -sprlength 200 -spr 5 -intree \
  "$INPUT_FASTA"'1.multi.fasttree' \
  "$INPUT_FASTA" > "$INPUT_FASTA"'multi.fasttree'
```

In this document there's a much simpler command, which is probably fine for the purpose of our course: 

```bash
fasttree -nt -nosupport input.fa > output.tree 2> output.log
```

**NOTE to self:** ran this with additional `-gtr` option and took 6 minutes. 

- `-nt` for nucleotide alignment (default is protein alignment).
- `-nosupport` to turn off support values (bootstrap) - it makes sense to turn this off, since we often have very few variable sites to bootstrap from.

We can visualise the tree we just produced with _FigTree_. 
We can also import the output from _Pangolin_ to annotate our tree by variant (**note:** unfortunately FigTree wants a TSV file, but pangolin exports CSV. I did this, but maybe there's a less confusing way to do this? `cat results/pangolin/run1_report.csv | sed 's/,/\t/g' > results/pangolin/run1_report.tsv`)


:::note
<details><summary>Installing `fasttree` and `iqtree`</summary>

You can install both these programs using _Conda_ (more about this package manager in [Reproducible Workflows](08-nextflow_conda_setup.html)).
For example, we can create a new environment called "phylogenetics" with both these programs as well as _FigTree_ (for tree visualisation).

```console
$ mamba create --name phylogenetics fasttree iqtree figtree
```

We can then activate this environment by running `conda activate phylogenetics`, making the programs available to use. 

Note that _FigTree_ is also available on Windows and Mac (see the [software page](http://tree.bio.ed.ac.uk/software/figtree/) for download links).

</details>
:::


:::exercise

- Looking at the tree we just constructed, do you think the Delta variant emerged from the Alpha variant?
- Produce a new phylogenetic tree but this time using both the sequences we processed and a sample of other public sequences that represent the global diversity of SARS-CoV-2 genomes. 
  - First combine the two files into one (`cat`).
  - Produce a combined annotation file with sequence name and lineage.
  - Then run `fasttree` with the same settings we used before.
- Visualise this new tree. Does your conclusion change?


:::

## Alignment

- MAFFT is used [here](https://github.com/roblanf/sarscov2phylo/blob/master/scripts/global_profile_alignment.sh)
- Pangolin uses minimap2 (see [docs](https://cov-lineages.org/resources/pangolin/usage.html))

Visualising alignment: [AliView](https://ormbunkar.se/aliview/) is lightweight and fast. 
[Nextstrain](https://clades.nextstrain.org) is probably the nicest because it includes the annotation.

Should we mask gaps with N's? Actually, I think ML methods ignore gaps and treat them as N's anyway.


## Problematic Sites

- These can be found here: https://github.com/W-L/ProblematicSites_SARS-CoV2
- more info here (note that not all sites in the VCF should be masked): https://virological.org/t/masking-strategies-for-sars-cov-2-alignments/480
- This script shows how these are masked: https://github.com/roblanf/sarscov2phylo/blob/master/scripts/mask_alignment.sh
- We could also use the more standard https://bedtools.readthedocs.io/en/latest/content/tools/maskfasta.html



## Summary

:::highlight

**Key Points**

- one
- two

:::
-->
