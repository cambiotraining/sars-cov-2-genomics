---
pagetitle: "SARS-CoV-2 Genomics"
---

# Lineage Assignment and Variant Classification

::: highlight

**Questions**

- What are the main variant annotation conventions for SARS-CoV-2?
- How can I assign sequences to lineages and classify them as variants of interest/concern?
- How can I visually explore the results of my variant analysis?

**Learning Objectives**

- Understand variant annotation conventions used by Gisaid, Pango, Nextstrain and WHO and how they relate to each other. 
- Assign sequences to Pango lineages using `pangolin`.
- Interactively explore mutations in the assembled genomes and their phylogenetic context using _Nexstrain_'s tools.

:::


:::note
This section has an accompanying <a href="https://docs.google.com/presentation/d/1rRrsHD6v0a9kH9MYxJZNMw56dRKAeLxgNjdG9w7Bic4/edit?usp=sharing" target="_blank">slide deck</a>.
:::


## SARS-CoV-2 Variants

As viruses (or any other organism) evolve, random DNA changes occur in the population, for example due to replication errors.
Many of these changes are likely to be _neutral_, meaning that they do not change the characteristics of the virus in any significant way. 
Neutral changes tend to _drift_ in the population, increasing or decreasing in frequency in a random way, but most likely end up disappearing due to their low starting frequency in the population. 

On the other hand, _advantageous mutations_ can occur, which lead to changes in the characteristics of the virus that are beneficial for its spread in the population (e.g. high transmissibility, resistance to immune response or vaccines, etc.). 
Such beneficial mutations will therefore experience _positive selection_, potentially leading to their increase in frequency in the population as they spread to more and more hosts. 

Viruses carrying those advantageous mutations may, over time, aquire other advantageous mutations that further increase their fitness and, therefore, their frequency in the population.
One way to visualise this is by looking at a _phylogenetic tree_ showing the relationship between sequences (based on their similarity) and how groups of sequences change over time.

