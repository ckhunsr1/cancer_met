# Cancer Metastasis

## *Quick Reference*
- **Step1_Input_Processing.R:** This file processes SEER excel file and gives an output ready to be used by APC webtool (https://analysistools.cancer.gov/apc/).
- **Step2_APC_Forecast.R:** This file performs forecasting of cancer metastasis incidence rates using Age-Period-Cohort model. We specifically followed the method detailed in Rosenberg et al. (https://pubmed.ncbi.nlm.nih.gov/26063794/). It should be noted also that this file also contained the code written by Dr. Wenjiang J. Fu, which utilizes AutoRegressive Integrated Moving Average (ARIMA) projection to perform forecasting. 
- **Step3_Output_Processing.R:** This file processes the output from Step2_APC_Forecast.R and gives the result with cancer metastasis incidence rates and corresponding confidence intervals.

## *functions folder*
**Objective:** Various functions required for codes above to run.
