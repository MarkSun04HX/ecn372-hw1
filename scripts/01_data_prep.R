# ============================================================================
# 01_data_prep.R — Prepare data for figures (filter for year 2007, etc.)
# ============================================================================
# Purpose:
#   Preprocess the gapminder dataset for analysis and figure creation.
#   Specifically, filters the dataset to year 2007 (for Figure 1) and creates
#   an in-memory data frame `gapminder_2007` for downstream analysis/plotting.
#
# Usage:
#   Should be run (or sourced) after 00_setup.R, from the project root.
#   Typical call: source("scripts/01_data_prep.R") from within scripts/02_make_figures.R
#
# Dependencies:
#   - scripts/00_setup.R — must establish project paths and load packages before this step
#   - gapminder package (dataset already loaded via setup)
#
# Author: Created via AI assistant
# Date: 2025-02-09
# Last Modified: 2026-02-10
# ============================================================================

# ============================================================================
# SETUP: ENSURE PACKAGES AND PATHS ARE INITIALIZED
# ============================================================================
# This statement loads all required packages and sets up paths. It must be
# sourced before using any variables or packages established in setup.
# Always keep this at the top of the script to maintain dependency order.
#
# By calling source("scripts/00_setup.R") here, we ensure:
#   1. tidyverse and gapminder packages are loaded
#   2. PROJECT_ROOT is properly detected (RStudio vs Rscript context)
#   3. OUTPUT_DIR exists and is accessible
source("scripts/00_setup.R")

# ============================================================================
# (RE-)DEFINE PROJECT-RELATIVE PATHS (DEFENSIVE SAFETY CHECK)
# ============================================================================
# Defensive step: if this script is run stand-alone or not from 02_make_figures.R,
# ensure essential objects are defined. This avoids path bugs and ensures
# OUTPUT_DIR exists, especially if the calling context is unknown.
#
# Logic:
#   1. Set PROJECT_ROOT to "." (project root is current working directory)
#      -- Ensures compatibility when run via: Rscript scripts/01_data_prep.R
#   2. Recompute OUTPUT_DIR using project-relative path
#   3. Create OUTPUT_DIR if it doesn't exist (recursive = TRUE)
#   4. Log confirmation message for reproducibility tracking/troubleshooting
#
# Note: This is redundant with 00_setup.R if sourced from the pipeline,
#       but harmless and ensures robustness if this script is called in
#       isolation or from a different working directory.
# ============================================================================

PROJECT_ROOT <- "."
OUTPUT_DIR <- file.path(PROJECT_ROOT, "output")
if (!dir.exists(OUTPUT_DIR)) dir.create(OUTPUT_DIR, recursive = TRUE)
message("Setup: packages loaded, output dir = ", OUTPUT_DIR)

# ============================================================================
# DATA PREPARATION: FILTER GAPMINDER DATA TO 2007
# ============================================================================
# Creates the gapminder_2007 dataset used in downstream scripts (e.g., for
# figure replication and analysis). This is the primary input for Figure 1
# (bubble-trends scatter plot with trend lines).
#
# Filter specification:
#   - Data source: gapminder (loaded in 00_setup.R)
#   - Condition: Only include records where year == 2007
#   - Result: gapminder_2007 — a tibble with 142 countries' 2007 data
#
# Tidyverse approach:
#   - Uses pipe operator (%) for readability
#   - filter() from dplyr package to select rows
#   - Result is kept in-memory (not written to disk) for fast access
#
# Dataset structure (gapminder_2007):
#   - country: character vector (country names)
#   - continent: character vector (continent assignment)
#   - year: integer vector (all values = 2007)
#   - lifeExp: numeric vector (life expectancy in years)
#   - pop: numeric vector (population)
#   - gdpPercap: numeric vector (GDP per capita in USD)
# ============================================================================

gapminder_2007 <- gapminder %>%
  filter(year == 2007)

# Log row count of filtered dataset for verification
# Useful for:
#   - Confirming data was filtered correctly
#   - Documenting dataset size for reproducibility reports
#   - Troubleshooting if filters are modified in future iterations
message("Data prep: gapminder_2007 has ", nrow(gapminder_2007), " rows.")

# ============================================================================
# END OF DATA PREPARATION
# ============================================================================
# At this point, the R environment now contains:
#   - All packages loaded (tidyverse, gapminder)
#   - PROJECT_ROOT and OUTPUT_DIR defined and verified
#   - gapminder_2007: a in-memory filtered dataset ready for plotting
#
# Next steps in the pipeline:
#   - scripts/02_make_figures.R sources this file and uses gapminder_2007
#     to create Figure 1 (bubble-trends scatter + trend lines)
#   - Plots are saved to OUTPUT_DIR (output/) as PDF files
#
# Manual use:
#   - If you want to explore gapminder_2007 interactively:
#     source("scripts/01_data_prep.R")
#     head(gapminder_2007)
#     summary(gapminder_2007)
# ============================================================================