# ==============================================================================
# Script: 06_clean_population.R
# Purpose: Clean population demographics data - calculate age structure proportions
# Author: Team 5
# Date: 2025-10-29
# ==============================================================================

# Set working directory
setwd("/home/han/Github/STAT3355-Data-Analysis/Team-Project")

cat("=== CLEANING POPULATION DEMOGRAPHICS DATA ===\n\n")

# ==============================================================================
# STEP 1: Load raw population data
# ==============================================================================

cat("STEP 1: Loading raw population data...\n")

pop_raw <- read.csv("raw_data/population-by-age-group.csv", stringsAsFactors = FALSE)

cat("Population data loaded:\n")
cat("- Rows:", nrow(pop_raw), "\n")
cat("- Columns:", ncol(pop_raw), "\n")
cat("- Years range:", min(pop_raw$Year), "-", max(pop_raw$Year), "\n\n")

# Show column names
cat("Column names:\n")
print(names(pop_raw))
cat("\n")

# ==============================================================================
# STEP 2: Rename columns for easier handling
# ==============================================================================

cat("STEP 2: Renaming columns...\n")

# Rename to shorter, cleaner names
names(pop_raw) <- c(
  "country_name",
  "noc",
  "year",
  "age_65_plus",
  "age_25_64",
  "age_15_24",
  "age_5_14",
  "age_0_4"
)

cat("Columns renamed for easier handling\n\n")

# ==============================================================================
# STEP 3: Filter to Olympic years only
# ==============================================================================

cat("STEP 3: Filtering to Olympic years...\n")

# Load hosts data to get Olympic years
hosts <- read.csv("raw_data/olympic_hosts.csv", stringsAsFactors = FALSE)
olympic_years <- sort(unique(as.numeric(hosts$Year[hosts$Type == "summergames" & !is.na(hosts$Year)])))

cat("Olympic years identified:", length(olympic_years), "years\n")

# Filter population data to Olympic years
pop_olympic <- pop_raw[pop_raw$year %in% olympic_years, ]

cat("Filtered from", nrow(pop_raw), "to", nrow(pop_olympic), "rows\n\n")

# ==============================================================================
# STEP 4: Calculate derived variables
# ==============================================================================

cat("STEP 4: Calculating derived population variables...\n")

# Calculate total population (sum of all age groups)
pop_olympic$total_population <- rowSums(pop_olympic[, c("age_65_plus", "age_25_64", "age_15_24", "age_5_14", "age_0_4")], na.rm = TRUE)

# Calculate working age population (15-64)
pop_olympic$working_age_population <- pop_olympic$age_15_24 + pop_olympic$age_25_64

# Calculate youth population (0-24)
pop_olympic$youth_population <- pop_olympic$age_0_4 + pop_olympic$age_5_14 + pop_olympic$age_15_24

# Calculate elderly population (65+)
pop_olympic$elderly_population <- pop_olympic$age_65_plus

# Calculate proportions
pop_olympic$working_age_proportion <- pop_olympic$working_age_population / pop_olympic$total_population
pop_olympic$youth_proportion <- pop_olympic$youth_population / pop_olympic$total_population
pop_olympic$elderly_proportion <- pop_olympic$elderly_population / pop_olympic$total_population

# Calculate child proportion (0-14)
pop_olympic$child_population <- pop_olympic$age_0_4 + pop_olympic$age_5_14
pop_olympic$child_proportion <- pop_olympic$child_population / pop_olympic$total_population

cat("Derived variables calculated:\n")
cat("- total_population\n")
cat("- working_age_population (15-64)\n")
cat("- youth_population (0-24)\n")
cat("- elderly_population (65+)\n")
cat("- child_population (0-14)\n")
cat("- All proportions calculated\n\n")

# ==============================================================================
# STEP 5: Clean NOC codes
# ==============================================================================

cat("STEP 5: Cleaning NOC codes...\n")

# Check for missing NOC codes
missing_noc <- sum(is.na(pop_olympic$noc) | pop_olympic$noc == "")
cat("- Records with missing NOC:", missing_noc, "\n")

# Remove records without NOC codes (can't merge without them)
pop_olympic <- pop_olympic[!is.na(pop_olympic$noc) & pop_olympic$noc != "", ]

cat("- Records after removing missing NOC:", nrow(pop_olympic), "\n\n")

