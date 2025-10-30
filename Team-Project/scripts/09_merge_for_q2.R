# ==============================================================================
# Script: 09_merge_for_q2.R
# Purpose: Merge datasets for Question 2 - Gender differences in home advantage
# Author: Team 5
# Date: 2025-10-29
# ==============================================================================

# Set working directory
setwd("/home/han/Github/STAT3355-Data-Analysis/Team-Project")

cat("=== MERGING DATA FOR QUESTION 2: GENDER DIFFERENCES IN HOME ADVANTAGE ===\n\n")

# ==============================================================================
# STEP 1: Load Q1 dataset as base
# ==============================================================================

cat("STEP 1: Loading Q1 dataset as base...\n")

q2_data <- read.csv("analysis_data/q1_home_advantage.csv", stringsAsFactors = FALSE)

cat("- Q1 data loaded:", nrow(q2_data), "records\n\n")

# ==============================================================================
# STEP 2: Verify Sex variable is clean
# ==============================================================================

cat("STEP 2: Verifying Sex variable...\n")

# Check unique values
sex_values <- unique(q2_data$Sex)
cat("- Unique Sex values:", paste(sex_values, collapse = ", "), "\n")

# Count by sex
sex_dist <- table(q2_data$Sex)
print(sex_dist)

# Check for missing values
missing_sex <- sum(is.na(q2_data$Sex) | q2_data$Sex == "")
cat("- Missing Sex values:", missing_sex, "\n\n")

if (missing_sex > 0) {
  cat("WARNING: Found missing Sex values. Removing these records.\n")
  q2_data <- q2_data[!is.na(q2_data$Sex) & q2_data$Sex != "", ]
  cat("- Records after removing missing Sex:", nrow(q2_data), "\n\n")
}

# ==============================================================================
# STEP 3: Add gender-specific baseline metrics
# ==============================================================================

cat("STEP 3: Adding gender-specific baseline metrics...\n")

# Load baseline data
baseline <- read.csv("cleaned_data/baseline_performance.csv", stringsAsFactors = FALSE)

# Select male-specific baseline
baseline_male <- baseline[, c(
  "noc",
  "male_performances",
  "male_total_medals",
  "male_total_golds",
  "male_avg_medal_rate",
  "male_avg_gold_rate",
  "male_avg_medal_points"
)]

# Select female-specific baseline
baseline_female <- baseline[, c(
  "noc",
  "female_performances",
  "female_total_medals",
  "female_total_golds",
  "female_avg_medal_rate",
  "female_avg_gold_rate",
  "female_avg_medal_points"
)]

# Merge male baseline
q2_data <- merge(
  q2_data,
  baseline_male,
  by.x = "NOC",
  by.y = "noc",
  all.x = TRUE
)

# Merge female baseline
q2_data <- merge(
  q2_data,
  baseline_female,
  by.x = "NOC",
  by.y = "noc",
  all.x = TRUE
)

cat("- Gender-specific baselines added\n\n")

# ==============================================================================
# STEP 4: Calculate gender-specific deviation from baseline
# ==============================================================================

cat("STEP 4: Calculating gender-specific deviations...\n")

# Initialize deviation columns
q2_data$gender_baseline_medal_rate <- NA
q2_data$gender_baseline_gold_rate <- NA
q2_data$gender_baseline_medal_points <- NA
q2_data$gender_deviation_medals <- NA
q2_data$gender_deviation_golds <- NA
q2_data$gender_deviation_points <- NA

# For males, use male baseline
male_rows <- q2_data$Sex == "M"
q2_data$gender_baseline_medal_rate[male_rows] <- q2_data$male_avg_medal_rate[male_rows]
q2_data$gender_baseline_gold_rate[male_rows] <- q2_data$male_avg_gold_rate[male_rows]
q2_data$gender_baseline_medal_points[male_rows] <- q2_data$male_avg_medal_points[male_rows]

# For females, use female baseline
female_rows <- q2_data$Sex == "F"
q2_data$gender_baseline_medal_rate[female_rows] <- q2_data$female_avg_medal_rate[female_rows]
q2_data$gender_baseline_gold_rate[female_rows] <- q2_data$female_avg_gold_rate[female_rows]
q2_data$gender_baseline_medal_points[female_rows] <- q2_data$female_avg_medal_points[female_rows]

# Calculate gender-specific deviations
q2_data$gender_deviation_medals <- q2_data$medal_won - q2_data$gender_baseline_medal_rate
q2_data$gender_deviation_golds <- q2_data$gold_medal - q2_data$gender_baseline_gold_rate
q2_data$gender_deviation_points <- q2_data$medal_points - q2_data$gender_baseline_medal_points

cat("- Gender-specific deviation metrics calculated\n\n")

# ==============================================================================
# STEP 5: Create interaction variable (is_host × Sex)
# ==============================================================================

cat("STEP 5: Creating interaction variables...\n")

# Create interaction term
q2_data$host_male <- ifelse(q2_data$is_host == 1 & q2_data$Sex == "M", 1, 0)
q2_data$host_female <- ifelse(q2_data$is_host == 1 & q2_data$Sex == "F", 1, 0)

# Create categorical interaction variable
q2_data$host_gender_group <- paste0(
  ifelse(q2_data$is_host == 1, "Host_", "NonHost_"),
  q2_data$Sex
)

