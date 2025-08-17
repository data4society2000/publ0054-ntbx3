#Creating graphs visualising my data

#Load relevant packages if not done already
library(dplyr)
library(readr)
library(tidyr)
library(ggplot2)
library(ggrepel)
library(countrycode)
library(interactions)

#Load data
data_eu <- read_csv("diss_data_eu.csv")

#Figure 1: plotting three types of disinfo over time in the EU
disinfo_long_eu <- data_eu %>%
  select(year, country_name, v2smgovdom, v2smpardom, v2smfordom) %>%
  pivot_longer(cols = starts_with("v2sm"),
               names_to = "disinfo_type",
               values_to = "value")

disinfo_avg_eu <- disinfo_long_eu %>%
  group_by(year, disinfo_type) %>%
  summarise(mean_value = mean(value, na.rm = TRUE), .groups = "drop")

p1 <- ggplot(disinfo_avg_eu, aes(x = year, y = mean_value, color = disinfo_type)) +
  geom_line(size = 1.2) +
  geom_point(size = 0.25) +
  scale_color_manual(values = c("v2smgovdom" = "#D73027",
                                "v2smpardom" = "#4575B4",
                                "v2smfordom" = "#66A61E"),
                     labels = c("Government Disinformation", "Party Disinformation", "Foreign Disinformation")) +
  labs(title   = "Disinformation Trends Over Time (EU Average)",
       x = "Year", y = "Average Disinformation", color = "Disinformation Type") +
  theme_minimal(base_size = 13)
print(p1)
ggsave("fig1_disinfo_trends_eu.png", p1, width = 8, height = 5, dpi = 320)

#Figure 3: quadrant of cases disinfo by backsliding for EU 2024
quad_plot_2024 <- data_eu %>%
  filter(year == 2024) %>%
  group_by(country_name) %>%
  summarise(
    avg_delib_backsliding = mean(delibdem_3yr, na.rm = TRUE),
    avg_disinfo = mean(v2smgovdom, na.rm = TRUE)
  ) %>%
  mutate(iso3 = countrycode(country_name, "country.name", "iso3c"))

mean_delib_backslide_2024 <- mean(quad_plot_2024$avg_delib_backsliding, na.rm = TRUE)
mean_disinfo_2024         <- mean(quad_plot_2024$avg_disinfo, na.rm = TRUE)

p2 <- ggplot(quad_plot_2024, aes(x = avg_disinfo, y = avg_delib_backsliding, label = iso3)) +
  annotate("rect", xmin = -Inf, xmax = mean_disinfo_2024, ymin = -Inf, ymax = mean_delib_backslide_2024, fill = "#fddede", alpha = 0.5) +
  annotate("rect", xmin =  mean_disinfo_2024, xmax =  Inf, ymin = -Inf, ymax = mean_delib_backslide_2024, fill = "#e1e1e1", alpha = 0.5) +
  annotate("rect", xmin = -Inf, xmax = mean_disinfo_2024, ymin =  mean_delib_backslide_2024, ymax =  Inf, fill = "#f0f6d9", alpha = 0.5) +
  annotate("rect", xmin =  mean_disinfo_2024, xmax =  Inf, ymin =  mean_delib_backslide_2024, ymax =  Inf, fill = "#d6f5dd", alpha = 0.5) +
  geom_point() +
  ggrepel::geom_text_repel(size = 3, max.overlaps = 100) +
  geom_vline(xintercept = mean_disinfo_2024, linetype = "dashed", color = "blue") +
  geom_hline(yintercept = mean_delib_backslide_2024, linetype = "dashed", color = "blue") +
  geom_smooth(aes(x = avg_disinfo, y = avg_delib_backsliding), method = "lm",
              se = FALSE, color = "red", size = 1) +
  labs(
    title = "Government Disinformation vs Change in Deliberative Democracy in 2024",
    x = "Government Disinformation",
    y = "Deliberative Backsliding (3-Year Change in DDI)"
  ) +
  theme_minimal()
print(p2)
ggsave("fig3_eu_quadrants_2024.png", p2, width = 8, height = 5, dpi = 320)

#Figure 4: change in DDI over time in cases + EU average
eu_avg <- data_eu %>%
  group_by(year) %>%
  summarise(avg_delibdem = mean(v2x_delibdem, na.rm = TRUE))

hun_pol <- data_eu %>%
  filter(country_name %in% c("Hungary", "Poland")) %>%
  select(country_name, year, v2x_delibdem)

p3 <- ggplot() +
  geom_line(data = eu_avg, aes(x = year, y = avg_delibdem), color = "grey30", size = 1.2) +
  geom_line(data = hun_pol, aes(x = year, y = v2x_delibdem, color = country_name), size = 1.2) +
  scale_color_manual(values = c("Hungary" = "darkred", "Poland" = "steelblue")) +
  labs(title = "Deliberative Democracy in the EU: Hungary & Poland vs EU Average",
       x = "Year", y = "Deliberative Democracy Index (0–1)", color = "Country") +
  theme_minimal(base_size = 13)