![Example of global phylogeny from the [Nextstrain public server](https://nextstrain.org/ncov/gisaid/global). Colours show different Nextstrain clades. (Screenshot taken Feb 2022)](images/lineages_example.svg)

In the figure above, which shows SARS-CoV-2 samples from across the world, we can see groups of similar sequences rapidly "expanding" at certain points in time. 
Such groups of sequences, which share a collection of DNA changes, are referred to as SARS-CoV-2 _variants_ (see box below about the ambiguous meaning of this term).
In an effort to understand the spread of the virus and monitor situations of increased occurrence of such variants, several groups and institutions have developed a system to classify groups of SARS-CoV-2 sequences as _variants of interest_ and _variants of concern_. 

A full explanation and definitions of such variants is given in the [World Health Organisation (WHO) variants page](https://www.who.int/en/activities/tracking-SARS-CoV-2-variants)
The main classification systems currently in use are: 

- [GISAID clades](https://www.gisaid.org/references/statements-clarifications/clade-and-lineage-nomenclature-aids-in-genomic-epidemiology-of-active-hcov-19-viruses/)
- [Nextstrain clades](https://nextstrain.org/blog/2020-06-02-SARSCoV2-clade-naming)
- [Pango lineages](https://cov-lineages.org/lineage_list.html)
- [World Health Organisation (WHO) variants](https://www.who.int/en/activities/tracking-SARS-CoV-2-variants)

In practice, there is a big overlap between these different nomenclature systems, with WHO variants having a direct match to Pango lineages and Nextstrain clades. 
In fact, the different teams work together to try and harmonise the nomenclature used, and thus facilitate the interpretation of sequence analysis.

:::note
**What is a variant?**

It is important to note that the term _variant_ can be sometimes ambiguous. 

The term "**SARS-CoV-2 variant**" usually refers to the [WHO definition of variants of concern/interest](https://www.who.int/en/activities/tracking-SARS-CoV-2-variants/) (e.g. the Alpha, Delta and Omicron variants), which includes sequences containing a _collection of several nucleotide changes_ that characterise that group.
According to this definition, we have two variants in the example below (samples 1 & 2 are one variant and samples 3 & 4 another variant).

![](images/variants_snps_indels.svg)

However, in bioinformatic sequence analysis, a **sequence variant** refers to an individual change in the DNA sequence (a SNP or an insertion/deletion). 
Using this definition, in the example above we have 5 variants: 3 SNPs and 2 indels. 
In the [Consensus Sequence](04-artic_nextflow.html) section, we mentioned one of our workflow steps was "variant calling". 
This was the definition of variant we were using: identifying individual SNPs and/or indels relative to the reference genome, from our sequencing data.
This is also reflected in the one of the common file formats used to store SNP/indel information, the [_VCF_ file](https://en.wikipedia.org/wiki/Variant_Call_Format), which means "Variant Call Format". 

Sometimes the term "mutation" is used to refer to SNP/indel variants.
For example see this [definition from the COG consortium](https://www.cogconsortium.uk/what-do-virologists-mean-by-mutation-variant-and-strain/). 

Because of this ambiguity, the terms "lineages" or "clades" are often used instead of "variants" when referring to groups of similar SARS-CoV-2 sequences, because they have a phylogenetic interpretation.
:::

## Pangolin

<img src="https://cov-lineages.org/assets/images/pangolin_logo.svg" alt="Pangolin" style="float:right;width:20%">

The first tool we will use is called `pangolin` and uses the [Pango nomenclature system](https://cov-lineages.org/).
The main steps performed by this tool are:

- Multiple sequence alignment of our samples against the _Wuhan-Hu-1_ reference genome, using the `minimap2` software.
- Assigning our sequences to lineages based on the current global phylogeny. Two methods/software are available:
  - _pangoLEARN_ (default) uses a pre-trained machine learning model.
  - _UShER_ uses a more classic parsimony-based method, but highly optimised for working with large numbers of sequences.
- Classifying our sequences according to the WHO nomenclature of variants of interest/concern using the `scorpio` software.

Because `pangolin` uses a series of tools and models internally (which change over time as more sequences become available), it is useful to know which versions are being used in the current analysis.
To do this, we can run the command:

```console
$ pangolin --all-versions
```

```
pangolin: 3.1.17
pangolearn: 2021-11-25
constellations: v0.0.30
scorpio: 0.3.15
pango-designation used by pangoLEARN/Usher: v1.2.101
pango-designation aliases: 1.2.112
```

To run _Pangolin_ we can use the following syntax:

```bash
pangolin --outdir directory/of/your/choice --outfile name_of_your_choice.csv path/to/your/sequences.fasta
```

:::exercise

Go to the course materials directory `03-lineages` (on our training machines `cd ~/Course_Materials/03-lineages`). 
There you will find a directory called `data`, which contains a file called `all_sequences.fa`, containing both UK and India samples that we processed in the [Consensus Assembly section](04-artic_nextflow.md).

To run `pangolin` on our sequences with default options, we would use the following command: 

```bash
pangolin --outdir results/pangolin/ --outfile uk_india_report.csv data/all_sequences.fa
```

- Create a directory for the output.
- Look at the help documentation (`pangolin --help`) and modify the command above to add options for:
  - Using _UShER_ for placing sequences on the phylogeny (instead of the default, which uses _pangoLEARN_).
  - Output the multiple sequence alignment generated during the analysis.
  - Use 8 CPUs (or "threads") for parallel processing.
- Run the modified command on the terminal. (**Bonus:** save the command in a new shell script for reproducibility.)
- Using the file explorer <i class="fa-solid fa-folder"></i>, open the results CSV file and:
  - Check whether there any variants of concern (these are found in the column called `scorpio_call`).
  - Check whether there are any problematic samples.

<details><summary>Answer</summary>

The first thing we should do is create the output directory for our results, and also a directory for our scripts: 

```bash
mkdir -p results/pangolin/
mkdir scripts/
```

We can look at the tool's help by using `pangolin --help`. 
From that documentation we can see the following three options that would do what we want:

- `--usher` uses the UShER algorithm to place our sequences in the global phylogeny.
- `--alignment` outputs the multiple sequence aligned from `minimap2` as a FASTA file.
- `--threads` allows us to use multiple CPUs for the computation.

Therefore, the command to run our analysis is:

```bash
pangolin --usher --alignment --outdir results/pangolin/ --outfile uk_india_report.csv --threads 8 data/all_sequences.fa
```

From VS Code, we could save this command in a script (File > New File) and save it in the `scripts` folder with the filename `pangolin.sh` (or another informative name of your choice). 

We can open the `uk_india_report.csv` file on our spreadsheet software to look at the results. 
In the column called "scorpio_call" we can see several samples that were classified as "Alpha" and "Delta" variants. 
Looking at the column "status", we can see that one of the samples failed the quality control applied by `pangolin`. 
This is the nanopore sample `barcode01`, which we had already identified as being slightly problematic, with a high percentage of ambiguous 'N' bases. 

</details>

:::


:::note
**Lineage assignment: _USHER_ or _pangoLEARN_?**

`pangolin` can use two different methods to place our sequences in the background global phylogeny.
Both methods are extremely efficient and designed to work with thousands (or millions) of sequences and generally give comparable results. 
_pangoLearn_ is faster than _UShER_, but the latter seems to perform better in the presence of missing data [reference needed].
:::


## Nextclade

<img src="https://raw.githubusercontent.com/nextstrain/nextclade/master/docs/assets/nextstrain_logo.svg" alt="Nextstrain" style="float:right;width:10%">

Another system of clade assignment is provided by `nextclade`, which is part of the broader software ecosystem [_Nextstrain_](https://clades.nextstrain.org/). 
This is a complementary analysis to what can be obtained with _Pangolin_, enriching our insights into the data. 

_Nextclade_ does similar steps as _Pangolin_, with some differences in the algorithms that are used:

- Each sequence is aligned with the _Wuhan-Hu-1_ reference genome using a local alignment algorithm.
- Samples are placed in the global phylogeny using a distance-based metric (placing the sequence on the tree where it has the highest similarity with).
- Clade assignment is done based on the previous phylogeny placement step.

You can find more details about _Nextclade_'s methods on [its documentation](https://docs.nextstrain.org/projects/nextclade/en/stable/user/algorithm/index.html).
_Nextclade_ also provides several quality control metrics, which are very useful to identify problematic samples. 

There are two main ways to use _Nextclade_:

- Through a web interface, which is easier to use, but cannot be configured or automated.
- Through a command line interface, which gives us more control over the analysis and can be included in a shell script to automate our analysis.


### Web Interface

_Nextclade_ offers a convenient interface, which can be used to run the default analysis on a set of sequences:

- Go to [nextclade.org](https://clades.nextstrain.org/)
- Select **SARS-CoV-2** and click **Next**
- Click **Select a file** to browse your computer and upload the FASTA file with the cleaned consensus sequences (`data/all_sequences.fa`).
- Click **Run**

Nextclade will show a progress of its analysis at the top of the page, and the results of several quality control metrics in the main panel (see Figure). 

![Overview of the Nextclade web interface.](images/nextclade_overview.svg)


:::exercise

Now that we have loaded our consensus sequences to [nextclade.org](https://clades.nextstrain.org/), answer the following questions:

1. Are there any samples that were classified as "bad" quality? If so, what is the main reason for their low quality? How does this relate with your previous look at the sequencing coverage in these datasets? <details><summary>Hint</summary>Use the data filters to help you answer this question.</details>
1. Can you identify any sequences classified as a WHO variant of concern? Does this agree with the previous analysis from _Pangolin_? <details><summary>Hint</summary>Although this information is available in the main panel, it might be easier to switch to the Phylogeny view, using the button on the top-right.</details>
1. The image below shows the positions of the mutations that characterise the Delta variant. On the Nextclade browser, select "Protein S" and in the right panel confirm that those mutations occur in the sequences classified as Delta. <details><summary>Hint</summary>To make this exploration easier, try filtering your samples for clade "21".</details>

<div class="figure">
  <a href="https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/SARS-CoV-2_Delta_variant.svg/6878px-SARS-CoV-2_Delta_variant.svg.png" target="_blank">
    <img align="center" src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/SARS-CoV-2_Delta_variant.svg/6878px-SARS-CoV-2_Delta_variant.svg.png"/>
  </a>
  <p class="caption">
    Mutations in the Delta variant Spike protein. The position of each mutation relative to the Wuhan-Hu-1 reference genome is shown. For example: "T19R" means that a T (Threonine) changed to a R (Arginine) in position 19 of the protein; "Δ157-158" means that there is a deletion in position 157-158 of the protein. Click the image to open a larger size. (source: [Wikipedia](https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/SARS-CoV-2_Delta_variant.svg/6878px-SARS-CoV-2_Delta_variant.svg.png))
  </p>
</div>



<details><summary>Answer</summary>

**A1.**

To look at how many samples are classified as different quality categories, we can use the filter button on the top-right 
<svg stroke="grey" fill="grey" stroke-width="0" viewBox="0 0 512 512" height="15" width="15" xmlns="http://www.w3.org/2000/svg"><path d="M487.976 0H24.028C2.71 0-8.047 25.866 7.058 40.971L192 225.941V432c0 7.831 3.821 15.17 10.237 19.662l80 55.98C298.02 518.69 320 507.493 320 487.98V225.941l184.947-184.97C520.021 25.896 509.338 0 487.976 0z"></path></svg>
.
We can tick/untick based on the way _Nextclade_ classified the sequences in quality categories.
By selecting only those samples that have "Bad Quality", we can see that nearly all of them are from the nanopore data. 
One of the main errors is due to too much missing data (ambiguous bases, "N"). 
We can see these as grey boxes in the variant panel on the right. 

**A2.**

In the column **Clade** we can see which clades each sequence was assigned to, following _Nextclade_'s own nomenclature. 
However, we also get information about the WHO variants of concern, which use the greek alphabet nomenclature. 
We can see "Alpha" and "Delta" variants in the data. 
This is perhaps even better visualised in the phylogeny view, by pressing the
<svg width="20" height="25"><g transform="translate(0,2)"><svg width="20" height="20" viewBox="16 19 27 22"><g id="Group" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" transform="translate(17.000000, 20.000000)"><polyline id="Path-3" stroke="#222" points="2.94117647 12.8571429 2.94117647 18.6083984 17.8459616 18.6083984 17.8459616 16.0260882 24.870031 16.0260882"></polyline><polyline id="Path-4" stroke="#222" points="17.8500004 18.5714286 17.8500004 20 25.0119374 20"></polyline><polyline id="Path-5" stroke="#222" points="2.94117647 12.8571429 3.00303284 7.21191058 10.2360102 7.11220045 10.4159559 2.99881623 17.1561911 2.93803403 17.1561911 0 24.313534 0"></polyline><polyline id="Path-6" stroke="#222" points="17.1599998 2.85714286 17.1599998 4.28571429 24.512941 4.28571429"></polyline><path d="M0,12.8571429 L2.94117647,12.8571429" id="Path-6" stroke="#222"></path><polyline id="Path-7" stroke="#222" points="10.2941176 7.14285714 10.2941176 11.4285714 24.5454676 11.4285714"></polyline></g></svg></g></svg>
phylogeny button on the top-right.

From there, we can see several variants classifed as "Delta" and "Alpha". 
Looking at some specific ones, we can see they are the same samples that _Pangolin_ identified as variants of concern. 
For example, sample ERR5921254 is classified as "21J (Delta)" by _Nextclade_ and as "Delta (AY.4-like)" by _Pangolin/Scorpio_.


**A3.**

Going back to the main panel, we can use the 
<svg stroke="grey" fill="grey" stroke-width="0" viewBox="0 0 512 512" height="15" width="15" xmlns="http://www.w3.org/2000/svg"><path d="M487.976 0H24.028C2.71 0-8.047 25.866 7.058 40.971L192 225.941V432c0 7.831 3.821 15.17 10.237 19.662l80 55.98C298.02 518.69 320 507.493 320 487.98V225.941l184.947-184.97C520.021 25.896 509.338 0 487.976 0z"></path></svg>
filter button to show only sequences from clade "21" (this includes "21J", "21I" and "21A", which are all sub-clades of _Delta_).

Comparing the mutation panel on the right with the mutations available from _Wikipedia_, we can see that they are all present in our sequences. 
Some other mutations seem to be more specific to the sub-clades. 
For example "A222V" seems to be specific to clade "21I".

</details>

:::


:::note
When using the _Nextclade_ web tools, the data does not leave your computer, so privacy concerns are not an issue. 
:::


### Command-line Interface

To use the command line interface of _Nextclade_ we need to first download "background" data, which will be used to classify and integrate our samples in the global phylogeny. 

We can check the available data for SARS-CoV-2 by running:

```console
$ nextclade dataset list --name sars-cov-2
```

The output of this command will inform us that we can run the following command to obtain the current (most up-to-date) version of the background dataset:

```console
$ nextclade dataset get --name sars-cov-2 --output-dir resources/nextclade_dataset
```

This command downloads data used by `nextclade` to compare our sequences with a pre-computed tree of publicly available sequences (so-called [reference tree](https://docs.nextstrain.org/projects/nextclade/en/stable/user/terminology.html#reference-tree-concept)). 

Now that we have downloaded our data, we are ready to run our `nextclade` analysis:

```bash
nextclade run \
   --in-order \
   --input-fasta data/all_sequences.fa \
   --input-dataset resources/nextclade_dataset/ \
   --include-reference \
   --output-dir results/nextclade \
   --output-basename uk_india \
   --output-json results/nextclade/uk_india.json \
   --output-tsv results/nextclade/uk_india.tsv \
   --output-tree results/nextclade/uk_india.auspice.json \
   --min-length 27000
```

The result from this analysis will generate several files in the output folder `results/nextclade`: 

- `uk_india.aligned.fasta` - aligned nucleotide sequences.
- `uk_india.gene.*.fasta` - aligned peptides.
- `uk_india.tsv` - analysis results, including clade assignment and several quality-control metrics.
  - `uk_india.json` - analysis results in a machine-readable format.
- `uk_india.auspice.json` - phylogenetic tree in a format that is compatible with [_Auspice_](https://auspice.us/) for interactive visualisation.
- `uk_india.insertions.csv` - nexclade removes insertions so that they no longer appear in the aligned peptide sequences. This CSV file contains the position and sequence of all those insertions.
- `uk_india.errors.csv` - CSV file with of errors and warnings for each sequence.

These files are equivalent to what the web-tool we used in the previous section gave us as the results. 

We can visualise the result of this analysis by uploading the `*.auspice.json` file to [auspice.us](https://auspice.us/).
In addition, we can upload a metadata table, which can be helpful to further explore our data. 

:::exercise

Go to [auspice.us](https://auspice.us/) and drag-and-drop the `uk_india.auspice.json` file onto the browser window. 
This should open a phylogeny panel, similar to what we previously obtained with the Web interface. 

Drag-and-drop our sample metadata file (stored in `sample_info_nextclade.csv`) into the browser window. 
This will add this metadata to the interactive view, including a new map panel showing the location of our samples.

Take some time to explore your data using this tool. 

:::

:::note
Nextclade adds the suffix "_new" to our sample names, so we created a new metadata file where we changed the name of our samples to include "_new" in their name as well. 
This is needed when adding metadata to our results on [auspice.us](https://auspice.us/).
Apart from that, the file is exactly the same as the `sample_info.csv` file we have been using so far. 
:::

:::exercise

_Nextclade_ also outputs the protein sequences for each of the SARS-CoV-2 genes. 
We can visualise these with the program AliView. 

<img src="https://avatars.githubusercontent.com/u/7050126?s=200&v=4" alt="Nextstrain" style="float:right;width:5%">

- Open AliView (this program's icon is shown on the right)
- Go to "File > Open File" and navigate to "Course_Materials > 03-lineages > results > nextclade" to open the file "uk_india.gene.S.fasta"
- Can you see the mutations characteristic of the Delta variant? (see image below)

<div class="figure">
  <a href="https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/SARS-CoV-2_Delta_variant.svg/6878px-SARS-CoV-2_Delta_variant.svg.png" target="_blank">
    <img align="center" src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/SARS-CoV-2_Delta_variant.svg/6878px-SARS-CoV-2_Delta_variant.svg.png"/>
  </a>
  <p class="caption">
    Mutations in the Delta variant Spike protein. Click image to open larger size. (source: [Wikipedia](https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/SARS-CoV-2_Delta_variant.svg/6878px-SARS-CoV-2_Delta_variant.svg.png))
  </p>
</div>

<details><summary>Answer</summary>

AliView allows us to interactively visualise a FASTA file with protein or DNA alignments. 

To help us explore these data, we can right-click the first sequence (Wuhan-Hu-1 reference) and choose "Set this sequence as template when Highlighting difference". 
This will make it easier to see aminoacid differences in our samples. 

We can scroll to the right to see that several samples contain the mutation at position 19 changing a T to an R, at position 157 there is a deletion and a change to a G, at position 452 a change from L to R, etc.

If we look at these samples' names, they match the classification obtained with Nextclade and Pangolin as being the Delta variant. 

</details>

:::

<!--
The alignment between _Nextclade_ and _Pangolin_ is slightly different at the start and end of the sequences. 
This is because _Pangolin_ masks the first 265bp and last 229bp of each sequence (confirm - empirically this seems to be the case; presumably this is done because assembly quality is generally lower there?).
-->


## Summary

:::highlight

**Key Points**

- Groups of similar SARS-CoV-2 sequences are classified into lineages or clades by different groups. The main nomenclature systems in use are _Nextstrain_, _Pangolin_ and _GISAID_. 
- In addition, the World Health Organisation (WHO) classifies some forms of SARS-CoV-2 as _variants of concern_ or _variants of interest_. These are forms of the virus that have been determined to have a significant public health impact. 
- The software `pangolin` can be used to assign consensus sequences to lineages and WHO variants.
- _Nextclade_ can also be used to assign sequences to clades and WHO variant classification. _Nextclade_ can be run from a web interface and the command line (`nextclade`). 

:::

