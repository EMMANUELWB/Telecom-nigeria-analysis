# ======================================================
# 📡 NCC Telecom Data Cleaning - Nigeria
# File: r/01_clean_ncc_data.R
# ======================================================

# Load packages
library(readr)     # read CSV files
library(dplyr)     # data manipulation
library(stringr)   # string handling
library(lubridate) # date handling

# ---------------------------
# Step 1: Load raw NCC dataset
# ---------------------------
ncc_raw <- read_csv("data_raw/ncc_subscriptions_teledensity.csv")

# Step 2: Inspect structure
head(ncc_raw)
str(ncc_raw)
colnames(ncc_raw)

# ---------------------------
# Step 3: Rename columns
# ---------------------------
ncc_clean <- ncc_raw %>%
  rename(
    month = 1,          # reporting month (e.g., "Jul'25")
    subscriptions = 2,  # active mobile subscriptions
    teledensity = 3     # teledensity (%)
  )

# ---------------------------
# Step 4: Clean + extract year and month
# ---------------------------
ncc_clean <- ncc_clean %>%
  mutate(
    # Convert "Jul'25" → proper Date, then keep only Year-Month
    month = parse_date_time(month, orders = c("b'y", "bY")) %>% 
      floor_date("month"),
    month = format(month, "%Y-%m"),  # store as "YYYY-MM"
    
    # Remove commas in subscriptions and convert to numeric
    subscriptions = as.numeric(gsub(",", "", subscriptions)),
    
    # Convert teledensity to numeric
    teledensity = as.numeric(teledensity),
    
    # Extract clean year and month name directly
    year = as.numeric(str_sub(month, 1, 4)),       # "2025"
    month_name = str_sub(month, 6, 7)              # "07"
  )

# ---------------------------
# Step 5: Check cleaned dataset
# ---------------------------
print(ncc_clean, n = 10)

# ---------------------------
# Step 6: Save cleaned dataset
# ---------------------------
write_csv(ncc_clean, "data_clean/ncc_subscriptions_teledensity_clean.csv")
