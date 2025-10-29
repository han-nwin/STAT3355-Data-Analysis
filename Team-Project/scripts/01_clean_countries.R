# ==============================================================================
# Script: 01_clean_countries.R
# Purpose: Create NOC mapping table to standardize country names across datasets
# Author: Team 5
# Date: 2025-10-29
# ==============================================================================

# Load required libraries
library(tidyverse)

# Set working directory to project root
setwd("/home/han/Github/STAT3355-Data-Analysis/Team-Project")

# ==============================================================================
# STEP 1: Load all raw datasets to examine country name variations
# ==============================================================================

cat("Loading raw datasets...\n")

# Athletes data (already has NOC codes!)
athletes <- read_csv("raw_data/Athletes_summer_games.csv")

# Olympic hosts
hosts <- read_csv("raw_data/olympic_hosts.csv")

# Country sizes
country_sizes <- read_csv("raw_data/country_sizes.csv")

# Population data
population <- read_csv("raw_data/population-by-age-group.csv")

# GDP data (skip first 4 metadata rows)
gdp <- read_csv("raw_data/gdp.csv", skip = 4)

# ==============================================================================
# STEP 2: Extract unique country names from each dataset
# ==============================================================================

cat("Extracting unique country names from each dataset...\n")

# From athletes - get unique NOC codes and Team names
athletes_countries <- athletes %>%
  filter(Season == "Summer") %>%
  distinct(NOC, Team) %>%
  arrange(NOC)

# From hosts - get unique countries (summer games only)
hosts_countries <- hosts %>%
  filter(Type == "summergames") %>%
  distinct(Country) %>%
  arrange(Country)

# From country sizes
sizes_countries <- country_sizes %>%
  distinct(Country) %>%
  arrange(Country)

# From population
pop_countries <- population %>%
  distinct(Entity, Code) %>%
  arrange(Entity)

# From GDP
gdp_countries <- gdp %>%
  distinct(`Country Name`, `Country Code`) %>%
  arrange(`Country Name`)

# ==============================================================================
# STEP 3: Create master NOC mapping table
# ==============================================================================

cat("Creating NOC mapping table...\n")

# Start with athletes data since it already has NOC codes
noc_mapping <- athletes_countries %>%
  rename(
    noc = NOC,
    name_athletes = Team
  )

# Add GDP country codes and names
gdp_lookup <- gdp_countries %>%
  rename(
    noc = `Country Code`,
    name_gdp = `Country Name`
  )

noc_mapping <- noc_mapping %>%
  left_join(gdp_lookup, by = "noc")

# Add population country codes and names
pop_lookup <- pop_countries %>%
  rename(
    noc = Code,
    name_population = Entity
  )

noc_mapping <- noc_mapping %>%
  left_join(pop_lookup, by = "noc")

# ==============================================================================
# STEP 4: Manual fixes for special cases
# ==============================================================================

cat("Applying manual fixes for special cases...\n")

# Create a manual mapping table for problematic cases
manual_fixes <- tribble(
  ~noc, ~name_athletes, ~name_hosts, ~name_gdp, ~name_population, ~name_sizes, ~notes,

  # United States variations
  "USA", "United States", "United States of America", "United States", "United States", "United States", "Standard",

  # China variations
  "CHN", "China", "People's Republic of China", "China", "China", "China", "Standard",

  # Russia/USSR variations
  "RUS", "Russia", "Russian Federation", "Russian Federation", "Russian Federation", "Russia", "USSR before 1991",

  # Great Britain variations
  "GBR", "Great Britain", "Great Britain", "United Kingdom", "United Kingdom", NA, "UK/GB difference",

  # Korea variations
  "KOR", "South Korea", "Republic of Korea", "Korea, Rep.", "South Korea", NA, "South Korea",

  # Germany variations
  "GER", "Germany", "Germany", "Germany", "Germany", NA, "Unified after 1990",

  # Australia
  "AUS", "Australia", "Australia", "Australia", "Australia", "Australia", "Co-host 1956",

  # Sweden
  "SWE", "Sweden", "Sweden", "Sweden", "Sweden", NA, "Co-host 1956",

  # France
  "FRA", "France", "France", "France", "France", "France", "Multiple hosting",

  # Japan
  "JPN", "Japan", "Japan", "Japan", "Japan", NA, "Multiple hosting",

  # Canada
  "CAN", "Canada", "Canada", "Canada", "Canada", "Canada", "Multiple hosting",

  # Greece
  "GRE", "Greece", "Greece", "Greece", "Greece", NA, "First modern Olympics 1896",

  # Brazil
  "BRA", "Brazil", "Brazil", "Brazil", "Brazil", "Brazil", "Hosted 2016",

  # Mexico
  "MEX", "Mexico", "Mexico", "Mexico", "Mexico", "Mexico", "Hosted 1968",

  # Belgium
  "BEL", "Belgium", "Belgium", "Belgium", "Belgium", "Belgium", "Hosted 1920",

  # Netherlands
  "NED", "Netherlands", "Netherlands", "Netherlands", "Netherlands", NA, "Hosted 1928",

  # Finland
  "FIN", "Finland", "Finland", "Finland", "Finland", NA, "Hosted 1952",

  # Italy
  "ITA", "Italy", "Italy", "Italy", "Italy", NA, "Multiple hosting",

  # Spain
  "ESP", "Spain", "Spain", "Spain", "Spain", NA, "Hosted 1992",

  # Historical cases
  "URS", "Soviet Union", "USSR", NA, NA, NA, "Soviet Union (dissolved 1991)",
  "GDR", "East Germany", NA, NA, NA, NA, "East Germany (until 1990)",
  "FRG", "West Germany", NA, NA, NA, NA, "West Germany (until 1990)",
  "TCH", "Czechoslovakia", NA, NA, NA, NA, "Czechoslovakia (until 1993)",
  "YUG", "Yugoslavia", NA, NA, NA, NA, "Yugoslavia (dissolved)",

  # Special cases
  "DEN", "Denmark", NA, "Denmark", "Denmark", NA, "Denmark/Sweden athletes exist",
  "SUI", "Switzerland", "Switzerland", "Switzerland", "Switzerland", NA, "SUI not CHE code"
)

