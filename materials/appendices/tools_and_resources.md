---
pagetitle: "SARS Genomic Surveillance"
---

# Tools and Resources {.unnumbered}

This page summarises several additional resources and software applications useful for SARS surveillance.


## Amplicon Primer Schemes {#sec-primer-schemes}

For amplicon sequencing, there are several protocols and commercial kits available.
We try to summarise some of the common ones below. 

### ARTIC

:::{.panel-tabset}
#### V5.3.2

ARTIC primer scheme version 5.3.2 ([link](https://github.com/artic-network/artic-ncov2019/tree/master/primer_schemes/nCoV-2019/V5.3.2)).

To analyse with `nf-core/viralrecon`, add these options to the command:

```bash
--genome 'MN908947.3' \
--primer_set artic \
--primer_set_version 5.3.2 \
--schema_ignore_params 'genomes,primer_set_version'
```

Or, alternatively, you can use the direct links to the FASTA/BED files: 

```bash
--fasta 'https://github.com/artic-network/artic-ncov2019/raw/master/primer_schemes/nCoV-2019/V5.3.2/SARS-CoV-2.reference.fasta' \
--gff 'https://github.com/nf-core/test-datasets/raw/viralrecon/genome/MN908947.3/GCA_009858895.3_ASM985889v3_genomic.200409.gff.gz' \
--primer_bed 'https://github.com/artic-network/artic-ncov2019/raw/master/primer_schemes/nCoV-2019/V5.3.2/SARS-CoV-2.scheme.bed'
```

#### V4.1

ARTIC primer scheme version 4.1 ([link](https://github.com/artic-network/artic-ncov2019/tree/master/primer_schemes/nCoV-2019/V4.1)).

To analyse with `nf-core/viralrecon`, add these options to the command:

```bash
--genome 'MN908947.3' \
--primer_set artic \
--primer_set_version 4.1
```

Or, alternatively, you can use the direct links to the FASTA/BED files: 

```bash
--fasta 'https://github.com/artic-network/artic-ncov2019/raw/master/primer_schemes/nCoV-2019/V4.1/SARS-CoV-2.reference.fasta' \
--gff 'https://github.com/nf-core/test-datasets/raw/viralrecon/genome/MN908947.3/GCA_009858895.3_ASM985889v3_genomic.200409.gff.gz' \
--primer_bed 'https://github.com/artic-network/artic-ncov2019/raw/master/primer_schemes/nCoV-2019/V4.1/SARS-CoV-2.scheme.bed'
```

#### V4

ARTIC primer scheme version 4 ([link](https://github.com/artic-network/artic-ncov2019/tree/master/primer_schemes/nCoV-2019/V4)).

To analyse with `nf-core/viralrecon`, add these options to the command:

```bash
--genome 'MN908947.3' \
--primer_set artic \
--primer_set_version 4
```

Or, alternatively, you can use the direct links to the FASTA/BED files: 

```bash
--fasta 'https://github.com/artic-network/artic-ncov2019/raw/master/primer_schemes/nCoV-2019/V4/SARS-CoV-2.reference.fasta' \
--gff 'https://github.com/nf-core/test-datasets/raw/viralrecon/genome/MN908947.3/GCA_009858895.3_ASM985889v3_genomic.200409.gff.gz' \
--primer_bed 'https://github.com/artic-network/artic-ncov2019/raw/master/primer_schemes/nCoV-2019/V4/SARS-CoV-2.scheme.bed'
```

#### V3

ARTIC primer scheme version 3 ([link](https://github.com/artic-network/artic-ncov2019/tree/master/primer_schemes/nCoV-2019/V3)).

To analyse with `nf-core/viralrecon`, add these options to the command:

```bash
--genome 'MN908947.3' \
--primer_set artic \
--primer_set_version 3
```

Or, alternatively, you can use the direct links to the FASTA/BED files: 

```bash
--fasta 'https://github.com/artic-network/artic-ncov2019/raw/master/primer_schemes/nCoV-2019/V3/nCoV-2019.reference.fasta' \
--gff 'https://github.com/nf-core/test-datasets/raw/viralrecon/genome/MN908947.3/GCA_009858895.3_ASM985889v3_genomic.200409.gff.gz' \
--primer_bed 'https://github.com/artic-network/artic-ncov2019/raw/master/primer_schemes/nCoV-2019/V3/nCoV-2019.primer.bed'
```

#### V2

ARTIC primer scheme version 2 ([link](https://github.com/artic-network/artic-ncov2019/tree/master/primer_schemes/nCoV-2019/V2)).

To analyse with `nf-core/viralrecon`, add these options to the command:

```bash
--genome 'MN908947.3' \
--primer_set artic \
--primer_set_version 2
```

Or, alternatively, you can use the direct links to the FASTA/BED files: 

```bash
--fasta 'https://github.com/artic-network/artic-ncov2019/raw/master/primer_schemes/nCoV-2019/V2/nCoV-2019.reference.fasta' \
--gff 'https://github.com/nf-core/test-datasets/raw/viralrecon/genome/MN908947.3/GCA_009858895.3_ASM985889v3_genomic.200409.gff.gz' \
--primer_bed 'https://github.com/artic-network/artic-ncov2019/raw/master/primer_schemes/nCoV-2019/V2/nCoV-2019.primer.bed'
```

#### V1

ARTIC primer scheme version 1 ([link](https://github.com/artic-network/artic-ncov2019/tree/master/primer_schemes/nCoV-2019/V1)).

To analyse with `nf-core/viralrecon`, add these options to the command:

```bash
--genome 'MN908947.3' \
--primer_set artic \
--primer_set_version 1
```

Or, alternatively, you can use the direct links to the FASTA/BED files: 

```bash
--fasta 'https://github.com/artic-network/artic-ncov2019/raw/master/primer_schemes/nCoV-2019/V1/nCoV-2019.reference.fasta' \
--gff 'https://github.com/nf-core/test-datasets/raw/viralrecon/genome/MN908947.3/GCA_009858895.3_ASM985889v3_genomic.200409.gff.gz' \
--primer_bed 'https://github.com/artic-network/artic-ncov2019/raw/master/primer_schemes/nCoV-2019/V1/nCoV-2019.primer.bed'
```

#### Midnight

Primers for the ["Midnight" protocol](https://www.protocols.io/view/34-midnight-34-sars-cov2-genome-sequencing-protoc-14egn2q2yg5d/v1), also known as "1200" as it produces fragments that are ~1200bp long.
This primer scheme is optimised for ONT platforms ([link](https://github.com/nf-core/test-datasets/raw/viralrecon/genome/MN908947.3/primer_schemes/artic/nCoV-2019/V1200/)).

To analyse with `nf-core/viralrecon`, add these options to the command:

```bash
--genome 'MN908947.3' \
--primer_set artic \
--primer_set_version 1200
```

Or, alternatively, you can use the direct links to the FASTA/BED files: 

```bash
--fasta 'https://github.com/nf-core/test-datasets/raw/viralrecon/genome/MN908947.3/primer_schemes/artic/nCoV-2019/V1200/nCoV-2019.reference.fasta' \
--gff 'https://github.com/nf-core/test-datasets/raw/viralrecon/genome/MN908947.3/GCA_009858895.3_ASM985889v3_genomic.200409.gff.gz' \
--primer_bed 'https://github.com/nf-core/test-datasets/raw/viralrecon/genome/MN908947.3/primer_schemes/artic/nCoV-2019/V1200/nCoV-2019.bed'
```
:::

### NEB VarSkip

:::{.panel-tabset}
#### 1a

NEB's VarSkip kit, primer version 1a ([link](https://github.com/nebiolabs/VarSkip/tree/main/schemes/NEB_VarSkip/V1a)).

For analysis with `nf-core/viralrecon` the direct link to the FASTA and BED files can be given: 

```bash
--fasta 'https://raw.githubusercontent.com/nebiolabs/VarSkip/main/schemes/NEB_VarSkip/V1a/NEB_VarSkip.reference.fasta' \
--gff 'https://github.com/nf-core/test-datasets/raw/viralrecon/genome/MN908947.3/GCA_009858895.3_ASM985889v3_genomic.200409.gff.gz' \
--primer_bed 'https://raw.githubusercontent.com/nebiolabs/VarSkip/main/schemes/NEB_VarSkip/V1a/NEB_VarSkip.scheme.bed'
```

#### 2a

NEB's VarSkip kit, primer version 2a ([link](https://github.com/nebiolabs/VarSkip/tree/main/schemes/NEB_VarSkip/V2a)).

For analysis with `nf-core/viralrecon` the direct link to the FASTA and BED files can be given: 

```bash
--fasta 'https://raw.githubusercontent.com/nebiolabs/VarSkip/main/schemes/NEB_VarSkip/V2a/NEB_VarSkip.reference.fasta' \
--gff 'https://github.com/nf-core/test-datasets/raw/viralrecon/genome/MN908947.3/GCA_009858895.3_ASM985889v3_genomic.200409.gff.gz' \
--primer_bed 'https://raw.githubusercontent.com/nebiolabs/VarSkip/main/schemes/NEB_VarSkip/V2a/NEB_VarSkip.scheme.bed'
```

#### 2b

NEB's VarSkip kit, primer version 2b ([link](https://github.com/nebiolabs/VarSkip/tree/main/schemes/NEB_VarSkip/V2b)).

For analysis with `nf-core/viralrecon` the direct link to the FASTA and BED files can be given: 

```bash
--fasta 'https://raw.githubusercontent.com/nebiolabs/VarSkip/main/schemes/NEB_VarSkip/V2b/NEB_VarSkip.reference.fasta' \
--gff 'https://github.com/nf-core/test-datasets/raw/viralrecon/genome/MN908947.3/GCA_009858895.3_ASM985889v3_genomic.200409.gff.gz' \
--primer_bed 'https://raw.githubusercontent.com/nebiolabs/VarSkip/main/schemes/NEB_VarSkip/V2b/NEB_VarSkip.scheme.bed'
```

#### Long 1a

NEB's VarSkip kit, primer version 1a, long primers ([link](https://github.com/nebiolabs/VarSkip/tree/main/schemes/NEB_VarSkip/V1a-long)).

For analysis with `nf-core/viralrecon` the direct link to the FASTA and BED files can be given: 

```bash
--fasta 'https://raw.githubusercontent.com/nebiolabs/VarSkip/main/schemes/NEB_VarSkip/V1a-long/NEB_VarSkip.reference.fasta' \
--gff 'https://github.com/nf-core/test-datasets/raw/viralrecon/genome/MN908947.3/GCA_009858895.3_ASM985889v3_genomic.200409.gff.gz' \
--primer_bed 'https://raw.githubusercontent.com/nebiolabs/VarSkip/main/schemes/NEB_VarSkip/V1a-long/NEB_VarSkip.scheme.bed'
```
:::

### Atoplex

[ATOPlex kit](https://en.mgi-tech.com/products/reagents_info/33/). 

For analysis with `nf-core/viralrecon` the direct link to the FASTA and BED files can be given: 

```bash
--fasta 'https://github.com/nf-core/test-datasets/raw/viralrecon/genome/NC_045512.2/GCF_009858895.2_ASM985889v3_genomic.200409.fna.gz' \
--gff 'https://github.com/nf-core/test-datasets/raw/viralrecon/genome/NC_045512.2/GCF_009858895.2_ASM985889v3_genomic.200409.gff.gz' \
--primer_bed 'https://github.com/nf-core/test-datasets/raw/viralrecon/genome/NC_045512.2/amplicon/nCoV-2019.atoplex.V1.bed'
```

### Illumina COVIDseq

:::{.panel-tabset}
#### COVIDseq

The original [COVIDseq kit](https://emea.illumina.com/products/by-type/ivd-products/covidseq.html) uses **ARTIC V3 primers**.

See section above for `nf-core/viralrecon` options.

#### COVIDseq (RUO version)

The [COVIDseq RUO version](https://emea.illumina.com/products/by-type/clinical-research-products/covidseq.html) uses **ARTIC V4 primers**.

See section above for `nf-core/viralrecon` options.
:::


### SWIFT / xGEN

The "[xGen SARS-CoV-2 Amplicon Panels](https://eu.idtdna.com/pages/products/next-generation-sequencing/workflow/xgen-ngs-amplicon-sequencing/predesigned-amplicon-panels/sars-cov-2-amp-panel)", previously called "SWIFT Normalase", is commercialised by IDT.
Unfortunately IDT does not make their BED files available publicly. 
If you purchase a kit from IDT, the company should provide you with the correct BED file to process your samples. 

**NOTE:** in the future we will provide a link to a BED file with _approximate_ coordinates, inferred bioinformatically. This can be useful if re-analysing public data. 


## Data Resources

- [outbreak.info](https://outbreak.info/) - interactive exploration of global SARS-CoV-2 data.
- [Nextstrain SARS-CoV-2 resources](https://nextstrain.org/sars-cov-2/) - analysis and datasets curated by the Nextrain team.
- Data portals:
  - [The European COVID-19 Data Platform](https://www.covid19dataportal.org/)
  - [NCBI SARS-CoV-2 Resources](https://www.ncbi.nlm.nih.gov/sars-cov-2/)
  - [GISAID](https://www.gisaid.org/)
- UK-specific resources:
  - [COVID-19 Genomics UK Consortium](https://www.cogconsortium.uk/tools-analysis/public-data-analysis-2/)
  - [COVID–19 Genomic Surveillance](https://covid19.sanger.ac.uk) built by the Wellcome Sanger Institute. 


## Web Tools

- [Taxonium](https://cov2tree.org/) - a tool for large tree visualisation.


## Other Courses

- [Mutation calling, viral genome reconstruction and lineage/clade assignment from SARS-CoV-2 sequencing data](https://training.galaxyproject.org/training-material/topics/variant-analysis/tutorials/sars-cov-2-variant-discovery/tutorial.html) - using the Galaxy platform.
- [The Power of Genomics to Understand the COVID-19 Pandemic](https://www.futurelearn.com/courses/genomics-covid-19) - a general introduction to the COVID-19 pandemic.
- [COVID-10 Data Analysis](https://www.climb.ac.uk/artic-and-climb-big-data-joint-workshop/) - ARTIC and CLIMB-BIG-DATA joint workshop with a series of lectures and tutorials available.
