# ==============================================================================
# Script: 02_clean_athletes.R
# Purpose: Clean athletes data - filter to summer gymnastics, create medal vars
# Author: Team 5
# Date: 2025-10-29
# ==============================================================================

# Set working directory
setwd("/home/han/Github/STAT3355-Data-Analysis/Team-Project")

cat("=== CLEANING ATHLETES DATA ===\n\n")

# ==============================================================================
# STEP 1: Load raw athletes data
# ==============================================================================

cat("STEP 1: Loading raw athletes data...\n")

athletes_raw <- read.csv("raw_data/Athletes_summer_games.csv", stringsAsFactors = FALSE)

cat("Total rows in raw data:", nrow(athletes_raw), "\n")
cat("Columns:", paste(names(athletes_raw), collapse=", "), "\n\n")

# Show dimensions
cat("Original data dimensions:\n")
cat("- Total records:", nrow(athletes_raw), "\n")
cat("- Total columns:", ncol(athletes_raw), "\n")
cat("- Years range:", min(athletes_raw$Year, na.rm=TRUE), "-", max(athletes_raw$Year, na.rm=TRUE), "\n")
cat("- Seasons:", paste(unique(athletes_raw$Season), collapse=", "), "\n\n")

# ==============================================================================
# STEP 2: Filter to Summer Olympics only
# ==============================================================================

cat("STEP 2: Filtering to Summer Olympics...\n")

athletes_summer <- athletes_raw[athletes_raw$Season == "Summer", ]

cat("After filtering to Summer:\n")
cat("- Records:", nrow(athletes_summer), "\n")
cat("- Removed:", nrow(athletes_raw) - nrow(athletes_summer), "Winter Olympics records\n\n")

# ==============================================================================
# STEP 3: Identify and filter to Gymnastics
# ==============================================================================

cat("STEP 3: Filtering to Gymnastics sports...\n")

# Show all unique sports to identify gymnastics variations
cat("Checking for gymnastics-related sports:\n")
gymnastics_sports <- unique(athletes_summer$Sport[grepl("Gymn", athletes_summer$Sport, ignore.case=TRUE)])
print(gymnastics_sports)
cat("\n")


# Filter to gymnastics (all variations)
athletes_gymnastics <- athletes_summer[athletes_summer$Sport %in% gymnastics_sports, ]

cat("After filtering to Gymnastics:\n")
cat("- Records:", nrow(athletes_gymnastics), "\n")
cat("- Unique athletes:", length(unique(athletes_gymnastics$Name)), "\n")
cat("- Years range:", min(athletes_gymnastics$Year, na.rm=TRUE), "-", max(athletes_gymnastics$Year, na.rm=TRUE), "\n\n")

# Show distribution by gymnastics type
cat("Distribution by gymnastics sport type:\n")
print(table(athletes_gymnastics$Sport))
cat("\n")

# ==============================================================================
# STEP 4: Create collapsed gymnastics category
# ==============================================================================

cat("STEP 4: Creating collapsed gymnastics category...\n")

# Create a standardized sport category
athletes_gymnastics$sport_category <- "Gymnastics"

# Also create a detailed category for potential future use
athletes_gymnastics$gymnastics_type <- athletes_gymnastics$Sport
athletes_gymnastics$gymnastics_type[athletes_gymnastics$Sport == "Gymnastics"] <- "Artistic Gymnastics"
athletes_gymnastics$gymnastics_type[athletes_gymnastics$Sport == "Artistic Gymnastics"] <- "Artistic Gymnastics"
athletes_gymnastics$gymnastics_type[athletes_gymnastics$Sport == "Rhythmic Gymnastics"] <- "Rhythmic Gymnastics"
athletes_gymnastics$gymnastics_type[athletes_gymnastics$Sport == "Trampoline Gymnastics"] <- "Trampoline Gymnastics"

cat("Gymnastics types standardized:\n")
print(table(athletes_gymnastics$gymnastics_type))
cat("\n")

# ==============================================================================
# STEP 5: Examine Medal column (BEFORE cleaning)
# ==============================================================================

cat("STEP 5: Examining Medal column BEFORE cleaning...\n")

