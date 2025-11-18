library(dplyr)
# Linear Regression Examples
n_population <- 10000
n_sample <- 50
n
error <- 2.4
covariates <- data.frame(x_1 = runif(n_population, -2, 8),
                         x_2 = rnorm(n_population, 12, 2),
                         x_3 = rgamma(n_population, 30, 2),
                         x_4 = rbinom(n_population, 1, 0.45))

population <- covariates %>% mutate(y_1 = 2.5 + 1.3*x_1 + 2.4*x_2 + 5.7*x_3 + rnorm(n_population, 0, error),
                                    y_2 = 1.8 + 0.02*x_1 + 2.4*x_2 + 0.01*x_3 + rnorm(n_population, 0, error),
                                    y_3 = 2.5 + 1.3*x_1 + 2.4*x_2 + 5.7*x_2^2 + rnorm(n_population, 0, error),
                                    y_4 = 2.5 + 1.3*x_1 + 3.9*x_4 + rnorm(n_population, 0, error))


sample <- population[sample(1:dim(population)[1], n_sample), ]


plot(sample$y_1, sample$x_3)
m0 <- lm(sample$y_1~sample$x_3)
coef <- summary(m0)$coefficients

NV <- 5.7
T_stat <- (5.5266 - NV)/0.3218
2*(1 - pt(abs(T_stat), df = n_sample - 2))

plot(sample$x_3, sample$y_1)
abline(a = coef[1,1], b = coef[2, 1],col = "red", lwd = 3)


plot(population$x_3, population$y_1)
abline(a = coef[1,1], b = coef[2, 1],col = "red", lwd = 3)
abline(a = 2.5, b = 5.7,col = "blue", lwd = 3)

# Using the sample, for each Problem do a hypothesis test for:
  # B_1 = 1.3
  # B_2 = 2.4
  # B_3 = 5.7
  # B_4 = 3.9
# as well as experiment with hypothesis tests for different numbers besides the one listed, and seeing
# how changing the error and sample size impact your results. 


# Fit a linear regression model for y_1 against
  # 1. x_1, 2. x_1, x_2, x_3

# Fit a linear regression model for y_2 against
# 1. x_1, 2. x_1, x_2, x_3

# Fit a linear regression model for y_3 against
# 1. x_1, x_2 2. x_1, (x_2)^2 3. x_1, x_2, (x_2)^2

# Fit a linear regression model for y_4 against
# 1. x_1, x_2 2. x_1, x_4


# Choose at least one regression to overlay the curve fit onto the scatter plot data


