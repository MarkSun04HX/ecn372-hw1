# 02_make_figures.R — Build figure outputs (run from project root)
# Usage: Rscript scripts/02_make_figures.R

# Ensure we're in project root when run via Rscript
if (length(commandArgs(trailingOnly = TRUE)) > 0) {
  script_dir <- dirname(sub("^--file=", "", commandArgs(trailingOnly = FALSE)[grep("^--file=", commandArgs(trailingOnly = FALSE))]))
  if (length(script_dir) > 0 && script_dir != "") {
    setwd(dirname(script_dir))
  }
}

source("scripts/00_setup.R")
source("scripts/01_data_prep.R")

# ---- Figure 1: Bubble trends (2007 GDP vs life expectancy, area = pop, trend lines) ----
# Median reference lines (dotted, perpendicular at median x and y)
med_gdp  <- median(gapminder_2007$gdpPercap)
med_life <- median(gapminder_2007$lifeExp)

# Population legend breaks: 1e6, 1e7, 1e8, 1e9
pop_breaks <- c(1e6, 1e7, 1e8, 1e9)
pop_labels <- c("1,000,000", "10,000,000", "100,000,000", "1,000,000,000")

# X-axis: dollar format with 2 decimals (e.g. $300.00, $1,000.00)
label_dollar_log <- function(x) {
  paste0("$", format(round(x, 2), big.mark = ",", nsmall = 2, trim = TRUE))
}

p1 <- ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp)) +
  # Dotted reference lines at median x and median y (draw first so they sit behind)
  geom_vline(xintercept = med_gdp,  linetype = "dotted", linewidth = 0.6, color = "gray40") +
  geom_hline(yintercept = med_life, linetype = "dotted", linewidth = 0.6, color = "gray40") +
  # Point area = population; points colored by continent
  geom_point(aes(size = pop, fill = continent), alpha = 0.6, shape = 21, color = "white", stroke = 0.5) +
  scale_size_area(max_size = 14, name = "Population", breaks = pop_breaks, labels = pop_labels) +
  # Legend keys: override sizes so the four circles are visible (scale still maps 1e6..1e9 to area on plot)
  guides(size = guide_legend(override.aes = list(size = c(1.5e8, 3.5e8, 6.5e8, 1e9)))) +
  scale_fill_brewer(palette = "Set1", name = "Continent") +
  # Log scale for GDP per person; axis labels as dollars
  scale_x_log10(labels = label_dollar_log) +
  # Overall trend line (linear)
  geom_smooth(method = "lm", se = FALSE, linewidth = 1, color = "black", aes(group = 1)) +
  # Within-continent trend lines (linear)
  geom_smooth(aes(group = continent, color = continent), method = "lm", se = FALSE, linewidth = 0.7) +
  scale_color_brewer(palette = "Set1", name = "Continent") +
  labs(
    x = "GDP per person (log scale)",
    y = "Life expectancy (years)",
    title = "Health and wealth across countries (2007)",
    subtitle = "Point area proportional to population; lines are fitted trends (overall + within continent)"
  ) +
  theme_minimal(base_size = 9) +
  theme(
    legend.position = "right",
    plot.title = element_text(hjust = 0, size = rel(1.35)),
    plot.subtitle = element_text(hjust = 0, size = rel(0.9)),
    axis.text = element_text(size = rel(0.9)),
    legend.text = element_text(size = rel(0.9)),
    legend.title = element_text(size = rel(0.95))
  )

out_path_1 <- file.path(OUTPUT_DIR, "figure-1-bubble-trends.pdf")
ggsave(out_path_1, p1, width = 8, height = 5, device = "pdf")
message("Saved: ", out_path_1)

# Placeholder for second figure (add when you choose figure 2)
# out_path_2 <- file.path(OUTPUT_DIR, "figure-2-....pdf")
# ggsave(out_path_2, p2, width = 8, height = 5, device = "pdf")

message("Done. Figures written to ", OUTPUT_DIR, ".")
