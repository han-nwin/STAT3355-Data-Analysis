# ==============================================================================
# Script: 03_clean_hosts.R
# Purpose: Clean Olympic hosts data - filter summer games, add NOC, split co-hosts
# Author: Team 5
# Date: 2025-10-29
# ==============================================================================

# Set working directory
setwd("/home/han/Github/STAT3355-Data-Analysis/Team-Project")

cat("=== CLEANING OLYMPIC HOSTS DATA ===\n\n")

# ==============================================================================
# STEP 1: Load raw hosts data
# ==============================================================================

cat("STEP 1: Loading raw hosts data...\n")

hosts_raw <- read.csv("raw_data/olympic_hosts.csv", stringsAsFactors = FALSE)

cat("Total rows in raw data:", nrow(hosts_raw), "\n")
cat("Columns:", paste(names(hosts_raw), collapse=", "), "\n\n")

# Show what we're starting with
cat("Sample of raw hosts data:\n")
print(head(hosts_raw[hosts_raw$Type == "summergames", c("Type", "Year", "City", "Country")], 10))

cat("\n")

# ==============================================================================
# STEP 2: Filter to summer games only
# ==============================================================================

cat("STEP 2: Filtering to summer games only...\n")

hosts_summer <- hosts_raw[hosts_raw$Type == "summergames", ]

cat("Summer games only:", nrow(hosts_summer), "rows\n")
cat("Years range:", min(hosts_summer$Year, na.rm=TRUE), "to", max(hosts_summer$Year, na.rm=TRUE), "\n\n")

# ==============================================================================
# STEP 3: Manual NOC mapping for host countries
# ==============================================================================

cat("STEP 3: Creating NOC mapping for host countries...\n")

# Create manual mapping for all host countries
# This handles the special cases and variations
host_noc_mapping <- data.frame(
  Country = c(
    "Greece",
    "France",
    "United States of America",
    "Great Britain",
    "Sweden",
    "Belgium",
    "Netherlands",
    "Germany",
    "Finland",
    "Australia, Sweden",  # Special case - 1956 co-hosts
    "Australia",
    "Italy",
    "Japan",
    "Mexico",
    "Canada",
    "USSR",
    "Republic of Korea",
    "Spain",
    "Brazil",
    "People's Republic of China"
  ),
  NOC = c(
    "GRE",
    "FRA",
    "USA",
    "GBR",
    "SWE",
    "BEL",
    "NED",
    "GER",
    "FIN",
    "AUS, SWE",  # Will split this later
    "AUS",
    "ITA",
    "JPN",
    "MEX",
    "CAN",
    "URS",  # USSR code
    "KOR",
    "ESP",
    "BRA",
    "CHN"
  ),
  stringsAsFactors = FALSE
)

# ==============================================================================
# STEP 4: Add NOC codes to hosts data
# ==============================================================================

cat("STEP 4: Adding NOC codes...\n")

# Merge NOC codes
hosts_with_noc <- merge(hosts_summer, host_noc_mapping, by = "Country", all.x = TRUE)

# Check for any missing NOC codes
missing_noc <- hosts_with_noc[is.na(hosts_with_noc$NOC), ]
if (nrow(missing_noc) > 0) {
  cat("WARNING: Some hosts missing NOC codes:\n")
  print(unique(missing_noc$Country))
}

cat("NOC codes added successfully\n\n")

# ==============================================================================
# STEP 5: Split co-hosts (1956: Australia, Sweden)
# ==============================================================================

cat("STEP 5: Handling co-host situation (1956)...\n")

# Find the 1956 co-host row
cohost_row <- hosts_with_noc[hosts_with_noc$Country == "Australia, Sweden", ]

if (nrow(cohost_row) > 0) {
  cat("Found 1956 co-host row. Splitting into two records...\n")

  # Create Australia record
  aus_row <- cohost_row
  aus_row$Country <- "Australia"
  aus_row$NOC <- "AUS"
  aus_row$City <- "Melbourne"

  # Create Sweden record
  swe_row <- cohost_row
  swe_row$Country <- "Sweden"
  swe_row$NOC <- "SWE"
  swe_row$City <- "Stockholm"

  # Remove the original co-host row and add the two separate rows
  hosts_split <- hosts_with_noc[hosts_with_noc$Country != "Australia, Sweden", ]
  hosts_split <- rbind(hosts_split, aus_row, swe_row)

  cat("Split complete: 1956 now has separate AUS and SWE records\n\n")
} else {
  hosts_split <- hosts_with_noc
  cat("No co-host row found\n\n")
}

