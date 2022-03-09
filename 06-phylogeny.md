---
pagetitle: "SARS-CoV-2 Genomics"
---

# Building a Phylogenetic Tree

::: highlight

**Questions**

- How can I build a phylogenetic tree from my consensus sequences?
- How can I produce multiple sequence alignment of the consensus sequences?
- (TODO) How can I place my consensus sequences in the global phylogeny?

**Learning Objectives**

- Understand the basics of how phylogeny trees are constructed using maximum likelihood methods.
- Describe what branch lengths represent in typical SARS-CoV-2 phylogenetic tree. 
- Recognise the limitations and challenges in building phylogenies for SARS-CoV-2.
- Use _IQ-Tree_ for phylogenetic tree inference.
- Use _MAFFT_ to produce a multiple sequence alignment.
- (TODO) Use _UShER_ to place sequences in the global phylogeny. 

:::

## Phylogenetics Basics

TODO: 

- brief intro to phylogenetics, based on Nicola's presentation. 
- Mention interpretation of branch length in particular SARS-CoV-2 has ~2 mutations per month (probably replication errors), leading to very short branch lengths and polytomies. 
- Note about bootstraping - should probably be avoided, since there are usually too few sites for meaningful results. 


## SARS-CoV-2 Phylogeny

<img src="https://raw.githubusercontent.com/roblanf/sarscov2phylo/master/tree_image.jpg" alt="Global Phylogeny" style="float:right;width:20%">

