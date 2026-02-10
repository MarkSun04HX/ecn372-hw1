# ECN372 — HW 1: Gapminder Figure Replication

This repository replicates two figures from the gapminder dataset using R, ggplot2, and dplyr.

## Repo Structure

- **`scripts/00_setup.R`** — Loads packages (tidyverse, gapminder, scales); creates output directory.
- **`scripts/01_data_prep.R`** — Filters and aggregates gapminder data for figures (2007 snapshot, continent-year summaries).
- **`scripts/02_make_figures.R`** — Entry point: sources setup and data prep, then generates two PDFs in `output/`.
- **`output/`** — Generated figure PDFs: `fig1_bubble_trends.pdf` and `figure-2-ribbon-median-weighted.pdf`.
- **`AI_USAGE.md`** — Log of all AI interactions used in development.

## Exact Replication Instructions

From the **project root**, run:

```bash
Rscript scripts/02_make_figures.R

```
   (This requires R with packages `tidyverse` and `gapminder` to replicate process)

## Process explanation

To replicate Figure 1 (Bubble Trends), I first observed the specification: a 2007 scatter plot with GDP per capita on the x-axis (log scale) and life expectancy on the y-axis, where each country's point has an area proportional to its population, colored by continent, with both overall and within-continent trend lines. I broke down these visual elements into ggplot2 components and wrote prompts to Cursor AI describing each requirement: "Create a scatter plot with size mapped to population using scale_size_area(), add a log-scale x-axis with dollar formatting, draw an overall trend line in black, then overlay continent-specific trend lines with continent colors." Cursor AI generated the complete geom_point(), scale_size_area(), scale_x_log10() with custom labeling function, and dual geom_smooth() layers. I then iteratively refined styling (legend sizes, theme, axis labels) by describing visual problems to GitHub Copilot and having it produce fixes.

For Figure 2 (Ribbon-Median-Weighted), I identified the core requirements by observing the specification: a line plot showing life expectancy trends over time within each continent, with a shaded ribbon representing the interquartile range (IQR, 25th–75th percentile) of country-level data, and two overlaid lines showing the median (blue, solid) and population-weighted mean (red, dashed). I described the data aggregation needed to GitHub Copilot: "Group gapminder by continent and year, calculate Q1, Q3, median, and population-weighted mean of life expectancy for each group." It produced the dplyr pipeline with group_by(), summarise(), and weighted.mean(). I then prompted it to "Build a ggplot with geom_ribbon for IQR, geom_line for median and weighted mean with different colors and linetypes, facet by continent with appropriate labels and caption." Copilot generated the full visualization, and I refined annotations and styling through follow-up prompts describing desired changes to colors, dash lengths, titles, and data attribution.



## AI usage

See **`AI_USAGE.md`** for the log of AI tool use.