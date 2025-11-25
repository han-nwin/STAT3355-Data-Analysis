# **Homework 8**

*STAT 3355 - Introduction to Data Analysis*


---

## **Problem 1**

Simulate a sample of ( y_1, \ldots, y_{100} ) from the simple linear model

[
Y = 1 + 2x + \varepsilon,
]

where

* ( \varepsilon \sim N(0, 6^2) ),
* ( x ) is an arithmetic sequence from 1 to 100 (step size 1),
* Use `set.seed(1)` so the simulation is reproducible.

### **Tasks**

* Make a **scatter plot** and **fit the data** with a **regression line**.
* Perform a **two-sided significance test** for
  [
  H_0: \beta_1 = 2 \quad \text{vs.} \quad H_a : \beta_1 \neq 2
  ]
  following the **7-step procedure** from lecture.
  Use significance level **à = 0.05**.

---

## **Problem 2**

The cost of a home is related to how many bedrooms it has.
The dataset below contains information for homes in Dallas:

| Price (USD) | 300,000 | 250,000 | 400,000 | 550,000 | 317,000 | 389,000 | 425,000 | 289,000 | 389,000 |
| ----------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- | ------- |
| Bedrooms    | 3       | 3       | 4       | 5       | 4       | 3       | 6       | 3       | 4       |

### **Tasks**

* Make a **scatter plot** and **fit a regression line**.
* Use the `prediction()` function to compute **confidence intervals** for the **mean price** of homes with **2 to 8 bedrooms**.

---

## **Problem 3**

The dataset **`deflection`** from the **UsingR** package contains deflection measurements for various loads.

### **Tasks**

* Make a **scatter plot** and **fit a linear regression line** modeling
  [
  \text{Deflection} = \beta_0 + \beta_1 \cdot \text{Load}
  ]
* Compute the **95% confidence intervals** for both ( \beta_0 ) and ( \beta_1 ).

---