Building phylogenetic trees for SARS-CoV-2 is challenging due to the large number of sequences available, with [millions of genomes submited to GISAID](https://www.gisaid.org/index.php?id=208) to this day. 
This means that using maximum-likelihood inference tools to build a global SARS-CoV-2 phylogeny is both time-consuming and computationally demanding. 

However, several researchers have dedicated their time to identifying tools and models suitable for the phylogenetic analysis of this organism. 
For example, the [global phylogenies repository](https://github.com/roblanf/sarscov2phylo) from Rob Lanfear provide with several tips on building phylogenetic trees for this organism.
Their trees are regularly updated and available to download from the GISAID website (which requires an account). 

Two popular tools used for phylogenetic inference via maximum-likelihood are **_FastTree_** and **_IQ-Tree_**.
Generally, when building a tree from a collection of samples, it may be worth including the Wuhan reference sequence as an outgroup to root the tree. 
Optionally, we can also add a collection of sequences from around the world (and across time) to contextualise our own samples in the global diversity. 

As an input, these programs need a _multiple sequence alignment_ FASTA file. 
For now we will use the alignment we previously obtained from `nextclade`, but we will see alternatives and other considerations later on.


### IQ-Tree

_IQ-TREE_ supports [many substitution models](http://www.iqtree.org/doc/Substitution-Models), including models with _rate heterogeneity_ across sites. 

Let's start by running the program with default options (we set `--prefix` to ensure output files go to a new folder):

```bash
iqtree2 -s data/uk_india.aligned.fasta --prefix results/iqtree/uk_india
```

Without specifying any options, `iqtree2` uses [_ModelFinder_](https://www.nature.com/articles/nmeth.4285) to find the substituion model that maximizes the likelihood of the data, while at the same time taking into account the complexity of each model (using information criteria metrics popular in statistics). 

From the information printed on the console after running the command, we can see that the chosen model for our alignment was "GTR+F+I", a [_generalised time reversible_ (GTR) substitution model](https://en.wikipedia.org/wiki/Substitution_model#Generalised_time_reversible). 
This model requires an estimate of each base frequency in the population of samples, which in this case is estimated by simply counting the frequencies of each base from the alignment (this is indicated by "+F" in the model name). 
Finally, the model includes rate heterogeneity across sites, allowing for a proportion of invariant sites (indicated by "+I" in the model name).
This makes sense, since we know that there are a lot of positions in the genome where there is no variation in our samples. 

We can look at the output folder (specified with `--prefix`) where we see several files with the following extension: 

- `.iqtree` - a text file containing a report of the IQ-Tree run, including a representation of the tree in text format.
- `.treefile` - the estimated tree in NEWICK format. We can use this file with other programs, such as _FigTree_, to visualise our tree. 
- `.log` - the log file containing the messages that were also printed on the screen. 
- `.bionj` - the initial tree estimated by neighbour joining (NEWICK format).
- `.mldist` - the maximum likelihood distances between every pair of sequences.
- `ckp.gz` - this is a "checkpoint" file, which IQ-Tree uses to resume a run in case it was interrupted (e.g. if you are estimating very large trees and your job fails half-way through).
- `.model.gz` - this is also a "checkpoint" file for the model testing step. 

The main files of interest are the report file (`.iqtree`) and the NEWICK tree file (`.treefile`).


:::note
**Inference of very large trees**

Although running _IQ-Tree_ with default options is fine for most applications, there will be some bottlenecks once the number of samples becomes too large. 
In particular, the _ModelFinder_ step may be very slow and so it's best to set a model of our choice based on other people's work. 
For example, [work by Rob Lanfear](https://github.com/roblanf/sarscov2phylo/blob/13-11-20/tree_estimation.md#which-model-is-best) suggests that models such as "GTR+G" and "GTR+I" are suitable for SARS-CoV-2.
We can specify the model used by `iqtree2` by adding the option `-m GTR+G`, for example. 

For very large trees (over 10k or 100k samples), using an alternative method to place samples in an existing phylogeny may be more adequate. 
[_UShER_](https://usher-wiki.readthedocs.io/en/latest/) is a popular tool that can be used to this end. 
It uses a parsimony-based method, which tends to perform well for SARS-CoV-2 phylogenies.

:::


## Visualising Trees

There are many programs that can be used to visualise phylogenetic trees. 
In this course we will use _FigTree_, which has a simple graphical user interface.

To open the tree, go to <kbd><kbd>File</kbd> > <kbd>Open...</kbd></kbd> and browse to the folder with the IQ-Tree output files. 
Select the file with `.treefile` extension and click <kbd>Open</kbd>.
You will be presented with a visual representation of the tree. 

We can also import a "tab delimited values" (TSV) file with annotations to add to the tree. 
For example, we can use our results from _Pangolin_ and _Nextclade_, as well as our metadata to improve our visualisation (we have prepared a TSV with this information combined, which you could also do using Excel or another spreadsheet software, for example). 

- Go to <kbd><kbd>File</kbd> > <kbd>Import annotations...</kbd></kbd> and open the annotation file. 
- On the menu on the left, click <kbd>Tip Labels</kbd> and under "Display" choose one of the fields of our metadata table. For example, you can display the lineage assigned by _Pangolin_ (lineage column of our annotation table). 

There are many ways to further configure the tree, including highlighting clades in the tree, and change the labels. 
See the figure below for an example.

![Annotated phylogenetic tree obtained with FigTree. We used the lineage of each sample as our tip labels and aligned the labels on the right (check the tickbox at the top of the left menu called "Align tip labels"). We identified two clades in the tree that corresponded to the Alpha and Delta variants, and used the "Highlight" tool to give them different colours. To do this, change the "Selection Mode" at the top to "Clade", then select the branch at the base of the clade you want to highlight, and press the "Highlight" button on the top to pick a colour.](images/phylogeny_figtree.svg)


<!-- 
From [here](https://github.com/roblanf/sarscov2phylo/issues/20#issuecomment-855319059):

```bash
iqtree2 -s aln.fasta -t NJ-R -n 0 -m GTR+R4 -nt 8 -blmin 0.00000000001
```

Although if we run with default options, it will use _ModelFinder Plus_ to identify best model (based on AIC):

```bash
iqtree -s aln.fasta -nt 8 -blmin 0.00000000001
```

This takes quite a while to run though. 

NOTE:
- In `iqtree2` the option `-nt` (number threads) is now `-T`. The default auto-detects so we could leave it out.
- Running `fasttree` results in a strange tree with a "laddering" effect. Running `iqtree` with `-blmin` set to a small number solves this somewhat.


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

Alignment: MAFFT is used [here](https://github.com/roblanf/sarscov2phylo/blob/master/scripts/global_profile_alignment.sh) `mafft --thread 1 --quiet --keeplength --add $seqfile "$REFERENCE_ALN" > $alfile` 

-->

## Alignment

So far, we have used the alignment generated by _Nextclade_. 
This is suitable for most purposes, however it is also possible to generate our own alignment. 

A widely used alignment software is called **_MAFFT_**.
This software provides several methods for alignment, with tradeoffs between speed and accuracy. 
We can look at the full documentation using `mafft --man` (`mafft --help` will give a shorter description of the main options). 

From its documentation we can see that the most precise alignment can be obtained with the options `--localpair --maxiterate 1000`. 
However, this is substantially slow and may not be feasible for more than a few hundred samples.

We will run _MAFFT_ with the default option, for the purposes of speed: 

```bash
mafft data/all_sequences.fa > results/mafft_alignment.fa
```

We can visualise our alignment using the software [AliView](https://ormbunkar.se/aliview/), which is both lightweight and fast, making it ideal for large alignments. 
Visualising the alignment can be useful for example to identify regions with missing data (more about this below). 

![Snapshop of an alignment visualised with AliView. In this case we are looking at the end of the alignment of our sequences, which shows a typical high number of missing ('N') bases.](images/alignment_aliview.png)


:::exercise

- Use `iqtree2` to build a new phylogenetic tree using the _MAFFT_ alignment we just created. 
Use the "GTR+G" substitution model and save the output with prefix `results/iqtree/uk_india_mafft`. 
- Visualise the new tree using _FigTree_ and import the TSV file with information about each sample. Use the "Highlight" tool to colour clades corresponding to variants of concern. 
- Can you identify any major differences between this new tree and the previous tree we made from the Nextclade alignment? 

<details><summary>Hint</summary>
To set the model used by IQ-Tree you can use the option `-m GTR+G`.
</details> 

<details><summary>Answer</summary>
TODO

```bash
iqtree2 -s results/mafft_alignment.fa --prefix results/iqtree/uk_india.mafft
```
</details> 
:::

:::note
**Very large alignments**

*MAFFT* may be substantially slower for a large number of samples. 
However, it does provide a functionality for adding sequences to an existing alignment (this is one of the methods used for inferring the global SARS-CoV-2 phylogeny). 
This can be done with the `--add` option and its documentation found on the [MAFFT website](https://mafft.cbrc.jp/alignment/software/addsequences.html).

One of the alternatives to _MAFFT_ include the [`minimap2`](https://lh3.github.io/minimap2/) software, which aligns each consensus sequence to the reference genome. 
In this case, insertions are not considered during the alignment, since gaps are not introduced in the reference genome. 
This is the tool used by _Pangolin_.

_Nextclade_ also uses an alignment algorithm where each consensus sequence is aligned with the reference genome. 
The alignment from this tool can also be used for phylogenetic inference, as we have done earlier. 
:::


### Missing Data & Problematic Sites

So far, we have been using all of our assembled samples in the phylogenetic analysis. 
However, we know that some of these have poorer quality (for example the "barcode01" sample from India had only ~50% genome coverage). 
Sequences with poor quality result in too many missing or ambiguous bases, which in turn are discarded during phylogenetic tree reconstruction. 
Therefore, for phylogenetic analysis, it is best if we remove samples with low sequencing coverage, and instead focus on high-quality samples (e.g. with >90% coverage). 

Even in samples with high quality, there is often a high percentage of missing data at the start and end of the consensus sequence. 
Therefore, it is common to _mask_ the first and last few hundred bases of the alignment, to avoid including spurious variable sites in the analysis. 

Finally, work by [Turakhia, de Maio, Thornlow, et al. (2020)](https://doi.org/10.1371/journal.pgen.1009175) has identified several sites that show an unexpected mutation pattern. 
This includes for example mutations that unexpectedly occur multiple times in different parts of the tree ([homoplasies](https://en.wikipedia.org/wiki/Homoplasy)) and often coincide with primer binding sites (from amplicon-based protocols) and can even be lab-specific (e.g. due to their protocols and data processing pipelines). 
The work from this team has led to the creation of a list of [problematic sites](https://virological.org/t/masking-strategies-for-sars-cov-2-alignments/480), which are recommended to be _masked_ before running the phylogenetic analysis. 

![Example of errors in phylogenetic inference due to recurrent sequencing errors. Source: [Figure 1 in Turakhia, de Maio, Thornlow et al. (2020)](https://journals.plos.org/plosgenetics/article/figure?id=10.1371/journal.pgen.1009175.g001)](https://journals.plos.org/plosgenetics/article/figure/image?size=inline&id=10.1371/journal.pgen.1009175.g001)

So, let's try to improve our alignment by:

- Masking the first and last 100bp of the sequences in the alignment.
- Masking the positions identified as problematic sites.

To mask a fasta file we can use the `bedtools` software, which comes with a collection of tools for genomic analysis.
One of the tools provided is called `bedtools maskfasta` and can mask a FASTA file based on either a VCF, BED or GFF file (see the [common file formats page](03-intro_ngs.html#Sequencing_File_Formats) if you need a reminder of what these are). 

Let's start by masking the problematic sites, which are [provided as a VCF file](https://raw.githubusercontent.com/W-L/ProblematicSites_SARS-CoV2/master/problematic_sites_sarsCov2.vcf).
We have already downloaded this file to our course materials folder, so we can go ahead and use this tool to mask our file:

```bash
bedtools maskfasta -fi results/alignment.fa -bed resources/problematic_sites_mask.vcf -fo results/alignment_problematic_sites_masked.fa
```

If we open the output file with AliView, we can confirm that the positions specified in the VCF file have now been masked with the missing 'N' character.

:::exercise
- Apply another mask to the file we just created, but this time using the BED file `resources/start_end_mask.bed` as the mask. Save the output as a new file called `results/alignment_fully_masked.fa`. 
- Open the new file in AliView and confirm that all the positions at the start and end of the alignment have been converted to the 'N' character.
- Re-run the phylogenetic inference using IQ-Tree using the "GTR+G" substitution model. 

<details><summary>Answer</summary>
TODO
</details>
:::

:::note
Add note about processing the VCF file used for masking. 
We can use bcftools to filter sites marked as "mask" and not the ones marked as "caution". 
:::

<!--
- These can be found here: https://github.com/W-L/ProblematicSites_SARS-CoV2
- more info here (note that not all sites in the VCF should be masked): https://virological.org/t/masking-strategies-for-sars-cov-2-alignments/480
- This script shows how these are masked: https://github.com/roblanf/sarscov2phylo/blob/master/scripts/mask_alignment.sh
- We could also use the more standard https://bedtools.readthedocs.io/en/latest/content/tools/maskfasta.html
-->


## Summary

:::highlight

**Key Points**

- one
- two

:::
