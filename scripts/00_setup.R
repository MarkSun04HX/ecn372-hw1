# ============================================================================
# 00_setup.R — Load packages and set project paths
# ============================================================================
# Purpose:
#   Initialize the R environment by loading required packages and establishing
#   project-relative paths for reproducible analysis. This script should be
#   sourced first before running any downstream analysis scripts.
#
# Key Functions:
#   - Loads tidyverse and gapminder packages
#   - Sets up OUTPUT_DIR for saving figures and outputs
#   - Ensures all paths are project-relative (no absolute paths)
#
# Usage:
#   source("scripts/00_setup.R")  # From project root
#
# Dependencies:
#   - tidyverse package (data manipulation and visualization)
#   - gapminder package (example dataset)
#   - rstudioapi package (optional, for RStudio project detection)
#
# Author: Created via AI assistant
# Date: 2025-02-09
# Last Modified: 2026-02-10
# ============================================================================

# Load required packages
# tidyverse: meta-package containing ggplot2, dplyr, tidyr, and other tools
# gapminder: dataset with life expectancy, GDP, and population by country/year
library(tidyverse)
library(gapminder)

# ============================================================================
# PROJECT PATH CONFIGURATION
# ============================================================================
# This section determines the project root directory in a way that works
# across different execution contexts (RStudio, Rscript, interactive R).
#
# Logic:
#   1. If running interactively in RStudio with no command-line args:
#      → Use rstudioapi::getActiveProject() to detect RStudio project
#   2. Otherwise (Rscript, R CMD BATCH, or interactive without RStudio):
#      → Default to "." (current working directory)
#   3. Fallback: If PROJECT_ROOT is NULL or empty, set to "."
#
# Note: This approach assumes scripts are run from the project root.
# ============================================================================

PROJECT_ROOT <- if (interactive() && length(commandArgs(trailingOnly = TRUE)) == 0) {
  # Running interactively in RStudio without CLI arguments
  # Use RStudio's project detection if available
  rstudioapi::getActiveProject()
} else {
  # Running via Rscript, R CMD BATCH, or in non-RStudio R environment
  # Assume current working directory is project root
  "."
}

# Safety check: ensure PROJECT_ROOT is never NULL or empty string
if (is.null(PROJECT_ROOT) || PROJECT_ROOT == "") PROJECT_ROOT <- "."

# ============================================================================
# OUTPUT DIRECTORY SETUP
# ============================================================================
# Create project-relative output directory for saving figures, tables, and
# other generated outputs. This keeps the working directory clean and
# organizes all outputs in one place.
#
# Logic:
#   1. Define OUTPUT_DIR as "output" subdirectory relative to PROJECT_ROOT
#   2. Check if directory exists; if not, create it (recursive = TRUE
#      allows creation of parent directories if needed)
#   3. Log confirmation message
#
# Important: All downstream scripts should reference OUTPUT_DIR when saving
#            files to ensure portability across systems/directories.
# ============================================================================

OUTPUT_DIR <- file.path(PROJECT_ROOT, "output")

# Create output directory if it doesn't exist
if (!dir.exists(OUTPUT_DIR)) {
  dir.create(OUTPUT_DIR, recursive = TRUE)
}

# Log confirmation that setup is complete
message("Setup: packages loaded, output dir = ", OUTPUT_DIR)

# ============================================================================
# END OF SETUP
# ============================================================================
# At this point:
#   - tidyverse and gapminder are loaded and ready for use
#   - PROJECT_ROOT points to the project's root directory
#   - OUTPUT_DIR points to output/ subdirectory and exists
#   - All paths are project-relative for reproducibility
#
# Next steps: Source 01_data_prep.R to load and prepare the gapminder data.
# ============================================================================