# ==============================================================================
# STEP 6: Calculate hosting history (first-time vs repeat)
# ==============================================================================

cat("STEP 6: Calculating hosting history...\n")

# Sort by year
hosts_split <- hosts_split[order(hosts_split$Year), ]

# For each row, count how many times that NOC has hosted BEFORE this year
hosts_split$hosting_count_prior <- 0
hosts_split$hosting_count_total <- 0
hosts_split$first_time_host <- 0

for (i in 1:nrow(hosts_split)) {
  current_noc <- hosts_split$NOC[i]
  current_year <- hosts_split$Year[i]

  # Count how many times this NOC hosted before this year
  prior_hosts <- sum(hosts_split$NOC == current_noc & hosts_split$Year < current_year, na.rm=TRUE)

  # Count total times including this one
  total_hosts <- sum(hosts_split$NOC == current_noc & hosts_split$Year <= current_year, na.rm=TRUE)

  hosts_split$hosting_count_prior[i] <- prior_hosts
  hosts_split$hosting_count_total[i] <- total_hosts
  hosts_split$first_time_host[i] <- ifelse(prior_hosts == 0, 1, 0)
}

cat("Hosting history calculated\n\n")

# ==============================================================================
# STEP 7: Select and order final columns
# ==============================================================================

cat("STEP 7: Selecting final columns...\n")

hosts_cleaned <- hosts_split[, c(
  "Year",
  "City",
  "Country",
  "NOC",
  "first_time_host",
  "hosting_count_prior",
  "hosting_count_total",
  "Athletes",
  "Countries",
  "Events"
)]

# Sort by year
hosts_cleaned <- hosts_cleaned[order(hosts_cleaned$Year), ]

# Reset row names
rownames(hosts_cleaned) <- NULL

cat("Columns selected and ordered\n\n")

# ==============================================================================
# STEP 8: Show summary statistics
# ==============================================================================

cat("=== SUMMARY STATISTICS ===\n\n")

cat("Total summer Olympics:", nrow(hosts_cleaned), "\n")
cat("Years range:", min(hosts_cleaned$Year), "-", max(hosts_cleaned$Year), "\n")
cat("Unique host countries (NOCs):", length(unique(hosts_cleaned$NOC)), "\n\n")

cat("First-time hosts:\n")
first_timers <- hosts_cleaned[hosts_cleaned$first_time_host == 1, c("Year", "City", "NOC")]
print(first_timers)

cat("\nRepeat hosts:\n")
repeat_hosts <- hosts_cleaned[hosts_cleaned$first_time_host == 0, c("Year", "City", "NOC", "hosting_count_total")]
print(repeat_hosts)

cat("\nCountries that hosted multiple times:\n")
multiple_hosts <- aggregate(Year ~ NOC, data=hosts_cleaned, FUN=length)
multiple_hosts <- multiple_hosts[multiple_hosts$Year > 1, ]
names(multiple_hosts)[2] <- "Times_Hosted"
multiple_hosts <- multiple_hosts[order(-multiple_hosts$Times_Hosted), ]
print(multiple_hosts)

# ==============================================================================
# STEP 9: Save cleaned data
# ==============================================================================

cat("\n=== SAVING CLEANED DATA ===\n")

write.csv(hosts_cleaned, "cleaned_data/hosts_cleaned.csv", row.names=FALSE)

cat("Saved to: cleaned_data/hosts_cleaned.csv\n")
cat("Total rows:", nrow(hosts_cleaned), "\n")
cat("Total columns:", ncol(hosts_cleaned), "\n\n")

# ==============================================================================
# STEP 10: Show final sample
# ==============================================================================

cat("=== SAMPLE OF CLEANED DATA ===\n\n")
print(head(hosts_cleaned, 15))

cat("\n=== SCRIPT COMPLETE ===\n")
