# ==============================================================================
# Script: 05_clean_country_info_v2.R
# Purpose: Clean country size data using existing noc_mapping.csv
# Author: Team 5
# Date: 2025-10-29
# ==============================================================================

# Set working directory
setwd("/home/han/Github/STAT3355-Data-Analysis/Team-Project")

cat("=== CLEANING COUNTRY INFO DATA (V2 - Using NOC Mapping) ===\n\n")

# ==============================================================================
# STEP 1: Load data
# ==============================================================================

cat("STEP 1: Loading data...\n")

# Load country sizes
country_sizes <- read.csv("raw_data/country_sizes.csv", stringsAsFactors = FALSE)

# Load NOC mapping
noc_mapping <- read.csv("cleaned_data/noc_mapping.csv", stringsAsFactors = FALSE)

cat("Country sizes loaded:", nrow(country_sizes), "countries\n")
cat("NOC mapping loaded:", nrow(noc_mapping), "unique mappings\n\n")

# ==============================================================================
# STEP 2: Create lookup from country_sizes names to NOC codes
# ==============================================================================

cat("STEP 2: Matching country_sizes names with NOC codes...\n")

# Get unique NOCs from mapping (remove duplicates from athletes data)
noc_unique <- noc_mapping[!duplicated(noc_mapping$noc), ]

# Try matching country_sizes names with different columns in noc_mapping
country_sizes$NOC <- NA

for (i in 1:nrow(country_sizes)) {
  country_name <- country_sizes$Country[i]

  # Try exact match with name_athletes
  match_idx <- which(noc_unique$name_athletes == country_name)
  if (length(match_idx) > 0) {
    country_sizes$NOC[i] <- noc_unique$noc[match_idx[1]]
    next
  }

  # Try exact match with name_gdp
  match_idx <- which(noc_unique$name_gdp == country_name)
  if (length(match_idx) > 0) {
    country_sizes$NOC[i] <- noc_unique$noc[match_idx[1]]
    next
  }

  # Try exact match with name_population
  match_idx <- which(noc_unique$name_population == country_name)
  if (length(match_idx) > 0) {
    country_sizes$NOC[i] <- noc_unique$noc[match_idx[1]]
    next
  }
}

# Manual fixes for special cases
country_sizes$NOC[country_sizes$Country == "DR Congo"] <- "COD"
country_sizes$NOC[country_sizes$Country == "Taiwan"] <- "TPE"
country_sizes$NOC[country_sizes$Country == "Côte d'Ivoire"] <- "CIV"
country_sizes$NOC[country_sizes$Country == "Republic of North Macedonia"] <- "MKD"
country_sizes$NOC[country_sizes$Country == "Czech Republic"] <- "CZE"
country_sizes$NOC[country_sizes$Country == "Congo"] <- "CGO"

cat("Matched:", sum(!is.na(country_sizes$NOC)), "countries\n")
cat("Unmatched:", sum(is.na(country_sizes$NOC)), "countries\n\n")

# Show unmatched countries (likely non-Olympic territories)
unmatched <- country_sizes$Country[is.na(country_sizes$NOC)]
if (length(unmatched) > 0) {
  cat("Unmatched countries (likely non-Olympic territories):\n")
  print(head(unmatched, 20))
  cat("\n")
}

# ==============================================================================
# STEP 3: Keep only countries with NOC codes (Olympic nations)
# ==============================================================================

cat("STEP 3: Filtering to Olympic nations only...\n")

country_info <- country_sizes[!is.na(country_sizes$NOC), ]

cat("Kept:", nrow(country_info), "Olympic nations with size data\n\n")

# ==============================================================================
# STEP 4: Create size categories
# ==============================================================================

cat("STEP 4: Creating country size categories...\n")

# Define thresholds (in km²)
small_threshold <- 500000      # 500,000 km²
large_threshold <- 5000000     # 5,000,000 km²

# Create categorical variable
country_info$country_size_category <- ifelse(
  country_info$Total_Area_km2 < small_threshold, "Small",
  ifelse(country_info$Total_Area_km2 >= large_threshold, "Large", "Medium")
)

# Make it a factor with proper order
country_info$country_size_category <- factor(
  country_info$country_size_category,
  levels = c("Small", "Medium", "Large")
)

cat("Size categories created:\n")
cat("- Small: < 500,000 km²\n")
cat("- Medium: 500,000 - 5,000,000 km²\n")
cat("- Large: > 5,000,000 km²\n\n")

# Show distribution
cat("Distribution by size category:\n")
print(table(country_info$country_size_category))
cat("\n")

# ==============================================================================
# STEP 5: Select and rename columns
# ==============================================================================

cat("STEP 5: Selecting final columns...\n")

country_info_final <- data.frame(
  noc = country_info$NOC,
  country_name = country_info$Country,
  total_area_km2 = country_info$Total_Area_km2,
  land_area_km2 = country_info$Land_Area_km2,
  world_share_pct = country_info$World_Share,
  country_size_category = country_info$country_size_category,
  stringsAsFactors = FALSE
)

# Sort by NOC
country_info_final <- country_info_final[order(country_info_final$noc), ]

# Reset row names
rownames(country_info_final) <- NULL

cat("Final columns:", paste(names(country_info_final), collapse=", "), "\n\n")

# ==============================================================================
# STEP 6: Show summary statistics
# ==============================================================================

cat("=== SUMMARY STATISTICS ===\n\n")

cat("Total Olympic nations with size data:", nrow(country_info_final), "\n\n")

cat("Size category breakdown:\n")
print(table(country_info_final$country_size_category))
cat("\n")

cat("Largest countries:\n")
largest <- country_info_final[order(-country_info_final$total_area_km2), ]
print(head(largest[, c("noc", "country_name", "total_area_km2", "country_size_category")], 10))

cat("\nSmallest countries in dataset:\n")
smallest <- country_info_final[order(country_info_final$total_area_km2), ]
print(head(smallest[, c("noc", "country_name", "total_area_km2", "country_size_category")], 10))

# Check which Olympic host countries we have
cat("\n=== COVERAGE OF OLYMPIC HOST COUNTRIES ===\n")

host_countries <- c("GRE", "FRA", "USA", "GBR", "SWE", "BEL", "NED", "GER",
                   "FIN", "AUS", "ITA", "JPN", "MEX", "CAN", "ESP", "BRA", "CHN", "KOR")

hosts_with_data <- host_countries[host_countries %in% country_info_final$noc]
hosts_missing <- host_countries[!host_countries %in% country_info_final$noc]

cat("Host countries WITH size data:", length(hosts_with_data), "out of 18\n\n")
if (length(hosts_with_data) > 0) {
  print(country_info_final[country_info_final$noc %in% hosts_with_data,
                           c("noc", "country_name", "total_area_km2", "country_size_category")])
}

if (length(hosts_missing) > 0) {
  cat("\nHost countries MISSING size data:", paste(hosts_missing, collapse=", "), "\n")
}

# ==============================================================================
# STEP 7: Save cleaned data
# ==============================================================================

cat("\n=== SAVING CLEANED DATA ===\n")

write.csv(country_info_final, "cleaned_data/country_info.csv", row.names=FALSE)

cat("Saved to: cleaned_data/country_info.csv\n")
cat("Total rows:", nrow(country_info_final), "\n")
cat("Total columns:", ncol(country_info_final), "\n\n")

# ==============================================================================
# STEP 8: Show final sample
# ==============================================================================

cat("=== SAMPLE OF CLEANED DATA ===\n\n")
print(head(country_info_final, 20))

cat("\n=== SCRIPT COMPLETE ===\n")
