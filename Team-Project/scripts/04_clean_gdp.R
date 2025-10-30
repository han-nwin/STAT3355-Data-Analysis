# ==============================================================================
# Script: 04_clean_gdp.R
# Purpose: Clean GDP data - reshape wide to long, add NOC codes, calculate per capita
# Author: Team 5
# Date: 2025-10-29
# ==============================================================================

# Set working directory
setwd("/home/han/Github/STAT3355-Data-Analysis/Team-Project")

cat("=== CLEANING GDP DATA ===\n\n")

# ==============================================================================
# STEP 1: Load raw GDP data (skip metadata rows)
# ==============================================================================

cat("STEP 1: Loading raw GDP data...\n")

# Skip first 4 metadata rows, row 5 has headers
gdp_raw <- read.csv("raw_data/gdp.csv", skip = 4, stringsAsFactors = FALSE)

cat("GDP data loaded:\n")
cat("- Rows:", nrow(gdp_raw), "\n")
cat("- Columns:", ncol(gdp_raw), "\n\n")

# ==============================================================================
# STEP 2: Reshape from wide to long format
# ==============================================================================

cat("STEP 2: Reshaping from wide to long format...\n")

# Get year columns (all columns starting with X followed by 4 digits)
year_cols <- grep("^X[0-9]{4}$", names(gdp_raw), value = TRUE)
cat("Found", length(year_cols), "year columns\n")

# Reshape using base R
gdp_long <- data.frame()

for (i in 1:nrow(gdp_raw)) {
  country_name <- gdp_raw$Country.Name[i]
  country_code <- gdp_raw$Country.Code[i]

  for (year_col in year_cols) {
    year <- as.numeric(gsub("X", "", year_col))
    gdp_value <- gdp_raw[i, year_col]

    gdp_long <- rbind(gdp_long, data.frame(
      country_name = country_name,
      country_code = country_code,
      year = year,
      gdp = gdp_value,
      stringsAsFactors = FALSE
    ))
  }

  if (i %% 50 == 0) {
    cat("Processed", i, "of", nrow(gdp_raw), "countries...\n")
  }
}

cat("\nReshaping complete! Long format rows:", nrow(gdp_long), "\n\n")

# ==============================================================================
# STEP 3: Clean GDP values
# ==============================================================================

cat("STEP 3: Cleaning GDP values...\n")

gdp_long$gdp[gdp_long$gdp == ""] <- NA
gdp_long$gdp <- as.numeric(gdp_long$gdp)

cat("- Non-missing GDP values:", sum(!is.na(gdp_long$gdp)), "\n\n")

# ==============================================================================
# STEP 4: Filter to Olympic years only
# ==============================================================================

cat("STEP 4: Filtering to Olympic years...\n")

hosts <- read.csv("raw_data/olympic_hosts.csv", stringsAsFactors = FALSE)
olympic_years <- sort(unique(as.numeric(hosts$Year[hosts$Type == "summergames" & !is.na(hosts$Year)])))

gdp_olympic <- gdp_long[gdp_long$year %in% olympic_years, ]

cat("Filtered to", length(olympic_years), "Olympic years\n")
cat("Records:", nrow(gdp_olympic), "\n\n")

# ==============================================================================
# STEP 5: Add NOC codes
# ==============================================================================

cat("STEP 5: Adding NOC codes...\n")

gdp_olympic$noc <- gdp_olympic$country_code

cat("NOC codes added\n\n")

# ==============================================================================
# STEP 6: Load and merge population data
# ==============================================================================

cat("STEP 6: Loading population for GDP per capita...\n")

population_raw <- read.csv("raw_data/population-by-age-group.csv", stringsAsFactors = FALSE)

age_cols <- grep("Population.*Age.*Variant", names(population_raw), value = TRUE)
population_raw$total_population <- rowSums(population_raw[, age_cols], na.rm = TRUE)

pop_data <- population_raw[, c("Code", "Year", "total_population")]
names(pop_data) <- c("noc", "year", "total_population")

# Merge
gdp_with_pop <- merge(
  gdp_olympic,
  pop_data,
  by = c("noc", "year"),
  all.x = TRUE
)

cat("Population data merged\n")
cat("- Records with population:", sum(!is.na(gdp_with_pop$total_population)), "\n\n")

# ==============================================================================
# STEP 7: Calculate GDP per capita
# ==============================================================================

cat("STEP 7: Calculating GDP per capita...\n")

gdp_with_pop$gdp_per_capita <- gdp_with_pop$gdp / gdp_with_pop$total_population

cat("GDP per capita calculated\n")
cat("- Valid values:", sum(!is.na(gdp_with_pop$gdp_per_capita)), "\n\n")

# ==============================================================================
# STEP 8: Final cleanup
# ==============================================================================

cat("STEP 8: Final cleanup...\n")

gdp_cleaned <- gdp_with_pop[, c(
  "noc",
  "country_name",
  "year",
  "gdp",
  "total_population",
  "gdp_per_capita"
)]

gdp_cleaned <- gdp_cleaned[order(gdp_cleaned$noc, gdp_cleaned$year), ]
rownames(gdp_cleaned) <- NULL

# ==============================================================================
# STEP 9: Summary statistics
# ==============================================================================

cat("\n=== SUMMARY STATISTICS ===\n\n")

cat("Final dataset:\n")
cat("- Records:", nrow(gdp_cleaned), "\n")
cat("- Countries:", length(unique(gdp_cleaned$noc)), "\n")
cat("- Years:", min(gdp_cleaned$year), "-", max(gdp_cleaned$year), "\n")
cat("- Olympic years:", length(unique(gdp_cleaned$year)), "\n\n")

# ==============================================================================
# STEP 10: Save cleaned data
# ==============================================================================

cat("=== SAVING CLEANED DATA ===\n")

write.csv(gdp_cleaned, "cleaned_data/gdp_long.csv", row.names=FALSE)

cat("Saved to: cleaned_data/gdp_long.csv\n")
cat("Rows:", nrow(gdp_cleaned), "\n")
cat("Columns:", ncol(gdp_cleaned), "\n\n")

cat("=== SCRIPT COMPLETE ===\n")
