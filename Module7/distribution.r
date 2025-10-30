
library(ggplot2)
library(UsingR)
library(plyr)
data("rivers")

rivers <- data.frame(length = rivers)

ggplot(data = rivers) + geom_histogram(mapping = aes(x = length))
ggplot(data = rivers) + 
  geom_histogram(mapping = aes(x = log(length))) + 
  geom_vline(xintercept = mean(log(rivers$length)), color = "red")

mu <- mean(log(rivers$length))
sigma <- sqrt(mean((log(rivers$length) - mu)^2))
x <- seq(5, 8, by = 0.01)
pdf <- dnorm(x, mean = mu, sd = sigma)
data <- data.frame(x = x, pdf = pdf)

ggplot() + 
  geom_histogram(data = log(rivers), mapping = aes(x = length, y = ..density..), bins = 12) +
  geom_line(data = data, mapping = aes(x = x, y = pdf), color = "red") 

ggplot() + 
  geom_histogram(data = rivers, aes(x = length, y = ..density..), bins = 10) +
  stat_function(fun = dlnorm, args = list(meanlog = mu, sdlog = sigma), color = "red")


n_0 <- 50
obs <- rexp(n = 100*n_0, rate = 1)
z <- rep(1:n_0, each = 100)
observed_50 <- data.frame(x = obs, z = z)
observed_50 <- observed_50 %>% 
  group_by(z) %>%
  reframe(m = mean(x), z, x) %>%
  ungroup() 

ggplot(data = subset(observed_50, z <= 20)) + 
  geom_histogram(mapping = aes(x = x, y = ..density..)) + 
  geom_line(data = theoretical, mapping = aes(x = x, y = f), color = "red") + 
  geom_vline(mapping = aes(xintercept = m), color = "blue") + 
  facet_wrap(~ z) + labs(y = "Density") 

length(unique(observed_50$m))

ggplot(data = observed_50) + 
  geom_histogram(mapping = aes(x = m, y=..density..), bins = floor(sqrt(n_0))) + 
  labs(x = "Sample means", y = "Density")


# Plot PMF of a Poisson with mean = 5
x <- 0:20
pmf <- dpois(x, lambda = 5)
data_theoretical <- data.frame(x = x, pmf = pmf)

ggplot(data_theoretical) + 
  geom_line(mapping = aes(x = x, y = pmf), stat = "identity") +
  labs(title = "Poisson PMF (λ = 5)", x = "x", y = "P(X = x)")

# Compare theoretical and observed curves
x_sim <- rpois(10000, lambda = 5)
data_observed <- data.frame(x_sim = x_sim)

ggplot(data_observed) + 
  geom_bar(mapping = aes(x = x_sim, y = ..prop..), stat = "count") +
  geom_line(data = data_theoretical, mapping = aes(x = x, y = pmf), color = "red") +
  labs(title = "Observed vs Theoretical Poisson Distribution", x = "x", y = "Proportion")

# Generate 1000 sample averages
x_bars <- numeric(1000)
for (i in 1:1000) {
  sample <- rpois(10000, lambda = 5)
  x_bars[i] <- mean(sample)
}

# Verify Central Limit Theorem
data_samples <- data.frame(x_bars = x_bars)

ggplot(data_samples) + 
  geom_histogram(mapping = aes(x = x_bars, y = ..density..), bins = 30, fill = "lightblue") +
  labs(title = "Sampling Distribution of the Mean", x = "Sample Mean", y = "Density")

# Overlay normal approximation
mu <- 5
sd <- sqrt(5 / 10000)
x_vals <- seq(4.9, 5.1, length.out = 1000)
pdf_vals <- dnorm(x_vals, mean = mu, sd = sd)
data_theoretical_pdf <- data.frame(x = x_vals, pdf = pdf_vals)

ggplot(data_samples) + 
  geom_histogram(mapping = aes(x = x_bars, y = ..density..), bins = 30, fill = "lightblue") +
  geom_line(data = data_theoretical_pdf, mapping = aes(x = x, y = pdf), color = "red") +
  labs(title = "CLT: Poisson Mean ~ Normal", x = "Sample Mean", y = "Density")

