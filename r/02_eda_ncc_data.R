# ======================================================
# 📊 NCC Telecom Data - Exploratory Data Analysis (EDA)
# File: r/02_eda_ncc_data.R
# ======================================================

# Load packages
library(readr)     # for reading CSV
library(dplyr)     # for data wrangling
library(ggplot2)   # for visualization
library(lubridate) # for dates
library(scales)    # for comma_format on y-axis

# ---------------------------
# 1. Load cleaned data
# ---------------------------
ncc_clean <- read_csv("data_clean/ncc_subscriptions_teledensity_clean.csv")

# 2. Quick inspection
head(ncc_clean)
str(ncc_clean)

# 3. Ensure 'month' is Date type
ncc_clean <- ncc_clean %>%
  mutate(month = as.Date(month))

# ---------------------------
# 4. Plot: Subscriptions over time
# ---------------------------
p1 <- ggplot(ncc_clean, aes(x = month, y = subscriptions)) +
  geom_line(color = "steelblue", linewidth = 1) +
  geom_point(color = "darkblue", size = 2) +
  labs(title = "📈 Active Mobile Subscriptions Over Time",
       x = "Month", y = "Subscriptions (millions)") +
  theme_minimal(base_size = 14) +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  )

# Save chart
ggsave("outputs/subscriptions_trend.png", p1,
       width = 8, height = 5, dpi = 300, bg = "white")

# ---------------------------
# 5. Plot: Teledensity (%) over time
# ---------------------------
p2 <- ggplot(ncc_clean, aes(x = month, y = teledensity)) +
  geom_line(color = "darkgreen", linewidth = 1) +
  geom_point(color = "forestgreen", size = 2) +
  labs(title = "🌍 Teledensity (%) Over Time",
       x = "Month", y = "Teledensity (%)") +
  theme_minimal(base_size = 14) +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  )

# Save chart
ggsave("outputs/teledensity_trend.png", p2,
       width = 8, height = 5, dpi = 300, bg = "white")

# ---------------------------
# 6. Combined dual-axis plot (optional, extra)
# ---------------------------
# Here I put subscriptions (millions) on the left axis
# and teledensity (%) on the right axis.
# A scaling factor makes them align properly.

# Compute scale factor
subs_millions <- ncc_clean$subscriptions / 1e6
max_subs_m <- max(subs_millions, na.rm = TRUE)
max_tel    <- max(ncc_clean$teledensity, na.rm = TRUE)

scale_factor <- ifelse(max_tel == 0 | is.na(max_tel), 1, max_subs_m / max_tel)

# Build combined plot
p_combined <- ggplot(ncc_clean, aes(x = month)) +
  geom_line(aes(y = subscriptions / 1e6,
                color = "Subscriptions (millions)"),
            size = 1.1) +
  geom_point(aes(y = subscriptions / 1e6,
                 color = "Subscriptions (millions)"),
             size = 1.5) +
  geom_line(aes(y = teledensity * scale_factor,
                color = "Teledensity (%)"),
            linetype = "dashed", size = 1.0) +
  geom_point(aes(y = teledensity * scale_factor,
                 color = "Teledensity (%)"),
             size = 1.5, shape = 1) +
  scale_y_continuous(
    name = "Subscriptions (millions)",
    labels = comma_format(accuracy = 0.1),
    sec.axis = sec_axis(~ . / scale_factor,
                        name = "Teledensity (%)")
  ) +
  scale_color_manual(
    name = "",
    values = c("Subscriptions (millions)" = "steelblue",
               "Teledensity (%)" = "darkgreen")
  ) +
  labs(
    title = "📊 Nigeria — Subscriptions vs Teledensity",
    subtitle = "Left: total subscribers (millions). Right: teledensity (%)",
    x = "Month"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    legend.position = "bottom",
    plot.background  = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA),
    axis.title.y.left  = element_text(color = "steelblue"),
    axis.title.y.right = element_text(color = "darkgreen")
  )

# Save combined chart
ggsave("outputs/ncc_combined_subs_teledensity.png", p_combined,
       width = 10, height = 5.5, dpi = 300, bg = "white")

# ---------------------------
# 7. Console check
# ---------------------------
print(p1)
print(p2)
print(p_combined)

cat("✅ All plots saved in outputs/ folder\n")
