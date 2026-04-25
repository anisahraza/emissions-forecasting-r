# UK Greenhouse Gas Emissions: Time Series Analysis & Forecasting (R)

## Overview
This project analyses UK greenhouse gas emissions from 1990–2023 using time series methods in R. It focuses on understanding long-term trends, testing statistical properties of the data, building forecasting models, and identifying key industrial contributors to emissions.

The analysis includes:
- Outlier detection  
- Stationarity testing (ADF test)  
- Time series modelling (ARIMA & ETS)  
- Forecasting future emissions  
- Model comparison and accuracy evaluation  
- Sector-level emissions analysis  

---

## Objectives
The main goals of this project are to:
- Analyse historical trends in UK greenhouse gas emissions  
- Test whether emissions follow a stationary process  
- Build and compare forecasting models  
- Evaluate predictive accuracy using statistical metrics  
- Identify the highest-emitting industries in the UK  

---

## Dataset
The dataset contains UK greenhouse gas emissions data from 1990–2023, along with sector-level emissions breakdowns extracted from an Excel file.

---

## Tools Used
- R programming language  
- readxl (data import)  
- tseries (Augmented Dickey-Fuller test)  
- forecast (ARIMA, ETS, forecasting tools)  
- dplyr & tidyr (data manipulation)  
- Base R plotting functions  

---

### Model Evaluation
- Ljung-Box test used to assess residual independence  
- Accuracy metrics compared (RMSE, MAE, MAPE)  
- ARIMA and ETS models both showed strong performance with low residual autocorrelation  

