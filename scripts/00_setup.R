# 00_setup.R — Load packages and set project paths
# Run from project root so that paths are project-relative.

if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
if (!requireNamespace("gapminder", quietly = TRUE)) install.packages("gapminder")

library(tidyverse)
library(gapminder)

# Project-relative paths: assume run from project root (e.g. Rscript scripts/02_make_figures.R)
PROJECT_ROOT <- "."

OUTPUT_DIR <- file.path(PROJECT_ROOT, "output")
if (!dir.exists(OUTPUT_DIR)) dir.create(OUTPUT_DIR, recursive = TRUE)

message("Setup: packages loaded, output dir = ", OUTPUT_DIR)
