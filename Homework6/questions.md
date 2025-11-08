# Homework 6
## STAT 3355 Introduction to Data Analysis

---

## Question 1

A cola beverage company claims that their cans are filled with 16.00 ounces of cola. The company also states that the fill of the cola cans follows a Gamma distribution with a shape parameter of 256000 and a rate parameter of 16000. Mark doesn't want to pay for 16.01 ounces of soda unless he is getting at least that much soda. Thus, he samples 34 cola cans from this beverage company to test their claim.

**What is the probability that the average fill of the sampled soda cans is greater than 16.01 ounces?**

---

## Question 2

The number of minutes for app engagement by a tablet user follows a normal distribution with μ = 8.2 minutes, and σ = 1 minute. Suppose, we take a sample of 60 tablet users.

**(a)** What are the mean and standard deviation of the sampling distribution of the sample mean?

**(b)** Find the 90th percentile for the sample mean time for app engagement for a tablet user. Interpret this value in a complete sentence.

**(c)** Find the probabilities that the sample mean is between ±1 standard deviation, ±2 standard deviations, and ±3 standard deviations.

**(d)** Is there a different way to do part (c) that involves not using R, and not using any form of calculations?

---

## Question 3

A study involving stress is done on a college campus among the students. The stress scores, ranging from 0 to 5, follow a binomial distribution with N = 5 and p = 0.5. Using a sample of 75 students, find:

**(a)** The probability that the average stress score for the 75 students is less than 2.25.

**(b)** The 90th percentile for the average stress score for the 75 students.

**(c)** The probability that the total of the 75 stress scores is less than 200.

**(d)** The 90th percentile for the total stress score for the 75 students.

---

## Question 4

Suppose that a market research analyst for a cell phone company conducts a study of their customers who exceed the data allowance included on their basic cell phone contract; the analyst finds that for those people who exceed the data included in their basic contract, the excess data used follows an exponential distribution with a mean of 2 Gigabytes (Gb). Consider a random sample of 80 customers who exceed the data allowance included in their basic cell phone contract.

**(a)** Suppose that one customer who exceeds the data limit for his cell phone contract is randomly selected. Find the probability that this individual customer's excess data use is larger than 2.5 Gb.

**(b)** Find the probability that the average excess data used by the 80 customers in the sample is larger than 2.5 Gb.

**(c)** Explain why the probabilities in (a) and (b) are different.

---

## Question 5

There were 70 enrolled students in STAT 3355 during the year 2020. The population of adults, 18 years or older, in the United States was 258.3 million in 2020. A student surveyed 30 of her classmates in 2020 and found that 22 students liked to play video games.

**If this student computed a 95% confidence interval, would it have contained the value of 65%, which was known to be the proportion of adults that liked to play video games in the United States in 2020?**

*(Hint: Calculate the confidence interval by hand at first, and then try to use R).*

---

## Problem 6

An elevator can safely hold 3,500 lbs. A sign in the elevator limits the passenger count to 15. If the adult population has a mean weight of 180 lbs with a 25 lbs standard deviation, how unusual would it be, if the central limit theorem applied, that an elevator holding 15 people would be carrying more than 3,500 pounds?

*(Hint: if X is a random variable indicating a person's weight, then assume X ~ Normal(μ = 180, σ² = 25²); use related d, p, q, and r functions to get the numerical answer.)*

---

## Problem 7

A restaurant sells an average of 25 bottles of wine per night, with a variance of 25. Assuming the central limit theorem applies, what is the probability that the restaurant will sell more than 600 bottles in the next 30 days?

*(Hint: if X is a random variable indicating one day sale, then assume X ~ Poisson(λ = 25); use related d, p, q, and r functions to get the numerical answer.)*

---

## Problem 8

Currently, there are 54 enrolled students in STAT 3355. It is known that 13.1% of the population in U.S. are left-handed. A student wishes to find the proportion of left-handed people in this class. She surveys 30 students and finds that only 2 are left-handed.

**If she computes a 95% confidence interval, would it contain the value of 13.1%?**

---

## Problem 9

For the `babies` dataset in the package `UsingR`, the variable `age` contains the mother's age and the variable `dage` contains the father's age.

**Find a 95% confidence interval for the difference in mean age. Does it contain 0? What do you assume about the data?**
