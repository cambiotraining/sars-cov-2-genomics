# load packages
library(tidyverse)
library(patchwork)

# real frequencies
x <- letters[c(rep(1, 5), rep(2, 10), rep(3, 10), rep(4, 25), rep(5, 50))]

# Take 10 samples of size N each
set.seed(20240216)
N <- 10
sim <- lapply(1:10, function(i){
  out <- x |>
           sample(N, replace = TRUE) |> 
           table() |> prop.table() |> 
           as.data.frame()
  out$sample <- as.character(stringr::str_pad(i, 2, pad = 0))
  names(out) <- c("variant", "frequency", "sample")
  return(out)
  })
sim <- do.call(rbind, sim)

# add the truth
temp <- x |> 
  table() |> 
  prop.table() |> 
  as.data.frame() |> 
  transform(rep = "truth")
names(temp) <- c("variant", "frequency", "sample")
sim <- rbind(temp, sim)

# visualise
sim |> 
  ggplot(aes(sample, frequency)) +
  geom_col(aes(fill = variant)) +
  scale_fill_manual(values = c("#95AAD3", "#C195C4", "#3A68AE", "#C25757", "#94C47D")) +
  theme_classic()
  

# Illustrating sampling
example <- data.frame(sample = x)
example <- crossing(x = 1:10, y = 1:10) |> 
  cbind(example)

set.seed(20240216)
p1 <- example |> 
  ggplot(aes(x, y, colour = sample)) +
  geom_point()
  
p2 <- example |> 
  sample_frac(0.5) |> 
  ggplot(aes(x, y, colour = sample)) +
  geom_point()

p3 <- example |> 
  sample_frac(0.5) |> 
  sample_frac(0.8) |> 
  ggplot(aes(x, y, colour = sample)) +
  geom_point()

p4 <- example |> 
  sample_frac(0.5) |> 
  sample_frac(0.8) |> 
  sample_frac(0.8) |> 
  ggplot(aes(x, y, colour = sample)) +
  geom_point()

# assemble
(p1 | p2 | p3 | p4) + 
  plot_layout(guides = "collect")  &
  coord_equal(xlim = c(1, 10), ylim = c(1, 10)) &
  scale_colour_manual(values = c("a" = "#95AAD3", 
                                 "b" = "#C195C4", 
                                 "c" = "#3A68AE", 
                                 "d" = "#C25757", 
                                 "e" = "#94C47D")) &
  theme_void() &
  theme(panel.border = element_rect(fill = NA))


# uncertainty in the estimated frequencies
# using Jeffreys interval estimation using the Beta
crossing(freq = c(0.01, 0.05, 0.1, 0.5, 0.9), depth = seq(10, 1000, 1)) |> 
  mutate(lo = qbeta(0.025, depth*freq+0.5, depth*(1-freq)+0.5),
         hi = qbeta(0.975, depth*freq+0.5, depth*(1-freq)+0.5)) |> 
  ggplot(aes(depth, freq)) +
  geom_line(aes(colour = factor(freq))) +
  geom_ribbon(aes(ymin = lo, ymax = hi, fill = factor(freq)), alpha = 0.3) +
  theme_bw() +
  scale_fill_viridis_d() + scale_colour_viridis_d() +
  scale_x_continuous(breaks = seq(0, 10000, 200)) +
  scale_y_continuous(breaks = seq(0, 1, 0.2)) +
  labs(x = "Sequencing depth", y = "Estimated frequency\n(95% confidence interval)",
       subtitle = "Decrease in uncertainty as sequencing depth increases",
       colour = "Starting\nfrequency", fill = "Starting\nfrequency")

# uncertainty interval for a variant at 50% frequency
crossing(freq = 0.5, depth = seq(10, 2000, 1)) |> 
  mutate(lo = qbeta(0.025, depth*freq+0.5, depth*(1-freq)+0.5),
         hi = qbeta(0.975, depth*freq+0.5, depth*(1-freq)+0.5)) |> #View()
  ggplot(aes(depth, hi - lo)) +
  geom_line(aes(group = factor(freq)), linewidth = 2) +
  theme_bw() +
  scale_colour_viridis_d() +
  scale_x_continuous(breaks = seq(0, 10000, 200)) +
  labs(x = "Sequencing depth", y = "Uncertainty\n(95% interval range)",
       subtitle = "Non-linear decrease in uncertainty as sequencing depth increases")

# probability of detecting a variant with at least 5 reads
# assuming different starting frequencies and total read depth
crossing(freq = c(0.01, 0.05, 0.1, 0.5, 0.9), depth = seq(10, 2000, 1)) |> 
  mutate(detect = 1 - pbinom(4, depth, freq)) |> 
  # filter(depth < 400) |> 
  ggplot(aes(depth, detect)) +
  geom_line(aes(colour = factor(freq)), linewidth = 2) +
  theme_bw() +
  scale_colour_viridis_d() +
  scale_x_continuous(breaks = seq(0, 2000, 200)) +
  scale_y_continuous(breaks = seq(0, 1, 0.2)) +
  labs(x = "Sequencing depth", y = "Probability of detection\n(minimum 5 reads)",
       subtitle = "High sequencing depth is required to detect rare variants",
       colour = "Starting\nfrequency")


#### Simulation ####

# real frequencies
x <- letters[c(rep(1, 1), rep(2, 5), rep(3, 10), rep(4, 25), rep(5, 59))]

# Each sample of size N each
set.seed(20240216)
depths <- c(250, 500, 1000, 2000, 4000)

# function to estimate the variant frequencies from a vector
# freqs is a vector of variant frequencies to sample from
# depth is the total sequencing depth - i.e. sample size
sample_variants <- function(freqs, depth){
  if (length(freqs) < 1 | sum(freqs) != 1){
    stop("freqs has to be of length > 1 and add up to 1.")
  }
  # variants is a vector of same length as the frequencies provided
  variants <- letters[1:length(freqs)]
  freqs <- sample(variants, depth, replace = TRUE, prob = freqs) |> 
           table() |> prop.table() |> 
           as.data.frame()
  names(freqs) <- c("variant", "frequency")
  return(freqs)
}

# simulate
nsim <- 10000  # number of simulations
freqs <- c(0.01, 0.05, 0.1, 0.25, 0.59) # starting frequencies
depths <- c(50, 250, 500, 1000, 2000)
sim <- lapply(1:nsim, function(i){
  out <- lapply(depths, function(d){
    out <- sample_variants(freqs, d)
    out$sim <- i
    out$depth <- d
    return(out)
  })
  out <- do.call(rbind, out)
})
sim <- do.call(rbind, sim)
sim$variant <- as.character(sim$variant)

sim |> 
  ggplot(aes(frequency)) +
  geom_density(aes(colour = factor(variant))) +
  geom_vline(xintercept = freqs) +
  facet_grid(~ depth)

sim |> 
  group_by(depth, variant) |> 
  summarise(detected = sum(frequency > 0)/1000,
            lo = quantile(frequency, 0.025),
            hi = quantile(frequency, 0.975)) |> 
  ggplot(aes(factor(depth), detected)) +
  geom_col(aes(fill = factor(variant)), position = "dodge")
  
sim |> 
  group_by(depth, variant) |> 
  summarise(detected = sum(frequency > 0)/1000,
            lo = quantile(frequency, 0.025),
            hi = quantile(frequency, 0.975)) |> 
  ggplot(aes(factor(depth))) +
  geom_errorbar(aes(ymin = lo, ymax = hi, colour = factor(variant)), 
                position = "dodge") +
  geom_hline(yintercept = freqs, colour = "grey") +
  theme_classic()
