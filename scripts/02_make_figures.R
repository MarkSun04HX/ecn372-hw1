# ============================================================================
# Figure Creation Script: Gapminder Visualizations
# ============================================================================
# Source: Load setup and data preparation scripts
source("scripts/00_setup.R")
source("scripts/01_data_prep.R")

# ---- Load: ggplot2 for visualization ----
library(ggplot2)                                    # Load ggplot2 for creating graphics

# ---- Load: dplyr for data manipulation ----
library(dplyr)                                      # Load dplyr for data wrangling and transformations

# ---- Load: gapminder dataset ----
library(gapminder)                                  # Load gapminder package (includes dataset)

# ---- Load: scales for formatting axes and colors ----
library(scales)                                     # Load scales for pretty axis labels and color palettes

# ============================================================================
# FIGURE 1: Bubble Chart - Health and Wealth (2007)
# ============================================================================

# ---- Setup: Calculate reference statistics ----
med_gdp  <- median(gapminder_2007$gdpPercap)        # Median GDP per capita
med_life <- median(gapminder_2007$lifeExp)          # Median life expectancy

# ---- Setup: Define population legend scales and labels ----
pop_breaks <- c(1e6, 1e7, 1e8, 1e9)
pop_labels <- c("1,000,000", "10,000,000", "100,000,000", "1,000,000,000")

# ---- Setup: Create dollar formatter function for axis labels ----
label_dollar_log <- function(x) {
  paste0("$", format(round(x, 2), big.mark = ",", nsmall = 2, trim = TRUE))
}

# ---- Build: Initialize ggplot with base aesthetics ----
# FIX: Assigned to 'p1' instead of 'p' to match the ggsave call below
p1 <- ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp, color = continent)) +

  # Reference lines
  geom_vline(xintercept = med_gdp, linetype = "dotted", linewidth = 0.6, color = "gray40") +
  geom_hline(yintercept = med_life, linetype = "dotted", linewidth = 0.6, color = "gray40") +

  # Scatter plot points (bubbles)
  geom_point(aes(size = pop), alpha = 0.7) +

  # FIX: Used the 'label_dollar_log' function defined above
  scale_x_log10(labels = label_dollar_log) +

  # Global Trend Line
  geom_smooth(aes(group = 1), method = "lm", se = FALSE, color = "gray30", linewidth = 0.8) +

  # Continent-Specific Trend Lines
  geom_smooth(aes(group = continent), method = "lm", se = FALSE, linewidth = 0.5) +

  # Population Size Legend
  scale_size_continuous(
    name = "Population",
    labels = label_number(scale_cut = cut_short_scale()),
    range = c(1, 20)
  ) +

  # Labels
  labs(
    x = "GDP per person (log scale)",
    y = "Life expectancy (years)",
    title = "Health and wealth across countries (2007)",
    subtitle = "Point area ... population; lines are fitted trends (overall + within continent)"
  ) +

  # Theme
  theme_minimal() +
  theme(
    legend.position = "right",
    plot.title = element_text(face = "bold")
  )

# ---- Save: Figure 1 output ----
ggsave(
  filename = file.path(OUTPUT_DIR, "fig1_bubble_trends.pdf"),
  plot = p1,
  width = 10,
  height = 6,
  dpi = 300
)

message("Figure 1 saved to ", file.path(OUTPUT_DIR, "fig1_bubble_trends.pdf"))


# ============================================================================
# FIGURE 2: Ribbon Plot - Life Expectancy Trends by Continent
# ============================================================================

# ---- Data Prep: Aggregate gapminder data by continent and year ----
gapminder_by_continent_year <- gapminder %>%
  group_by(continent, year) %>%
  summarise(
    q1_lifeExp = quantile(lifeExp, probs = 0.25, na.rm = TRUE),
    median_lifeExp = median(lifeExp, na.rm = TRUE),
    q3_lifeExp = quantile(lifeExp, probs = 0.75, na.rm = TRUE),
    weighted_mean_lifeExp = weighted.mean(lifeExp, w = pop, na.rm = TRUE),
    .groups = "drop"
  )

# ---- Build: Initialize ggplot with base aesthetics ----
p2 <- ggplot(gapminder_by_continent_year, aes(x = year)) +
  
  # Ribbon: IQR
  geom_ribbon(aes(ymin = q1_lifeExp, ymax = q3_lifeExp),
              fill = "gray70",
              alpha = 0.4,
              color = NA) +
  
  # Line: Median
  geom_line(aes(y = median_lifeExp, linetype = "Median"),
            color = "blue",
            linewidth = 0.8) +
  
  # Line: Weighted Mean
  geom_line(aes(y = weighted_mean_lifeExp, linetype = "Population-weighted mean"),
            color = "red",
            linewidth = 0.8) +
  
  # Legend
  scale_linetype_manual(name = "Trend Line",
                        values = c("Median" = "solid",
                                   "Population-weighted mean" = "22")) +
  
  # Facet
  facet_wrap(~continent, ncol = 2) +
  
  # Labels
  labs(x = "Year",
       y = "Life expectancy (years)",
       title = "Life expectancy over time (within each continent)",
       subtitle = "Ribbon = country-level IQR (25th–75th percentile) each year",
       caption = "Data: gapminder package") +
  
  # Theme
  theme_minimal(base_size = 9) +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0, size = rel(1.35)),
        plot.subtitle = element_text(hjust = 0, size = rel(0.9)),
        plot.caption = element_text(hjust = 1, size = rel(0.85), color = "gray50"),
        axis.text = element_text(size = rel(0.85)),
        legend.text = element_text(size = rel(0.85)),
        legend.title = element_text(size = rel(0.95)))

# ---- Save: Figure 2 output ----
ggsave(
  filename = file.path(OUTPUT_DIR, "figure-2-ribbon-median-weighted.pdf"),
  plot = p2,
  width = 12,
  height = 8,
  dpi = 300
)

# FIX: Removed trailing comma inside message()
message("Figure 2 saved to ", file.path(OUTPUT_DIR, "figure-2-ribbon-median-weighted.pdf"))