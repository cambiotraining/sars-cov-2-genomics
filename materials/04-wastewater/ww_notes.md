---
pagetitle: "SARS Genomic Surveillance"
---

# Wastewater surveillance

- Links
  - https://doi.org/10.3201/eid2908.221634
  - https://en.ssi.dk/covid-19/national-surveillance-of-sars-cov-2-in-wastewater
  - https://link.springer.com/article/10.1007/s10096-023-04590-0
  - https://wastewater-observatory.jrc.ec.europa.eu/


- Cheaper than clinical testing
- Not everyone will come to a clinical setting to get tested, but everybody goes to the toilet
- A single sample captures many people
- Several pathogens can be found (potentially)
- Includes marginalised or isolated populations
- High population coverage
- Possible to compare results across geographical regions
- Cost effective, fast and flexible
- Supplement to other surveillance systems
  - Wastewater surveils everyone in a population - but no distinction between those that have symptoms or not
  - Clinical captures only those that cause disease symptoms (or severe hospitalisations)
- Gives distribution of variants circulating in population
  - these variants might be different from the variants circulating in clinical cases (causing symptoms)
- Where to sample and how often?
  - Depends on the goals
  - E.g. to surveil local outbreaks need to do sampling in more locations (local wastewater treatment plants); for regional surveillance only a few key treatment plants in the country; for national surveillance even fewer.
  - Need to consider the population density, e.g. how many people live in each catchment area of a wastewater plant.
- Challenges
  - results cannot be translated to exact number of infected individuals
  - not as intuitive to interpret
  - sources of variation such as shedding, dilution, degradation
  - sensitivity can be low
- In Denmark
  - They have samplers setup next to the plant
  - Usually take proportional samples, i.e. wastewater is collected in proportion to the inflow to the treatment plant (more water is sampled when there is more flow). 
  - Samples collected in two 24h periods per week.
  - In the lab the main objective is to estimate concentration of SARS-CoV-2 in the sample
  - Sample is purified and RNA extracted, then used for RT-qPCR
- The qPCR results are converted to RNA-copies equivalent. The trend is plotted over time.
  - For reporting they classify the trend over 3 weeks into categories "strong decrease", "decrease", "stable", "increase", "strong increase" --> to facilitate communication with stakeholders
- Wastewater surveillance is a good indication of the underlying incidence of SARS-CoV-2 in the population
  - They had very high testing rates at some point, which allowed them to compare the wastewater to the clinical


**Sample preparation in the lab**

- Purification of samples
- Wastewater samples are highly variable
- Season and catchment area can also affect physiochemical properties of the samples
  - Dilution (rainy season), salt, pH, organic matter, retention time in sewage pipes
- No one method is optimal for every sample
- Viral concentration is very low
  - viral concentration is the most important step in wastewater sample prep
- Common methods of concentration:
  - precipitation
    - polyethylene glycol precipitation - shields molecules and viruses from water and allows precipitating them
    - pros: cheap, no special equipment
    - cons: long protocol, hard to reproduce
  - ultracentrifugation
    - uses a filter that catches larger molecules
    - pros: simple protocol and easy to implement
    - cons: filters can clog, organic material is also retained
  - direct capture / lysis
    - lyse the particles such as viruses, and then get RNA/DNA material using either a silica column membrane (to capture nucleic acids) or magnetic beads to bind DNA/RNA.
    - Pros: captures also already lysed particles; it uses modified standard labs
    - Cons: chemical properties of the sample can affect recovery; co-precipitation of PCR inhibitors
  - adsorption-elution
    - binding viral particles to a solid-phase - e.g. a membrane, beads or mesh
    - pros: can be scaled well
    - cons: more expensive and specialised equipment may be required
- Different concentration techniques are used in the field of wastewater surveillance - there is no "best" method really
- After concentration most extraction protocols can be used. The basic steps are:
  - Lysis (detergent, protease)
  - Bind RNA to either beads of membrane (column-based)
  - Wash
  - Elute
- Removal of PCR inhibitors is key
  - This can be done using either a dilution series and seeing if the drop in cycles is as predicted
  - or you can add a known standard to the sample and compare the Ct value for it compared to the SARS-CoV-2 to see if there is inhibition (something like that, I think?)
- Limit centrifugation before processing, because the virus binds to organic matter, so will loose some virus in the process
- Saturation of purification may lead to underestimation of viral concentration
- When setting up a surveillance lab, it's a good idea to test different protocols to pick the one that is most effective
  - make sure to test across different treatment plants and different times of year - to account for variation
  - just taking a method from a paper may not be the best approach for your setting
- Can also spike the samples with a known virus to assess the quality of the extraction. 
  - they don't do it because they have automated and optimised protocols quite a lot, so didn't find it necessary


**Analysis, QC and automation**

- Fluorescent probe-based real-time PCR
- A probe with a fluorescent report is added to the mix
- The polymerase also has an exonuclease activity, which cleaves the reporter from the probe, releasing it from the quencher and thus releasing signal
- This method can be multiplex (using different fluorofores)
- Ct value is estimated
  - A standard curve is used to convert the Ct values to RNA concentration (using dilution series from panels with known concentration)
- Multiple genes used for their quantification - multiplex 3-4 PCR targets
- Sampling (e.g. pipetting) will affect the final quantification
  - see https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5496743/
