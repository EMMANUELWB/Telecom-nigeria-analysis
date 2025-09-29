# ======================================================
# 📊 NCC vs World Bank Comparison
# File: r/.R
# ======================================================

# Load packages
library(ggplot2)
library(dplyr)
library(readr)

# Create output folder if it doesn't exist
if (!dir.exists("output")) {
  dir.create("output")
}

# Load merged dataset
merged <- read_csv("data/processed/merged_ncc_wb.csv")

# ------------------------------------------------------
# Plot 1: NCC vs WB total subscriptions over time
# ------------------------------------------------------
p1 <- ggplot(merged, aes(x = year)) +
  geom_line(aes(y = wb_total, color = "World Bank"), size = 1.2) +
  geom_line(aes(y = ncc_total, color = "NCC"), size = 1.2) +
  labs(
    title = "NCC vs World Bank: Total Subscriptions (Nigeria)",
    x = "Year",
    y = "Total Subscriptions",
    color = "Source"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  )

# Save Plot 1
ggsave(
  filename = "output/ncc_vs_wb_total.png",
  plot = p1,
  width = 8,
  height = 5,
  dpi = 300,
  bg = "white"
)

# ------------------------------------------------------
# Plot 2: Difference (NCC - WB) over time
# ------------------------------------------------------
merged <- merged %>%
  mutate(diff = ncc_total - wb_total)

p2 <- ggplot(merged, aes(x = year, y = diff)) +
  geom_col(fill = "steelblue") +
  geom_hline(yintercept = 0, linetype = "dashed") +
  labs(
    title = "Difference between NCC and World Bank Subscriptions",
    x = "Year",
    y = "Difference (NCC - WB)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  )

# Save Plot 2
ggsave(
  filename = "output/ncc_vs_wb_difference.png",
  plot = p2,
  width = 8,
  height = 5,
  dpi = 300,
  bg = "white"
)
