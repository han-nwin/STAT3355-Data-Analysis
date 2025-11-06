library(dplyr)
library(ggplot2)
#Monte Carlo Simulation in R
# Creating the population
population <- rexp(10000000, rate = 0.10)
# Identifying the truth
truth <- mean(population)
# Initializing parameters
test <- NULL
n <- 50
a <- 0.05
#Dr. Octavious Smiley CI 27

#Monte Carlo Simulation in R
# Monte Carlo Simulations
for(i in 1:1000){
  # Taking random sample
  monte_sample <- sample(population, size = n)
  # Finding mean
  x_bar <- mean(monte_sample)
  # Calculating the standard error
  s.e <- sd(monte_sample)/sqrt(n)
  # Calculating the quantile
  z_a <- qnorm(1 - a/2)
  # Creating confidence interval
  confidence_interval <- c(x_bar - s.e*z_a, x_bar + s.e*z_a)
  # Checking if confidence interval has the truth
  if(between(truth, confidence_interval[1], confidence_interval[2])){
    test[i] <- 1
  } else {
    test[i] <- 0
  }
}
# Determining what proportion of intervals contain the truth
# Should be 1 - alpha
mean(test)
#Dr. Octavious Smiley CI 28

# Population proportion
omega_0 <- 0.15
n <- 150000
omega_hat <- 0.1513
z <- (omega_hat - omega_0)/sqrt(omega_0*(1 - omega_0)/n)

x <- seq(-5, 5, length.out = 1000)
pdf <- dnorm(x, mean = 0, sd = 1)
theoretical <- data.frame(x = x, pdf = pdf)
ggplot() + geom_polygon(data = theoretical, mapping = aes(x = x, y = pdf), alpha = 0.5, color = "grey", fill = "grey") + labs(x = "z-statistic", y = "Probability density") + geom_vline(xintercept = z) 
ggplot() + geom_polygon(data = theoretical, mapping = aes(x = x, y = pdf), alpha = 0.5, color = "grey", fill = "grey") + geom_area(data = subset(theoretical, x >= abs(z)), mapping = aes(x = x, y = pdf), alpha = 0.5, color = "orange", fill = "orange") + labs(x = "z-statistic", y = "Probability density") + geom_vline(xintercept = z)

1 - pnorm(omega_hat, mean = omega_0, sd = sqrt(omega_0*(1 - omega_0)/150000))
1 - pnorm(z, mean = 0, sd = 1)

prop.test(x = 22695, n = n, p = omega_0, alternative = "greater")
binom.test(x = 22695, n = n, p = omega_0, alternative = "greater")


