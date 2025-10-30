# ==============================================================================
# Script: 11_merge_for_q4.R
# Purpose: Merge datasets for Question 4 - GDP, demographics, and home advantage
# Author: Team 5
# Date: 2025-10-29
# ==============================================================================

# Set working directory
setwd("/home/han/Github/STAT3355-Data-Analysis/Team-Project")

cat("=== MERGING DATA FOR QUESTION 4: ECONOMICS & DEMOGRAPHICS ANALYSIS ===\n\n")

# ==============================================================================
# STEP 1: Load Q3 dataset as base (already has country factors)
# ==============================================================================

cat("STEP 1: Loading Q3 dataset as base...\n")

q4_data <- read.csv("analysis_data/q3_country_factors.csv", stringsAsFactors = FALSE)

cat("- Q3 data loaded:", nrow(q4_data), "records\n\n")

# ==============================================================================
# STEP 2: Add GDP data
# ==============================================================================

cat("STEP 2: Adding GDP data...\n")

# Load GDP data
gdp <- read.csv("cleaned_data/gdp_long.csv", stringsAsFactors = FALSE)

# Select relevant columns
gdp_select <- gdp[, c(
  "noc",
  "year",
  "gdp",
  "gdp_per_capita"
)]

# Rename for clarity
names(gdp_select) <- c(
  "noc",
  "year",
  "country_gdp",
  "country_gdp_per_capita"
)

# Merge with main data
q4_data <- merge(
  q4_data,
  gdp_select,
  by.x = c("NOC", "Year"),
  by.y = c("noc", "year"),
  all.x = TRUE
)

cat("- GDP data added\n")
cat("- Records with GDP data:", sum(!is.na(q4_data$country_gdp)), "\n")
cat("- Records with GDP per capita:", sum(!is.na(q4_data$country_gdp_per_capita)), "\n\n")

# ==============================================================================
# STEP 3: Add full demographic data
# ==============================================================================

cat("STEP 3: Adding demographic age structure data...\n")

# Load population data
population <- read.csv("cleaned_data/population_cleaned.csv", stringsAsFactors = FALSE)

# Select demographic proportion columns
demo_select <- population[, c(
  "noc",
  "year",
  "child_proportion",
  "youth_proportion",
  "elderly_proportion"
)]

# Rename for clarity
names(demo_select) <- c(
  "noc",
  "year",
  "country_child_prop",
  "country_youth_prop",
  "country_elderly_prop"
)

# Merge with main data
q4_data <- merge(
  q4_data,
  demo_select,
  by.x = c("NOC", "Year"),
  by.y = c("noc", "year"),
  all.x = TRUE
)

cat("- Demographic proportions added\n")
cat("- Records with demographic data:", sum(!is.na(q4_data$country_child_prop)), "\n\n")

# ==============================================================================
# STEP 4: Create GDP categories
# ==============================================================================

cat("STEP 4: Creating GDP categories...\n")

# Create GDP per capita tertiles (Low/Medium/High)
if (sum(!is.na(q4_data$country_gdp_per_capita)) > 0) {
  gdp_quantiles <- quantile(q4_data$country_gdp_per_capita,
                            probs = c(0, 1/3, 2/3, 1),
                            na.rm = TRUE)

  q4_data$gdp_category <- cut(
    q4_data$country_gdp_per_capita,
    breaks = gdp_quantiles,
    labels = c("Low GDP", "Medium GDP", "High GDP"),
    include.lowest = TRUE
  )

  cat("- GDP categories created:\n")
  cat("  - Low GDP: <", round(gdp_quantiles[2], 0), "\n")
  cat("  - Medium GDP:", round(gdp_quantiles[2], 0), "-", round(gdp_quantiles[3], 0), "\n")
  cat("  - High GDP: >", round(gdp_quantiles[3], 0), "\n\n")

  # Create binary indicators
  q4_data$is_low_gdp <- ifelse(q4_data$gdp_category == "Low GDP", 1, 0)
  q4_data$is_medium_gdp <- ifelse(q4_data$gdp_category == "Medium GDP", 1, 0)
  q4_data$is_high_gdp <- ifelse(q4_data$gdp_category == "High GDP", 1, 0)
}

