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
  scale_fill_brewer(palette = "Set1", name = "Continent") +
  # Log scale for GDP per person; axis labels as dollars
  scale_x_log10(labels = label_dollar_log) +
  # Overall trend line (linear)
  geom_smooth(method = "lm", se = FALSE, linewidth = 1, color = "black", aes(group = 1)) +
  # Within-continent trend lines (linear)
  geom_smooth(aes(group = continent, color = continent), method = "lm", se = FALSE, linewidth = 0.7) +
  scale_color_brewer(palette = "Set1", name = "Continent") +
  # Override legend key sizes to make population circles visible
  guides(size = guide_legend(override.aes = list(size = c(2, 4, 6, 8)))) +
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

# Save figure 1
ggsave(
  filename = file.path(OUTPUT_DIR, "fig1_bubble_trends.pdf"),
  plot = p1,
  width = 10,
  height = 6,
  dpi = 300
)

message("Figure 1 saved to ", file.path(OUTPUT_DIR, "fig1_bubble_trends.pdf"))

ggsave(file.path(OUTPUT_DIR, "fig1_bubble_trends.pdf"), plot = p1, width = 8, height = 6)

gapminder_by_continent_year <- gapminder %>%
  group_by(continent, year) %>%
  summarise(
    # IQR: 25th and 75th percentiles
    q1_lifeExp = quantile(lifeExp, probs = 0.25, na.rm = TRUE),
    median_lifeExp = median(lifeExp, na.rm = TRUE),
    q3_lifeExp = quantile(lifeExp, probs = 0.75, na.rm = TRUE),
    # Population-weighted mean
    weighted_mean_lifeExp = weighted.mean(lifeExp, w = pop, na.rm = TRUE),
    .groups = "drop"
  )

p2 <- ggplot(gapminder_by_continent_year, aes(x = year)) +
  # Ribbon for IQR (25th–75th percentile)
  geom_ribbon(aes(ymin = q1_lifeExp, ymax = q3_lifeExp), 
              fill = "gray70", alpha = 0.4, color = NA) +
  # Line for median (blue)
  geom_line(aes(y = median_lifeExp, linetype = "Median"), 
            color = "blue", linewidth = 0.8) +
  # Line for population-weighted mean (red dashed)
  geom_line(aes(y = weighted_mean_lifeExp, linetype = "Population-weighted mean"), 
            color = "red", linewidth = 0.8) +
  scale_linetype_manual(name = "Trend Line", 
                        values = c("Median" = "solid", "Population-weighted mean" = "22")) +
  facet_wrap(~continent, ncol = 2) +
  labs(
    x = "Year",
    y = "Life expectancy (years)",
    title = "Life expectancy over time (within each continent)",
    subtitle = "Ribbon = country-level IQR (25th–75th percentile) each year",
    caption = "Data: gapminder package"
  ) +
  theme_minimal(base_size = 9) +
  theme(
    legend.position = "bottom",
    plot.title = element_text(hjust = 0, size = rel(1.35)),
    plot.subtitle = element_text(hjust = 0, size = rel(0.9)),
    plot.caption = element_text(hjust = 1, size = rel(0.85), color = "gray50"),
    axis.text = element_text(size = rel(0.85)),
    legend.text = element_text(size = rel(0.85)),
    legend.title = element_text(size = rel(0.95))
  )

# Save figure 2
ggsave(
  filename = file.path(OUTPUT_DIR, "figure-2-ribbon-median-weighted.pdf"),
  plot = p2,
  width = 12,
  height = 8,
  dpi = 300
)

message("Figure 2 saved to ", file.path(OUTPUT_DIR, "figure-2-ribbon-median-weighted.pdf"))
ggsave(file.path(OUTPUT_DIR, "figure-2-ribbon-median-weighted.pdf"), plot = p2, width = 12, height = 8, dpi = 300)