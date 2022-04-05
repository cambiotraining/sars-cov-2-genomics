---
pagetitle: "SARS-CoV-2 Genomics"
---

# Building a Phylogenetic Tree

::: highlight

**Questions**

- How can I build a phylogenetic tree from my consensus sequences?
- How can I produce multiple sequence alignment of the consensus sequences?

**Learning Objectives**

- Understand the basics of how phylogeny trees are constructed using maximum likelihood methods.
- Describe what branch lengths represent in typical SARS-CoV-2 phylogenetic tree. 
- Recognise the limitations and challenges in building phylogenies for SARS-CoV-2.
- Use _IQ-Tree_ for phylogenetic tree inference.
- Use _MAFFT_ to produce a multiple sequence alignment.
:::

:::note
This section has an accompanying <a href="https://drive.google.com/file/d/19MCiM8JhWgtSwvQdotfJRlyv7Z7CVJwz/view?usp=sharing" target="_blank">slide deck</a>.
:::

<!--
## Phylogenetics Basics

TODO: 

- brief intro to phylogenetics, based on Nicola's presentation. 
- Mention interpretation of branch length in particular SARS-CoV-2 has ~2 mutations per month (probably replication errors), leading to very short branch lengths and polytomies. 
- Note about bootstraping - should probably be avoided, since there are usually too few sites for meaningful results. 


- Multifurcations happen when several samples have the same sequence, so the branch lengths between them are zero, so they all collapse to a single node. This can happen for example if you have a local outbreak of a variant where every sample has the same variant.
- Recombination can cause problems in phylogenies. This is when two viral sequences recombine with each other, so now the new sequence has part of its genome closely-related to one parent and the other from the other parent. This can cause problems with phylogenetic trees. There are software that can detect recombination events. In particular the software RIPPLES can work with large sample sizes.

### Alignment

To build a phylogenetic tree we need to start with all our sequences aligned to each other. 
The alignment might result in _gaps_ in some sequences, where missing nucleotides in some sequences are represented with `-` character. 
The alignment is usually stored as a FASTA file, and all sequences have to be of the same length (because they are aligned to each other). 

Gaps (`-`) and ambiguous positions (`N`) are treated as missing data by the phylogenetic methods. 

Something to note is that phylogenetic inference assumes that the alignments we give are correct. 
However, errors in the consensus sequence or missing data can sometimes lead to poor alignments.
One thing to pay attention to is whether there are very long branches in our trees, suggesting a sample with an unusual high number of mutations. 
Inspecting these samples may reveal errors in the alignment, for example due to high proportion of missing data that leads to poor alignments, which may result in false variable positions. 

Other errors are harder to detect but work from Turakaia et al was able to build a collection of recurrent errors that affect phylogenies.


### Tree Inference

There are broadly three types of methods: 

- distance
- parsimony
- maximum likelihood

#### Distance Phylogenies

These methods rely on calculating the distance between each pair of sequences.
Popular methods of this kind are _neighbour-joining_ (NJ) or 

#### Maximum Parsimony

Infers a tree that requires the fewest number of mutations needed along each branch of the tree to explain the data. 

This method can be inaccurate when there are long branches in the tree (this problem is referred to as "long branch attaction"). 
However, for SARS-CoV-2 this is not a big problem, because the sequences tend to be very similar to each other. 

In fact, a recent tool called _UShER_ has been developed for SARS-CoV-2 analysis using a parsimony-based method. 
This tool was developed to be very efficient at working with millions of samples, which is harder with maximum likelihood methods. 

#### Maximum Likelihood

- Uses a probabilistic model for genome evolution.
- Model of evolution:
  - DNA substituion model
    - JC69 assumes only one mutation rate
    - HKY85 assumes different mutation rates (transitions have different rates)
    - GTR is another one
  - Rate heterogeneity:
    - Invariant sites - the model will assume that a certain proportion of the sites in the genome might never change.
    - Rate variation (Gamma models used) - the model will assume that different sites of the genome might evolve at different rates.
- Generally, more complex models give better results (but are more computationally demanding and require more data)
-  
-->


## SARS-CoV-2 Phylogeny

