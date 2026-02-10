# ============================================================================
# Figure Creation Script: Gapminder Visualizations
# ============================================================================
# Source: Load setup and data preparation scripts
source("scripts/00_setup.R")
source("scripts/01_data_prep.R")

# ============================================================================
# FIGURE 1: Bubble Chart - Health and Wealth (2007)
# ============================================================================

# ---- Setup: Calculate reference statistics ----
med_gdp  <- median(gapminder_2007$gdpPercap)        # Median GDP per capita for reference line
med_life <- median(gapminder_2007$lifeExp)          # Median life expectancy for reference line

# ---- Setup: Define population legend scales and labels ----
pop_breaks <- c(1e6, 1e7, 1e8, 1e9)                 # Population breakpoints: 1M, 10M, 100M, 1B
pop_labels <- c("1,000,000", "10,000,000",          # Human-readable population labels
                 "100,000,000", "1,000,000,000")

# ---- Setup: Create dollar formatter function for axis labels ----
label_dollar_log <- function(x) {                   # Format axis labels as currency
  paste0("$", format(round(x, 2),                   # Add dollar sign, round to 2 decimals
                     big.mark = ",",                 # Add comma separators for thousands
                     nsmall = 2, trim = TRUE))
}

# ---- Build: Initialize ggplot with base aesthetics ----
p1 <- ggplot(gapminder_2007, aes(x = gdpPercap, y = lifeExp)) +
  
  # Add reference lines at median values (draw first = behind other elements)
  geom_vline(xintercept = med_gdp,                  # Vertical line at median GDP
             linetype = "dotted", linewidth = 0.6, color = "gray40") +
  geom_hline(yintercept = med_life,                 # Horizontal line at median life expectancy
             linetype = "dotted", linewidth = 0.6, color = "gray40") +
  
  # Add data points: size proportional to population, color by continent
  geom_point(aes(size = pop, fill = continent),    # Map population to point size, continent to fill color
             alpha = 0.6,                           # Semi-transparent circles
             shape = 21,                            # Circle with separate border
             color = "white",                       # White border around circles
             stroke = 0.5) +                        # Border thickness
  
  # Scale for population sizes in legend
  scale_size_area(max_size = 14,                    # Maximum circle size
                  name = "Population",              # Legend title
                  breaks = pop_breaks,              # Population breakpoints
                  labels = pop_labels) +            # Human-readable labels
  
  # Color scale for continents
  scale_fill_brewer(palette = "Set1", name = "Continent") +
  
  # X-axis: Log scale with dollar formatting
  scale_x_log10(labels = label_dollar_log) +
  
  # Trend lines: Overall trend across all countries
  geom_smooth(method = "lm",                        # Linear model
              se = FALSE,                           # No confidence interval
              linewidth = 1,                        # Line thickness
              color = "black",                      # Overall trend in black
              aes(group = 1)) +                     # Single line for all data
  
  # Trend lines: Within-continent trends
  geom_smooth(aes(group = continent,                # Separate line per continent
                  color = continent),               # Color by continent
              method = "lm",                        # Linear model
              se = FALSE,                           # No confidence interval
              linewidth = 0.7) +                    # Thinner than overall trend
  
  # Color scale for continent trend lines
  scale_color_brewer(palette = "Set1", name = "Continent") +
  
  # Override legend: Make population circles in legend visible
  guides(size = guide_legend(override.aes = list(size = c(2, 4, 6, 8)))) +
  
  # Labels and titles
  labs(x = "GDP per person (log scale)",
       y = "Life expectancy (years)",
       title = "Health and wealth across countries (2007)",
       subtitle = "Point area proportional to population; lines are fitted trends (overall + within continent)") +
  
  # ---- Customize: Theme and appearance ----
  theme_minimal(base_size = 9) +                    # Clean minimal theme
  theme(legend.position = "right",                  # Legend on right side
        plot.title = element_text(hjust = 0, size = rel(1.35)),      # Left-aligned title
        plot.subtitle = element_text(hjust = 0, size = rel(0.9)),    # Left-aligned subtitle
        axis.text = element_text(size = rel(0.9)),                   # Axis label size
        legend.text = element_text(size = rel(0.9)),                 # Legend text size
        legend.title = element_text(size = rel(0.95)))               # Legend title size

