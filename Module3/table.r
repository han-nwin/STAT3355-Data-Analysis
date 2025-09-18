install.packages("UsingR")
library(UsingR)
library(ggplot2)


data("babies")

# Smoke variable
x <- babies$smoke
table(x)

# Turn x into a factor vector
x <- factor(x, 
            labels = c("Never", "Now", "Until pregnancy",
                       "Once but quit", "Unknown"))
table(x)

names(which.max(table(x)))

p <- table(x) / sum(table(x))
p

p <- table(x) / sum(table(x))
- sum(p * log(p))

p <- table(x) / sum(table(x))
1 - sum(p * p)


x <- babies$age

# Tabulate data
table(x)

# Change the value of 99 to NA
x[which(x == 99)] <- NA

# Turn x to a factor vector
x <- cut(x, breaks = c(0, 19, 29, 39, 49),
         labels = c("10s", "20s", "30s", "40s"))
table(x)

# What is the mode
names(which.max(table(x)))

# What is the proportion of 40s women
round(table(x)["40s"] / sum(table(x)), 3)

p_age <- table(x) / sum(table(x))
- sum(p_age * log(p_age))
log(sum(length(unique(x))))

p_age <- table(x) / sum(table(x))
- sum(p_age * log(p_age))
log(sum(length(unique(x))))


barplot(table(x))

# Smoke variable cleaning again
x <- babies$smoke
table(x)

# Change the value of 9 to NA
index_9 <- which(x == 9)
x[index_9] <- NA

# Turn x to a factor vector
x <- factor(x, 
            labels = c("Never", "Now", "Until pregnancy",
                       "Once but quit"))
table(x)

# Plot the bar chart
barplot(table(x))


# Turn x to a factor vector
x <- factor(x, 
            labels = c("Never", "Now", "Until \npregnancy",
                       "Once \nbut \nquit"))
table(x)

# Plot the bar chart
barplot(table(x),
        main = "Mother Smoking Status",
        col = "orange",
        ylab = "Frequency",
        cex.names = 0.8,
        las = 2)


# Load data central.park
data("central.park")

# Plot the average temperature in May 2003 at Central Park, NYC
barplot(central.park$AVG)

x <- central.park$AVG

# Name the bars from day 1 to 31
barplot(x, names.arg = 1:31)

# Name the x and y axis
barplot(x, names.arg = 1:31,
        xlab = "Days in May 2003", ylab = "Temp. (Fahrenheit)")

# Set the title
barplot(x, names.arg = 1:31,
        xlab = "Days in May 2003", ylab = "Temp. (Fahrenheit)",
        main = "Average Temperature at Central Park, NYC")

# Limit the bottom of y axis to freezing point
barplot(x, names.arg = 1:31,
        xlab = "Days in May 2003", ylab = "Temp. (Fahrenheit)",
        main = "Average Temperature at Central Park, NYC",
        ylim = c(32, 75), xpd = FALSE)

# Color each bar with respect to above or below the mean
cr <- rep("blue", 31)
index <- which(central.park$AVG > mean(central.park$AVG))
cr[index] <- "red"

barplot(x, names.arg = 1:31,
        xlab = "Days in May 2003", ylab = "Temp. (Fahrenheit)",
        main = "Average Temperature at Central Park, NYC",
        ylim = c(32, 75), xpd = FALSE, col = cr, border = cr)

# Smoke variable
x <- babies$smoke
table(x)
x <- x[-which(x == 9)]

# Turn x into a factor vector
x <- factor(x, 
            labels = c("Never", "Now", "Until pregnancy",
                       "Once but quit"))

perc <- paste("(", 
              round(table(x)/sum(table(x))*100, 1), 
              "%)", 
              sep = "")

new_labs <- paste(levels(x), perc)

new_x <- factor(x, labels = new_labs)

pie(table(new_x),
    col = c("red", "orange", "yellow",  "purple"))