# Log transform GDP for regression (handle zeros/NAs)
q4_data$log_gdp_per_capita <- ifelse(
  !is.na(q4_data$country_gdp_per_capita) & q4_data$country_gdp_per_capita > 0,
  log(q4_data$country_gdp_per_capita),
  NA
)

cat("- Log GDP per capita calculated\n\n")

# ==============================================================================
# STEP 5: Create demographic categories
# ==============================================================================

cat("STEP 5: Creating demographic categories...\n")

# Create binary indicators for "young" vs "old" populations
# Young = above median youth proportion
if (sum(!is.na(q4_data$country_youth_prop)) > 0) {
  youth_median <- median(q4_data$country_youth_prop, na.rm = TRUE)
  q4_data$is_young_population <- ifelse(
    !is.na(q4_data$country_youth_prop) & q4_data$country_youth_prop > youth_median,
    1,
    0
  )
  cat("- Young population indicator created (median youth prop:", round(youth_median, 3), ")\n")
}

# Old = above median elderly proportion
if (sum(!is.na(q4_data$country_elderly_prop)) > 0) {
  elderly_median <- median(q4_data$country_elderly_prop, na.rm = TRUE)
  q4_data$is_old_population <- ifelse(
    !is.na(q4_data$country_elderly_prop) & q4_data$country_elderly_prop > elderly_median,
    1,
    0
  )
  cat("- Old population indicator created (median elderly prop:", round(elderly_median, 3), ")\n\n")
}

# ==============================================================================
# STEP 6: Create interaction terms for economic analysis
# ==============================================================================

cat("STEP 6: Creating interaction terms...\n")

# Hosting × GDP category
q4_data$host_low_gdp <- ifelse(q4_data$is_host == 1 & q4_data$is_low_gdp == 1, 1, 0)
q4_data$host_medium_gdp <- ifelse(q4_data$is_host == 1 & q4_data$is_medium_gdp == 1, 1, 0)
q4_data$host_high_gdp <- ifelse(q4_data$is_host == 1 & q4_data$is_high_gdp == 1, 1, 0)

# Hosting × Demographics
q4_data$host_young_pop <- ifelse(q4_data$is_host == 1 & q4_data$is_young_population == 1, 1, 0)
q4_data$host_old_pop <- ifelse(q4_data$is_host == 1 & q4_data$is_old_population == 1, 1, 0)

cat("- Interaction terms created\n\n")

# ==============================================================================
# STEP 7: Calculate economic efficiency metrics
# ==============================================================================

cat("STEP 7: Calculating efficiency metrics...\n")

# Medals per GDP (medals per billion GDP)
q4_data$medals_per_billion_gdp <- ifelse(
  !is.na(q4_data$country_gdp) & q4_data$country_gdp > 0,
  (q4_data$total_country_medals / q4_data$country_gdp) * 1e9,
  NA
)

# "Medal efficiency" = actual medal rate / expected based on GDP
# For host countries, compare to their baseline
q4_data$economic_efficiency <- ifelse(
  !is.na(q4_data$baseline_medal_rate) & q4_data$baseline_medal_rate > 0,
  q4_data$medal_won / q4_data$baseline_medal_rate,
  NA
)

cat("- Efficiency metrics calculated\n\n")

# ==============================================================================
# STEP 8: Reorder columns
# ==============================================================================

cat("STEP 8: Organizing final dataset...\n")

# Get all columns
all_cols <- names(q4_data)

# Key columns first
key_cols <- c(
  "Year", "City", "NOC", "Team", "Name", "Sex", "Age",
  "Sport", "gymnastics_type", "Event",
  "Medal", "medal_won", "gold_medal", "medal_points",
  "is_host", "first_time_host", "hosting_count_prior", "hosting_count_total",
  # Country size (from Q3)
  "country_size_category", "total_area_km2",
  # Population (from Q3)
  "country_total_population", "population_category", "country_working_age_prop",
  # GDP
  "country_gdp", "country_gdp_per_capita", "log_gdp_per_capita",
  "gdp_category", "is_low_gdp", "is_medium_gdp", "is_high_gdp",
  # Demographics
  "country_child_prop", "country_youth_prop", "country_elderly_prop",
  "is_young_population", "is_old_population",
  # Efficiency metrics
  "gymnast_count", "gymnasts_per_million",
  "total_country_medals", "medals_per_million",
  "medals_per_billion_gdp", "economic_efficiency",
  # Baseline and deviation
  "baseline_medal_rate", "baseline_gold_rate",
  "deviation_from_baseline_medals", "deviation_from_baseline_golds",
  # Interaction terms
  "host_low_gdp", "host_medium_gdp", "host_high_gdp",
  "host_young_pop", "host_old_pop",
  "host_small", "host_medium", "host_large"
)

