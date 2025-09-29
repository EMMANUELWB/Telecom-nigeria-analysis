# ======================================================
# 🔗 Merge NCC + World Bank Data
# File: r/04_merge_ncc_wb.R
# ======================================================

# Load packages
library(readr)
library(dplyr)
library(ggplot2)

# ---------------------------
# Step 1: Load cleaned datasets
# ---------------------------
ncc <- read_csv("data_clean/ncc_subscriptions_teledensity_clean.csv")
wb  <- read_csv("data_clean/worldbank_mobile_subs_clean.csv")

# ---------------------------
# Step 2: Filter World Bank to Nigeria only
# ---------------------------
wb_ng <- wb %>%
  filter(country == "Nigeria",
         indicator == "Mobile-cellular subscriptions (per 100 people)") %>%
  select(country, year, subscriptions_per_100)


head(wb_ng)

# ---------------------------
# Step 3: Aggregate NCC to yearly average
# ---------------------------
ncc_yearly <- ncc %>%
  group_by(year) %>%
  summarise(
    avg_subscriptions = mean(subscriptions, na.rm = TRUE),
    avg_teledensity   = mean(teledensity, na.rm = TRUE)
  )

head(ncc_yearly)

# ---------------------------
# Step 4: Merge datasets by year
# ---------------------------
merged <- ncc_yearly %>%
  left_join(wb_ng, by = "year")

# Quick check
print(merged, n = 10)

# ---------------------------
# Step 5: Comparison chart
# ---------------------------
p <- ggplot(merged, aes(x = year)) +
  geom_line(aes(y = avg_teledensity, color = "NCC Teledensity (%)"), linewidth = 1) +
  geom_line(aes(y = subscriptions_per_100, color = "World Bank Subscriptions per 100"), linewidth = 1, linetype = "dashed") +
  labs(
    title = "📊 Nigeria Mobile Penetration: NCC vs World Bank",
    x = "Year",
    y = "Per 100 People / Teledensity (%)",
    color = "Source"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  )

# Save chart
ggsave("outputs/ncc_vs_worldbank_comparison.png", p, width = 8, height = 5, dpi = 300)

# ---------------------------
# Step 6: Show chart
# ---------------------------
print(p)
