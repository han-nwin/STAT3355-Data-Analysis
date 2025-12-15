
# Final Exam

## STAT 3355 - Data Analysis for Statisticians & Actuaries

This is an individual assignment; collaboration is not allowed. You are allowed to consult all other resources, but copying text over to AI assistance programs is strictly forbidden. You may collaborate with emerging technology but it is not allowed to do it for you.

The deadline for submission is **December 16th 11:59pm CT** on eLearning. Submissions should be planned to be submitted well before the deadline as late submissions due to technical difficulties will incur a penalty.

Submit a **single PDF file** with clear question labels and answers. You do not have to rewrite every question onto your RMarkdown file; just label the blocks *Questions 1.1* etc. Corresponding code should be shown on your pdf. Code submission is mandatory unless calculations are included in your pdf. Present all calculations in your code with comments.

Direct any questions only to the professor, not your peers, nor the TA. Maintain exam integrity. Your assessment will consider correctness, clarity, and adherence to instructions. Violations may result in disciplinary action.

If you cannot get your RMarkdown pdf to compile, you are allowed to submit your code for a **10% penalty**.

---

## The 7 Steps of Hypothesis Testing

1. Specify model for the data
2. State Null and Alternative Hypothesis
3. Specify Test Statistic
4. State alpha level
5. Create test statistic
6. Compute p-value
7. Interpret Results

**Good luck with your Exam!**

---

# Problem 1

Poisson distribution is a discrete probability distribution that expresses the probability of a given number of events occurring in a fixed interval of time if these events occur with a known constant rate and independently of the time since the last event.

[
p_X(x) = \frac{e^{-\lambda} \lambda^x}{x!}
]

---

## Question 1.1 (5 points)

Suppose ( X ) has a Poisson distribution with an expected value of **8.9**.

What is the probability its value is at least as big as 7 but not bigger than 9?

That is:

[
P(7 \le X \le 9)
]

---

## Question 1.2 (5 points)

Suppose we recorded **35 daily deaths** caused by COVID-19 in the past seven days, and obtained the numbers:

```
8, 12, 6, 12, 8, 8, 12, 5, 9, 10, 6, 8, 6, 16, 7, 13, 5, 10,
5, 7, 9, 7, 8, 8, 9, 10, 8, 9, 9, 8, 8, 6, 10, 9, 17
```

If we assume this sample is independent and identically distributed, then what is the **95% confidence interval of the mean**?

Do **not** use any built-in functions for confidence intervals.

---

## Question 1.3 (10 points)

Assume we know the data from Question 1.2 follows a Poisson distribution, but we believe:

[
\lambda = 8.1
]

Write **1-2 sentences** explaining why we can use the **Z-test** here, then at the **0.05 significance level** perform the Z test with the alternative being that:

[
\lambda > 8.1
]

Detail **all 7 steps of hypothesis testing**, and recall:

* The test statistic must be built under the null
* The mean and standard deviation of the Poisson distribution are the same

Do **not** use any built-in functions that automatically do it for you.

---

# Problem 2

The following table lists the numbers of emails received by a student and an instructor from Sunday to Saturday in the past week.

The data follow a Poisson distribution. However, the Poisson distribution can be approximated by a normal distribution when ( \lambda \ge 5 ).

That is, if:

[
X \sim \text{Poi}(\lambda)
]

and ( \lambda \ge 5 ), then under this approximation:

[
X \sim N(\mu = \lambda, \sigma^2 = \lambda)
]

Conduct all tests at the **à = 0.05** significance level.

|            | Sun | Mon | Tue | Wed | Thu | Fri | Sat | Total |
| ---------- | --- | --- | --- | --- | --- | --- | --- | ----- |
| Student    | 9   | 19  | 12  | 18  | 11  | 15  | 10  | 74    |
| Instructor | 20  | 17  | 23  | 14  | 23  | 20  | 20  | 137   |

---

## Question 2.1 (5 points)

Assuming the number of emails received is independent of whether it is a student or a professor, and the row and column totals are fixed, calculate the matrix of the expected number of emails for students and professors for each day of the week by:

[
\text{Expected Count} = \frac{(\text{Row Total}) (\text{Column Total})}{\text{Grand Total}}
]

The results should be printed in a matrix with the proper row and column names.

---

## Question 2.2 (10 points)

Using a **chi-squared test of independence**, do we have enough evidence to conclude the number of emails received is independent of whether it's a professor or a student?

Detail your **7 steps of hypothesis testing**.

Do **not** use any built-in functions that automatically do it for you.

---

# Problem 3

