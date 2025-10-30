# ==============================================================================
# Script: 07_calculate_baseline.R
# Purpose: Calculate baseline gymnastics performance for each country in non-hosting years
# Author: Team 5
# Date: 2025-10-29
# ==============================================================================

# Set working directory
setwd("/home/han/Github/STAT3355-Data-Analysis/Team-Project")

cat("=== CALCULATING BASELINE PERFORMANCE ===\n\n")

# ==============================================================================
# STEP 1: Load required data
# ==============================================================================

cat("STEP 1: Loading data...\n")

# Load cleaned athletes data (gymnastics only)
athletes <- read.csv("cleaned_data/athletes_cleaned.csv", stringsAsFactors = FALSE)

# Load hosts data
hosts <- read.csv("cleaned_data/hosts_cleaned.csv", stringsAsFactors = FALSE)

cat("- Athletes loaded:", nrow(athletes), "records\n")
cat("- Hosts loaded:", nrow(hosts), "host records\n\n")

# ==============================================================================
# STEP 2: Create is_host indicator for each athlete
# ==============================================================================

cat("STEP 2: Creating is_host indicator...\n")

# Create a lookup of Year + NOC for host countries
hosts$year_noc <- paste(hosts$Year, hosts$NOC, sep = "_")
host_lookup <- unique(hosts$year_noc)

# Add is_host indicator to athletes
athletes$year_noc <- paste(athletes$Year, athletes$NOC, sep = "_")
athletes$is_host <- ifelse(athletes$year_noc %in% host_lookup, 1, 0)

cat("- Host performances:", sum(athletes$is_host == 1), "\n")
cat("- Non-host performances:", sum(athletes$is_host == 0), "\n\n")

# ==============================================================================
# STEP 3: Calculate overall baseline (all genders combined)
# ==============================================================================

cat("STEP 3: Calculating overall baseline performance...\n")

# Filter to NON-hosting years only for baseline
baseline_data <- athletes[athletes$is_host == 0, ]

cat("- Using", nrow(baseline_data), "non-hosting performances for baseline\n")

# Calculate baseline metrics by country (NOC)
baseline_overall <- aggregate(
  cbind(
    total_performances = medal_won,
    medals_won = medal_won,
    gold_medals = gold_medal,
    medal_points_total = medal_points
  ) ~ NOC,
  data = baseline_data,
  FUN = function(x) c(
    count = length(x),
    sum = sum(x, na.rm = TRUE),
    mean = mean(x, na.rm = TRUE)
  )
)

# Flatten the aggregated results
baseline_overall_flat <- data.frame(
  noc = baseline_overall$NOC,
  total_performances = baseline_overall$total_performances[, "count"],
  total_medals = baseline_overall$medals_won[, "sum"],
  total_golds = baseline_overall$gold_medals[, "sum"],
  total_medal_points = baseline_overall$medal_points_total[, "sum"],
  avg_medal_rate = baseline_overall$medals_won[, "mean"],
  avg_gold_rate = baseline_overall$gold_medals[, "mean"],
  avg_medal_points = baseline_overall$medal_points_total[, "mean"],
  stringsAsFactors = FALSE
)

cat("- Calculated baselines for", nrow(baseline_overall_flat), "countries\n\n")

# ==============================================================================
# STEP 4: Calculate gender-specific baselines
# ==============================================================================

cat("STEP 4: Calculating gender-specific baselines...\n")

# Male baseline
baseline_male <- aggregate(
  cbind(
    total_performances = medal_won,
    medals_won = medal_won,
    gold_medals = gold_medal,
    medal_points_total = medal_points
  ) ~ NOC,
  data = baseline_data[baseline_data$Sex == "M", ],
  FUN = function(x) c(
    count = length(x),
    sum = sum(x, na.rm = TRUE),
    mean = mean(x, na.rm = TRUE)
  )
)

baseline_male_flat <- data.frame(
  noc = baseline_male$NOC,
  male_performances = baseline_male$total_performances[, "count"],
  male_total_medals = baseline_male$medals_won[, "sum"],
  male_total_golds = baseline_male$gold_medals[, "sum"],
  male_avg_medal_rate = baseline_male$medals_won[, "mean"],
  male_avg_gold_rate = baseline_male$gold_medals[, "mean"],
  male_avg_medal_points = baseline_male$medal_points_total[, "mean"],
  stringsAsFactors = FALSE
)

# Female baseline
baseline_female <- aggregate(
  cbind(
    total_performances = medal_won,
    medals_won = medal_won,
    gold_medals = gold_medal,
    medal_points_total = medal_points
  ) ~ NOC,
  data = baseline_data[baseline_data$Sex == "F", ],
  FUN = function(x) c(
    count = length(x),
    sum = sum(x, na.rm = TRUE),
    mean = mean(x, na.rm = TRUE)
  )
)