- Technical replicates are highly recommended in this case, because of the limit of detection
- How can we convert viral concentration to the number of people that it came from?
  - There are ways to normalise for this, but one method to do it is using molecular markers that you add to the reaction
  - Nucleic acid markers for population: 
    - PMMoV - only humans consume pepper
    - CrAssphage - common in the human gut
    - bacteroids - enterobacteria
    - RNase P or mitochondrial DNA - something that is excreted by humans in high quantity
  - Note that using these markers are used for normalisation between samples, but you cannot back-calculate how many people contributed to the sample. So, it accounts for things like dilution due to rain, or variations in population density over time (e.g. in coastal areas, where density increases in holiday).
- Quality control
  - having a standard is important - having samples with known numbers of viral copies is essential to build standard curves
  - use stable reference samples - e.g. a circular plasmid that is stable; using a reference sample when building standard curves will allow seeing if something is odd, e.g. RNAse degradation that shifts the curve down (even though at first sight it might look like a nice straight line)
- Automation
  - consistency between samples over time
  - use robot liquid handler to do most work
  - lots of investment up front, but saves time, avoids sample mixup, long-term consistency


**Processing of RT-qPCR data**

- The data we start with is: 
  - date, location, sample ID, target gene, technical replicate name (they always do 3 techs), Cq or Ct value, RNA copies per well
  - The RNA copies per well is calculated from standard curves - this is the value they use in analysis
- Analysis
  - Take average of the 3 technical replicates
  - Transform copies_per_well to copies_per_l:
    - `copies_per_l = copies_per_well * 2000`
    - log10-transform data
  - normalise results - they have two SARS markers, N1 and N2, and the normaliser PMMoV. Their normalisation formula is: `log10_sars_faeces = (log10(N1) + log10(N2))/2 - log10(PMMoV)`
    - basically the average of the two markers (which they call `log10_sars`) minus the PMMoV. Because we are on log-scale these are effectively a LFC
  - For interpretation, they then back-transform the number: `10^log10_sars_faeces * 10^7`; the 10^7 is just to bring the number to a sensible scale
- Other variables are recorded such as flow into the plant, precipitation, temperature
- Population data is also used by pairing number of inhabitants within each catchment area
- The population data can be used to then calculate a weighted average

**Normalisation**

- Variation in the composition of wastewater needs to be considered when normalising data
- Several factors: 
  - number of people using the sewage system
  - e.g. in Copenhagen 2022 they had tour de France, which massively increased the number of tourists in the region
  - rain, precipitation, groundwater all influence outcome
  - the amount of industry around the catchment area also has big influence
- Normalising both by the amount of flow that comes into the treatment plant and the population in the area, different treatment plants can be compared
- For flow normalisation we need flow measurements from the wastewater treatment plant.
  - only accounts for dilution, but not for number of shredders
  - flow often not available, however no additional analysis is required in the lab
- For faecal normalisation we need an extra PCR reaction in the lab (e.g. for the PPMoV, CrAssphage, etc.)
  - only this normalisation takes into account variations in the population density
  - this normalisation indirectly also accounts for dilution effects
- A good faecal indicator needs to be something that is consistent in the shedding, and that only comes from humans.
- Can do just faecal normalisation, although they usually calculate both normalised values to compare the two estimates.

**Wastewater sequencing**

- Why sequence wastewater?
  - Depends on the pathogen
    - e.g. monitoring poliovirus can assess whether we have vaccine-derived or wild-type poliovirus circulating
    - for SARS-CoV-2 we can get idea of circulating variants, emerging variants
- Which technology? There's different pros and cons
  - Illumina: more accurate, short reads
  - ONT: less accurate, long reads
  - Ion Torrent: accuracy in-between, short reads
  - But also portability and yield also things to consider
- Denmark:
  - ONT sequencing of 1049bp amplicon of the S gene
  - Map to references of S genes of different variants
  - However this was limiting as it didn't allow distinguishing fine-resolution distinction of variants
  - Later setup Illumina WGS
- Sample prep:
  - cDNA synthesis using random hexamer primers
  - then two pools A and B, to use ARTIC protocol
- Wastewater samples is tricky
  - fragmented genomes
  - low concentration
  - PCR inhibitors
  - Mix of different variants
  - Low mapping rates not uncommon
- Freyja demix output
  - coverage should be greater than 50% (that seems too low to me...)
- Lineage abundance estimates can sometimes be limited by the depth of coverage
  - If you have low coverage, freyja may assign an equal estimate to several lineages that share those variants. 
  - If we increase min depth used by freyja, then we are increasing our resolution for abundance estimate, but we may include less of the genome. So, it's a trade-off.
  - Can also set a filter for minimum lineage abundance to be reported, but then we need to be aware that we've set that threshold, so we will not get some potentially rare variants reported. 
- Challenges
  - Level of resolution
    - we want to capture the diversity, but not exagerate it
  - How do we normalise across sites?
    - E.g. if we have 10% abundance in one site and 70% in another site, what is the average?
    - Catchment areas will have different numbers of inhabitants
    - Number of mapped reads does not reflect that variation
    - Should we take viral load of the sample or number of mapped reads in the sample into account?
  - Sometimes there are discrepancies between what is detected with Freyja and what is seen with clinical samples, in particular for low-frequency lineages
    - Deeper sequencing is needed to catch those less abundant lineages


Trainers:

- Amanda Qvesel (bioinformatics) - amqv@ssi.dk

