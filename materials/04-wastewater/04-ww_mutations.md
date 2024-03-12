---
pagetitle: "SARS Genomic Surveillance"
---

# Mutation Analysis

:::{.callout-caution}

Under development

:::


## Mutation Frequency Visualisation

TODO - using R to read the mutations long table and make some heatmap-style visualisations


## Mutation co-occurrence

As mentioned, low-frequency lineages pose a challenge in the analysis of mixed samples, as it becomes difficult to distinguish their presence from technical background noise (e.g. due to sequencing errors). 
An approach to help distinguish errors from the true presence of a rare lineage is to look for mutations that co-occur in the same read or read pair. 
As it would be very unlikely that two (or more) errors would occur in exactly the same read pair, the presence of co-occurring mutations provide a high-confidence signal that the respective lineage is present in the sample. 

This approach requires that the lineages of interest have enough distinguishing mutations within close proximity to each other (i.e. in the same PCR amplicon). 

Another application of co-occurring mutations is to provide a stronger evidence for new emerging lineages.
If the same pattern of co-occurring mutations is observed across multiple samples and at increasing frequencies over time, it may be cause for concern and require close monitoring.
See, for example, the study of [Jahn et al 2022](https://doi.org/10.1038/s41564-022-01185-x), where they demonstrate that co-occurring mutations characteristic of the Alpha variant were detected in wastewater samples from two Swiss cities around 2 weeks before its first report from clinical samples.

Can use some R code to visualise them (although a bit ugly due to parsing): 

```r
library(tidyverse)
theme_set(theme_classic())

covar <- read_tsv("results/covariants.tsv") %>% 
  janitor::clean_names()

covar %>% 
  mutate(covarid = factor(1:n())) %>% 
  separate_longer_delim(covariants, " ") %>% 
  mutate(pos = str_remove(covariants, "^[C,A,T,G,\\(]") %>% str_remove("[C,A,T,G,\\)].*$") %>% as.numeric()) %>% 
  mutate(covariants = fct_reorder(covariants, pos)) %>% 
  group_by(covarid) %>% 
  filter(n() > 1) %>% 
  ungroup() %>% 
  ggplot(aes(covarid, covariants)) +
  geom_tile(aes(fill = freq), colour = "grey") +
  scale_fill_viridis_c(limits = c(0, 1))
```

