# ==============================================================================
# Script: 08_merge_for_q1.R
# Purpose: Merge datasets for Question 1 - Does hosting provide home advantage?
# Author: Team 5
# Date: 2025-10-29
# ==============================================================================

# Set working directory
setwd("/home/han/Github/STAT3355-Data-Analysis/Team-Project")

cat("=== MERGING DATA FOR QUESTION 1: HOME ADVANTAGE ANALYSIS ===\n\n")

# ==============================================================================
# STEP 1: Load cleaned datasets
# ==============================================================================

cat("STEP 1: Loading cleaned datasets...\n")

# Load athletes data (gymnastics only)
athletes <- read.csv("cleaned_data/athletes_cleaned.csv", stringsAsFactors = FALSE)

# Load hosts data
hosts <- read.csv("cleaned_data/hosts_cleaned.csv", stringsAsFactors = FALSE)

# Load baseline performance data
baseline <- read.csv("cleaned_data/baseline_performance.csv", stringsAsFactors = FALSE)

cat("- Athletes loaded:", nrow(athletes), "records\n")
cat("- Hosts loaded:", nrow(hosts), "host records\n")
cat("- Baseline loaded:", nrow(baseline), "countries\n\n")

# ==============================================================================
# STEP 2: Create is_host indicator
# ==============================================================================

cat("STEP 2: Creating is_host indicator...\n")

# Create a lookup table of Year + NOC for host countries
hosts_lookup <- unique(hosts[, c("Year", "NOC")])
hosts_lookup$is_host <- 1

# Merge with athletes to add is_host indicator
q1_data <- merge(
  athletes,
  hosts_lookup,
  by.x = c("Year", "NOC"),
  by.y = c("Year", "NOC"),
  all.x = TRUE
)

# Replace NA with 0 (not hosting)
q1_data$is_host[is.na(q1_data$is_host)] <- 0

cat("- is_host indicator created\n")
cat("- Host performances:", sum(q1_data$is_host == 1), "\n")
cat("- Non-host performances:", sum(q1_data$is_host == 0), "\n\n")

# ==============================================================================
# STEP 3: Add hosting history variables
# ==============================================================================

cat("STEP 3: Adding hosting history variables...\n")

# Select hosting history columns
hosts_history <- hosts[, c("Year", "NOC", "first_time_host", "hosting_count_prior", "hosting_count_total")]

# Merge hosting history (only for host years)
q1_data <- merge(
  q1_data,
  hosts_history,
  by = c("Year", "NOC"),
  all.x = TRUE
)

# For non-host years, set hosting history to 0/NA appropriately
q1_data$first_time_host[is.na(q1_data$first_time_host)] <- 0
q1_data$hosting_count_prior[is.na(q1_data$hosting_count_prior)] <- 0
q1_data$hosting_count_total[is.na(q1_data$hosting_count_total)] <- 0

cat("- Hosting history variables added\n\n")

# ==============================================================================
# STEP 4: Add baseline performance metrics
# ==============================================================================

cat("STEP 4: Adding baseline performance metrics...\n")

# Select baseline columns for overall performance
baseline_overall <- baseline[, c(
  "noc",
  "total_performances",
  "total_medals",
  "total_golds",
  "avg_medal_rate",
  "avg_gold_rate",
  "avg_medal_points"
)]

# Rename for clarity
names(baseline_overall) <- c(
  "noc",
  "baseline_performances",
  "baseline_total_medals",
  "baseline_total_golds",
  "baseline_medal_rate",
  "baseline_gold_rate",
  "baseline_medal_points"
)

# Merge with main data
q1_data <- merge(
  q1_data,
  baseline_overall,
  by.x = "NOC",
  by.y = "noc",
  all.x = TRUE
)

cat("- Baseline performance metrics added\n")
cat("- Countries with baseline data:", sum(!is.na(q1_data$baseline_medal_rate)), "\n\n")

# ==============================================================================
# STEP 5: Calculate deviation from baseline (home advantage measure)
# ==============================================================================

cat("STEP 5: Calculating deviation from baseline...\n")

# For each athlete performance, compare to their country's baseline
# Only meaningful for countries with baseline data
q1_data$deviation_from_baseline_medals <- NA
q1_data$deviation_from_baseline_golds <- NA
q1_data$deviation_from_baseline_points <- NA

# Calculate deviations (positive = better than baseline)
q1_data$deviation_from_baseline_medals <- q1_data$medal_won - q1_data$baseline_medal_rate
q1_data$deviation_from_baseline_golds <- q1_data$gold_medal - q1_data$baseline_gold_rate
q1_data$deviation_from_baseline_points <- q1_data$medal_points - q1_data$baseline_medal_points

cat("- Deviation metrics calculated\n")
cat("- These show how much better/worse than historical baseline\n\n")

# ==============================================================================
# STEP 6: Add country-year level aggregates
# ==============================================================================

cat("STEP 6: Calculating country-year aggregates...\n")

# Count gymnasts per country per year
gymnasts_per_country <- aggregate(
  Name ~ NOC + Year,
  data = q1_data,
  FUN = function(x) length(unique(x))
)
names(gymnasts_per_country) <- c("NOC", "Year", "gymnast_count")

# Count medals per country per year
medals_per_country <- aggregate(
  cbind(
    total_medal_count = medal_won,
    total_gold_count = gold_medal,
    total_medal_points = medal_points
  ) ~ NOC + Year + is_host,
  data = q1_data,
  FUN = sum
)

# Calculate medal rate per country per year
medals_per_country <- merge(
  medals_per_country,
  gymnasts_per_country,
  by = c("NOC", "Year")
)

