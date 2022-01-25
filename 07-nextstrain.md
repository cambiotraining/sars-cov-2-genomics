---
pagetitle: "SARS-CoV-2 Genomics"
---

# Reporting and Communication

::: highlight

**Questions**

- How can I produce a summary report for my analysis?
- (this would be cool - perhaps having some example reports from NVAP) How can I communicate my analysis to non-bioinformatician decision makers?

**Learning Objectives**

- Use `civet` to produce a report that contextualises sequences in the wider SARS-CoV-2 phylogeny, highlights variants of interest/concern, and produce time-resolved visualisations of those variants.
- Use _Nexttrain_ to... 

:::


## Nextclade

:::note
<details><summary>Installing `nextclade`</summary>

You can install both these programs using _Conda_ (more about this package manager in [Reproducible Workflows](08-nextflow_conda_setup.html)).
For example, we can add it to an environment called "covid19":

```console
$ mamba install --name covid19 nextclade
```

We can then activate this environment by running `conda activate covid19`, making the program available to use. 

</details>
:::

Nextclade can be used to analyse our sequences against the reference genome, assign sequences to clades and identify potential quality issues.
This is a complementary analysis to what can be obtained with _Pangolin_, enriching our insights into the data. 
The output of _Nextclade_ can be used with an interactive visualisation environment called _Auspice_. 

There are two main ways to use _Nextclade_:

- Through their web interface at [clades.nextstrain.org](https://clades.nextstrain.org)
  - Select "SARS-CoV-2" and click "Next"
  - Click "Select a file" to browse your computer and upload the FASTA file with all your consensus sequences.
  - Click "Run"
- Through a command-line tool, which is detailed below.

We can start by checking information about available data for SARS-CoV-2 provided by _Nextclade_:

```console
$ nextclade dataset list --name sars-cov-2
```

The output of this command will inform us that we can run the following command to obtain the current (most up-to-date) version of the dataset:

```console
$ nextclade dataset get --name 'sars-cov-2' --output-dir 'data/sars-cov-2'
```

This command downloads data used by `nextclade` to compare our sequences with a pre-computed tree of publicly available sequences (so-called [reference tree](https://docs.nextstrain.org/projects/nextclade/en/stable/user/terminology.html#reference-tree-concept)). 

Now that we have downloaded our data, we are ready to run our `nextclade` analysis:

```bash
nextclade run \
   --in-order \
   --input-fasta results/pangolin/all_sequences.fa \
   --input-dataset data/sars-cov-2/ \
   --include-reference \
   --output-dir results/nextclade \
   --output-basename run1 \
   --output-json results/nextclade/run1.json \
   --output-tsv results/nextclade/run1.tsv \
   --output-tree results/nextclade/run1.auspice.json \
   --min-length 27000
```

We can now analyse the output from this analysis, by looking in our folder `ls results/nextclade`. 
We will see the following:

- `run1.aligned.fasta` - aligned nucleotide sequences.
- `run1.gene.*.fasta` - aligned peptides.
- `run1.tsv` - analysis results, including clade assignment and several quality-control metrics.
  - `run1.json` - analysis results in a machine-readable format.
- `run1.auspice.json` - phylogenetic tree in a format that is compatible with [_Auspice_](https://auspice.us/) for interactive visualisation.
- `run1.insertions.csv` - nexclade removes insertions so that they no longer appear in the aligned peptide sequences. This CSV file contains the position and sequence of all those insertions.
- `run1.errors.csv` - CSV file with of errors and warnings for each sequence.


Possibly we can run Augur to add metadata (e.g. date) for pretier display on Auspice: 
https://docs.nextstrain.org/projects/augur/en/stable/usage/cli/filter.html




:::exercise

- Load the output from _Nextclade_ into _Auspice_
- Filter the data by "Node type -> New" 
- What can you conclude in terms of the types of variants in the data? Does this agree with previous analysis from _Pangolin_?
- In the bottom panel of the viewer there is a plot of "Diversity", which shows sites where there is substantial variation in the population of samples. Check one of these positions in the S protein (spike protein). 
- Compare these positions with the known mutations in the Delta variant (image below).
- Open the peptide alignment for the S protein in AliView and scroll to the position you highlighted in the previous step to confirm this change. 

![Mutations in the Delta variant Spike protein. (source: Wikipedia)](https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/SARS-CoV-2_Delta_variant.svg/6878px-SARS-CoV-2_Delta_variant.svg.png)

:::

:::note

When using auspice.us the data does not leave your computer, so privacy concerns are not an issue. 

:::

:::note

Worth keeping these in mind:

```
# default values
--penalty-gap-extend 0 \
--penalty-gap-open 6 \
--penalty-gap-open-in-frame 7 \
--penalty-gap-open-out-of-frame 8 \
--penalty-mismatch 1 \
--score-match 3 \
--max-indel 400
```

The alignment between _Nextclade_ and _Pangolin_ is slightly different at the start and end of the sequences. 
This is because _Pangolin_ masks the first 265bp and last 229bp of each sequence (confirm - empirically this seems to be the case; presumably this is done because assembly quality is generally lower there?).

### Metadata

We can add metadata CSV which triggers the geographic panel. 
If we provide latitude and longitude it plots the samples on the map.
I don't know if having "Region" and "Country" also triggers this. 

## Nextstrain

This is more complex to setup in terms of input files, although very useful because we can then visualise things across time and geographically. 
Docs here: https://docs.nextstrain.org/projects/ncov/en/latest/analysis/index.html

:::

## Summary

:::highlight

**Key Points**

- one
- two

:::
