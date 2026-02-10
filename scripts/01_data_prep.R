# 01_data_prep.R — Prepare data for figures (filter 2007, etc.)
# Expects to be sourced after 00_setup.R (from project root).

# Filter to 2007 for Figure 1 (bubble-trends)

source("scripts/00_setup.R")

gapminder_2007 <- gapminder %>%
  filter(year == 2007)

message("Data prep: gapminder_2007 has ", nrow(gapminder_2007), " rows.")
