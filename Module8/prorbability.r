
# Load required library
library(ggplot2)

# --- Binomial PMF for X ~ Binomial(100, 0.6) ---
x <- 0:100
p <- dbinom(x, size = 100, prob = 0.6)
data <- data.frame(x = x, p = p)

# Plot the PMF
ggplot(data) +
  geom_bar(mapping = aes(x = as.factor(x), y = p),
           stat = "identity",
           fill = rgb(223/255, 117/255, 0)) +
  scale_x_discrete(breaks = seq(0, 100, by = 10)) +
  labs(x = "x", y = "p.m.f.")

# --- Binomial Quantiles ---
qbinom(c(0.25, 0.5, 0.75), size = 100, prob = 0.6)

# --- Simulate 1000 Binomial(100, 0.6) variables ---
x_sim <- rbinom(1000, size = 100, prob = 0.6)
data_2 <- data.frame(x = x_sim)

# Histogram of simulated values + overlay PMF
ggplot() +
  geom_histogram(data = data_2,
                 mapping = aes(x = x, y = ..density..),
                 binwidth = 1,
                 fill = "lightblue", color = "black") +
  geom_line(data = data,
            mapping = aes(x = x, y = p),
            color = "red", size = 1)

# --- Normal approximations for SAT-like scores ---
x <- 400:1600
p_100 <- dnorm(x, mean = 1059, sd = 100)
p_210 <- dnorm(x, mean = 1059, sd = 210)
p_300 <- dnorm(x, mean = 1059, sd = 300)

data_norm <- data.frame(
  x = rep(x, 3),
  p = c(p_100, p_210, p_300),
  sd = factor(c(rep("sd = 100", length(x)),
                rep("sd = 210", length(x)),
                rep("sd = 300", length(x))))
)

# Plot the PDFs
ggplot(data_norm) +
  geom_line(mapping = aes(x = x, y = p, color = sd, linetype = sd)) +
  labs(x = "SAT", y = "p.d.f.")

# --- Normal probability between 1140 and 1380 ---
pnorm(1380, mean = 1059, sd = 210) - pnorm(1140, mean = 1059, sd = 210)

# --- Simulate 1000 normal r.v.'s and compare histogram to PDF ---
x_sim <- rnorm(1000, mean = 1059, sd = 210)
data_simulated <- data.frame(x_sim = x_sim)

x <- 400:1600
pdf <- dnorm(x, mean = 1059, sd = 210)
data_theoretical <- data.frame(x = x, pdf = pdf)

# Plot histogram of simulated vs. theoretical PDF
ggplot() +
  geom_histogram(data = data_simulated,
                 mapping = aes(x = x_sim, y = ..density..),
                 binwidth = 25,
                 fill = "lightgray", color = "black") +
  geom_line(data = data_theoretical,
            mapping = aes(x = x, y = pdf),
            color = "blue", size = 1)

x_sim <- rgamma(1000, shape = 60, rate = 10)
x <- seq(0, 15, by = 0.01)
pdf <- dgamma(x, shape = 60, rate = 10)
hist(data_simulated$x_sim, freq = FALSE)
lines(x, pdf, col = "red", lwd = 3)