medals_per_country$country_medal_rate <- medals_per_country$total_medal_count / medals_per_country$gymnast_count
medals_per_country$country_gold_rate <- medals_per_country$total_gold_count / medals_per_country$gymnast_count

# Merge country-year aggregates back to main data
q1_data <- merge(
  q1_data,
  medals_per_country[, c("NOC", "Year", "gymnast_count", "country_medal_rate", "country_gold_rate")],
  by = c("NOC", "Year"),
  all.x = TRUE
)

cat("- Country-year aggregates added\n")
cat("- Variables: gymnast_count, country_medal_rate, country_gold_rate\n\n")

# ==============================================================================
# STEP 7: Reorder and select final columns
# ==============================================================================

cat("STEP 7: Organizing final dataset...\n")

# Select and order columns logically
q1_final <- q1_data[, c(
  # Identifiers
  "Year",
  "City",
  "NOC",
  "Team",
  "Name",
  "Sex",
  "Age",
  # Event details
  "Sport",
  "gymnastics_type",
  "Event",
  # Outcome variables
  "Medal",
  "medal_won",
  "gold_medal",
  "medal_points",
  # Main independent variable
  "is_host",
  # Hosting history
  "first_time_host",
  "hosting_count_prior",
  "hosting_count_total",
  # Baseline metrics (historical performance)
  "baseline_performances",
  "baseline_total_medals",
  "baseline_total_golds",
  "baseline_medal_rate",
  "baseline_gold_rate",
  "baseline_medal_points",
  # Deviation from baseline (key for home advantage)
  "deviation_from_baseline_medals",
  "deviation_from_baseline_golds",
  "deviation_from_baseline_points",
  # Country-year aggregates
  "gymnast_count",
  "country_medal_rate",
  "country_gold_rate"
)]

# Sort by Year, NOC, Name
q1_final <- q1_final[order(q1_final$Year, q1_final$NOC, q1_final$Name), ]
rownames(q1_final) <- NULL

cat("- Dataset organized with", ncol(q1_final), "variables\n\n")

# ==============================================================================
# STEP 8: Summary statistics
# ==============================================================================

cat("=== SUMMARY STATISTICS ===\n\n")

cat("Final Q1 Dataset:\n")
cat("- Total records:", nrow(q1_final), "\n")
cat("- Unique athletes:", length(unique(q1_final$Name)), "\n")
cat("- Countries:", length(unique(q1_final$NOC)), "\n")
cat("- Years:", length(unique(q1_final$Year)), "\n")
cat("- Olympic Games:", length(unique(paste(q1_final$Year, q1_final$City))), "\n\n")

cat("Hosting Status:\n")
cat("- Host performances:", sum(q1_final$is_host == 1), "\n")
cat("- Non-host performances:", sum(q1_final$is_host == 0), "\n")
cat("- Host percentage:", round(100 * sum(q1_final$is_host == 1) / nrow(q1_final), 2), "%\n\n")

cat("Medal Distribution:\n")
cat("- Total medals:", sum(q1_final$medal_won), "\n")
cat("- Host nation medals:", sum(q1_final$medal_won[q1_final$is_host == 1]), "\n")
cat("- Non-host nation medals:", sum(q1_final$medal_won[q1_final$is_host == 0]), "\n\n")

cat("Medal Rates:\n")
cat("- Overall medal rate:", round(mean(q1_final$medal_won), 4), "\n")
cat("- Host nation medal rate:", round(mean(q1_final$medal_won[q1_final$is_host == 1]), 4), "\n")
cat("- Non-host nation medal rate:", round(mean(q1_final$medal_won[q1_final$is_host == 0]), 4), "\n")
cat("- Difference (Host - Non-host):",
    round(mean(q1_final$medal_won[q1_final$is_host == 1]) - mean(q1_final$medal_won[q1_final$is_host == 0]), 4), "\n\n")

cat("Gold Medal Rates:\n")
cat("- Overall gold rate:", round(mean(q1_final$gold_medal), 4), "\n")
cat("- Host nation gold rate:", round(mean(q1_final$gold_medal[q1_final$is_host == 1]), 4), "\n")
cat("- Non-host nation gold rate:", round(mean(q1_final$gold_medal[q1_final$is_host == 0]), 4), "\n")
cat("- Difference (Host - Non-host):",
    round(mean(q1_final$gold_medal[q1_final$is_host == 1]) - mean(q1_final$gold_medal[q1_final$is_host == 0]), 4), "\n\n")

# ==============================================================================
# STEP 9: Save merged dataset
# ==============================================================================

cat("=== SAVING MERGED DATA ===\n")

write.csv(q1_final, "analysis_data/q1_home_advantage.csv", row.names = FALSE)

cat("Saved to: analysis_data/q1_home_advantage.csv\n")
cat("Rows:", nrow(q1_final), "\n")
cat("Columns:", ncol(q1_final), "\n\n")

cat("=== SCRIPT COMPLETE ===\n")
cat("\nQuestion 1 dataset ready for analysis!\n\n")
cat("Key variables for analysis:\n")
cat("- is_host: Main independent variable (1 = hosting, 0 = not hosting)\n")
cat("- medal_won, gold_medal, medal_points: Outcome variables\n")
cat("- baseline_medal_rate: Historical performance for comparison\n")
cat("- deviation_from_baseline: Direct measure of home advantage\n\n")
cat("Recommended analyses:\n")
cat("1. Chi-square test: is_host vs medal_won\n")
cat("2. T-test: Compare medal rates (host vs non-host)\n")
cat("3. Logistic regression: medal_won ~ is_host + controls\n")
cat("4. Compare hosting year performance to baseline\n")
