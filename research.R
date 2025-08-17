#Running regressions on the EU dataset

#Packages
library(dplyr)
library(tidyr)
library(readr)
library(countrycode)
library(texreg)
library(ggplot2)
library(interactions)
library(ggrepel)

#Load data
data_eu <- read_csv("diss_data_eu.csv")

#Hypothesis 1
m1 <- lm(delibdem_3yr ~
           v2smgovdom + v2smpardom + v2smfordom +
           v2cacamps + v2smpolsoc + v2smpolhate +
           v2x_rule + v2exrescon + v2x_jucon + v2xlg_legcon +
           v2merange + v2mecorrpt + v2mecrit + v2smgovsmcenprc +
           v2x_freexp_altinf + v2csprtcpt + v2xel_frefair +
           v2xeg_eqdr + gini + nato + soviet,
         data = data_eu)

#Hypothesis 2 with societal polarisation
m2 <- lm(delibdem_3yr ~
           v2smgovdom * v2smpolsoc +
           v2smpardom + v2smfordom +
           v2cacamps + v2smpolhate +
           v2x_rule + v2exrescon + v2x_jucon + v2xlg_legcon +
           v2merange + v2mecorrpt + v2mecrit + v2smgovsmcenprc +
           v2x_freexp_altinf + v2csprtcpt + v2xel_frefair +
           v2xeg_eqdr + gini + nato + soviet,
         data = data_eu)

#Hypothesis 2 with political polarisation
m3 <- lm(delibdem_3yr ~
           v2smgovdom * v2cacamps +
           v2smpardom + v2smfordom +
           v2smpolsoc + v2smpolhate +
           v2x_rule + v2exrescon + v2x_jucon + v2xlg_legcon +
           v2merange + v2mecorrpt + v2mecrit + v2smgovsmcenprc +
           v2x_freexp_altinf + v2csprtcpt + v2xel_frefair +
           v2xeg_eqdr + gini + nato + soviet,
         data = data_eu)

#Hypothesis 3 with gini index
m4 <- lm(delibdem_3yr ~
           v2smgovdom * gini +
           v2smpardom + v2smfordom + v2cacamps +
           v2smpolsoc + v2smpolhate +
           v2x_rule + v2exrescon + v2x_jucon + v2xlg_legcon +
           v2merange + v2mecorrpt + v2mecrit + v2smgovsmcenprc +
           v2x_freexp_altinf + v2csprtcpt + v2xel_frefair +
           v2xeg_eqdr + nato + soviet,
         data = data_eu)

#Hypothesis 3 with distribution of resources
m5 <- lm(delibdem_3yr ~
           v2smgovdom * v2xeg_eqdr +
           v2smpardom + v2smfordom + v2cacamps +
           v2smpolsoc + v2smpolhate +
           v2x_rule + v2exrescon + v2x_jucon + v2xlg_legcon +
           v2merange + v2mecorrpt + v2mecrit + v2smgovsmcenprc +
           v2x_freexp_altinf + v2csprtcpt + v2xel_frefair +
           gini + nato + soviet,
         data = data_eu)

screenreg(list(m1,m2,m3,m4,m5),digits=3)