cat("- Interaction variables created:\n")
cat("  - host_male: Host males\n")
cat("  - host_female: Host females\n")
cat("  - host_gender_group: Categorical (Host_M, Host_F, NonHost_M, NonHost_F)\n\n")

# ==============================================================================
# STEP 6: Reorder columns
# ==============================================================================

cat("STEP 6: Organizing final dataset...\n")

# Get all column names
all_cols <- names(q2_data)

# Key columns to put first
key_cols <- c(
  "Year", "City", "NOC", "Team", "Name", "Sex", "Age",
  "Sport", "gymnastics_type", "Event",
  "Medal", "medal_won", "gold_medal", "medal_points",
  "is_host", "first_time_host", "hosting_count_prior", "hosting_count_total",
  # Overall baseline
  "baseline_medal_rate", "baseline_gold_rate", "baseline_medal_points",
  # Gender-specific baseline
  "gender_baseline_medal_rate", "gender_baseline_gold_rate", "gender_baseline_medal_points",
  # Overall deviation
  "deviation_from_baseline_medals", "deviation_from_baseline_golds", "deviation_from_baseline_points",
  # Gender-specific deviation
  "gender_deviation_medals", "gender_deviation_golds", "gender_deviation_points",
  # Interaction variables
  "host_male", "host_female", "host_gender_group",
  # Country-year aggregates
  "gymnast_count", "country_medal_rate", "country_gold_rate"
)

# Get remaining columns
remaining_cols <- setdiff(all_cols, key_cols)

# Reorder
q2_final <- q2_data[, c(key_cols, remaining_cols)]

# Sort by Year, NOC, Sex, Name
q2_final <- q2_final[order(q2_final$Year, q2_final$NOC, q2_final$Sex, q2_final$Name), ]
rownames(q2_final) <- NULL

cat("- Dataset organized\n\n")

# ==============================================================================
# STEP 7: Summary statistics by gender
# ==============================================================================

cat("=== SUMMARY STATISTICS ===\n\n")

cat("Final Q2 Dataset:\n")
cat("- Total records:", nrow(q2_final), "\n")
cat("- Male athletes:", sum(q2_final$Sex == "M"), "\n")
cat("- Female athletes:", sum(q2_final$Sex == "F"), "\n\n")

cat("By Gender and Hosting Status:\n")
for (sex in c("M", "F")) {
  gender_label <- ifelse(sex == "M", "Male", "Female")
  cat("\n", gender_label, "Athletes:\n", sep = "")

  sex_data <- q2_final[q2_final$Sex == sex, ]
  host_data <- sex_data[sex_data$is_host == 1, ]
  nonhost_data <- sex_data[sex_data$is_host == 0, ]

  cat("  - Total performances:", nrow(sex_data), "\n")
  cat("  - Host performances:", nrow(host_data), "\n")
  cat("  - Non-host performances:", nrow(nonhost_data), "\n")
  cat("  - Overall medal rate:", round(mean(sex_data$medal_won), 4), "\n")
  cat("  - Host medal rate:", round(mean(host_data$medal_won), 4), "\n")
  cat("  - Non-host medal rate:", round(mean(nonhost_data$medal_won), 4), "\n")
  cat("  - Home advantage (Host - Non-host):",
      round(mean(host_data$medal_won) - mean(nonhost_data$medal_won), 4), "\n")
}

cat("\nGender Comparison:\n")
male_host_rate <- mean(q2_final$medal_won[q2_final$Sex == "M" & q2_final$is_host == 1])
male_nonhost_rate <- mean(q2_final$medal_won[q2_final$Sex == "M" & q2_final$is_host == 0])
male_advantage <- male_host_rate - male_nonhost_rate

female_host_rate <- mean(q2_final$medal_won[q2_final$Sex == "F" & q2_final$is_host == 1])
female_nonhost_rate <- mean(q2_final$medal_won[q2_final$Sex == "F" & q2_final$is_host == 0])
female_advantage <- female_host_rate - female_nonhost_rate

cat("- Male home advantage:", round(male_advantage, 4), "\n")
cat("- Female home advantage:", round(female_advantage, 4), "\n")
cat("- Difference (Female - Male):", round(female_advantage - male_advantage, 4), "\n\n")

# ==============================================================================
# STEP 8: Save merged dataset
# ==============================================================================

cat("=== SAVING MERGED DATA ===\n")

write.csv(q2_final, "analysis_data/q2_gender_analysis.csv", row.names = FALSE)

cat("Saved to: analysis_data/q2_gender_analysis.csv\n")
cat("Rows:", nrow(q2_final), "\n")
cat("Columns:", ncol(q2_final), "\n\n")

cat("=== SCRIPT COMPLETE ===\n")
cat("\nQuestion 2 dataset ready for gender analysis!\n\n")
cat("Key variables for analysis:\n")
cat("- Sex: Gender (M/F)\n")
cat("- is_host: Hosting status\n")
cat("- host_male, host_female: Interaction indicators\n")
cat("- host_gender_group: Categorical interaction\n")
cat("- gender_baseline_*: Gender-specific historical baselines\n")
cat("- gender_deviation_*: Gender-specific deviations from baseline\n\n")
cat("Recommended analyses:\n")
cat("1. Compare home advantage by gender (interaction analysis)\n")
cat("2. Test: medal_won ~ is_host * Sex\n")
cat("3. Compare male vs female deviation from gender-specific baselines\n")
