# Data Cleaning Plan - Team 5 Olympics Project

## Overview

This document outlines the data cleaning requirements for both:
1. **Data Cleaning Assignment (Due Nov 4th)** - Document at least 3 variables
2. **Full Project** - All variables needed to answer research questions

---

## Two Different Scopes

### For the Data Cleaning Assignment (Due Nov 4th) - Minimum Requirement
- **Must clean at least 3 variables** for the assignment submission
- Show tables before/after + written summary for just those 3

### For the Full Project - What You Actually Need
To actually **answer your research questions**, you'll need to clean MORE than 3 variables. You just don't have to document all of them in the Nov 4th assignment.

---

## Variables Needed by Research Question

### Question 1: Does hosting provide a competitive advantage in gymnastics?

**REQUIRED variables (5):**
1. ✅ **Country Name Standardization** (NOC codes) - can't merge datasets without this
2. ✅ **Gymnastics Sport Collapse** - need to identify gymnastics records
3. ✅ **Medal Outcome Variables** - your dependent variable (medal counts)
4. ✅ **Host Country Indicator** (is_host) - your main independent variable
5. ✅ **Baseline Performance Calculation** (NEW) - need each country's historical average medals to compare against hosting year

**Optional but helpful:**
- Gender variable cleaning (if Sex has missing values)

---

### Question 2: Gender differences in home advantage

**REQUIRED variables (same 5 as Q1, plus):**
6. ✅ **Sex Variable Validation** - check for missing/inconsistent values (M/F)

---

### Question 3: Hosting experience, country size, and participation

