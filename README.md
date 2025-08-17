# Disinformation and Deliberative Democracy – R Scripts

This repository contains three R scripts used in my dissertation research on the relationship between government disinformation and deliberative democracy in the European Union (2000–2024).  

The workflow is organised into three steps: dataset creation, regression analysis, and plotting.  

I would like to thank my partner, Nicholas Price, for his guidance in setting up this repository and writing the README.

---

## Contents

- **builddataset.R**  
  - Builds the dataset from the V-Dem v15 dataset and World Bank Gini index data.  
  - Filters to the period 2000–2024.  
  - Adds geopolitical controls (EU, NATO, Soviet legacy).  
  - Reverses disinformation and polarisation scales (so higher values = more).  
  - Creates the dependent variable `delibdem_3yr` (3-year change in deliberative democracy).  
  - Saves two files:  
    - `diss_data.csv` (global sample)  
    - `diss_data_eu.csv` (EU member states only).  

- **research.R**  
  - Runs the core regression models (Hypotheses 1–3) on the EU dataset.  
  - Models test interactions between government disinformation and:
    - Societal polarisation  
    - Political polarisation  
    - Gini index  
    - Distribution of resources (`v2xeg_eqdr`)  
  - Outputs regression tables to the console (via `texreg::screenreg`).  

- **graphs.R**  
  - Produces all figures used in the dissertation, including:  
    1. EU trends in government, party, and foreign disinformation over time  
    2. Quadrant scatter plot of government disinformation vs deliberative democracy change (2024, with shaded quadrants and red fit line)  
    3. Trends in deliberative democracy for Hungary, Poland, and the EU average  
    4. Marginal effect plots of government disinformation × societal polarisation  
    5. Marginal effect plots of government disinformation × political polarisation  
    6. Normalised overlay for Hungary: deliberative democracy vs government disinformation (original V-Dem scale)  
    7. Normalised overlay for Poland: deliberative democracy vs government disinformation (original V-Dem scale)  
  - Each figure is also saved as a `.png` file in the working directory.  

---

## Citation

If you use this code, please cite the V-Dem v15 dataset and the World Bank Gini Index as the original data sources.  
