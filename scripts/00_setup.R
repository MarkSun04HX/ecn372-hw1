# 00_setup.R — Load packages and set project paths
# Run from project root so that paths are project-relative.



library(tidyverse)
library(gapminder)

# Project-relative paths (no absolute paths)
PROJECT_ROOT <- if (interactive() && length(commandArgs(trailingOnly = TRUE)) == 0) {
  rstudioapi::getActiveProject()
} else {
  # When run via Rscript, assume we're in project root or set by caller
  "."
}
if (is.null(PROJECT_ROOT) || PROJECT_ROOT == "") PROJECT_ROOT <- "."

OUTPUT_DIR <- file.path(PROJECT_ROOT, "output")
if (!dir.exists(OUTPUT_DIR)) dir.create(OUTPUT_DIR, recursive = TRUE)

message("Setup: packages loaded, output dir = ", OUTPUT_DIR)
