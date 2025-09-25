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
############################################

library(UsingR)

# ----------------------------------------------------------------------
# Load data
data("fat")

# Draw a scatter plot for neck against wrist
plot(fat$wrist, fat$neck)
plot(neck ~ wrist, data = fat)

# Draw a scatter plot for height against wrist
plot(height ~ wrist, data = fat)
plot(height ~ wrist, data = fat, subset = height > 50)

# ----------------------------------------------------------------------
# Load data
data("central.park")
barplot(AVG ~ DY, data = central.park,
        xlab = "Days in May 2003",
        ylab = "Temp. (Fahrenheit)",
        main = "Average Temperature at Central Park, NYC",
        col = ifelse(central.park$AVG > mean(central.park$AVG), "red",
                     "blue"),
        pch = 19)

# Draw a scatter plot
plot(AVG ~ DY, data = central.park)

# Add a title and axis labels
plot(AVG ~ DY, data = central.park,
     xlab = "Days in May 2003",
     ylab = "Temp. (Fahrenheit)",
     main = "Average Temperature at Central Park, NYC")

# Change the point look
plot(AVG ~ DY, data = central.park,
     xlab = "Days in May 2003",
     ylab = "Temp. (Fahrenheit)",
     main = "Average Temperature at Central Park, NYC",
     pch = 16, col = "#e87500")

# Make color indicate if the daily temperature was greater than average
plot(AVG ~ DY, data = central.park,
     xlab = "Days in May 2003",
     ylab = "Temp. (Fahrenheit)",
     main = "Average Temperature at Central Park, NYC",
     pch = 16, col = ((central.park$AVG < mean(central.park$AVG)) + 1) * 123)

# Add a title and axis labels
plot(AVG ~ DY, data = central.park,
     xlab = "Days in May 2003",
     ylab = "Temp. (Fahrenheit)",
     main = "Average Temperature at Central Park, NYC",
     col = ifelse(central.park$AVG > mean(central.park$AVG), "red",
                  "blue"),
     pch = 19)

points(10, 65, col = "black", pch = 19, cex = 3)


abline(a = 55, b = 1)
points(10, 65, col = "black", pch = 19, cex = 3)
abline(a = 55, b = 0.3, col = "red")


# ----------------------------------------------------------------------
# Draw an empty figure
plot(NULL,
     xlim = c(min(central.park$DY), max(central.park$DY)),
     ylim = c(min(central.park$AVG), max(central.park$AVG)),
     xlab = "Days in May 2003",
     ylab = "Temp. (Fahrenheit)")

# Add points
points(central.park$DY, central.park$AVG, pch = 16)

# Draw an empty figure again
plot(NULL,
     xlim = c(min(central.park$DY), max(central.park$DY)),
     ylim = c(min(central.park$AVG), max(central.park$AVG)),
     xlab = "Days in May 2003",
     ylab = "Temp. (Fahrenheit)")

# Add line segments
lines(central.park$DY, central.park$AVG)

# Add a horizontal line indicating the average of daily average temperatures
abline(h = mean(central.park$AVG), lty = 2)

# ----------------------------------------------------------------------
# Load data
data("fat")

# Draw a scatter plot
plot(hip ~ height, data = fat)

# Add a title and axis labels
plot(hip ~ height, data = fat,
     las = 1,
     xlab = "Height (inches)",
     ylab = "Hip circumference (cm)",
     main = "Relationship between height and hip")

# Add a red horizontal dashed line to indicate the mean of hip
abline(h = mean(fat$hip), col = 2, lty = 2)

# Add a red vertical dashed line to indicate the mean of height
abline(v = mean(fat$height), col = 2, lty = 2)

# Calculate the correlation
cor(fat$hip, fat$height)


## AI ##
library(UsingR)
data("fat")

# Draw a scatter plot of hip circumference against height
plot(hip ~ height, data = fat,
     las = 1,
     xlab = "Height (inches)",
     ylab = "Hip circumference (cm)",
     main = "Relationship between height and hip",
     col = "orange")

# Add a red horizontal dashed line indicating the mean hip circumference
abline(h = mean(fat$hip), col = "red", lty = 2)

# Add a red vertical dashed line indicating the mean height
abline(v = mean(fat$height), col = "red", lty = 2)
# Calculate the correlation
cor(fat$hip, fat$height)

