# Team 5 - Olympics Gymnastics Project TODO

**Project:** Does hosting the Olympics provide home advantage in gymnastics?
**Data Cleaning Due:** November 4, 2025

---

## ✅ COMPLETED

### Variable 1: Country Name Standardization & Size Categories

- ✅ Created `noc_mapping.csv` - Master NOC lookup table (230+ countries)
- ✅ Created `scripts/01_clean_countries.R` - NOC mapping creation
- ✅ Created `scripts/05_clean_country_info_v2.R` - Country size cleaning (~197 countries)
- ✅ Generated `cleaned_data/country_info.csv` with:
  - NOC codes
  - Total area & land area
  - Size categories (Small/Medium/Large)
- ✅ Created `reports/data_cleaning_report.Rmd` - Report template
- ✅ Documented Variable 1 in report with BEFORE/AFTER tables

**Status:** Ready for Nov 4th assignment ✓

---

## ✅ COMPLETED

### Variable 1: Country Name Standardization & Size Categories
- ✅ Created and documented in report
- ✅ Files: `noc_mapping.csv`, `country_info.csv`
- ✅ Script: `scripts/05_clean_country_info_v2.R`

### Variable 2: Medal Outcome Variables
- ✅ Created `scripts/02_clean_athletes.R`
- ✅ Generated `cleaned_data/athletes_cleaned.csv`
- ✅ Documented in report with BEFORE/AFTER tables
- ✅ Created variables: medal_won, gold_medal, medal_points
- ✅ Filtered to gymnastics only (~23k records)

---

## 🔄 IN PROGRESS - Variable 3 for Nov 4th

### Variable 3: GDP Reshaping & Per Capita Calculation (CHOSEN)

**Why this variable:**
- Supports Question 4 (economic prosperity effect on home advantage)
- Most impressive transformation (wide → long format)
- Shows data reshaping skills
- Creates derived variable (GDP per capita)

**What needs to be done:**
- [ ] Create `scripts/04_clean_gdp.R`
  - Skip first 4 metadata rows
  - Reshape from wide to long format (65+ year columns → rows)
  - Add NOC codes using noc_mapping
  - Filter to Olympic years only (1896-2020, summer games)
  - Merge with population data
  - Calculate GDP per capita = GDP / total_population
  - Output: `cleaned_data/gdp_long.csv`
- [ ] Document in report:
  - BEFORE: Show wide format sample (years as columns) - looks messy
  - AFTER: Show long format with Year, NOC, GDP, Population, GDP_per_capita
  - Show GDP trends plot for select host countries
  - Show GDP per capita comparison table

**Status:** Planning complete, ready to code

---

## 📋 TODO - Additional Scripts (Not for Nov 4th report, but needed later)

### Other Variables (For Full Project Analysis)

#### Variable: Olympic Host Indicator
- [ ] Run `scripts/03_clean_hosts.R` (already created, just run it)
- [ ] Generate `cleaned_data/hosts_cleaned.csv`
- [ ] Not documenting in Nov 4th report (only doing 3 variables)
- [ ] But needed for Questions 1, 2, 3 analysis later

---

## 📋 TODO - Additional Variables (Not for Nov 4th, but needed for full project)

### Variable 4: Population & Demographics
- [ ] Create `scripts/05_clean_population.R`
  - Add NOC codes
  - Calculate total_population (sum of age groups)
  - Calculate working_age_proportion
  - Calculate youth_proportion
  - Filter to Olympic years
  - Output: `cleaned_data/population_clean.csv`

### Variable 5: Hosting History
- [ ] Already in `hosts_cleaned.csv` from Variable 3
- [ ] Variables: `first_time_host`, `hosting_count_prior`, `hosting_count_total`

### Variable 6: Gymnastics Sport Category Collapse
- [ ] Already handled in athletes_cleaned.R (Variable 2)
- [ ] Collapse: "Gymnastics", "Artistic Gymnastics", "Rhythmic Gymnastics", "Trampoline Gymnastics" → all to "Gymnastics"