**REQUIRED variables (Q1's 5, plus):**
7. ✅ **First-Time Host Indicator** - track hosting history
8. ✅ **Country Size** - merge country_sizes.csv with NOC standardization
9. ✅ **Population Size** - from population dataset (for population-based analysis)
10. ✅ **Gymnast Participation Count** (NEW) - count of gymnasts per country per Olympics

---

### Question 4: GDP and demographics

**REQUIRED variables (Q1's 5, plus):**
11. ✅ **GDP Data Reshaping** - wide to long format
12. ✅ **GDP Per Capita Calculation** - GDP / population
13. ✅ **Total Population** - sum of age groups
14. ✅ **Working Age Proportion** - demographic structure
15. ✅ **GDP/demographic matching to Olympic years** - nearest year matching

---

## Complete Variable Summary Table
  - Small: < 500,000 km^2
  - Medium: 500,000 - 5,000,000 km^2
  - Large: > 5,000,000 km^2

| Variable | For Nov 4 Assignment? | For Full Project? | Complexity |
|----------|----------------------|-------------------|------------|
| 1. Country Name Standardization | ✅ **YES - Include** | ✅ Required | HIGH |
| 2. Gymnastics Sport Collapse | ✅ **YES - Include** | ✅ Required | LOW |
| 3. Medal Outcome Variables | ✅ **YES - Include** | ✅ Required | LOW |
| 4. Host Country Indicator | ⚠️ Optional | ✅ Required | MEDIUM |
| 5. Baseline Performance | ⚠️ Optional | ✅ Required Q1 | MEDIUM |
| 6. Sex Variable Check | ❌ Do but don't document | ✅ Required Q2 | LOW |
| 7. First-Time Host | ❌ Do but don't document | ✅ Required Q3 | LOW |
| 8. Country Size | ❌ Do but don't document | ✅ Required Q3 | LOW |
| 9. Population | ❌ Do but don't document | ✅ Required Q3, Q4 | MEDIUM |
| 10. Gymnast Count | ❌ Do but don't document | ✅ Required Q3 | LOW |
| 11. GDP Reshaping | ❌ Do but don't document | ✅ Required Q4 | HIGH |
| 12. GDP Per Capita | ❌ Do but don't document | ✅ Required Q4 | MEDIUM |
| 13. Age Structure | ❌ Do but don't document | ✅ Required Q4 | MEDIUM |

---

## Detailed Variable Descriptions

### 1. Country Name Standardization ⭐⭐⭐ (MOST IMPORTANT)

**Problem:** Country names are inconsistent across ALL 5 datasets:

| Dataset | Variable | Example Issues |
|---------|----------|----------------|
| `Athletes_summer_games.csv` | Team | "China", "United States", "Denmark/Sweden" |
| `olympic_hosts.csv` | Country | "United States of America", "Australia, Sweden", "USSR", "Republic of Korea" |
| `country_sizes.csv` | Country | "United States", "Russia", "DR Congo" |
| `population-by-age-group.csv` | Entity | "United States", "Russian Federation", "China" |
| `gdp.csv` | Country Name | "United States", "Russian Federation", "Korea, Rep." |

**What to clean:**
- **Create a standardized country mapping table** with NOC codes (CHN, USA, FIN, etc.)
- Map all country name variations to NOC codes:
  - "United States" / "United States of America" / "USA" → "USA"
  - "Russia" / "USSR" / "Russian Federation" → "RUS" (handle historical changes)
  - "Korea, Rep." / "Republic of Korea" / "South Korea" → "KOR"
- Handle special cases:
  - "Denmark/Sweden" (Team field for shared athletes) → split into DEN and SWE
  - "Australia, Sweden" (1956 co-hosts) → split into AUS and SWE
  - Historical transitions (USSR→RUS, East/West Germany→GER)
- Create new variable: `NOC` in all datasets

**Tables to show:**
- **Before:** Table showing country name variations across all 5 datasets (sample 10-15 countries)
- **After:** Table showing standardized NOC codes with count of records per country

**Needed for:** Questions 1, 2, 3, 4 (ALL)

---

### 2. Medal Outcome Variable Creation ⭐⭐⭐

**Problem:** The `Medal` column in `Athletes_summer_games.csv` has:
- Empty strings `""` for no medal (most rows)
- Text values: `"Gold"`, `"Silver"`, `"Bronze"`
- No numeric summary variable

**What to clean:**
- Create **3 new binary variables**:
  - `medal_won`: 1 if any medal, 0 if blank
  - `gold_medal`: 1 if Gold, 0 otherwise
  - `medal_any`: Same as medal_won but clearer name
- Create **1 new numeric variable**:
  - `medal_points`: Gold=3, Silver=2, Bronze=1, None=0
- Keep original `Medal` column for reference

**Tables to show:**
- **Before:** Frequency table of `Medal` column (count and % for each category)
- **After:** Frequency table showing new variables with cross-tabulation

**Needed for:** Questions 1, 2, 3

---

### 3. Host Country Indicator (New Variable Creation) ⭐⭐⭐

**Problem:** Need to identify which athletes competed in their home country

**What to clean:**
- Filter `olympic_hosts.csv` to `Type == "summergames"` only
- Extract `Country` and `Year` from hosts dataset
- Handle special case: 1956 had "Australia, Sweden" → create 2 host records
- Merge with `Athletes_summer_games.csv` by `Year`
- Create `is_host`: 1 if athlete's NOC matches host country NOC for that year, 0 otherwise
- Create `host_country_noc`: NOC code of host country for each year

**Tables to show:**
- **Before:** Table of summer Olympic hosts by year (showing Country name issues)
- **After:** Table showing Year, host_country_noc, and count of host nation athletes vs non-host

**Needed for:** Questions 1, 2, 3, 4 (ALL)

---

### 4. Gymnastics Sport Category Collapse ⭐⭐

**Problem:** `Sport` column has multiple gymnastics categories:
- "Gymnastics" (earlier Olympics)
- "Artistic Gymnastics"
- "Rhythmic Gymnastics" (added 1984)
- "Trampoline Gymnastics" (added 2000)

**What to clean:**
- Create `sport_category` variable:
  - Collapse all gymnastics types → "Gymnastics"
  - OR keep separate for different analysis
- Create `is_gymnastics`: Binary 1/0 indicator
- Document which years had which sports

**Tables to show:**
- **Before:** Frequency table of Sport containing "Gymnastics" by Year
- **After:** Frequency table of cleaned `sport_category` or `is_gymnastics`

**Needed for:** Questions 1, 2, 3

---

### 5. GDP Data Reshaping & Matching ⭐⭐

**Problem:** `gdp.csv` has major structural issues:
- **Wide format**: Years are in columns (1960-2024), need long format
- Missing values shown as empty strings `""`
- Extra header rows (rows 1-4 are metadata)
- Country names need standardization
- Need GDP **per capita** but only have total GDP

**What to clean:**
- Skip first 4 rows, read from row 5
- **Reshape from wide to long**: Pivot year columns into rows
- Filter to Olympic years only (1896-2020, summer games only)
- Standardize country names to NOC codes
- Convert GDP to numeric (handle empty strings as NA)
- **Calculate GDP per capita**: Merge with population data and divide
  - `gdp_per_capita = GDP / total_population`
- Match each Olympic year with closest available GDP year

**Tables to show:**
- **Before:** Wide format showing 3-4 countries with years as columns
- **After:** Long format showing Year, NOC, GDP, Population, GDP_per_capita (sample 10-15 rows)

**Needed for:** Question 4

---

### 6. First-Time vs Repeat Host Variable ⭐

**Problem:** Need to track hosting experience

**What to create:**
- From `olympic_hosts.csv` (summer games only):
- Count cumulative hosting history for each country
- Create `first_time_host`: Binary 1 if first time hosting, 0 otherwise
- Create `hosting_count_prior`: Number of times hosted before this Olympics
- Create `hosting_count_total`: Total times hosted including this one

**Tables to show:**
- **Before:** List of all summer Olympic hosts with years
- **After:** Table showing Country, Year, first_time_host, hosting_count

**Needed for:** Question 3

---

### 7. Country Size Variables ⭐

**Problem:** `country_sizes.csv` needs to be matched with other datasets

**What to clean:**
- Standardize `Country` names to NOC codes
- Create categorical variable: `country_size_category`
  - Small: < 500,000 km²
  - Medium: 500,000 - 5,000,000 km²
  - Large: > 5,000,000 km²
- Merge with Olympics data by NOC

**Tables to show:**
- **Before:** country_sizes.csv sample with inconsistent country names
- **After:** Table with NOC, Total_Area_km2, country_size_category

**Needed for:** Question 3

---

### 8. Population Age Structure Variables (New Variable Creation) ⭐

**Problem:** Raw age group data needs transformation into meaningful metrics

**What to create from `population-by-age-group.csv`:**
- Calculate `total_population` = sum of all age columns
- Calculate `working_age_population` = `Age 15-24` + `Age 25-64`
- Calculate `working_age_proportion` = working_age_population / total_population
- Calculate `youth_proportion` = (`Age 0-4` + `Age 5-14` + `Age 15-24`) / total_population
- Filter to Olympic years only
- Standardize `Entity` to NOC codes

**Tables to show:**
- **Before:** Raw population by age group (5 columns, sample 5 countries)
- **After:** Derived variables showing total_population, working_age_proportion, youth_proportion

**Needed for:** Question 4

---

### 9. Baseline Performance Calculation ⭐

**Problem:** To measure "home advantage," need to compare hosting year performance to historical baseline

**What to create:**
- For each country, calculate average gymnastics medals won in non-hosting years
- Create `historical_avg_medals`: Mean medal count when NOT hosting
- Create `historical_avg_gold`: Mean gold medal count when NOT hosting
- Calculate this separately for men's and women's gymnastics (for Question 2)

**Tables to show:**
- **Before:** Raw medal counts by country by year
- **After:** Country-level summary showing historical_avg_medals, hosting year medals, difference

**Needed for:** Questions 1, 2

---

### 10. Sex Variable Validation ⭐

**Problem:** Need to verify Sex variable is clean for gender analysis

**What to check:**
- Ensure only "M" and "F" values exist
- Check for missing values
- Check if any records have inconsistent coding

**Tables to show:**
- **Before:** Frequency table of Sex variable (including any anomalies)
- **After:** Confirmation that only M/F exist with counts

**Needed for:** Question 2

---

### 11. Gymnast Participation Count ⭐

**Problem:** Need to count number of gymnasts each country sends

**What to create:**
- Count unique athletes per country per Olympics for gymnastics
- Create `gymnast_count`: Number of gymnasts sent by each country each year
- Compare host vs non-host countries

**Tables to show:**
- **Before:** Raw athlete-level data
- **After:** Country-year level summary showing gymnast_count

**Needed for:** Question 3

---

### 12. Population Size Variables ⭐

**Problem:** Need total population for per-capita analyses and population-based comparisons

**What to create from `population-by-age-group.csv`:**
- Calculate `total_population` = sum of all age group columns
- Match to Olympic years
- Standardize country names to NOC codes
- Merge with main dataset

**Tables to show:**
- **Before:** Age group columns
- **After:** NOC, Year, total_population

**Needed for:** Questions 3, 4

---

## Recommended Strategy

### Strategy: Do ALL the cleaning now, but only document 3-5 for Nov 4th

**For the Nov 4th Assignment - Document these 3:**
1. **Country Name Standardization** (biggest, most important)
2. **Medal Outcome Variables** (straightforward, core to analysis)
3. **GDP Reshaping + Per Capita** (complex, impressive - counts as 1 "variable creation")

**OR if you want to impress with 5:**
1. Country Name Standardization
2. Medal Outcome Variables
3. Host Country Indicator
4. Gymnastics Sport Collapse
5. GDP Reshaping + Per Capita

**But actually clean everything** so you're ready for the full project!

---

## The Bottom Line

You'll need to clean **way more than 3 variables** to actually answer your questions. The assignment is just asking you to **document 3-5 of them thoroughly** with before/after tables.

**Recommended approach:**
- Clean everything (all ~13 variables/transformations)
- For Nov 4th, pick the 3-5 most interesting/complex ones to write up
- You'll already have all the data ready for your full analysis

---

## Assignment Deliverable Format

For each cleaned variable documented in the Nov 4th assignment, your PDF should include:

1. **Written summary** (2-3 paragraphs):
   - What was the problem?
   - What cleaning steps did you take?
   - Why was this necessary?

2. **Before table**: Show the variable(s) BEFORE cleaning
   - Example: First 10-15 rows showing messy data

3. **After table**: Show the variable(s) AFTER cleaning
   - Example: Same rows showing cleaned data
   - Include frequency/summary statistics

---

## Data Sources

1. `Athletes_summer_games.csv` - Main Olympics athlete data (237,674 rows)
2. `olympic_hosts.csv` - Olympic host cities and countries (64 rows)
3. `country_sizes.csv` - Country area data (235 rows)
4. `population-by-age-group.csv` - Population by age groups (18,944 rows)
5. `gdp.csv` - GDP data in wide format (271 rows)