print(p3)
ggsave("fig4_eu_avg_vs_HU_PL.png", p3, width = 8, height = 5, dpi = 320)

#Figure 5 and 6: marginal effects for disinfo / polarisation regressions
p4 <- interact_plot(m2,
                    pred = v2smgovdom,
                    modx = v2smpolsoc,
                    plot.points = TRUE,
                    interval = TRUE,
                    int.width = 0.95,
                    x.label = "Government Disinformation",
                    modx.labels = c("Low Polarisation", "Mean", "High Polarisation"),
                    y.label = "Predicted Change in DDI (3-Year)",
                    main.title = "Marginal Effect of Government Disinformation \n at Varying Levels of Societal Polarisation",
                    colors = "blue")
print(p4)
ggsave("fig5_marginal_socpol.png", p4, width = 8, height = 5, dpi = 320)

p5 <- interact_plot(m3,
                    pred = v2smgovdom,
                    modx = v2cacamps,
                    plot.points = TRUE,
                    interval = TRUE,
                    int.width = 0.95,
                    x.label = "Government Disinformation",
                    modx.labels = c("Low Polarisation", "Mean", "High Polarisation"),
                    y.label = "Predicted Change in DDI (3-Year)",
                    main.title = "Marginal Effect of Government Disinformation \n at Varying Levels of Political Polarisation",
                    colors = "blue")
print(p5)
ggsave("fig6_marginal_govdis_x_polpol.png", p5, width = 8, height = 5, dpi = 320)

#Figure 7: normalised plot of Hungary variables over time with original disinfo scale
hungary_data <- data_eu %>%
  filter(country_name == "Hungary") %>%
  mutate(
    delib_norm = (v2x_delibdem - min(v2x_delibdem, na.rm = TRUE)) /
      (max(v2x_delibdem, na.rm = TRUE) - min(v2x_delibdem, na.rm = TRUE)),
    disinfo_orig_norm = 1 - (
      (v2smgovdom - min(v2smgovdom, na.rm = TRUE)) /
        (max(v2smgovdom, na.rm = TRUE) - min(v2smgovdom, na.rm = TRUE))
    )
  )

p6 <- ggplot(hungary_data, aes(x = year)) +
  geom_line(aes(y = delib_norm, color = "Deliberative Democracy"), size = 1.2) +
  geom_point(aes(y = delib_norm, color = "Deliberative Democracy"), size = 2) +
  geom_line(aes(y = disinfo_orig_norm, color = "Gov. Disinfo (V-Dem Scale)"), size = 1.2) +
  geom_point(aes(y = disinfo_orig_norm, color = "Gov. Disinfo (V-Dem Scale)"), size = 2) +
  scale_color_manual(values = c(
    "Deliberative Democracy"   = "#1F4E79",
    "Gov. Disinfo (V-Dem Scale)" = "#D73027"
  )) +
  labs(
    title = "Hungary: Deliberative Democracy and Government Disinformation",
    y = "Normalised Score (0–1)", x = "Year", color = "Indicator"
  ) +
  theme_minimal(base_size = 13)
print(p6)
ggsave("fig7_hungary_delib_vs_disinfo_originalscale.png", p6, width = 8, height = 5, dpi = 320)

#Figure 8: normalised plot of Poland variables over time with original disinfo score
poland_data <- data_eu %>%
  filter(country_name == "Poland") %>%
  mutate(
    delib_norm = (v2x_delibdem - min(v2x_delibdem, na.rm = TRUE)) /
      (max(v2x_delibdem, na.rm = TRUE) - min(v2x_delibdem, na.rm = TRUE)),
    disinfo_orig_norm = 1 - (
      (v2smgovdom - min(v2smgovdom, na.rm = TRUE)) /
        (max(v2smgovdom, na.rm = TRUE) - min(v2smgovdom, na.rm = TRUE))
    )
  )

p7 <- ggplot(poland_data, aes(x = year)) +
  geom_line(aes(y = delib_norm, color = "Deliberative Democracy"), size = 1.2) +
  geom_point(aes(y = delib_norm, color = "Deliberative Democracy"), size = 2) +
  geom_line(aes(y = disinfo_orig_norm, color = "Gov. Disinfo (V-Dem Scale)"), size = 1.2) +
  geom_point(aes(y = disinfo_orig_norm, color = "Gov. Disinfo (V-Dem Scale)"), size = 2) +
  scale_color_manual(values = c(
    "Deliberative Democracy"   = "#1F4E79",
    "Gov. Disinfo (V-Dem Scale)" = "#D73027"
  )) +
  labs(
    title = "Poland: Deliberative Democracy vs. Government Disinformation",
    y = "Normalised Score (0–1)", x = "Year", color = "Indicator"
  ) +
  theme_minimal(base_size = 13)
print(p7)
ggsave("fig8_poland_delib_vs_disinfo_originalscale.png", p7, width = 8, height = 5, dpi = 320)

