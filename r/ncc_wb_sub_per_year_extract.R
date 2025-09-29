# ======================================================
# 📡 Nigeria Telecom: Convert WB per 100 → Totals (Dec NCC only)
# ======================================================

library(dplyr)
library(readr)

# --- Load datasets
wb <- read_csv("data_clean/worldbank_mobile_subs_clean.csv")       
ncc <- read_csv("data_clean/ncc_subscriptions_teledensity_clean.csv")    

# --- Nigeria population (millions, World Bank estimates)
# Source: World Bank SP.POP.TOTL
population <- tibble::tibble(
  Year = 2000:2024,
  population = c(
    122876723, 126819921, 130854904, 134942222, 139079963,
    143265302, 147496168, 151782098, 156129819, 160540160,
    165014557, 169543930, 174129142, 178770855, 183466920,
    188201149, 192960119, 197749887, 202567952, 207414669,
    212289154, 217188078, 222104331, 227020204, 231842396
  )
)

# --- Clean WB
wb_clean <- wb %>%
  select(year, subscriptions_per_100) %>%
  mutate(year = as.integer(year))

# --- Clean NCC (📌 December only, using month_name == 12)
ncc_clean <- ncc %>%
  filter(month_name == 12) %>%       # December snapshots
  select(year, subscriptions) %>%
  mutate(year = as.integer(year))

# --- Convert WB to totals
wb_totals <- wb_clean %>%
  inner_join(population, by = c("year" = "Year")) %>%
  mutate(total_subscriptions = (subscriptions_per_100 / 100) * population)

# --- Merge WB & NCC
merged <- wb_totals %>%
  inner_join(ncc_clean, by = "year") %>%
  select(year, wb_total = total_subscriptions, ncc_total = subscriptions)

# --- Save merged dataset
write_csv(merged, "merged_subscriptions.csv")

# --- Preview
print(merged, n = 25)
