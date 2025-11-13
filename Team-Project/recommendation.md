# Statistical Test Recommendations

## Overview
This document provides guidance on which statistical tests are appropriate for each research question in the Olympics gymnastics home advantage analysis.

---

## Should Some Questions Use Chi-Square Test?

**Yes, potentially!** Several questions involve comparing categorical outcomes (medal won: yes/no) across groups, which makes chi-square tests appropriate.

### **Question 1, Sub-question 1** (Medal Rates: Host vs Non-Host)
**Current approach:** Two-proportion z-test (`prop.test`)

**Chi-square alternative:** You could also use chi-square test here because:
- You're comparing **categorical outcomes** (medal won: yes/no) across **two groups** (host vs non-host)
- A 2×2 contingency table would work:

```
                Medal Won    No Medal
Host            count1       count2
Non-Host        count3       count4
```

**Note:** `prop.test()` in R actually performs a chi-square test under the hood! The X-squared statistic you see is a chi-square value.

**Implementation:**
```r
# Chi-square test for Q1
contingency_table <- table(q1_data$is_host, q1_data$medal_won)
chisq.test(contingency_table)
```

---

## When to Use Each Test

### **Chi-Square Test (χ²)**

**Use when:** Comparing **categorical variables** across groups

**Your data scenarios:**
- ✅ **Medal won (yes/no) vs Hosting status (host/non-host)** - Question 1
- ✅ **Medal won vs Gender AND Hosting status** - Could restructure Question 2 as a 2×2×2 table
- ✅ **Medal won vs Country size category (Small/Medium/Large)** - Question 3

**Requirements:**
- Both variables are categorical
- Independent observations
- Expected frequency ≥ 5 in each cell

**Example for your data:**
```r
# Chi-square test for Q1
contingency_table <- table(q1_data$is_host, q1_data$medal_won)
chisq.test(contingency_table)

# Chi-square for Q2 (Gender × Hosting)
chisq.test(table(q2_data$Sex, q2_data$is_host, q2_data$medal_won))

# Chi-square for Q3 (Country size)
size_table <- q3_hosting %>%
  mutate(got_medal = medal_rate > baseline) %>%
  select(country_size_category, got_medal)
chisq.test(table(size_table))
```

---

### **Z-Test (Two-Proportion)**

**Use when:** Comparing **proportions** between two groups

**Your current usage:**
- ✅ **Question 1** (Presentation.Rmd lines 161-166): Comparing medal rates (proportions) between host vs non-host
- This is essentially the **same as chi-square for 2×2 tables**

**When z-test is preferred:**
- When you want confidence intervals for difference in proportions
- When framing as "proportion comparison" is more intuitive
- Large sample sizes (n > 30)

**Advantages over chi-square:**
- Provides confidence interval for the difference in proportions
- More interpretable output for comparing two groups
- Direct hypothesis test about difference

---

### **T-Test**

**Use when:** Comparing **continuous numeric means** between groups

**Your current usage:**
- ✅ **Question 1, Sub-question 2** (lines 217-222): **Paired t-test** comparing hosting year rate vs baseline rate for same countries
- ✅ **Question 2** (lines 356-362): Comparing medal rates (treated as continuous) by gender
- ✅ **Question 3** (lines 575-586, 622-634): Comparing improvements and participation counts

**Types:**
- **Paired t-test**: Same subjects measured twice (e.g., before/after hosting)
- **Independent t-test**: Different groups (e.g., males vs females)

**Note:** You're treating medal_won (0/1) as a continuous variable when using t-test on means. This works because the **mean of binary variable = proportion**, but it's less precise than proportion tests for binary outcomes.

**When appropriate:**
- Comparing means of truly continuous variables (e.g., gymnast count, improvement rates)
- Paired comparisons (before/after, baseline/hosting)
- Sample sizes are reasonably large (Central Limit Theorem applies)

---

### **Correlation Tests**

**Use when:** Examining relationship between **two continuous variables**

**Your current usage:**
- ✅ **Question 4**: GDP per capita vs improvement (lines 698-711)
- ✅ **Question 4**: Working-age population vs improvement (lines 746-759)

**Types:**
- **Pearson correlation**: Linear relationship, both variables continuous and normally distributed
- **Spearman correlation**: Non-parametric alternative, works with ranked data

---

## Recommendations for Your Analysis

### **Questions that SHOULD use Chi-Square:**

#### 1. **Question 1, Sub-question 1** (Current: prop.test ✓)
Already using prop.test (which is chi-square). Could explicitly show chi-square table for clarity:

```r
# Show contingency table
table(q1_data$is_host, q1_data$medal_won)

# Chi-square test (equivalent to prop.test for 2×2)
chisq.test(table(q1_data$is_host, q1_data$medal_won))
```

**Recommendation:** Keep current approach (prop.test), but consider adding chi-square table display for visual clarity.

---

#### 2. **Question 2: Gender Differences** (Current: t-test)
Currently using t-test, but **chi-square would be more appropriate** for comparing medal win rates:

