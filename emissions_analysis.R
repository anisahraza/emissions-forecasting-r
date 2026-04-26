# ============================================================
# 📉 UK Greenhouse Gas Emissions Analysis (1990–2023)
# Time Series Modelling, Forecasting & Sector Breakdown
# ============================================================
# Objective:
# Analyse UK greenhouse gas emissions using time series methods,
# including trend detection, stationarity testing, forecasting,
# and industry-level emissions analysis.

# ============================================================
# 1. SETUP & DATA LOADING
# ============================================================

# Set working directory (local environment)
> setwd("/Users/anisah/Desktop")

# ============================================================
# 2. OUTLIER DETECTION
# ============================================================

# Standardise emissions series using z-scores
# Purpose: identify potential extreme values in emissions data
> z_scores <- scale(emissions_ts)

# Extract outliers (values beyond ±3 standard deviations)
> outliers <- emissions_ts[abs(z_scores) > 3]

# Confirm presence/absence of outliers
> print(outliers)
numeric(0)


# ============================================================
# 3. DATA IMPORT & TIME SERIES CONSTRUCTION
# ============================================================

# Load required library for Excel file handling
> library(readxl)

# Define dataset location
> file_path <- "provisionalatmoshpericemissionsghg.xlsx"

# Extract emissions data (1990–2023) and convert to time series object
> emissions_ts <- ts(as.numeric(read_excel(file_path, sheet = 3, range = "Y9:Y42", col_names = FALSE)[[1]]), start = 1990)

# Visualise full emissions time series
> ts.plot(emissions_ts,
+ main = "Total Greenhouse Gas Emissions in the UK (1990–2023)",
+ xlab = "Year",
+ ylab = "Total Emissions (in thousands)")


# ============================================================
# 4. STATIONARITY TESTING (ADF TEST)
# ============================================================

# Load package for statistical time series testing
> library(tseries)

# Perform Augmented Dickey-Fuller test
# Purpose: determine whether the series is stationary
> adf_result <- adf.test(emissions_ts)

# Display test results
> print(adf_result)


# ============================================================
# 5. FORECASTING MODELS (ARIMA & ETS)
# ============================================================

# Load forecasting package
> library(forecast)

# Automatically select best ARIMA model
> arima_model <- auto.arima(emissions_ts)

# Diagnostic checks on ARIMA residuals
> checkresiduals(arima_model)


# Fit ETS exponential smoothing model
> ets_model <- ets(emissions_ts)

# Residual diagnostics for ETS model
> checkresiduals(ets_model)


# Alternative ARIMA model with enforced differencing
> arima_model2 <- auto.arima(emissions_ts, d = 2)

# Residual diagnostics for alternative ARIMA model
> checkresiduals(arima_model2)


# ============================================================
# 6. RESIDUAL ANALYSIS
# ============================================================

# Extract ARIMA residuals
> residuals_arima2 <- residuals(arima_model2)

# Check distribution of residuals
> hist(residuals_arima2,
+ main = "Histogram of ARIMA(0,2,2) Residuals",
+ xlab = "Residuals",
+ freq = FALSE)

# Overlay normal distribution curve for comparison
> curve(dnorm(x, mean = mean(residuals_arima2), sd = sd(residuals_arima2)), 
+       col = "red", lwd = 2, add = TRUE)


# ============================================================
# 7. FORECASTING FUTURE EMISSIONS
# ============================================================

# Generate 5-year forecast using ARIMA model
> arima_forecast2 <- forecast(arima_model2, h = 5)

# Plot forecast with custom axis formatting
> plot(
+ arima_forecast2,
+ main = "ARIMA(0,2,2) Forecast of UK Greenhouse Gas Emissions (2023–2028)",
+ xlab = "Year",
+ ylab = "Emissions (thousands)",
+ xaxt = "n")

# Add yearly tick marks for readability
> axis(1, at = seq(1990, 2028, by = 5), labels = seq(1990, 2028, by = 5))


# ============================================================
# 8. FORECAST ACCURACY COMPARISON
# ============================================================

# Generate forecasts for model comparison
> arima_forecast <- forecast(arima_model, h = 5)
> ets_forecast <- forecast(ets_model, h = 5)

# Compute accuracy metrics
> arima_accuracy <- accuracy(arima_forecast)
> ets_accuracy <- accuracy(ets_forecast)
> arima_accuracy2 <- accuracy(arima_forecast2)

# Display model performance comparison
> print(arima_accuracy)
> print(arima_accuracy2)
> print(ets_accuracy)


# ============================================================
# 9. INDUSTRY-LEVEL EMISSIONS ANALYSIS
# ============================================================

# Load additional libraries for data manipulation
> library(tidyr)
> library(dplyr)

# Import sector-level emissions dataset
> emissions_industry_total <- read_excel(file_path, sheet = 3, range = "A8:X42")

# Aggregate total emissions by sector
> column_totals <- colSums(emissions_industry_total[, -1], na.rm = TRUE)

# Identify top 10 emitting sectors
> top_10_totals <- sort(column_totals, decreasing = TRUE)[1:10]

# Display highest emitting sectors
> top_10_totals


# ============================================================
# 10. TOP SECTORS IN 2022
# ============================================================

# Extract 2022 emissions by industry
> emissions_industry <- read_excel(file_path, sheet = 3, range = "A8:X42")

# Filter for 2022 data
> emissions_2022 <- emissions_industry[emissions_industry$`Industry name` == 2022, ]

# Identify top 5 emitting sectors in 2022
> top_5_emissions <- emissions_2022 %>%
+ pivot_longer(cols = -`Industry name`, names_to = "sector", values_to = "emission") %>% 
+ arrange(desc(emission)) %>%
+ head(5)

# Display results
> top_5_emissions


# ============================================================
# 11. VISUALISING TOP EMITTING SECTORS
# ============================================================

# Set plot margins for readability
> par(mar = c(5, 8, 4, 2)) 

# Prepare data for visualisation
> top_5_totals <- top_5_emissions$emission
> names(top_5_totals) <- top_5_emissions$sector

# Create bar chart of top emitting sectors
> barplot_heights <- barplot(
+ top_5_totals,
+ main = "Top 5 Sectors by Total Emissions (2022)",
+ xlab = "Emissions",
+ ylab = "",
+ las = 1, 
+ col = viridis::viridis(5),
+ xaxt = "n"
+ )

# Label y-axis clearly
> mtext("Total Emissions", side = 2, line = 6, cex = 1.2)

# Add legend for sector identification
> legend(
+ "topright",
+ legend = names(top_5_totals),
+ fill = viridis::viridis(5), 
+ title = "Sectors",
+ cex = 0.8 
+ )