# Remaining columns
remaining_cols <- setdiff(all_cols, key_cols)

# Reorder
q4_final <- q4_data[, c(key_cols, remaining_cols)]

# Sort
q4_final <- q4_final[order(q4_final$Year, q4_final$NOC, q4_final$Name), ]
rownames(q4_final) <- NULL

cat("- Dataset organized\n\n")

# ==============================================================================
# STEP 9: Summary statistics
# ==============================================================================

cat("=== SUMMARY STATISTICS ===\n\n")

cat("Final Q4 Dataset:\n")
cat("- Total records:", nrow(q4_final), "\n")
cat("- Countries:", length(unique(q4_final$NOC)), "\n")
cat("- Years:", length(unique(q4_final$Year)), "\n\n")

cat("Data Completeness:\n")
cat("- Records with GDP data:", sum(!is.na(q4_final$country_gdp_per_capita)), "\n")
cat("- Records with demographic data:", sum(!is.na(q4_final$country_youth_prop)), "\n")
cat("- Records with complete economic data:", sum(!is.na(q4_final$country_gdp_per_capita) &
                                                    !is.na(q4_final$country_youth_prop)), "\n\n")

cat("GDP Category Distribution:\n")
gdp_dist <- table(q4_final$gdp_category, useNA = "ifany")
print(gdp_dist)
cat("\n")

cat("Home Advantage by GDP Category:\n")
for (gdp_cat in c("Low GDP", "Medium GDP", "High GDP")) {
  gdp_data <- q4_final[q4_final$gdp_category == gdp_cat & !is.na(q4_final$gdp_category), ]
  if (nrow(gdp_data) > 0) {
    host_rate <- mean(gdp_data$medal_won[gdp_data$is_host == 1], na.rm = TRUE)
    nonhost_rate <- mean(gdp_data$medal_won[gdp_data$is_host == 0], na.rm = TRUE)
    advantage <- host_rate - nonhost_rate

    cat("  ", gdp_cat, ":\n", sep = "")
    cat("    - Host medal rate:", round(host_rate, 4), "\n")
    cat("    - Non-host medal rate:", round(nonhost_rate, 4), "\n")
    cat("    - Home advantage:", round(advantage, 4), "\n")
  }
}
cat("\n")

# ==============================================================================
# STEP 10: Save merged dataset
# ==============================================================================

cat("=== SAVING MERGED DATA ===\n")

write.csv(q4_final, "analysis_data/q4_economics_demographics.csv", row.names = FALSE)

cat("Saved to: analysis_data/q4_economics_demographics.csv\n")
cat("Rows:", nrow(q4_final), "\n")
cat("Columns:", ncol(q4_final), "\n\n")

cat("=== SCRIPT COMPLETE ===\n")
cat("\nQuestion 4 dataset ready for economics & demographics analysis!\n\n")
cat("Key variables for analysis:\n")
cat("- country_gdp_per_capita: Economic prosperity\n")
cat("- log_gdp_per_capita: For regression analysis\n")
cat("- gdp_category: Low/Medium/High\n")
cat("- country_youth_prop, country_elderly_prop: Age structure\n")
cat("- is_young_population, is_old_population: Binary demographics\n")
cat("- medals_per_billion_gdp: Economic efficiency\n")
cat("- Interaction terms: host_low_gdp, host_high_gdp, etc.\n\n")
cat("Recommended analyses:\n")
cat("1. Correlation: GDP per capita vs home advantage magnitude\n")
cat("2. Regression: medal_won ~ is_host * log_gdp_per_capita\n")
cat("3. Compare rich vs poor host nations\n")
cat("4. Demographic effects on home advantage\n")
