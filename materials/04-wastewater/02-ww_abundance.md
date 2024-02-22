---
pagetitle: "SARS Genomic Surveillance"
---

# Wastewater surveillance

:::{.callout-caution}

Under development

:::


## Bioinformatic analysis

![](images/workflow_wastewater_overview.svg)

The command to run our analysis is very similar to what was explained in the [consensus assembly of clinical isolates](../02-isolates/01-consensus.md): 

```bash
nextflow run nf-core/viralrecon \
  -r dev -profile singularity \
  --platform illumina \
  --input SAMPLESHEET_CSV \
  --outdir OUTPUT_DIRECTORY \
  --protocol amplicon \
  --genome 'MN908947.3' \
  --primer_set artic \
  --primer_set_version PRIMER_VERSION \
  --skip_assembly --skip_asciigenome \
  --skip_consensus
```

The key differences are: 

- `-r dev`: we are using the **development version** of the pipeline, which is not yet released as an official version. 
  The reason is that Freyja is currently (Feb 2024) only available in the development version. 
  Once a new version of the pipleine is released (>= 2.7), it should no longer be necessary to use the development version. 
- `--skip_consensus`: in this case we skip the generation of a consensus FASTA file. 
  Since wastewater samples are mixed, it doesn't make sense to generate a consensus FASTA file, as it would potentially include mutations from different lineages in the final consensus, creating artificial recombinant genomes.

### Depth threshold

There are [other options](https://nf-co.re/viralrecon/dev/parameters#skip_freyja) that can be specified with `viralrecon` to modify the default behaviour of Freyja. 
A couple that are worth highlighting are:

- `--freyja_depthcutoff` determines the minimum depth of sequencing for a site to be used in the Freyja analysis. The default '0', i.e. Freyja uses all the sites in its analysis, as long as at least 1 read is mapped to the reference. 
  This may seem insufficient, however recall that Freyja will use all the mutations across the genome, so as long as the average depth of sequencing is high enough (e.g. >100x), then even if some of the sites have low depth the accuracy of the final estimates might still be good. 

### Confidence intervals

- `--freyja_repeats` determines the number of bootstrap repeats used to estimate confidence intervals for the abundance estimates. The default is 100 bootstrap replicates, which should be fine to get an idea of the uncertainty of those estimates. However, this step is very computationally demanding, substantially increasing the time to run the analysis (it is, essentially, running the Freyja step 100 times for each sample). Therefore, it can sometimes be advantageous to "turn off" this option by setting `--freyja_repeats 1`. In that case, make sure to ignore the confidence intervals that are output by the pipeline.


## Output Files

After running the pipeline, we get several output files. 
These are very similar to what has been described for [clinical isolates](../02-isolates/02-qc.md). 
As a reminder, here are some files of interest:

- `multiqc/multiqc_report.html`: a MultiQC quality report, including information about average depth of coverage, fraction of the genome covered, number of mutations identified, etc. 
- `variants/bowtie2/`: directory with individual BAM files, which can be visualised with _IGV_ if we want to look at the reads mapped to the reference genome.
- `variants/ivar/variants_long_table.csv`: a CSV file with the aggregated results of all the mutations detected in each sample. 

The new directories of particular interest for wastewater analysis are:

- `variants/freyja/demix`: directory containing the output files from the `freyja demix` command, used to estimate lineage abundances.
- `variants/freyja/bootstrap`: directory containing the output files from the `freyja boot` command, used to get confidence intervals for the estimated lineage abundances.
- `variants/freyja/variants`: directory containing the output files from the `freyja variants` command, which includes all the variants (mutations) considered by Freyja in its lineage abundance calculations. These are somewhat redundant with the files in `variants/ivar/variants_long_table.csv`.


## Freyja Output

Freyja outputs files in a non-standard format. 
Here is an example from one of our samples: 

```
            SRR18541029.variants.tsv
summarized  [('Omicron', 0.9074885644836951), ('Delta', 0.04843510729864781), ('Other', 0.03151409250566481)]
lineages    BA.1 BA.1.1.8 BA.1.20 AY.116 BA.1.8 B.1.1.529 XS BA.1.1.17 XP XD BA.1.1.5 BA.1.1.10 AY.39 AY.46.1 AY.3.1
abundances  0.42763980 0.33859152 0.04909740 0.04170587 0.03905280 0.02662011 0.02634620 0.00904814 0.00811069 0.00516789 0.00476190 0.00456621 0.00277376 0.00206299 0.00189249
resid       13.531715333760909
coverage    98.86633448149016
```

Here is the meaning of each line from this file:

1. The name of the file
2. The frequency of variants of concern, which is added up based on the frequency of individual lineages.
3. The name of each individual lineage detected in the sample.
4. The corresponding frequencies of each lineage from the previous line, in descending order.
5. The "residual" variation left from the statistical model used to estimate the frequencies; this value does not have an easy interpretation. 
6. The percentage of the genome covered at 10x depth. We can also obtain this information from the regular MultiQC report.


## Mutation co-occurrence

As mentioned, low-frequency lineages pose a challenge in the analysis of mixed samples, as it becomes difficult to distinguish their presence from technical background noise (e.g. due to sequencing errors). 
An approach to help distinguish errors from the true presence of a rare lineage is to look for mutations that co-occur in the same read or read pair. 
As it would be very unlikely that two (or more) errors would occur in exactly the same read pair, the presence of co-occurring mutations provide a high-confidence signal that the respective lineage is present in the sample. 

This approach requires that the lineages of interest have enough distinguishing mutations within close proximity to each other (i.e. in the same PCR amplicon). 

Another application of co-occurring mutations is to provide a stronger evidence for new emerging lineages.
If the same pattern of co-occurring mutations is observed across multiple samples and at increasing frequencies over time, it may be cause for concern and require close monitoring.
See, for example, the study of [Jahn et al 2022](https://doi.org/10.1038/s41564-022-01185-x), where they demonstrate that co-occurring mutations characteristic of the Alpha variant were detected in wastewater samples from two Swiss cities around 2 weeks before its first report from clinical samples.




## Glossary

- WBE - wastewater-based epidemiology
- WWTP - wastewater treatment plants
- WGS - whole-genome sequencing