# 📡 Telecom Data Analytics Case Study: Nigeria

## Project Overview
This project explores Nigeria’s mobile subscription growth by reconciling data from the **Nigerian Communications Commission (NCC)** and the **World Bank (WB)**. It focuses on subscription totals and growth trends rather than operator-level competition or broadband penetration.

The case study demonstrates **data preparation, cleaning, merging, and visualization using R**, with final insights presented through **PowerPoint storytelling**.

## Goal
- Convert World Bank’s *“mobile subscriptions per 100 people”* metric into **total subscriptions** using Nigeria’s population estimates.  
- Merge World Bank totals with NCC’s annual subscription data (December snapshots).  
- Compare differences between NCC and World Bank reporting.  
- Visualize and interpret the trend of total subscriptions over time.  

## Datasets
- **Nigerian Communications Commission (NCC):** Monthly mobile subscription and teledensity data.  
- **World Bank (WB):** Mobile cellular subscriptions per 100 people.  
- **World Bank (Population):** Annual Nigerian population estimates for conversion.  

## Methodology
1. **Data Cleaning (R):** Selected relevant columns, filtered December-only NCC values, and prepared World Bank data.  
2. **Transformation (R):** Converted World Bank subscriptions per 100 → totals using population.  
3. **Merging (R):** Joined World Bank and NCC datasets by year.  
4. **Visualization (R):** Created line charts comparing subscription growth trends.  
5. **Storytelling (PowerPoint):** Highlighted insights, differences, and key takeaways.  

## Key Insights
- Both NCC and World Bank datasets show strong growth in Nigeria’s mobile subscriptions since 2000.  
- After converting WB’s per-100 figures, totals align closely with NCC’s December-reported subscriptions, though small differences exist due to reporting methodology.  
- By 2023, Nigeria surpassed **220 million subscriptions**, indicating near-saturation relative to population.  

## Tools
- **R (dplyr, ggplot2, readr)** – Data preparation, merging, and visualization  
- **PowerPoint** – Storytelling and presentation of results  
