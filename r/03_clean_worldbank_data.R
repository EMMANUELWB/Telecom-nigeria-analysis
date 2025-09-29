# ======================================================
# 🌍 World Bank Mobile Subscriptions - Cleaning
# File: r/03_clean_worldbank_data.R
# ======================================================

# Load packages
library(readr)
library(dplyr)
library(tidyr)

# 1. Load raw data
wb_raw <- read_csv("data_raw/mobile-cellular-subscriptions_1758627613877.csv")

# 2. Inspect structure
head(wb_raw)
colnames(wb_raw)


wb_clean <- wb_raw %>%
  select(
    country = entityName,
    iso_code = entityIso,
    year = dataYear,
    subscriptions_per_100 = dataValue,
    indicator = seriesName,
    units = seriesUnits
  )

head(wb_clean, 5)


# 4. Save cleaned dataset
write_csv(wb_clean, "data_clean/worldbank_mobile_subs_clean.csv")

# Quick check
print(wb_clean, n = 10)
