#Building my dataset for analysis

#Packages
library(dplyr)
library(tidyr)
library(readr)
library(countrycode)
library(texreg)
library(ggplot2)
library(interactions)
library(ggrepel)

#Load original V-Dem dataset
vdem <- readRDS("V-Dem-CY-Full+Others-v15.rds") %>%
  filter(year >= 2000, year <= 2024)

#Filtering for variables I will be using
vdem <- vdem %>%
  select(country_name, year,
         v2x_libdem, v2x_delibdem,
         v2smfordom, v2smpardom, v2smgovdom,
         v2cacamps, v2mecrit, v2merange, v2mecorrpt,
         v2x_rule, v2exrescon, v2x_freexp_altinf, v2csprtcpt, v2smpolsoc,
         v2x_jucon, v2xlg_legcon, v2xel_frefair, v2smgovsmcenprc,
         v2xeg_eqdr, v2caautmob, v2smpolhate)

#Add IS03 codes 
vdem$iso3 <- countrycode(vdem$country_name, "country.name", "iso3c")
vdem$iso3[vdem$country_name == "Kosovo"]     <- "XKX"
vdem$iso3[vdem$country_name == "Somaliland"] <- "SML"
vdem$iso3[vdem$country_name == "Zanzibar"]   <- "ZNZ"

#Adding gini index data
gini <- read_csv("gini.csv", show_col_types = FALSE)
gini_long <- gini %>%
  pivot_longer(cols = starts_with("19") | starts_with("20"),
               names_to = "year", values_to = "gini") %>%
  mutate(
    year = as.integer(year),
    country_name = .data[["Country Name"]]
  ) %>%
  select(country_name, year, gini)

data <- vdem %>%
  left_join(gini_long, by = c("country_name", "year")) %>%
  group_by(country_name) %>%
  arrange(year, .by_group = TRUE) %>%
  tidyr::fill(gini, .direction = "downup") %>%
  ungroup()

#Adding geopolitical controls for nato, eu and soviet 
data <- data %>%
  mutate(
    nato = case_when(
      country_name %in% c("Belgium","Bulgaria","Canada","Czechia","Denmark","Estonia",
                          "France","Germany","Greece","Hungary","Iceland","Italy",
                          "Latvia","Lithuania","Luxembourg","Netherlands","Norway",
                          "Poland","Portugal","Romania","Slovakia","Slovenia","Spain",
                          "Turkey","United Kingdom","United States of America") ~ 1,
      country_name == "Albania"         & year >= 2009 ~ 1,
      country_name == "Croatia"         & year >= 2009 ~ 1,
      country_name == "Montenegro"      & year >= 2017 ~ 1,
      country_name == "North Macedonia" & year >= 2020 ~ 1,
      country_name == "Finland"         & year >= 2023 ~ 1,
      country_name == "Sweden"          & year >= 2024 ~ 1,
      TRUE ~ 0
    ),
    eu = case_when(
      country_name %in% c("Austria","Belgium","Cyprus","Czechia","Denmark","Estonia",
                          "Finland","France","Germany","Greece","Hungary","Ireland",
                          "Italy","Latvia","Lithuania","Luxembourg","Malta","Netherlands",
                          "Poland","Portugal","Slovakia","Slovenia","Spain","Sweden") ~ 1,
      country_name == "Bulgaria" & year >= 2007 ~ 1,
      country_name == "Romania"  & year >= 2007 ~ 1,
      country_name == "Croatia"  & year >= 2013 ~ 1,
      country_name == "United Kingdom" & year <= 2020 ~ 1,
      TRUE ~ 0
    )
  )

soviet <- c("Armenia","Azerbaijan","Belarus","Estonia","Georgia","Kazakhstan","Kyrgyzstan",
            "Latvia","Lithuania","Moldova","Russia","Tajikistan","Turkmenistan","Ukraine","Uzbekistan",
            "Albania","Bulgaria","Czechia","Hungary","Poland","Romania","Slovakia","Germany")
data$soviet <- ifelse(data$country_name %in% soviet, 1, 0)

#Reversing the scales for variables that are confusing
data <- data %>%
  mutate(
    v2smgovdom = 4 - v2smgovdom,
    v2smpardom = 4 - v2smpardom,
    v2smfordom = 4 - v2smfordom,
    v2smpolsoc = 4 - v2smpolsoc,
    v2smpolhate = 4 - v2smpolhate
  )

#Creating DV
data <- data %>%
  group_by(country_name) %>%
  arrange(year, .by_group = TRUE) %>%
  mutate(
    delibdem_3yr   = v2x_delibdem - lag(v2x_delibdem, 3),
    backsliding_3yr = v2x_libdem - lag(v2x_libdem, 3)   # kept only if you need it
  ) %>%
  ungroup()

rm(list = setdiff(ls(), c("data", "data_eu")))

#Save
write_csv(data, "diss_data.csv")
data_eu <- data %>% filter(eu == 1)
write_csv(data_eu, "diss_data_eu.csv")