### Variable 7: Baseline Performance Calculation
- [ ] Create script to calculate each country's historical average medals (non-hosting years)
- [ ] Needed for Question 1 analysis

---

## 📋 TODO - Analysis Data (Merge Scripts)

### After cleaning is done, create merged datasets for each question:

- [ ] `scripts/06_merge_for_q1.R` → `analysis_data/q1_home_advantage.csv`
  - Merge: athletes_cleaned + hosts_cleaned
  - Filter: gymnastics only
  - Add: is_host indicator

- [ ] `scripts/07_merge_for_q2.R` → `analysis_data/q2_gender.csv`
  - Same as Q1 but ensure Sex variable clean

- [ ] `scripts/08_merge_for_q3.R` → `analysis_data/q3_country_factors.csv`
  - Merge: athletes_cleaned + hosts_cleaned + country_info + population

- [ ] `scripts/09_merge_for_q4.R` → `analysis_data/q4_gdp_demographics.csv`
  - Merge: All datasets (athletes + hosts + country_info + gdp + population)

---

## 📋 TODO - Nov 4th Assignment Deliverable

### PDF Requirements:
For each of 3+ variables, include:

1. **BEFORE table/plot** - Show messy data
2. **Written explanation** (2-3 paragraphs):
   - What was cleaned?
   - Why was it cleaned?
   - What was expected outcome?
3. **AFTER table/plot** - Show cleaned data with summary stats

### Current Status:
- ✅ Variable 1: Country standardization & size (COMPLETE in Rmd)
- ⏳ Variable 2: Medal outcome variables (TODO)
- ⏳ Variable 3: Host indicator OR GDP reshaping (TODO)

### To Submit:
- [ ] Knit Rmd to PDF
- [ ] Review PDF for errors
- [ ] Submit to eLearning (one person from team)

---

## 🎯 RECOMMENDED NEXT STEPS

**For completing Nov 4th assignment:**

1. **Do Variable 2 (Medal Outcome)** - athletes_cleaned.csv
   - Most important for your analysis
   - Straightforward cleaning
   - Good before/after tables

2. **Choose Variable 3:**
   - **Option A:** Host indicator (quick, already have script)
   - **Option B:** GDP reshaping (more impressive, more work)

3. **Knit report and submit**

---

## 📊 Research Questions Summary

**Need these variables for:**

- **Q1: Home advantage overall**
  - Athletes data (gymnastics, medals)
  - Host indicator
  - Baseline performance

- **Q2: Gender differences**
  - Same as Q1 + Sex variable validation

- **Q3: Country size & hosting experience**
  - Q1 variables + country_info + population + hosting history

- **Q4: GDP & demographics**
  - Q3 variables + GDP + age structure

---

## 📁 File Structure Status

```
✅ raw_data/              - All original CSVs
✅ cleaned_data/          - Partially complete
   ✅ noc_mapping.csv
   ✅ country_info.csv
   ⏳ hosts_cleaned.csv   (script ready, not run)
   ❌ athletes_cleaned.csv
   ❌ gdp_long.csv
   ❌ population_clean.csv
✅ analysis_data/         - Empty (for later)
✅ scripts/               - Partially complete
   ✅ 01_clean_countries.R
   ⏳ 02_clean_athletes.R  (TODO)
   ✅ 03_clean_hosts.R
   ⏳ 04_clean_gdp.R       (TODO)
   ⏳ 05_clean_population.R (TODO)
   ✅ 05_clean_country_info_v2.R
   ❌ 06-09 merge scripts (for later)
✅ reports/
   ✅ data_cleaning_report.Rmd (Variable 1 done)
   ⏳ data_cleaning_report.pdf (TODO: knit)
✅ logs.md               - Planning document
✅ TODO.md               - This file
```

---

**Last Updated:** 2025-10-29
