# AI Usage Log

## 2025-02-09 — Figure 1: Bubble trends (setup + scripts + replication)

- **Tool:** Cursor Agent
- **Prompt:** (Paraphrased) Do as instructed in README: set up the three scripts under `scripts/`, make the image for figure 1 (2007 scatter GDP vs life expectancy, point area = population, trend lines overall + within continent), divide work across the three files, and record AI usage in `AI_USAGE.md`.
- **Output summary:** Agent created `scripts/00_setup.R` (packages + project-relative `OUTPUT_DIR`), `scripts/01_data_prep.R` (filter `gapminder` to year 2007 → `gapminder_2007`), and `scripts/02_make_figures.R` (source setup and data prep; build ggplot: scatter with `scale_x_log10()`, point size = `pop` via `scale_size_area()`, overall `geom_smooth(..., aes(group = 1))` and within-continent `geom_smooth(aes(group = continent, color = continent))`; save to `output/figure-1-bubble-trends.pdf`). Simplified x-axis to `scale_x_log10()` without custom label formatter to avoid scales package version issues. README was updated with repo structure and exact replication command.
- **What I used:** All of the above: the three scripts as written, with Figure 1 logic in `02_make_figures.R` using `gapminder_2007` from `01_data_prep.R`. No manual edits to the generated PDF.
- **Verification:** Ran `Rscript scripts/02_make_figures.R` from project root; script completed successfully and produced `output/figure-1-bubble-trends.pdf`. No absolute paths; single entry point as required.

## 2025-02-09 — Figure 1: Align with requirements (colors, linear trends, labels, title)

- **Tool:** Cursor Agent
- **Prompt:** (Paraphrased) Fix misalignment: (1) points for different continents should be different colors; (2) trend lines should be linear; (3) title = "Health and wealth across countries (2007)" with subtitle "Point area ∝ population; lines are fitted trends (overall + within continent)"; (4) y-axis label "Life expectancy (years)", x-axis label "GDP per person (log scale)". Record AI usage in AI_USAGE.md.
- **Output summary:** Agent updated `scripts/02_make_figures.R`: mapped point fill to continent via `aes(fill = continent)` and `scale_fill_brewer(palette = "Set1")`; changed both `geom_smooth` calls from `method = "loess"` to `method = "lm"`; set `labs(title = "...", subtitle = "...", x = "...", y = "...")` as specified. Subtitle text uses "proportional to" (not Unicode ∝) to avoid PDF encoding warnings. Added new AI usage log entry to AI_USAGE.md.
- **What I used:** All of the above: point colors by continent, linear fits, and the exact title, subtitle, and axis labels in `02_make_figures.R`; new entry in AI_USAGE.md.
- **Verification:** Re-run `Rscript scripts/02_make_figures.R` from project root to regenerate `output/figure-1-bubble-trends.pdf` and confirm points are continent-colored, lines are straight, and labels match.

## 2025-02-09 — Figure 1: Population legend, median reference lines, dollar x-axis, smaller fonts

- **Tool:** Cursor Agent
- **Prompt:** (Paraphrased) (1) Population legend on the right with categories 1,000,000; 10,000,000; 100,000,000; 1,000,000,000. (2) Add dotted perpendicular lines intersecting at the median position for both x and y. (3) X-axis units like $300.00 and $1,000.00. (4) Make fonts smaller for a better look.
- **Output summary:** Agent updated `scripts/02_make_figures.R`: added `scale_size_area(..., breaks = c(1e6, 1e7, 1e8, 1e9), labels = c("1,000,000", ...))` for the population legend; computed `med_gdp` and `med_life` and added `geom_vline(xintercept = med_gdp)` and `geom_hline(yintercept = med_life)` with `linetype = "dotted"` and gray color; added custom `label_dollar_log()` for `scale_x_log10(labels = ...)` to format as $X,XXX.00; reduced `theme_minimal(base_size = 9)` and set smaller `size = rel(...)` for title, subtitle, axis text, and legend text.
- **What I used:** All of the above in `02_make_figures.R`: population breaks/labels, median dotted reference lines, dollar-formatted x-axis, and smaller base font plus relative sizes for plot elements.
- **Verification:** Ran `Rscript scripts/02_make_figures.R`; PDF regenerated successfully with updated legend, reference lines, axis labels, and typography.

## 2025-02-09 — Figure 1: Visible population spheres in legend, title left-aligned and hierarchy

- **Tool:** Cursor Agent
- **Prompt:** (Paraphrased) (1) Can only see population numbers on the right, not the spheres—make the population circles in the legend visible. (2) Both title lines indented to the left; "Health and wealth across countries (2007)" in a bigger font.
- **Output summary:** Agent changed size scale from `scale_size_area` to `scale_size_continuous(..., range = c(3, 14), trans = "sqrt")` so the minimum mapped size is 3 (not 0), making all four legend circles visibly different. Kept breaks/labels 1e6–1e9; area remains proportional to population via sqrt transform. Set `plot.title` and `plot.subtitle` to `hjust = 0` (left-aligned); title `size = rel(1.35)`, subtitle `size = rel(0.9)` so the first line is clearly larger.
- **What I used:** All of the above in `02_make_figures.R`: `scale_size_continuous` with range and sqrt for visible legend spheres; left-aligned title and subtitle with larger title font.
- **Verification:** Ran `Rscript scripts/02_make_figures.R`; PDF regenerated; legend shows four distinct circle sizes; title block is left-aligned with a larger first line.

## 2025-02-09 — Figure 1: Revert plot to scale_size_area; fix only legend circles

- **Tool:** Cursor Agent
- **Prompt:** (Paraphrased) Revert: the spheres on the graph were fine; it’s the legend circles (1,000,000; 10,000,000; …) that weren’t visible. Go back to the earlier graphics, keep the title change, and fix the reference population sizes on the side.
- **Output summary:** Agent reverted the size scale to `scale_size_area(max_size = 14, breaks = pop_breaks, labels = pop_labels)` so the scatter again has point area proportional to population. Legend visibility fixed by `guides(size = guide_legend(override.aes = list(size = c(1.5e8, 3.5e8, 6.5e8, 1e9))))` so the four legend keys are drawn at population values that map to visible circle sizes while labels remain 1,000,000 … 1,000,000,000. Title left-aligned with larger first line kept as-is.
- **What I used:** All of the above in `02_make_figures.R`: scale_size_area restored; guides(size = ... override.aes ...) for legend key sizes only.
- **Verification:** Ran `Rscript scripts/02_make_figures.R`; PDF has graph bubbles as before and four visible legend circles with correct labels.