# ---- Save: Figure 1 output ----
ggsave(
  filename = file.path(OUTPUT_DIR, "fig1_bubble_trends.pdf"),  # Output filename
  plot = p1,                                                    # Plot object to save
  width = 10,                                                   # Width in inches
  height = 6,                                                   # Height in inches
  dpi = 300                                                     # Resolution
)

message("Figure 1 saved to ", file.path(OUTPUT_DIR, "fig1_bubble_trends.pdf"))


# ============================================================================
# FIGURE 2: Ribbon Plot - Life Expectancy Trends by Continent
# ============================================================================

# ---- Data Prep: Aggregate gapminder data by continent and year ----
gapminder_by_continent_year <- gapminder %>%
  group_by(continent, year) %>%                     # Group by continent and year
  summarise(
    # Calculate 25th percentile (lower quartile) of life expectancy
    q1_lifeExp = quantile(lifeExp, probs = 0.25, na.rm = TRUE),
    
    # Calculate median life expectancy
    median_lifeExp = median(lifeExp, na.rm = TRUE),
    
    # Calculate 75th percentile (upper quartile) of life expectancy
    q3_lifeExp = quantile(lifeExp, probs = 0.75, na.rm = TRUE),
    
    # Calculate population-weighted mean (countries with larger populations weighted more)
    weighted_mean_lifeExp = weighted.mean(lifeExp, w = pop, na.rm = TRUE),
    
    .groups = "drop"                                # Ungroup after summarise
  )

# ---- Build: Initialize ggplot with base aesthetics ----
p2 <- ggplot(gapminder_by_continent_year, aes(x = year)) +
  
  # Add ribbon: Shaded area between Q1 and Q3 (interquartile range)
  geom_ribbon(aes(ymin = q1_lifeExp, ymax = q3_lifeExp),  # Y-axis range (Q1 to Q3)
              fill = "gray70",                      # Fill color: light gray
              alpha = 0.4,                          # Transparency: 40%
              color = NA) +                         # No border around ribbon
  
  # Add line: Median life expectancy (solid blue)
  geom_line(aes(y = median_lifeExp, linetype = "Median"),  # Y-axis: median, linetype label
            color = "blue",                         # Line color: blue
            linewidth = 0.8) +                      # Line thickness
  
  # Add line: Population-weighted mean (dashed red)
  geom_line(aes(y = weighted_mean_lifeExp, linetype = "Population-weighted mean"),  # Y-axis: weighted mean
            color = "red",                          # Line color: red
            linewidth = 0.8) +                      # Line thickness
  
  # Define line types for legend
  scale_linetype_manual(name = "Trend Line",
                        values = c("Median" = "solid",              # Solid line for median
                                   "Population-weighted mean" = "22")) +  # Dashed line for weighted mean
  
  # Facet: Separate panel for each continent (2 columns)
  facet_wrap(~continent, ncol = 2) +
  
  # Labels and titles
  labs(x = "Year",
       y = "Life expectancy (years)",
       title = "Life expectancy over time (within each continent)",
       subtitle = "Ribbon = country-level IQR (25th–75th percentile) each year",
       caption = "Data: gapminder package") +
  
  # ---- Customize: Theme and appearance ----
  theme_minimal(base_size = 9) +                    # Clean minimal theme
  theme(legend.position = "bottom",                 # Legend at bottom
        plot.title = element_text(hjust = 0, size = rel(1.35)),              # Left-aligned title
        plot.subtitle = element_text(hjust = 0, size = rel(0.9)),            # Left-aligned subtitle
        plot.caption = element_text(hjust = 1, size = rel(0.85), color = "gray50"),  # Right-aligned data source
        axis.text = element_text(size = rel(0.85)),                          # Axis label size
        legend.text = element_text(size = rel(0.85)),                        # Legend text size
        legend.title = element_text(size = rel(0.95)))                       # Legend title size

# ---- Save: Figure 2 output ----
ggsave(
  filename = file.path(OUTPUT_DIR, "figure-2-ribbon-median-weighted.pdf"),  # Output filename
  plot = p2,                                                                 # Plot object to save
  width = 12,                                                                # Width in inches
  height = 8,                                                                # Height in inches
  dpi = 300                                                                  # Resolution
)

message("Figure 2 saved to ", file.path(OUTPUT_DIR, "figure-2-ribbon-median-weighted.pdf"))