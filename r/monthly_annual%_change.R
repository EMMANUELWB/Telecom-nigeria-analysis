# ============================
# 📡 NCC Subscriptions & Teledensity
# ============================
library(dplyr)
library(lubridate)
library(ggplot2)
library(readr)
library(tibble)

# --- Load NCC CSV (adjust path if needed)
ncc <- read_csv("data_clean/ncc_subscriptions_teledensity_clean.csv")

# --- Prepare monthly data
ncc_monthly <- ncc %>%
  mutate(month = as.Date(paste0(month, "-01"))) %>%
  arrange(month) %>%
  mutate(subs_pct_change = (subscriptions / lag(subscriptions) - 1) * 100)

# --- Flag enforcement date(s)
enforcement_dates <- as.Date(c("2022-04-04", "2023-03-15"))

# --- Plot subscriptions & teledensity
p <- ggplot(ncc_monthly, aes(month)) +
  geom_line(aes(y = subscriptions/1e6), color = "steelblue") +
  geom_line(aes(y = teledensity), color = "darkgreen") +
  geom_vline(xintercept = enforcement_dates, linetype = "dashed", color = "red") +
  labs(
    title = "NCC Subscriptions & Teledensity",
    y = "Subscriptions (millions) & Teledensity (%)",
    x = "Month"
  ) +
  theme_minimal(base_size = 13) +
  theme(plot.background = element_rect(fill = "white", color = NA))

# --- Save chart
ggsave("outputs/ncc_subs_teledensity.png", p, width = 10, height = 6, dpi = 300, bg = "white")

# ======================================================
# Function to measure impact of enforcement
# ======================================================
impact <- function(df, date, days = 90){
  start <- as.Date(date)
  
  before <- df %>%
    filter(month == start %m-% months(1)) %>%
    pull(subscriptions)
  
  after <- df %>%
    filter(month == start %m+% months(days %/% 30)) %>%
    pull(subscriptions)
  
  tibble(
    date = start,
    before = before,
    after = after,
    pct_change = (after - before)/before * 100
  )
}

# Apply the function to all enforcement dates
impact_results <- bind_rows(lapply(enforcement_dates, function(d) impact(ncc_monthly, d)))

# ======================================================
# Save impact results as CSV in clean folder
# ======================================================
write_csv(impact_results, "clean/impact_results.csv")