# ==============================================================================
# STEP 5: Examine cases that need attention
# ==============================================================================

cat("\n=== EXAMINING DATA BEFORE CLEANING ===\n")

# Show sample of athletes data
cat("\nSample from Athletes data (showing NOC already exists):\n")
athletes %>%
  filter(Season == "Summer") %>%
  select(Name, Team, NOC, Year, Sport) %>%
  head(10) %>%
  print()

# Show unique Team/NOC combinations that have issues
cat("\nTeam names with multiple countries (need splitting):\n")
athletes %>%
  filter(Season == "Summer", str_detect(Team, "/|,")) %>%
  distinct(Team, NOC) %>%
  print()

# Show hosts with country name issues
cat("\nHosts data country names:\n")
hosts %>%
  filter(Type == "summergames") %>%
  select(Year, Country, City) %>%
  print(n = 30)

# Show countries that appear in athletes but not in GDP
cat("\nNOCs in Athletes but missing from GDP data:\n")
noc_in_athletes <- unique(athletes$NOC[athletes$Season == "Summer"])
noc_in_gdp <- unique(gdp$`Country Code`)
missing_in_gdp <- setdiff(noc_in_athletes, noc_in_gdp)
cat(paste(missing_in_gdp, collapse = ", "), "\n")

# ==============================================================================
# STEP 6: Create final NOC mapping with all variations
# ==============================================================================

cat("\nCreating final NOC mapping table...\n")

# Use the manual fixes as the base, then fill in from data where available
noc_mapping_final <- manual_fixes %>%
  select(noc, name_athletes, name_hosts, name_gdp, name_population, notes)

# Add all NOCs from athletes that aren't in manual fixes
all_nocs <- athletes %>%
  filter(Season == "Summer") %>%
  distinct(NOC, Team) %>%
  anti_join(manual_fixes, by = c("NOC" = "noc")) %>%
  rename(noc = NOC, name_athletes = Team) %>%
  left_join(
    gdp %>% distinct(`Country Code`, `Country Name`) %>% rename(noc = `Country Code`, name_gdp = `Country Name`),
    by = "noc"
  ) %>%
  left_join(
    population %>% distinct(Code, Entity) %>% rename(noc = Code, name_population = Entity),
    by = "noc"
  ) %>%
  mutate(
    name_hosts = NA_character_,
    notes = "Auto-mapped from data"
  )

# Combine manual and auto-mapped
noc_mapping_final <- bind_rows(noc_mapping_final, all_nocs) %>%
  arrange(noc)

# ==============================================================================
# STEP 7: Save the mapping table
# ==============================================================================

cat("Saving NOC mapping table...\n")

write_csv(noc_mapping_final, "cleaned_data/noc_mapping.csv")

cat("\n=== NOC MAPPING COMPLETE ===\n")
cat("Saved to: cleaned_data/noc_mapping.csv\n")
cat("Total NOC codes mapped:", nrow(noc_mapping_final), "\n")

# Show summary
cat("\nSummary of mapping coverage:\n")
cat("- Athletes (Team names):", sum(!is.na(noc_mapping_final$name_athletes)), "\n")
cat("- GDP data:", sum(!is.na(noc_mapping_final$name_gdp)), "\n")
cat("- Population data:", sum(!is.na(noc_mapping_final$name_population)), "\n")
cat("- Manual mappings:", sum(noc_mapping_final$notes == "Auto-mapped from data", na.rm = TRUE), "\n")

# Display sample of final mapping
cat("\nSample of final NOC mapping:\n")
noc_mapping_final %>%
  filter(!is.na(notes)) %>%
  head(20) %>%
  print()

cat("\n=== SCRIPT COMPLETE ===\n")