baseline_female_flat <- data.frame(
  noc = baseline_female$NOC,
  female_performances = baseline_female$total_performances[, "count"],
  female_total_medals = baseline_female$medals_won[, "sum"],
  female_total_golds = baseline_female$gold_medals[, "sum"],
  female_avg_medal_rate = baseline_female$medals_won[, "mean"],
  female_avg_gold_rate = baseline_female$gold_medals[, "mean"],
  female_avg_medal_points = baseline_female$medal_points_total[, "mean"],
  stringsAsFactors = FALSE
)

cat("- Male baselines for", nrow(baseline_male_flat), "countries\n")
cat("- Female baselines for", nrow(baseline_female_flat), "countries\n\n")

# ==============================================================================
# STEP 5: Merge all baselines together
# ==============================================================================

cat("STEP 5: Merging baseline datasets...\n")

# Merge overall with male
baseline_combined <- merge(
  baseline_overall_flat,
  baseline_male_flat,
  by = "noc",
  all.x = TRUE
)

# Merge with female
baseline_combined <- merge(
  baseline_combined,
  baseline_female_flat,
  by = "noc",
  all.x = TRUE
)

# Replace NAs with 0 for countries with no male or female performances
baseline_combined[is.na(baseline_combined)] <- 0

cat("- Combined baseline dataset created\n")
cat("- Total countries:", nrow(baseline_combined), "\n\n")

# ==============================================================================
# STEP 6: Add country names for readability
# ==============================================================================

cat("STEP 6: Adding country names...\n")

# Get unique NOC to country name mapping from athletes data
country_names <- unique(athletes[, c("NOC", "Team")])
names(country_names) <- c("noc", "country_name")

# Take first occurrence if duplicates
country_names <- country_names[!duplicated(country_names$noc), ]

# Merge country names
baseline_final <- merge(
  baseline_combined,
  country_names,
  by = "noc",
  all.x = TRUE
)

# Reorder columns to put country_name after noc
col_order <- c("noc", "country_name", setdiff(names(baseline_final), c("noc", "country_name")))
baseline_final <- baseline_final[, col_order]

# Sort by total medals descending
baseline_final <- baseline_final[order(-baseline_final$total_medals), ]

cat("- Country names added\n\n")

# ==============================================================================
# STEP 7: Summary statistics
# ==============================================================================

cat("=== SUMMARY STATISTICS ===\n\n")

cat("Overall Baseline Statistics:\n")
cat("- Countries with baseline data:", nrow(baseline_final), "\n")
cat("- Total non-hosting performances:", sum(baseline_final$total_performances), "\n")
cat("- Total medals in non-hosting years:", sum(baseline_final$total_medals), "\n")
cat("- Average medal rate:", round(mean(baseline_final$avg_medal_rate), 4), "\n\n")

cat("Gender-Specific Statistics:\n")
cat("- Countries with male data:", sum(baseline_final$male_performances > 0), "\n")
cat("- Countries with female data:", sum(baseline_final$female_performances > 0), "\n")
cat("- Average male medal rate:", round(mean(baseline_final$male_avg_medal_rate[baseline_final$male_performances > 0]), 4), "\n")
cat("- Average female medal rate:", round(mean(baseline_final$female_avg_medal_rate[baseline_final$female_performances > 0]), 4), "\n\n")

# Show top 10 countries by total medals
cat("Top 10 Countries by Total Medals (Non-Hosting Years):\n")
top10 <- head(baseline_final[, c("noc", "country_name", "total_performances", "total_medals", "avg_medal_rate")], 10)
print(top10, row.names = FALSE)
cat("\n")

# ==============================================================================
# STEP 8: Save baseline performance data
# ==============================================================================

cat("=== SAVING BASELINE DATA ===\n")

write.csv(baseline_final, "cleaned_data/baseline_performance.csv", row.names = FALSE)

cat("Saved to: cleaned_data/baseline_performance.csv\n")
cat("Rows:", nrow(baseline_final), "\n")
cat("Columns:", ncol(baseline_final), "\n\n")

cat("=== SCRIPT COMPLETE ===\n")
cat("\nBaseline performance metrics calculated for:\n")
cat("- Overall performance (all genders)\n")
cat("- Male-specific performance\n")
cat("- Female-specific performance\n\n")
cat("These baselines can now be used to measure 'home advantage' by comparing\n")
cat("hosting-year performance to historical non-hosting performance.\n")
