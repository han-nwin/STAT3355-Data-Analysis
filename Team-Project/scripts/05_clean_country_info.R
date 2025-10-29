# ==============================================================================
# Script: 05_clean_country_info.R
# Purpose: Clean country size data and create country_info lookup table
# Author: Team 5
# Date: 2025-10-29
# ==============================================================================

# Set working directory
setwd("/home/han/Github/STAT3355-Data-Analysis/Team-Project")

cat("=== CLEANING COUNTRY INFO DATA ===\n\n")

# ==============================================================================
# STEP 1: Load data
# ==============================================================================

cat("STEP 1: Loading data...\n")

# Load country sizes
country_sizes <- read.csv("raw_data/country_sizes.csv", stringsAsFactors = FALSE)

# Load NOC mapping
noc_mapping <- read.csv("cleaned_data/noc_mapping.csv", stringsAsFactors = FALSE)

cat("Country sizes loaded:", nrow(country_sizes), "countries\n")
cat("NOC mapping loaded:", nrow(noc_mapping), "NOCs\n\n")

# Show sample
cat("Sample of country_sizes data:\n")
print(head(country_sizes[, c("Country", "Total_Area_km2", "Land_Area_km2")], 10))
cat("\n")

# ==============================================================================
# STEP 2: Manual NOC mapping for country sizes
# ==============================================================================

cat("STEP 2: Creating NOC mapping for countries in size dataset...\n")

# Create manual mapping for country name variations
country_noc_manual <- data.frame(
  Country = c(
    "Russia",
    "Canada",
    "China",
    "United States",
    "Brazil",
    "Australia",
    "India",
    "Argentina",
    "Kazakhstan",
    "Algeria",
    "DR Congo",
    "Mexico",
    "Indonesia",
    "Libya",
    "Iran",
    "Mongolia",
    "Peru",
    "Chad",
    "Niger",
    "Angola",
    "Mali",
    "South Africa",
    "Colombia",
    "Ethiopia",
    "Bolivia",
    "Egypt",
    "Tanzania",
    "Nigeria",
    "Venezuela",
    "Pakistan",
    "Namibia",
    "Mozambique",
    "Turkey",
    "Chile",
    "Zambia",
    "Myanmar",
    "Afghanistan",
    "Somalia",
    "Ukraine",
    "Madagascar",
    "Botswana",
    "Kenya",
    "France",
    "Yemen",
    "Thailand",
    "Spain",
    "Sweden",
    "Morocco",
    "Uzbekistan"
  ),
  NOC = c(
    "RUS",
    "CAN",
    "CHN",
    "USA",
    "BRA",
    "AUS",
    "IND",
    "ARG",
    "KAZ",
    "ALG",
    "COD",
    "MEX",
    "INA",
    "LBA",
    "IRI",
    "MGL",
    "PER",
    "CHA",
    "NIG",
    "ANG",
    "MLI",
    "RSA",
    "COL",
    "ETH",
    "BOL",
    "EGY",
    "TAN",
    "NGR",
    "VEN",
    "PAK",
    "NAM",
    "MOZ",
    "TUR",
    "CHI",
    "ZAM",
    "MYA",
    "AFG",
    "SOM",
    "UKR",
    "MAD",
    "BOT",
    "KEN",
    "FRA",
    "YEM",
    "THA",
    "ESP",
    "SWE",
    "MAR",
    "UZB"
  ),
  stringsAsFactors = FALSE
)

cat("Manual NOC mapping created for", nrow(country_noc_manual), "countries\n\n")

# ==============================================================================
# STEP 3: Merge NOC codes with country sizes
# ==============================================================================

cat("STEP 3: Merging NOC codes with country sizes...\n")

# Merge
country_info <- merge(country_sizes, country_noc_manual, by = "Country", all.x = FALSE)

cat("Matched countries:", nrow(country_info), "\n")

# Check which countries from sizes are missing
missing <- country_sizes[!country_sizes$Country %in% country_noc_manual$Country, ]
if (nrow(missing) > 0) {
  cat("\nCountries in sizes dataset without NOC mapping:\n")
  print(head(missing$Country, 20))
  cat("(These are likely non-Olympic countries and can be ignored)\n\n")
}

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

cat("Total countries:", nrow(country_info_final), "\n\n")

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
                   "FIN", "AUS", "ITA", "JPN", "MEX", "CAN", "URS", "KOR",
                   "ESP", "BRA", "CHN")

hosts_with_data <- host_countries[host_countries %in% country_info_final$noc]
hosts_missing <- host_countries[!host_countries %in% country_info_final$noc]

cat("Host countries WITH size data:", length(hosts_with_data), "\n")
print(country_info_final[country_info_final$noc %in% hosts_with_data,
                         c("noc", "country_name", "total_area_km2", "country_size_category")])

if (length(hosts_missing) > 0) {
  cat("\nHost countries MISSING size data:", paste(hosts_missing, collapse=", "), "\n")
  cat("(You may need to add these manually if needed for analysis)\n")
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
