# ==============================================================================
# Script: 10_merge_for_q3.R
# Purpose: Merge datasets for Question 3 - Country size, hosting experience, participation
# Author: Team 5
# Date: 2025-10-29
# ==============================================================================

# Set working directory
setwd("/home/han/Github/STAT3355-Data-Analysis/Team-Project")

cat("=== MERGING DATA FOR QUESTION 3: COUNTRY FACTORS ANALYSIS ===\n\n")

# ==============================================================================
# STEP 1: Load Q1 dataset as base
# ==============================================================================

cat("STEP 1: Loading Q1 dataset as base...\n")

q3_data <- read.csv("analysis_data/q1_home_advantage.csv", stringsAsFactors = FALSE)

cat("- Q1 data loaded:", nrow(q3_data), "records\n\n")

# ==============================================================================
# STEP 2: Add country size information
# ==============================================================================

cat("STEP 2: Adding country size information...\n")

# Load country info
country_info <- read.csv("cleaned_data/country_info.csv", stringsAsFactors = FALSE)

# Select relevant columns
country_size <- country_info[, c(
  "noc",
  "total_area_km2",
  "land_area_km2",
  "country_size_category"
)]

# Merge with main data
q3_data <- merge(
  q3_data,
  country_size,
  by.x = "NOC",
  by.y = "noc",
  all.x = TRUE
)

cat("- Country size data added\n")
cat("- Countries with size data:", sum(!is.na(q3_data$country_size_category)), "\n")
cat("- Countries missing size data:", sum(is.na(q3_data$country_size_category)), "\n\n")

# ==============================================================================
# STEP 3: Add population data
# ==============================================================================

cat("STEP 3: Adding population data...\n")

# Load population data
population <- read.csv("cleaned_data/population_cleaned.csv", stringsAsFactors = FALSE)

# Select relevant columns
pop_select <- population[, c(
  "noc",
  "year",
  "total_population",
  "working_age_population",
  "working_age_proportion"
)]

# Rename for clarity
names(pop_select) <- c(
  "noc",
  "year",
  "country_total_population",
  "country_working_age_pop",
  "country_working_age_prop"
)

# Merge with main data
q3_data <- merge(
  q3_data,
  pop_select,
  by.x = c("NOC", "Year"),
  by.y = c("noc", "year"),
  all.x = TRUE
)

cat("- Population data added\n")
cat("- Records with population data:", sum(!is.na(q3_data$country_total_population)), "\n\n")

# ==============================================================================
# STEP 4: Create size-based categories for analysis
# ==============================================================================

cat("STEP 4: Creating analysis categories...\n")

# Create binary size indicators
q3_data$is_small_country <- ifelse(q3_data$country_size_category == "Small", 1, 0)
q3_data$is_medium_country <- ifelse(q3_data$country_size_category == "Medium", 1, 0)
q3_data$is_large_country <- ifelse(q3_data$country_size_category == "Large", 1, 0)

# Create population tertiles (Small/Medium/Large by population)
if (sum(!is.na(q3_data$country_total_population)) > 0) {
  pop_quantiles <- quantile(q3_data$country_total_population,
                            probs = c(0, 1/3, 2/3, 1),
                            na.rm = TRUE)

  q3_data$population_category <- cut(
    q3_data$country_total_population,
    breaks = pop_quantiles,
    labels = c("Low Population", "Medium Population", "High Population"),
    include.lowest = TRUE
  )

  cat("- Population categories created\n")
}

# Create hosting experience categories
q3_data$hosting_experience <- cut(
  q3_data$hosting_count_total,
  breaks = c(-1, 0, 1, Inf),
  labels = c("Never Hosted", "First Time", "Repeat Host"),
  right = TRUE
)

cat("- Size and hosting categories created\n\n")

# ==============================================================================
# STEP 5: Calculate per-capita metrics
# ==============================================================================

cat("STEP 5: Calculating per-capita metrics...\n")

# Gymnasts per capita (per million people)
q3_data$gymnasts_per_million <- ifelse(
  !is.na(q3_data$country_total_population) & q3_data$country_total_population > 0,
  (q3_data$gymnast_count / q3_data$country_total_population) * 1000000,
  NA
)

# Medals per capita (per million people) - at country-year level
country_year_medals <- aggregate(
  medal_won ~ NOC + Year,
  data = q3_data,
  FUN = sum
)
names(country_year_medals) <- c("NOC", "Year", "total_country_medals")

q3_data <- merge(
  q3_data,
  country_year_medals,
  by = c("NOC", "Year"),
  all.x = TRUE
)

q3_data$medals_per_million <- ifelse(
  !is.na(q3_data$country_total_population) & q3_data$country_total_population > 0,
  (q3_data$total_country_medals / q3_data$country_total_population) * 1000000,
  NA
)

cat("- Per-capita metrics calculated\n\n")

# ==============================================================================
# STEP 6: Create interaction terms
# ==============================================================================

cat("STEP 6: Creating interaction terms...\n")

