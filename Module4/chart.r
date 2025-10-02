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

library(UsingR)
data("babies")

babies$smoke[which(babies$smoke == 9)] <- NA
babies$smoke <- factor(babies$smoke, labels = c("Never", "Now", 
                                                "Till pregnancy", 
                                                "Once but quit"))
boxplot(wt ~ smoke, data = babies)
boxplot(wt ~ smoke, data = babies,
        horizontal = TRUE)


library(ggplot2)
data("diamonds")
library(lattice)
boxplot(price ~ round(carat), data = diamonds,
        ylim = c(0, 30000),
        col = "orange")
boxplot(price ~ color, data = diamonds,
        ylim = c(0, 30000),
        col = "orange")

F_tab <- table(round(diamonds$carat), diamonds$color)
levelplot(F_tab,
          ylab = "Color",
          xlab = "Carat")

babies$age[which(babies$age == 99)] <- NA
# Create a new variable indicating advanced maternal age
babies$ama <- babies$age >= 35
boxplot(wt ~ ama, data = babies,
        xlab = "Advanced Mother's Age",
        ylab = "Baby's weight")

subsets <- c("Never", "Now", 
             "Till pregnancy", 
             "Once but quit")

plot(density(babies$wt[which(babies$age_group == subsets[1])]),
     ylim = c(0, 0.03),
     xlab = "Mother's Age Group",
     col = 1,
     main = "Does smoke affect birth weight?")
# Draw more line
for(i in 2:length(subsets)){
  lines(density(babies$wt[which(babies$age_group == subsets[i])]),
        col = i)
}

legend("topleft", c("Never", "Now", "Till pregnancy", "Once but quit"), 
       col = 1:4, 
       lwd = rep(1.5, 4), lty = c(1, 1, 1, 1), 
       bty = "n")

# Obtain the density
density_never <- density(babies$wt[which(babies$smoke == "Never")])
density_now <- density(babies$wt[which(babies$smoke == "Now")])
density_till <- density(babies$wt[which(babies$smoke == "Till pregnancy")])
density_quit <- density(babies$wt[which(babies$smoke == "Once but quit")])

# Obtain the plot range
ymin <- min(density_never$y, density_now$y,
            density_till$y, density_quit$y)
ymax <- max(density_never$y, density_now$y,
            density_till$y, density_quit$y)
xmin <- min(babies$wt)
xmax <- max(babies$wt)


# Create the density plots comparing birth weight among
# Mothers in age ranges
# < 22, [22,28], [28,34], 34+

# Use cut to divide the age into groups
babies$age_group <- cut(babies$age, breaks = c(-Inf, 22, 28, 34, Inf),
                       labels = c("<22", "22-28", "28-34", "34+"),
                       right = TRUE)

# Define colors for each age group
colors <- c("red", "blue", "green", "purple")
names(colors) <- levels(babies$age_group)

# Plot the density for the first group to set up the plot
first_group <- levels(babies$age_group)[1]
d <- density(babies$wt[babies$age_group == first_group], na.rm = TRUE)
plot(d, col = colors[first_group], lwd = 2,
     xlim = range(babies$wt, na.rm = TRUE),
     ylim = c(0, max(sapply(levels(babies$age_group), function(g) max(density(babies$wt[babies$age_group == g], na.rm = TRUE)$y)))),
     xlab = "Baby's Birthweight (oz)",
     ylab = "Density",
     main = "Density of Baby's Birthweight by Mother's Age Group")

# Add density lines for the other groups
for (group in levels(babies$age_group)[-1]) {
  d <- density(babies$wt[babies$age_group == group], na.rm = TRUE)
  lines(d, col = colors[group], lwd = 2)
}

# Add legend
legend("topright", legend = levels(babies$age_group), col = colors, lwd = 2, bty = "n")


# Remove NA values from age_group and wt for plotting
babies_clean <- babies[!is.na(babies$age_group) & !is.na(babies$wt), ]

ggplot(babies_clean, aes(x = wt, color = age_group, fill = age_group)) +
  geom_density(alpha = 0.3) +
  labs(title = "Density of Baby's Birthweight by Mother's Age Group",
       x = "Baby's Birthweight (oz)",
       y = "Density",
       color = "Mother's Age Group",
       fill = "Mother's Age Group") +
  theme_minimal()

names <-  c("<22","[22 - 28)","[28, 34)",">34")
m_breaks <- cut(babies$age, 
                breaks = c(-Inf, 22, 28, 34, Inf),
                labels = names)

plot(density(babies[which(m_breaks == names[1]), "age"]),
     col = 1, xlim = c(10, 50), ylim = c(0, 0.4), main = "")
for(i in 2:4){
  lines(density(babies[which(m_breaks == names[i]), "age"]),
        col = i)
}

# Add a legend
legend("topright",                              
       legend = names,            
       col = 1:4,                               
       lty = 1,                                 
       title = "")