# ==============================================================================
# STEP 6: Select final columns
# ==============================================================================

cat("STEP 6: Selecting final columns...\n")

pop_cleaned <- pop_olympic[, c(
  "noc",
  "country_name",
  "year",
  # Raw age group populations
  "age_0_4",
  "age_5_14",
  "age_15_24",
  "age_25_64",
  "age_65_plus",
  # Derived totals
  "total_population",
  "child_population",
  "youth_population",
  "working_age_population",
  "elderly_population",
  # Proportions
  "child_proportion",
  "youth_proportion",
  "working_age_proportion",
  "elderly_proportion"
)]

# Sort by NOC and year
pop_cleaned <- pop_cleaned[order(pop_cleaned$noc, pop_cleaned$year), ]
rownames(pop_cleaned) <- NULL

cat("Final dataset structure complete\n\n")

# ==============================================================================
# STEP 7: Summary statistics
# ==============================================================================

cat("=== SUMMARY STATISTICS ===\n\n")

cat("Final dataset:\n")
cat("- Records:", nrow(pop_cleaned), "\n")
cat("- Countries:", length(unique(pop_cleaned$noc)), "\n")
cat("- Years:", min(pop_cleaned$year), "-", max(pop_cleaned$year), "\n")
cat("- Olympic years:", length(unique(pop_cleaned$year)), "\n\n")

cat("Data completeness:\n")
cat("- Records with complete data:", sum(complete.cases(pop_cleaned)), "\n")
cat("- Records with missing values:", sum(!complete.cases(pop_cleaned)), "\n\n")

cat("Summary of key proportions:\n")
cat("- Mean working age proportion:", round(mean(pop_cleaned$working_age_proportion, na.rm=TRUE), 4), "\n")
cat("- Mean youth proportion:", round(mean(pop_cleaned$youth_proportion, na.rm=TRUE), 4), "\n")
cat("- Mean elderly proportion:", round(mean(pop_cleaned$elderly_proportion, na.rm=TRUE), 4), "\n")
cat("- Mean child proportion:", round(mean(pop_cleaned$child_proportion, na.rm=TRUE), 4), "\n\n")

# Show sample of top countries by population (most recent Olympic year)
cat("Top 10 Countries by Population (2020 Olympics):\n")
pop_2020 <- pop_cleaned[pop_cleaned$year == 2020 & !is.na(pop_cleaned$total_population), ]
pop_2020_sorted <- pop_2020[order(-pop_2020$total_population), ]
top10 <- head(pop_2020_sorted[, c("noc", "country_name", "total_population", "working_age_proportion")], 10)
print(top10, row.names = FALSE)
cat("\n")

# ==============================================================================
# STEP 8: Check for Olympic host countries coverage
# ==============================================================================

cat("=== OLYMPIC HOST COUNTRIES COVERAGE ===\n\n")

# Key host countries
host_nocs <- c("GRE", "FRA", "USA", "GBR", "SWE", "BEL", "NED", "GER",
               "FIN", "AUS", "ITA", "JPN", "MEX", "CAN", "ESP", "BRA", "CHN", "KOR")

host_coverage <- host_nocs %in% unique(pop_cleaned$noc)
hosts_covered <- sum(host_coverage)
hosts_missing <- host_nocs[!host_coverage]

cat("Olympic host countries with population data:", hosts_covered, "out of", length(host_nocs), "\n")
if (length(hosts_missing) > 0) {
  cat("Missing host countries:", paste(hosts_missing, collapse = ", "), "\n")
}
cat("\n")

# ==============================================================================
# STEP 9: Save cleaned data
# ==============================================================================

cat("=== SAVING CLEANED DATA ===\n")

write.csv(pop_cleaned, "cleaned_data/population_cleaned.csv", row.names = FALSE)

cat("Saved to: cleaned_data/population_cleaned.csv\n")
cat("Rows:", nrow(pop_cleaned), "\n")
cat("Columns:", ncol(pop_cleaned), "\n\n")

cat("=== SCRIPT COMPLETE ===\n")
cat("\nPopulation demographics data ready for Question 4 analysis!\n")
cat("\nKey variables created:\n")
cat("- Total population and age group breakdowns\n")
cat("- Working age proportion (15-64 years)\n")
cat("- Youth proportion (0-24 years)\n")
cat("- Elderly proportion (65+ years)\n")
cat("- Child proportion (0-14 years)\n")