```r
# Chi-square test: Gender × Hosting Status × Medal Won
# Test if gender and hosting interact differently
male_table <- table(q2_data$is_host[q2_data$Sex == "M"],
                    q2_data$medal_won[q2_data$Sex == "M"])
female_table <- table(q2_data$is_host[q2_data$Sex == "F"],
                      q2_data$medal_won[q2_data$Sex == "F"])

chisq.test(male_table)
chisq.test(female_table)
```

**Recommendation:** Replace t-tests with chi-square tests for comparing medal rates by gender and hosting status. This is more statistically rigorous for binary outcomes.

---

#### 3. **Question 3, Sub-question 1: Country Size** (Current: descriptive only)
Currently only shows descriptive statistics. Should add chi-square test:

```r
# Create binary outcome: improved vs not improved
q3_hosting_binary <- q3_hosting %>%
  mutate(improved = improvement > 0)

# Chi-square test: Country size vs Improvement
chisq.test(table(q3_hosting_binary$country_size_category,
                 q3_hosting_binary$improved))
```

**Recommendation:** Add chi-square test to determine if country size significantly affects likelihood of improvement.

---

### **Questions Using Correct Tests:**

#### ✅ **Question 1, Sub-question 2: Paired t-test** (lines 217-222)
**Correct!** Paired t-test is appropriate for comparing:
- Same countries measured twice (baseline vs hosting year)
- Continuous outcome (medal rate as proportion)

#### ✅ **Question 3, Sub-question 2: Independent t-test** (lines 575-586)
**Correct!** Independent t-test for comparing:
- First-time vs repeat hosts (different groups)
- Continuous outcome (improvement rate)

#### ✅ **Question 3, Sub-question 3: Independent t-test** (lines 622-634)
**Correct!** Independent t-test for comparing:
- Host vs non-host (different groups)
- Continuous outcome (gymnast count)

#### ✅ **Question 4: Correlation tests** (lines 698-711, 746-759)
**Correct!** Pearson correlation for:
- GDP per capita (continuous) vs improvement (continuous)
- Working-age population (continuous) vs improvement (continuous)

---

## Quick Reference Table

| Test | Variables | Example from Your Project | When to Use |
|------|-----------|---------------------------|-------------|
| **Chi-Square** | Categorical vs Categorical | Medal won (Y/N) vs Hosting status (Host/Non-host) | Comparing frequencies/proportions across categories |
| **Z-test (proportions)** | Proportion in Group 1 vs Group 2 | % medal rate for hosts vs non-hosts | Comparing two proportions with large samples |
| **T-test (independent)** | Continuous mean in Group 1 vs Group 2 | Average medal rate for males vs females | Comparing means between two independent groups |
| **T-test (paired)** | Before/after for same subjects | Country's hosting year rate vs their baseline | Comparing means for same subjects measured twice |
| **Correlation** | Two continuous variables | GDP per capita vs improvement | Examining linear relationship strength |

---

## Summary of Changes Needed

### ✅ **Already Correct:**
- Question 1, Sub-question 2: Paired t-test
- Question 3, Sub-questions 2 & 3: Independent t-tests
- Question 4: Correlation tests

### ⚠️ **Consider Changing:**

1. **Question 2 (Gender analysis):**
   - **Current:** Independent t-tests
   - **Better:** Chi-square tests for categorical medal outcomes
   - **Why:** Medal won is binary categorical, not continuous

2. **Question 3, Sub-question 1 (Country size):**
   - **Current:** Descriptive statistics only
   - **Add:** Chi-square test to determine statistical significance
   - **Why:** Need formal test to determine if size categories differ significantly

### 💡 **Optional Enhancement:**

1. **Question 1, Sub-question 1:**
   - Keep prop.test (it's already chi-square)
   - Add contingency table display for clarity
   - Both approaches are statistically equivalent

---

## Key Insight

**Your current tests are mostly appropriate**, but you could strengthen the analysis by:

1. **Using chi-square for Question 2** instead of t-tests when comparing categorical medal outcomes across groups
2. **Adding chi-square test for Question 3, Sub-question 1** to formally test country size effects
3. The t-tests work because you're treating proportions as continuous means, but **chi-square is more statistically rigorous for binary categorical data**

---

## Additional Considerations

### Sample Size Requirements

- **Chi-square:** Expected frequency ≥ 5 in each cell
- **T-test:** Generally n ≥ 30 per group for Central Limit Theorem
- **Z-test:** Large sample approximation, typically n ≥ 30

### Effect Size Measures

Consider adding effect size measures:
- **Chi-square:** Cramér's V or odds ratio
- **T-test:** Cohen's d
- **Correlation:** Already provides effect size (r)

### Multiple Comparison Adjustments

If performing multiple statistical tests, consider:
- Bonferroni correction
- False Discovery Rate (FDR) adjustment
- Adjusting α level (e.g., 0.05 / number of tests)

---

## References

- Agresti, A. (2018). *Statistical Methods for the Social Sciences* (5th ed.). Pearson.
- Field, A., Miles, J., & Field, Z. (2012). *Discovering Statistics Using R*. Sage Publications.
- McHugh, M. L. (2013). The chi-square test of independence. *Biochemia Medica*, 23(2), 143-149.
