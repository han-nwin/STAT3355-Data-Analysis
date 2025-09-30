# Load data
library(UsingR)
data("diamond")

# Problem 1
cor(diamond$price, diamond$carat)

# Problem 2
plot(price ~ carat, data = diamond)


# Strong linear correlation pattern, no need
# to compute the Spearman correlation

library(UsingR)
# Load data
data("fat")

# Draw a scatter plot for neck against wrist
plot(neck ~ wrist, data = fat, pch = 16,
     xlab = "Wrist circumference (cm)",
     ylab = "Neck circumference (cm)",
     main = "Relationship between neck and wrist")

# Add lines to indicate their means
abline(h = mean(fat$neck), col = "red", lty = 2)
abline(v = mean(fat$wrist), col = "red", lty = 2)

# Fit a regression line and plot it
m <- lm(neck ~ wrist, data = fat)
abline(a = coef(m)[1], b = coef(m)[2], col = "blue", lwd = 1.5)



x <- runif(100, -5, 5)
y <- 10 + 3.4*x + 2.1*x^2 + rnorm(100, mean = 0, sd = 7)
plot(x, y)

m1 <- lm(y~x)
summary(m1)

coef(m1)[1]
coef(m1)[2]

abline(a = coef(m1)[1], b = coef(m1)[2], col = "red", lwd = 3)


plot(x, y)
x2 <- x^2
m2 <- lm(y~ x + x2)
summary(m2)

coef(m2)[1]
coef(m2)[2]
coef(m2)[3]

y_pred <- coef(m2)[1] + coef(m2)[2]*x + coef(m2)[3]*x2

n <- order(x)
lines(x[n], y_pred[n], col = "red", lwd = 3)





x <- sort(runif(100, -1, 1))
y <- 1.5 + 4.5*x^3 - 2.6*x^2 - 1.1*x + rnorm(100, sd = 0.2)
plot(x, y)

x3 <- x^3
x2 <- x^2

m1 <- lm(y~ x3 + x2 + x)
coef(m1)

lines(x, coef(m1)[1] + coef(m1)[2]*x3 + coef(m1)[3]*x2 + coef(m1)[4]*x, col = "red")


library(UsingR)
data("samhda")


table(samhda$gender)
table(samhda$alcohol)

samhda$gender[which(samhda$gender == 7)] <- NA
samhda$alcohol[which(samhda$alcohol == 9)] <- NA
samhda$gender <- factor(samhda$gender,
                        labels = c("M", "F"))
samhda$alcohol <- as.logical(2 - samhda$alcohol)

F_tab <- table(samhda$gender, samhda$alcohol)
P <- F_tab/sum(F_tab)
P


table(samhda$alcohol)
table(samhda$marijuana) # Yes, need to clean this
samhda$marijuana[which(samhda$marijuana == 9)] <- NA
samhda$marijuana <- as.logical(2 - samhda$marijuana)

table(samhda$alcohol, samhda$marijuana)

library(lattice)

F_tab <- table(samhda$alcohol, samhda$marijuana)

levelplot(F_tab)
levelplot(F_tab,
          xlab = "Alcohol",
          ylab = "Marijuana",
          main = "The school-aged behavior")

levelplot(F_tab,
          xlab = "Alcohol",
          ylab = "Marijuana",
          main = "The school-aged behavior",
          cuts = 1)

levelplot(F_tab,
          xlab = "Alcohol",
          ylab = "Marijuana",
          main = "The school-aged behavior",
          cuts = 4)

levelplot(F_tab,
          xlab = "Alcohol",
          ylab = "Marijuana",
          main = "The school-aged behavior",
          col.regions = grey(level = seq(0,1, by = 0.01)))

rownames(F_tab) <- c("No Alcohol", "Alcohol")
colnames(F_tab) <- c("No Marijuana", "Marijuana")

barplot(t(F_tab), 
        names.arg = c("No Alcohol", "Alcohol"),
        legend.text = c("Weed", "No Weed"),
        main = "School Aged Behavior")

barplot(t(F_tab), 
        names.arg = c("No Alcohol", "Alcohol"),
        legend.text = c("No Weed", "Weed"),
        main = "School Aged Behavior",
        beside = TRUE)

barplot(t(prop.table(F_tab)), 
        names.arg = c("No Alcohol", "Alcohol"),
        legend.text = c("No Weed", "Weed"),
        main = "School Aged Behavior",
        ylim = c(0, 1))

barplot(prop.table(F_tab), 
        names.arg = c("No Alcohol", "Alcohol"),
        legend.text = c("No Weed", "Weed"),
        main = "School Aged Behavior",
        beside = TRUE)