<img src="https://raw.githubusercontent.com/roblanf/sarscov2phylo/master/tree_image.jpg" alt="Global Phylogeny" style="float:right;width:20%">

Building phylogenetic trees for SARS-CoV-2 is challenging due to the large number of sequences available, with [millions of genomes submited to GISAID](https://www.gisaid.org/index.php?id=208) to this day. 
This means that using maximum-likelihood inference tools to build a global SARS-CoV-2 phylogeny is both time-consuming and computationally demanding. 

However, several researchers have dedicated their time to identifying tools and models suitable for the phylogenetic analysis of this organism. 
For example, the [global phylogenies repository](https://github.com/roblanf/sarscov2phylo) from Rob Lanfear provide with several tips on building phylogenetic trees for this organism.
Their trees are regularly updated and available to download from the GISAID website (which requires an account). 

Global phylogenies are also available from the groups of Russell Corbett-Detig and Yatish Turakhia, who have developed [efficient methods and tools](https://doi.org/10.1093/molbev/msab264) for dealing with large phylogenies. 
These tools include _UShER_ and _matUtils_, introducing a new and efficient file format for storing phylogenetic trees, mutations and other annotations (such as lineages) called _mutation-annotated trees_ (MAT format). 
Their phylogenies are updated daily and are [publicly available for download](http://hgdownload.soe.ucsc.edu/goldenPath/wuhCor1/UShER_SARS-CoV-2/). 
(Note: Course materials covering these tools are still under development.)

Two popular tools used for phylogenetic inference via maximum-likelihood are **_FastTree_** and **_IQ-Tree_**.
Generally, when building a tree from a collection of samples you can include the Wuhan-Hu-1 reference sequence as an outgroup to root the tree. 
Optionally, you can also add a collection of sequences from around the world (and across time) to contextualise your samples in the global diversity. 

As an input, these programs need a _multiple sequence alignment_ FASTA file. 
For now we will use the alignment we previously obtained from `nextclade`, but we will see alternatives and other considerations later on.


### IQ-Tree

_IQ-TREE_ supports [many substitution models](http://www.iqtree.org/doc/Substitution-Models), including models with _rate heterogeneity_ across sites. 

Let's start by creating an output directory for our results:

```bash
mkdir -p results/iqtree
```

And then run the program with default options (we set `--prefix` to ensure output files go to the directory we just created and are named "uk_india"):

```bash
iqtree2 -s data/uk_india.nextclade.alignment.fa --prefix results/iqtree/uk_india
```

Without specifying any options, `iqtree2` uses [_ModelFinder_](https://www.nature.com/articles/nmeth.4285) to find the substituion model that maximizes the likelihood of the data, while at the same time taking into account the complexity of each model (using information criteria metrics commonly used to assess statistical models). 

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
For SARS-CoV-2, a reference-based alignment approach is often used, which is suitable for closely-related genomes. 
MAFF provides this functionality, which is detailed in its [documentation](https://mafft.cbrc.jp/alignment/software/closelyrelatedviralgenomes.html).

Let's create a directory for our alignment:

```bash
mkdir results/mafft
```

The command we will use to run our reference-based alignment is:

```bash
mafft --6merpair --maxambiguous 0.1 --addfragments data/all_sequences.fa resources/reference.fa > results/mafft/alignment.fa
```

The meaning of the options used is: 

- `--6merpair` is a fast method for estimating the distances between sequences, based on the number of short 6bp sequences shared between each pair of sequences. This is less accurate than other options available (like `--localpair` and `--globalpair`), but runs much faster in whole genome data like we have.
- `--maxambiguous 0.1` automatically removes samples with more than 10% ambiguous 'N' bases (or any other value of our choice). This is a convenient way to remove samples with poor genome coverage from our analysis. 
- `--addfragments data/all_sequences.fa` is the file with the sequences we want to align.
- finally, at the end of the command we give the reference genome as the input sequence to align our sequences against. 

MAFFT provides several other methods for alignment, with tradeoffs between speed and accuracy. 
You can look at the full documentation using `mafft --man` (`mafft --help` will give a shorter description of the main options). 
For example, from its documentation we can see that the most precise alignment can be obtained with the options `--localpair --maxiterate 1000`. 
However, this is quite slow and may not be feasible for whole genome data of SARS-CoV-2.


### Visualising alignments 

We can visualise our alignment using the software [AliView](https://ormbunkar.se/aliview/), which is both lightweight and fast, making it ideal for large alignments. 
Visualising the alignment can be useful for example to identify regions with missing data (more about this below). 

![Snapshop of an alignment visualised with AliView. In this case we are looking at the end of the alignment of our sequences, which shows a typical high number of missing ('N') bases.](images/alignment_aliview.png)


:::exercise

- Use `iqtree2` to build a new phylogenetic tree using the _MAFFT_ alignment we just created. 
Use the _GTR+G_ substitution model and save the output with prefix `results/iqtree/uk_india_mafft`. **Bonus:** save the command in a shell script.
- Visualise the new tree using _FigTree_ and import the TSV file with information about each sample. Use the "Highlight" tool to colour clades corresponding to variants of concern. 

<details><summary>Hint</summary>
To set the model used by IQ-Tree you can use the option `-m GTR+G`.
</details> 

<details><summary>Answer</summary>

The command to run the analysis is: 

```bash
iqtree2 -m GTR+G -s results/mafft/alignment.fa --prefix results/iqtree/uk_india_mafft
```

We have used the option `-m GTR+G` to tell _IQ-Tree_ to use that specific substition model, instead of trying to infer the best model for our data. 
The other options are similar to what we used before, expect we use our MAFFT alinment as input and use a new output prefix for this run. 

We can open a new _FigTree_ window and go to <kbd>File > Open...</kbd> to open the file named `uk_india_mafft.treefile`. 
This should display our new tree. 
We can then go to <kbd>File > Import Annotation...</kbd> to import our metadata sheet. 
Going to <kbd>Tip Labels</kbd> on the menu on the left, we can then name our tips according to the `scorpio_call` column, which includes the _Variant of Concern_ classification done by the _Scorpio_ software (part of _Pangolin_).

Once we identify the clade in our tree corresponding to variants of concern, we can use the "Highlight" button on the top to add colour annotations to our tree. 
</details> 
:::

:::note
**Other Alignment Strategies**

There are other commonly used alignment tools used for SARS-CoV-2 genomes:

- The [`minimap2`](https://lh3.github.io/minimap2/) software has been designed for aligning long sequences to a reference genome. It can therefore be used to align each consensus sequence to the Wuhan-Hu-1 genome. This is the tool internally used by _Pangolin_.
- _Nextclade_ uses an internal alignment algorithm where each consensus sequence is aligned with the reference genome. The alignment from this tool can also be used for phylogenetic inference, as we have done earlier. 

It is worth mentioning that when doing reference-based alignment, insertions relative to the reference genome are not considered. 
:::


### Missing Data & Problematic Sites

So far, we have been using all of our assembled samples in the phylogenetic analysis. 
However, we know that some of these have poorer quality (for example the "barcode01" sample from India had only ~50% genome coverage). 
Although, generally speaking, sequences with missing data are unlikely to substantially affect the phylogenetic results, their placement in the phylogeny will be more uncertain (since several variable sites may be missing data). 
Therefore, for phylogenetic analysis, it is best if we remove samples with low sequencing coverage, and instead focus on high-quality samples (e.g. with >90% coverage). 

A more serious issue affecting phylogenies is the presence of recurrent errors in certain positions of the genome. 
One of the regions with a higher prevalence of errors is the start and end of the consensus sequence, which also typically contains many missing data (see example in Figure 2).
Therefore, it is common to _mask_ the first and last few bases of the alignment, to avoid including spurious variable sites in the analysis. 

Additionally, work by [Turakhia, de Maio, Thornlow, et al. (2020)](https://doi.org/10.1371/journal.pgen.1009175) has identified several sites that show an unexpected mutation pattern. 
This includes, for example, mutations that unexpectedly occur multiple times in different parts of the tree ([homoplasies](https://en.wikipedia.org/wiki/Homoplasy)) and often coincide with primer binding sites (from amplicon-based protocols) and can even be lab-specific (e.g. due to their protocols and data processing pipelines). 
The work from this team has led to the creation of a list of [problematic sites](https://virological.org/t/masking-strategies-for-sars-cov-2-alignments/480), which are recommended to be _masked_ before running the phylogenetic analysis. 

![Example of errors in phylogenetic inference due to recurrent sequencing errors. Source: [Figure 1 in Turakhia, de Maio, Thornlow et al. (2020)](https://journals.plos.org/plosgenetics/article/figure?id=10.1371/journal.pgen.1009175.g001)](https://journals.plos.org/plosgenetics/article/figure/image?size=inline&id=10.1371/journal.pgen.1009175.g001)

So, let's try to improve our alignment by masking the problematic sites, which are [provided as a VCF file](https://raw.githubusercontent.com/W-L/ProblematicSites_SARS-CoV2/master/problematic_sites_sarsCov2.vcf).
This file also includes the first and last positions of the genome as targets for masking (positions 1–55 and 29804–29903, relative to the Wuhan-Hu-1 reference genome MN908947.3). 
The authors also provide a [python script](https://github.com/W-L/ProblematicSites_SARS-CoV2/blob/master/src/mask_alignment_using_vcf.py) for masking a multiple sequence alignment. 
We have already downloaded these files to our course materials folder, so we can go ahead and use the script to mask our file:

```bash
python scripts/mask_alignment_using_vcf.py --mask -v resources/problematic_sites.vcf -i results/mafft/alignment.fa -o results/mafft/alignment_masked.fa
```

If we open the output file with AliView, we can confirm that the positions specified in the VCF file have now been masked with the missing 'N' character.

:::note
**Using Python Scripts**

Bioinformaticians often write custom scripts for particular tasks. 
In this example, the authors of the "problematic sites" wrote a _Python_ script that takes as input the FASTA file we want to mask as well as a VCF with the list of sites to be masked. 

Python scripts are usually run with the `python` program and often accept options in a similar way to other command-line tools, using the syntax `--option` (this is not always the case, but most professionally written scripts follow this convention). 
To see how to use the script we can use the option `--help`. 
For our case, we could run: 

```console
$ python scripts/mask_alignment_using_vcf.py --help
```
:::

:::exercise

- Build a new phylogenetic tree from the masked alignment, using the _GTR+G_ substitution model. Save the output with prefix `results/iqtree/uk_india_mafft_masked`
- Open this new tree on FigTree and compare with the previous tree generated from the non-masked alignment. Are the trees very different? 

<details><summary>Answer</summary>

We can run `iqtree2` similarly to how we've done before: 

```bash
iqtree2 -m GTR+G -s results/mafft/alignment_masked.fa --prefix results/iqtree/uk_india_mafft_masked
```

Opening both trees with FigTree and comparing them side-by-side, we can see that they are generally similar, with the same samples clustering together in both. 
One of the most noticeable differences is that the branch lengths have changed. 
This makes sense, because masking the genomes should have removed mutations that are errors rather than true variation, leading to differences in the estimated distances between samples. 

</details>

:::


## Summary

:::highlight

**Key Points**

- Methods for phylogenetic inference include _parsimony_ and _maximum likelihood_. Maximum likelihood methods are preferred because they include more features of the evolutionary process. However, they are computationally more demanding than parsimony-based methods. 
- To build a phylogenetic tree we need a _multiple sequence alignment_ of the sequences we want to infer a tree from. 
- In SARS-CoV-2, alignments are usually done against the Wuhan-Hu-1 reference genome.
- We can use the software `mafft` to produce a multiple sequence alignment. The option `--addfragments` is used to produce an alignment against the reference genome. 
- The software `iqtree` can be used for inferring trees from an alignment using maximum likelihood. This software supports a wide range of _substitution models_ and a method to identify the model that maximizes the likelihood of the data.
- Some of the substituion models that have been used to build global SARS-CoV-2 phylogenies are "GTR+G" and "GTR+I". 
- Before building a phylogeny, we should be careful to _mask_ problematic sites that can lead to misleading placements of samples in the tree. The [SARS-CoV-2 Problematic Sites repository](https://github.com/W-L/ProblematicSites_SARS-CoV2) provides with an updated list of sites that should be masked.

:::