# Count medals
medal_summary <- data.frame(
  Medal_Value = c("Gold", "Silver", "Bronze", "No Medal (blank)"),
  Count = c(
    sum(athletes_gymnastics$Medal == "Gold", na.rm=TRUE),
    sum(athletes_gymnastics$Medal == "Silver", na.rm=TRUE),
    sum(athletes_gymnastics$Medal == "Bronze", na.rm=TRUE),
    sum(athletes_gymnastics$Medal == "" | is.na(athletes_gymnastics$Medal))
  )
)

medal_summary$Percentage <- round(100 * medal_summary$Count / nrow(athletes_gymnastics), 2)

cat("Medal distribution BEFORE cleaning:\n")
print(medal_summary)
cat("\n")

# ==============================================================================
# STEP 6: Create medal outcome variables
# ==============================================================================

cat("STEP 6: Creating medal outcome variables...\n")

# Binary: Did they win ANY medal?
athletes_gymnastics$medal_won <- ifelse(
  athletes_gymnastics$Medal %in% c("Gold", "Silver", "Bronze"),
  1,
  0
)

# Binary: Did they win GOLD?
athletes_gymnastics$gold_medal <- ifelse(
  athletes_gymnastics$Medal == "Gold",
  1,
  0
)

# Numeric: Medal points (Gold=3, Silver=2, Bronze=1, None=0)
athletes_gymnastics$medal_points <- 0
athletes_gymnastics$medal_points[athletes_gymnastics$Medal == "Bronze"] <- 1
athletes_gymnastics$medal_points[athletes_gymnastics$Medal == "Silver"] <- 2
athletes_gymnastics$medal_points[athletes_gymnastics$Medal == "Gold"] <- 3

cat("Medal variables created:\n")
cat("- medal_won: Binary (1 = any medal, 0 = no medal)\n")
cat("- gold_medal: Binary (1 = gold, 0 = no gold)\n")
cat("- medal_points: Numeric (Gold=3, Silver=2, Bronze=1, None=0)\n\n")

# Verify
cat("Verification of new variables:\n")
cat("- medal_won = 1:", sum(athletes_gymnastics$medal_won == 1), "\n")
cat("- gold_medal = 1:", sum(athletes_gymnastics$gold_medal == 1), "\n")
cat("- Average medal_points:", round(mean(athletes_gymnastics$medal_points), 3), "\n\n")

# ==============================================================================
# STEP 7: Validate Sex variable
# ==============================================================================

cat("STEP 7: Validating Sex variable...\n")

sex_table <- table(athletes_gymnastics$Sex, useNA="ifany")
cat("Sex distribution:\n")
print(sex_table)
cat("\n")

# Check for any unexpected values
valid_sex <- c("M", "F")
invalid_sex <- athletes_gymnastics$Sex[!athletes_gymnastics$Sex %in% valid_sex & !is.na(athletes_gymnastics$Sex)]

if (length(invalid_sex) > 0) {
  cat("WARNING: Found invalid Sex values:\n")
  print(unique(invalid_sex))
  cat("\n")
} else {
  cat("Sex variable is clean (only M and F values)\n\n")
}

# ==============================================================================
# STEP 8: Verify NOC codes
# ==============================================================================

cat("STEP 8: Verifying NOC codes...\n")

# Load NOC mapping
noc_mapping <- read.csv("cleaned_data/noc_mapping.csv", stringsAsFactors = FALSE)

# Check if all NOCs in gymnastics data are in our mapping
gymnastics_nocs <- unique(athletes_gymnastics$NOC)
mapped_nocs <- unique(noc_mapping$noc)

missing_nocs <- gymnastics_nocs[!gymnastics_nocs %in% mapped_nocs]

cat("Total unique NOCs in gymnastics data:", length(gymnastics_nocs), "\n")
cat("NOCs in our mapping:", length(mapped_nocs), "\n")

if (length(missing_nocs) > 0) {
  cat("WARNING: NOCs in gymnastics but not in mapping:\n")
  print(missing_nocs)
  cat("\n")
} else {
  cat("All NOCs are in our mapping - good!\n\n")
}

# ==============================================================================
# STEP 9: Select final columns
# ==============================================================================

cat("STEP 9: Selecting and ordering final columns...\n")