# Hosting × Country Size
q3_data$host_small <- ifelse(q3_data$is_host == 1 & q3_data$is_small_country == 1, 1, 0)
q3_data$host_medium <- ifelse(q3_data$is_host == 1 & q3_data$is_medium_country == 1, 1, 0)
q3_data$host_large <- ifelse(q3_data$is_host == 1 & q3_data$is_large_country == 1, 1, 0)

# Hosting × First Time
q3_data$host_first_time <- ifelse(q3_data$is_host == 1 & q3_data$first_time_host == 1, 1, 0)
q3_data$host_repeat <- ifelse(q3_data$is_host == 1 & q3_data$first_time_host == 0 & q3_data$is_host == 1, 1, 0)

cat("- Interaction terms created\n\n")

# ==============================================================================
# STEP 7: Reorder columns
# ==============================================================================

cat("STEP 7: Organizing final dataset...\n")

# Get all columns
all_cols <- names(q3_data)

# Key columns first
key_cols <- c(
  "Year", "City", "NOC", "Team", "Name", "Sex", "Age",
  "Sport", "gymnastics_type", "Event",
  "Medal", "medal_won", "gold_medal", "medal_points",
  "is_host", "first_time_host", "hosting_count_prior", "hosting_count_total",
  # Country size
  "total_area_km2", "land_area_km2", "country_size_category",
  "is_small_country", "is_medium_country", "is_large_country",
  # Population
  "country_total_population", "country_working_age_pop", "country_working_age_prop",
  "population_category",
  # Hosting experience
  "hosting_experience",
  # Per capita metrics
  "gymnast_count", "gymnasts_per_million",
  "total_country_medals", "medals_per_million",
  # Baseline and deviation
  "baseline_medal_rate", "baseline_gold_rate",
  "deviation_from_baseline_medals", "deviation_from_baseline_golds",
  # Interaction terms
  "host_small", "host_medium", "host_large",
  "host_first_time", "host_repeat"
)

# Remaining columns
remaining_cols <- setdiff(all_cols, key_cols)

# Reorder
q3_final <- q3_data[, c(key_cols, remaining_cols)]

# Sort
q3_final <- q3_final[order(q3_final$Year, q3_final$NOC, q3_final$Name), ]
rownames(q3_final) <- NULL

cat("- Dataset organized\n\n")

# ==============================================================================
# STEP 8: Summary statistics
# ==============================================================================

cat("=== SUMMARY STATISTICS ===\n\n")

cat("Final Q3 Dataset:\n")
cat("- Total records:", nrow(q3_final), "\n")
cat("- Countries:", length(unique(q3_final$NOC)), "\n")
cat("- Years:", length(unique(q3_final$Year)), "\n\n")

cat("Country Size Distribution:\n")
size_dist <- table(q3_final$country_size_category, useNA = "ifany")
print(size_dist)
cat("\n")

cat("Home Advantage by Country Size:\n")
for (size in c("Small", "Medium", "Large")) {
  size_data <- q3_final[q3_final$country_size_category == size & !is.na(q3_final$country_size_category), ]
  if (nrow(size_data) > 0) {
    host_rate <- mean(size_data$medal_won[size_data$is_host == 1], na.rm = TRUE)
    nonhost_rate <- mean(size_data$medal_won[size_data$is_host == 0], na.rm = TRUE)
    advantage <- host_rate - nonhost_rate

    cat("  ", size, "countries:\n", sep = "")
    cat("    - Host medal rate:", round(host_rate, 4), "\n")
    cat("    - Non-host medal rate:", round(nonhost_rate, 4), "\n")
    cat("    - Home advantage:", round(advantage, 4), "\n")
  }
}

cat("\nHosting Experience Distribution:\n")
exp_dist <- table(q3_final$hosting_experience[q3_final$is_host == 1], useNA = "ifany")
print(exp_dist)
cat("\n")

# ==============================================================================
# STEP 9: Save merged dataset
# ==============================================================================

cat("=== SAVING MERGED DATA ===\n")

write.csv(q3_final, "analysis_data/q3_country_factors.csv", row.names = FALSE)

cat("Saved to: analysis_data/q3_country_factors.csv\n")
cat("Rows:", nrow(q3_final), "\n")
cat("Columns:", ncol(q3_final), "\n\n")

cat("=== SCRIPT COMPLETE ===\n")
cat("\nQuestion 3 dataset ready for country factors analysis!\n\n")
cat("Key variables for analysis:\n")
cat("- country_size_category: Small/Medium/Large by area\n")
cat("- population_category: Low/Medium/High by population\n")
cat("- hosting_experience: Never/First Time/Repeat\n")
cat("- gymnasts_per_million: Participation rate\n")
cat("- medals_per_million: Success rate per capita\n")
cat("- Interaction terms: host_small, host_medium, host_large, etc.\n\n")
cat("Recommended analyses:\n")
cat("1. Compare home advantage by country size\n")
cat("2. First-time vs repeat host advantage\n")
cat("3. Participation rates and medal success\n")
