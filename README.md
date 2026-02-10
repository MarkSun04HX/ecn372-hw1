# ECN372 — HW 1

Replicate any two figures in this repository.

---

## Repo structure

- **`README.md`** — This file; assignment description and replication instructions.
- **`AI_USAGE.md`** — Log of AI (Cursor) usage as required by the assignment.
- **`scripts/`**
  - **`00_setup.R`** — Loads `tidyverse` and `gapminder`, creates project-relative `OUTPUT_DIR` (`output/`).
  - **`01_data_prep.R`** — Builds `gapminder_2007` (year == 2007) for Figure 1 and other figures as needed.
  - **`02_make_figures.R`** — Entry point: sources setup and data prep, then produces PDFs in `output/`.
- **`output/`** — Generated figure PDFs (e.g. `figure-1-bubble-trends.pdf`).

## Exact replication instructions

From the **project root** (the folder containing `README.md` and `scripts/`), run:

```bash
Rscript scripts/02_make_figures.R
```

This installs `tidyverse` and `gapminder` if missing, prepares data, and writes `output/figure-1-bubble-trends.pdf`. No absolute paths are used.

## Process explanation (reverse‑engineering)

Figure 1 was replicated from the written spec in this README (no reference PDF was in the repo). The gapminder dataset has `country`, `continent`, `year`, `lifeExp`, `pop`, and `gdpPercap`, so we filtered to `year == 2007` in `01_data_prep.R`. For the plot we used a scatter of `gdpPercap` (x, log scale) vs `lifeExp` (y), mapped `size = pop` with `scale_size_area()` so point area represents population, then added an overall trend with `geom_smooth(..., aes(group = 1))` and within-continent trends with `geom_smooth(aes(group = continent, color = continent))` (loess, no SE ribbons). Work was split across the three scripts: setup in `00_setup.R`, data prep in `01_data_prep.R`, and figure construction in `02_make_figures.R`. When a second figure is added, the same workflow will be extended and this section can be updated.

---

The goal is to practice
  - data manipulation using `tidyverse` functionality
  - visualization using `ggplot2`
  - using reproducible workflows.

## What you’re replicating

Choose **any two** of the following:

- **`figure-1-bubble-trends.pdf`**
  - 2007 scatter of GDP per person (log scale) vs life expectancy
  - **Point area = population**
  - Trend lines: overall + within continent
- **`figure-2-ribbon-median-weighted.pdf`**
  - Life expectancy over time within each continent
  - **Ribbon = country-level IQR (25th–75th percentile) each year**
  - Lines for **median** and **population‑weighted mean**
- **`figure-3-dumbbell-gains.pdf`**
  - Dumbbell-style comparison of life expectancy in **1952 vs 2007**
  - **Top 8 countries per continent by life expectancy increase**
  - Labels show **years gained**
- **`figure-4-heatmap.pdf`**
  - Heatmap of life expectancy over time
  - **Top 12 countries per continent (by population in 2007)**
- **`figure-5-trajectories.pdf`**
  - “Development paths” over time
  - GDP per person (log scale) vs life expectancy, with year progression
  - Each facet is a country (**top‑2 by population per continent in 2007**)

**Data:** All figures are based on the `gapminder` dataset (from the **`gapminder` R package**).

## Deliverables (what must be in your repo)
Your public GitHub repository **must be named** `ecn372-hw1` and must include:

- **All code** used to generate your two figures (no manual editing of output files).
- **Two output figure files** (PDF) saved in an `output/` subfolder.
- A top-level **`README.md`** that includes:
  - **Repo structure** (what each folder/script is for).
  - **Exact replication instructions** (what to run in the terminal to reproduce all desired project outputs).
  - A **1–2 paragraph explanation** of how you figured out how to replicate the figures (your reverse‑engineering process).
- **AI usage documentation** (see “Using Cursor AI” below).
  - Put this in `AI_USAGE.md` (recommended) or a clearly labeled section of your `README.md`.

## Replicability requirements (non‑negotiable)
When I clone your repo on my machine, I should be able to reproduce your figures using a single command in my terminal (based on your replication instructions).

- **No absolute paths** (e.g., no `/Users/you/...`). Use project‑relative paths.
- **One clear entry point** that builds the figures (e.g., `Rscript scripts/make_figures.R`).
- Your `README.md` must include **exact commands** to reproduce results.
  
## Suggested repo structure (you can adapt)
You can organize your project however you want, but a clean structure helps replication. Example:

```text
ecn372-hw1/
  README.md
  renv.lock                  # if using renv
  scripts/
    00_setup.R               # optional: setup helpers
    01_data_prep.R           # optional: cleaning/summaries
    02_make_figures.R        # required: produces your two output files
  output/
    figure-?.pdf
    figure-?.pdf
  AI_USAGE.md                # required documentation of AI use
```

## Using Cursor AI (encouraged, with strict documentation)
You are **explicitly encouraged** to use Cursor’s AI agents/chat for anything (debugging, ggplot ideas, dplyr transformations, theming, etc.) **as long as you document it precisely**.

Your **AI usage log** must include, for each meaningful AI interaction:

- **Tool/context** (e.g., Cursor Chat, Agent, inline edit)
- **Your prompt** (copy/paste)
- **What the AI suggested** (short summary or pasted excerpt)
- **What you actually used/changed** (be specific; mention files/functions)
- **Any verification** you did (e.g., “ran script; figure regenerated; compared to reference”)

### Minimal template (copy/paste into `AI_USAGE.md`)
```text
## AI Usage Log

### YYYY-MM-DD — Figure X: [short description]
- Tool: [Cursor Chat / Agent / inline edit / etc.]
- Prompt: "[paste your prompt]"
- Output summary: [what the AI suggested]
- What I used: [what you actually implemented, with file names]
- Verification: [how you verified it worked]
```

Using AI does not reduce your responsibility. You must understand and be able to explain the code you submit.

## Grading (example rubric)
- **Replicability (40%)**: repo runs from README steps; environment pinned; clean paths; outputs generated.
- **Figure replication quality (40%)**: correct data filters/summaries, geoms, scales (e.g., log GDP), facets, legends/labels; “close enough” aesthetics.
- **Code quality (10%)**: readable, commented, sensible file organization.
- **README + process explanation + AI documentation (10%)**: clear structure, clear narrative of how you reverse‑engineered, complete AI log.

