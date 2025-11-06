library(ggplot2)

# Significance Tests for a Proportion
# Example: In the year 2010, the poverty rate in the United
# States was around 15%. In 2011, the rate was measured at
# 15.13% with a sample size of 150,000, as reported by the
# United States Census Bureau. Does the poverty rate increase
# during 2010 and 2011?

# Given data
p0 <- 0.15          # Proportion in 2010
p_hat <- 0.1513     # Proportion in 2011
n <- 150000         # Sample size in 2011

# Null hypothesis: p = 0.15 (poverty rate did not increase)
# Alternative hypothesis: p > 0.15 (poverty rate increased)

# Calculate the test statistic (z)
z <- (p_hat - p0) / sqrt(p0 * (1 - p0) / n)
cat("Test statistic (z):", z, "\n")

# Calculate the p-value for one-sided test
p_value <- 1 - pnorm(z)
cat("P-value:", p_value, "\n")

# Prepare data for ggplot
x <- seq(-4, 4, length=1000)
y <- dnorm(x)
df <- data.frame(x = x, y = y)

# Critical value for 0.05 significance level
z_critical <- qnorm(0.95)

# Plot using ggplot2
ggplot(df, aes(x = x, y = y)) +
  geom_line(size = 1) +
  geom_ribbon(data = subset(df, x >= z_critical), aes(ymax = y), ymin = 0, fill = "red", alpha = 0.5) +
  geom_vline(xintercept = z_critical, linetype = "dashed", color = "red") +
  geom_point(aes(x = z, y = dnorm(z)), color = "blue", size = 3) +
  geom_text(aes(x = z, y = dnorm(z), label = paste0("z = ", round(z, 3))), hjust = -0.1, color = "blue") +
  labs(title = "Z-test for Proportion",
       x = "Z value",
       y = "Density") +
  theme_minimal()

# Conclusion at significance level alpha = 0.05
if (p_value < 0.05) {
  cat("Reject the null hypothesis: There is evidence that the poverty rate increased from 2010 to 2011.\n")
} else {
  cat("Fail to reject the null hypothesis: There is not enough evidence to conclude the poverty rate increased.\n")
}

