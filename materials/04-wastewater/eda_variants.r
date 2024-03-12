library(tidyverse)
theme_set(theme_classic())

vars <- read_csv("./preprocessed/viralrecon/variants//ivar/variants_long_table.csv") |> 
  janitor::clean_names()

meta <- read_csv("sample_info.csv")

vars <- vars |> 
  full_join(meta, by = "sample") |> 
  mutate(sample = fct_reorder(sample, date),
         gene = fct_reorder(gene, pos))

p <- vars |> 
  filter(dp > 10 & effect == "missense_variant") |> 
  group_by(pos) |> 
  filter(any(af > 0.5) & n_distinct(sample) >= 3) |> 
  group_by(sample, date, pos, alt, gene) |> 
  summarise(freq = mean(af)) |> 
  ungroup() |> 
  ggplot(aes(factor(pos), sample)) +
  geom_tile(aes(fill = freq)) +
  facet_grid(~ gene, scale = "free_x", space = "free_x") +
  scale_fill_continuous(limits = c(0, 1)) +
  scale_x_discrete(guide = guide_axis(angle = 45))

p

plotly::ggplotly(p)


# Tidy Freyja variants

lineages <- read_csv("results/tidyfreyja/lineage_abundances.csv")

lineages |> 
  group_by(sample, abundance) |>
  filter(n() > 1)
