# The Politics of Falsehood: A Mixed Methods Study of Disinformation and Democratic Backsliding in Hungary and Poland - R Scripts

This repository contains three R scripts used in my dissertation research on the relationship between government disinformation and deliberative democracy in the European Union (2000–2024).  

The workflow is organised into three steps: dataset creation, regression analysis, and plotting.  

For a full description of all the variables included in the dataset, please refer to Appendix B of the dissertation.

---

## Contents

- **builddataset.R**  
  - Builds the dataset from the V-Dem v15 dataset and World Bank Gini index data.  
  - Filters to the period 2000–2024.  
  - Manually creates geopolitical controls (EU, NATO, Soviet legacy).  
  - Reverses disinformation and polarisation scales (so higher values represent more).  
  - Creates the dependent variable `delibdem_3yr` (3-year change in deliberative democracy index).  
  - Saves two files:  
    - `diss_data.csv` (global sample)  
    - `diss_data_eu.csv` (EU member states only).  

- **research.R**  
  - Runs the core regression models (Hypotheses 1–3) on the EU dataset.  
  - Models test interactions between government disinformation and:
    - Societal polarisation 
    - Political polarisation  
    - Gini index  
    - Distribution of resources  
  - Outputs regression tables to the console (via `texreg::screenreg`).  

- **graphs.R**  
  - Produces all figures used in the dissertation, including:  
    1. EU trends in government, party, and foreign disinformation over time  
    2. Quadrant scatter plot of government disinformation vs deliberative democracy change used for case selection 
    3. Trends in deliberative democracy for Hungary, Poland, and the EU average  
    4. Marginal effect plots of government disinformation × societal polarisation  
    5. Marginal effect plots of government disinformation × political polarisation  
    6. Normalised overlay for Hungary: deliberative democracy vs government disinformation (original V-Dem scale)  
    7. Normalised overlay for Poland: deliberative democracy vs government disinformation (original V-Dem scale)  
  - Each figure is also saved as a `.png` file in the working directory.  

---

## Citation

If you use this code, please cite the V-Dem v15 dataset and the World Bank Gini Index as the original data sources.  

Coppedge, M., Gerring, J., Knutsen, C.H., Lindberg, S.I., Teorell, J., Altman, D., Angiolillo, F., Bernhard, M., et al. (2025). V-Dem [Country-Year/Country-Date] Dataset v15. Varieties of Democracy (V-Dem) Project. Available at: https://doi.org/10.23696/vdemds25. 

World Bank. (n.d.). ‘Gini index’. [online] World Bank. Available at: https://data.worldbank.org/indicator/SI.POV.GINI.