athletes_cleaned <- athletes_gymnastics[, c(
  "Name",
  "Sex",
  "Age",
  "Team",
  "NOC",
  "Year",
  "Season",
  "City",
  "Sport",
  "sport_category",
  "gymnastics_type",
  "Event",
  "Medal",
  "medal_won",
  "gold_medal",
  "medal_points"
)]

# Sort by Year, then NOC, then Name
athletes_cleaned <- athletes_cleaned[order(athletes_cleaned$Year, athletes_cleaned$NOC, athletes_cleaned$Name), ]

# Reset row names
rownames(athletes_cleaned) <- NULL

cat("Final columns:", paste(names(athletes_cleaned), collapse=", "), "\n\n")

# ==============================================================================
# STEP 10: Summary statistics
# ==============================================================================

cat("=== SUMMARY STATISTICS ===\n\n")

cat("Final cleaned dataset:\n")
cat("- Total records:", nrow(athletes_cleaned), "\n")
cat("- Total columns:", ncol(athletes_cleaned), "\n")
cat("- Unique athletes:", length(unique(athletes_cleaned$Name)), "\n")
cat("- Unique countries (NOCs):", length(unique(athletes_cleaned$NOC)), "\n")
cat("- Years range:", min(athletes_cleaned$Year), "-", max(athletes_cleaned$Year), "\n")
cat("- Olympics covered:", length(unique(athletes_cleaned$Year)), "\n\n")

cat("Medal statistics:\n")
cat("- Total medals won:", sum(athletes_cleaned$medal_won), "\n")
cat("- Gold medals:", sum(athletes_cleaned$gold_medal), "\n")
cat("- Silver medals:", sum(athletes_cleaned$Medal == "Silver"), "\n")
cat("- Bronze medals:", sum(athletes_cleaned$Medal == "Bronze"), "\n")
cat("- No medal:", sum(athletes_cleaned$medal_won == 0), "\n")
cat("- Medal rate:", round(100 * sum(athletes_cleaned$medal_won) / nrow(athletes_cleaned), 2), "%\n\n")

cat("Gender distribution:\n")
print(table(athletes_cleaned$Sex))
cat("\n")

cat("Gymnastics types:\n")
print(table(athletes_cleaned$gymnastics_type))
cat("\n")

cat("Top 10 countries by gymnastics participation:\n")
country_counts <- sort(table(athletes_cleaned$NOC), decreasing=TRUE)
print(head(country_counts, 10))
cat("\n")

# ==============================================================================
# STEP 11: Show BEFORE vs AFTER comparison
# ==============================================================================

cat("=== BEFORE vs AFTER COMPARISON ===\n\n")

cat("BEFORE (Raw data):\n")
cat("- Total records:", nrow(athletes_raw), "\n")
cat("- All sports:", length(unique(athletes_raw$Sport)), "sports\n")
cat("- Medal column: Text values ('Gold', 'Silver', 'Bronze', '')\n")
cat("- No medal indicators\n\n")

cat("AFTER (Cleaned data):\n")
cat("- Total records:", nrow(athletes_cleaned), "(gymnastics only)\n")
cat("- Gymnastics types:", length(unique(athletes_cleaned$gymnastics_type)), "types\n")
cat("- Medal column: Original preserved\n")
cat("- New variables: medal_won, gold_medal, medal_points\n")
cat("- sport_category: All set to 'Gymnastics'\n")
cat("- gymnastics_type: Detailed type preserved\n\n")

# ==============================================================================
# STEP 12: Save cleaned data
# ==============================================================================

cat("=== SAVING CLEANED DATA ===\n")

write.csv(athletes_cleaned, "cleaned_data/athletes_cleaned.csv", row.names=FALSE)

cat("Saved to: cleaned_data/athletes_cleaned.csv\n")
cat("Total rows:", nrow(athletes_cleaned), "\n")
cat("Total columns:", ncol(athletes_cleaned), "\n\n")

# ==============================================================================
# STEP 13: Show sample of cleaned data
# ==============================================================================

cat("=== SAMPLE OF CLEANED DATA ===\n\n")
cat("First 10 records:\n")
print(head(athletes_cleaned[, c("Name", "Sex", "NOC", "Year", "gymnastics_type", "Medal", "medal_won", "gold_medal")], 10))

cat("\n=== SCRIPT COMPLETE ===\n")