Fitting a simple linear regression model on a data set reporting the divorce rate in the United States between 1920 and 1996, we obtained the following output in R.

* **divorce**: number of divorces per 1,000 women aged 15+
* **femlab**: percent female participation in labor force aged 15+

```
Call:
lm(formula = divorce ~ femlab, data = data)

Residuals:
     Min       1Q   Median       3Q      Max
-3.7264  -1.6385   0.1595   1.2211   8.0442

Coefficients:
               Estimate Std. Error t value Pr(>|t|)
(Intercept)   -3.65527   0.92798   -3.939  0.000182 ***
femlab         0.43867   0.02302   19.056   < 2e-16 ***

Signif. codes:
0 `***' 0.001 `**' 0.01 `*' 0.05 `.' 0.1 ` ' 1

Residual standard error: 2.361 on 75 degrees of freedom
Multiple R-squared:  0.8288,   Adjusted R-squared:  0.8265
F-statistic: 363.1 on 1 and 75 DF,  p-value: < 2.2e-16
```
---

## Question 3.1 (5 points)

What are the null hypotheses corresponding to the **t-statistics** (i.e. t-value shown in the output)?

---

## Question 3.2 (5 points)

Based on the output, interpret the result in terms of **slope**.

Based on the **p-values** (i.e. Pr(>|t|) shown in the output), would you conclude that the univariate relationship between female labor market participation and the divorce rate is statistically significant at:

[
\alpha = 0.01
]

---

## Question 3.3 (10 points)

A newspaper reported that if the percent of female participation in labor force increases **5%**, then we would see **over 2 more divorces per 1,000 women** in a year on average.

Perform a significance test to test the related hypothesis.

* Show your work **step-by-step**
* Choose a significance level of **0.01**
* Do **not** use any built-in functions for hypothesis testing

---

## Question 3.4 (5 points)

In your own words, explain the agreement or disagreement between Questions **3.3** and **3.2**.

---

# Question 4 (10 points)

Suppose you have access to a finite population stored as a vector `population`. You want to study the empirical coverage of a confidence interval procedure for the population mean.

Write a function that takes the following four inputs:

* `population`: a vector containing the full population values
* `à`: the significance level for a two-sided confidence interval
* `n`: the sample size to draw from the population each time
* `iterations`: the number of times to repeat the sampling process

Within the function, you will:

1. Repeatedly sample from the population `iterations` times
2. Each time, construct a ((1 - \alpha) \times 100%) confidence interval for the mean using only that sample (assume large sample size)
3. Check whether the true population mean is contained in that interval

   * Store a **1** if the interval contains the truth, and **0** otherwise
4. At the end, compute and return the proportion of intervals that contained the true mean
5. Pseudocode for you to modify is on the last page

---

## Question 4.1 (5 points)

Only call your function to run the results using the following inputs:

* `population = rgamma(10000, shape = 24, rate = 5)`
* `alpha = 0.05`
* `n = 100`
* `iterations = 10000`

Report the proportions of intervals covering the truth. Briefly explain why it did or didn't closely mirror alpha - even if you couldn't write the function.

---

## Question 4.2 (5 points)

Only call your function to run the results using the following inputs:

* `population = rpois(100000, lambda = 0.05)`
* `alpha = 0.05`
* `n = 11`
* `iterations = 10000`

Report the proportions of intervals covering the truth. Briefly explain why it did or didn't closely mirror alpha - even if you couldn't write the function.

---

# Pseudocode Guideline

```text
function ci_coverage(population, alpha, n, iterations):

# Step 1: Compute the true parameter from the full population
truth = mean(population)

# Step 2: Create a vector to store 0/1 indicators
hits = iterations

# Step 3: For each iteration, draw a sample and build a CI
for i from 1 to iterations:

    # 3a. Draw a random sample of size n from population
    sample_i = # random sample of size n from population

    # 3b. Compute the sample mean and sample standard deviation
    xbar = mean(sample_i)
    s = # standard deviation of sample_i

    # 3c. Compute the standard error of the mean
    SE = s / sqrt(n)

    # 3d. Find the critical value for a (1 - alpha) CI
    # (for large n, use the standard normal z_{1 - alpha/2})
    z_star = # quantile of standard normal at 1 - alpha/2

    # 3e. Construct the two-sided confidence interval
    lower = xbar - z_star * SE
    upper = xbar + z_star * SE

    # 3f. Check if the true mean is inside the interval
    if (truth >= lower) and (truth <= upper):
        hits[i] = 1
    else:
        hits[i] = 0

# Step 4: After the loop, compute the empirical coverage
coverage = mean(hits)

# Step 5: Return the coverage proportion
return coverage
```

---
