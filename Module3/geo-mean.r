library(UsingR)

# Load data babies
data("babies")

# Birth weight variable
mean(babies$wt)

# Mother age variable
x <- babies$age
mean(x)

# Example using apply function on babies dataset
# We will calculate the mean of numeric columns in the babies dataset
# Select only numeric columns
numeric_data <- babies[, sapply(babies, is.numeric)]

# Apply the mean function to each column, removing NA values
column_means <- apply(numeric_data, 2, mean, na.rm = TRUE)

print(column_means)

# Change 99 to NA
index_99 <- which(x == 99)
x[index_99] <- NA
mean(x, na.rm = TRUE)

#### PRACTICE
library(UsingR)
data("rivers")
x <- rivers
n <- length(rivers)
# What proportion are less than the median length?
x_bar <- median(x)
print(sum(x < x_bar) / n)
# What proportion are less than the mean length?
x_bar <- mean(x)
print(sum(x < x_bar) / n)
# Compare the mean, median, and 25%-trimmed mean. Is there a big difference among the three numbers?
mean_val <- mean(x)
median_val <- median(x)
trimmed_mean_val <- mean(x, trim = 0.25)

print(paste("Mean:", mean_val))
print(paste("Median:", median_val))
print(paste("25%-trimmed Mean:", trimmed_mean_val))

### END PRACTICE

library(UsingR)

# Load data babies
data("babies")

# Birth weight variable
mean(babies$wt)
median(babies$wt)
summary(babies$wt)

# Load data CEO compensation
data("exec.pay")
mean(exec.pay)
median(exec.pay)

# Get Q(0), Q(1)
range(exec.pay)

# Get Q(0), Q(0.25), Q(0.5), Q(0.75), Q(1)
quantile(exec.pay)

# Get Q(0.2), Q(0.4), Q(0.6), Q(0.8)
quantile(exec.pay, probs = seq(0.2, 0.8, by = 0.2))

# Get any p-th quantile
p <- 0.15
quantile(exec.pay, probs = p)

mean(exec.pay)
median(exec.pay)
mean(exec.pay, trim = 0.05)
mean(exec.pay, trim = 0.2)


data("rivers")
x <- rivers
n <- length(x)

# What proportion are less than the mean
x_bar <- mean(x)
print(sum(x < x_bar) / n)

# Compare the mean, median, and 25%-trimmed mean
print(mean(x))
print(median(x))
print(mean(x, trim = 0.25))


var(babies$wt)

# Sample standard deviation
sqrt(var(babies$wt))
sd(babies$wt)

# Data scaling (z-scores)
z <- c(scale(babies$wt, center = TRUE, scale = TRUE))
z <- (babies$wt - mean(babies$wt)) / sqrt(var(babies$wt))

sum(abs(z) <= 1) / length(z)
sum(abs(z) <= 2) / length(z)
sum(abs(z) <= 3) / length(z)

# IQR
IQR(babies$wt)

# Range
range(babies$wt)



z <- rivers
z <- (z - mean(z))/sd(z)

sum(abs(z) <= 1) / length(z)
sum(abs(z) <= 2) / length(z)

## PRACTICE 2
library(UsingR)
x <- data("rivers")
n <- length(x)
# Compare the standard deviation, IQR, and MAD for babies$wt
z <- rivers
z <- (z - mean(z))/sd(z)

sum(abs(z) <= 1) / length(z)
sum(abs(z) <= 2) / length(z)
hist(z)
#End practice 2


# Load data babies
library(UsingR)
data("babies")

# Baby weight variable
x <- babies$wt

# Draw the histogram
hist(x)

x <- babies$wt
n <- length(x)

# Square-root choice
k <- ceiling(sqrt(n))

# Sturges’ formula
k <- 1 + ceiling(log2(n))

# Rice rule
k <- ceiling(2 * n^(1 / 3))

hist(x,
     breaks = seq(min(x), max(x), length.out = k + 1),
     xlab = "Weight", main = " ")

# Scott’s normal reference
h <- 3.5 * sqrt(var(x)) / n^(1 / 3)
k <- ceiling((max(x) - min(x)) / h)

# Plot the histogram
hist(x,
     breaks = seq(min(x), max(x), length.out = k + 1),
     xlab = "Weight", main = " ",
     col = "#008542", las = 1)

# Freedman–Diaconis choice
h <- 2 * IQR(x) / n^(1 / 3)
k <- ceiling((max(x) - min(x)) / h)

# Plot the histogram
hist(x,
     breaks = seq(min(x), max(x), length.out = k + 1),
     xlab = "Weight", main = " ",
     col = "#008542", las = 1)

data("exec.pay")
x <- exec.pay
n <- length(x)

# Freedman–Diaconis choice
h <- 2 * IQR(x) / (n^(1 / 3))
k <- ceiling((max(x) - min(x)) / h)

hist(x,
     breaks = seq(min(x), max(x), length.out = k + 1),
     xlab = "Compensation (10k)")

hist(x,
     breaks = seq(min(x), max(x), length.out = k + 1),
     xlim = c(0, 200),
     xlab = "Compensation (10k)")

# Baby weight variable
x <- babies$wt

# Histogram
hist(x, xlab = " ", freq = TRUE, las = 1)

# Histogram and density plot
hist(x, xlab = " ", freq = FALSE, las = 1)
lines(density(x))

# Density plot only
plot(density(x), xlab = " ", las = 1, main = "Density plot of x")


# ----------------------------------------------------------------------

# Baby weight variable
x <- babies$wt

# Get the quantile summary
summary(x)

# Draw the boxplot
boxplot(x)
boxplot(x, horizontal = TRUE)

par(mfrow = c(2, 1))
hist(x, main = "Histogram", xlab = " ", ylab = " ", xlim = c(60, 180))
boxplot(x, main = "Boxplot", horizontal = TRUE, ylim = c(60, 180))
par(mfrow = c(1, 1))

# violinplot placeholder in original (no base function); using vioplot below
# violinplot(x, col = "orange")

library(vioplot)
vioplot(x, horizontal = TRUE,
        xlab = "Newborn weight (oz)",
        col = "orange",
        main = "The violin plot of baby weights",
        cex.main = 1.8)


# Density plot only
par(mfrow = c(1, 1))
plot(density(x), xlab = " ", las = 1, main = "Density plot of x")

hist(x, xlab = " ", freq = FALSE, las = 1, col = "yellow")
lines(density(x), col = "red")

par(mfrow = c(1, 2))
hist(x, xlab = " ", freq = FALSE, las = 1, col = "yellow")
hist(x, xlab = " ", freq = FALSE, las = 1, col = "yellow")
lines(density(x), col = "red", lwd = 4)

# -----
plot(density(x), lwd =3, col = "red")
hist(x, freq = FALSE)
lines(density(x), lwd = 3, col = "red")

par(mfrow = c(1, 2))
hist(x, freq = FALSE, col = "yellow")
hist(x, freq = FALSE, col = "yellow")
lines(density(x), lwd = 3, col = "red")
par(mfrow = c(1,1))











