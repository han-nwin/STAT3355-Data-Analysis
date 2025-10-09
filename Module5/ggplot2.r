install.packages("gridExtra")
# Load data
library(ggplot2)
data("mpg")
# Question 1
F_tab <- table(mpg$drv,  mpg$class)
barplot(F_tab, col = c("red","green", "blue"),
         ylab = "Frequency", las = 1, 
        ylim = c(0, 100),
        legend.text = c ("4-wheel", 
                         "Front-wheel",
                         "Rear-wheel"),
        args.legend = list(x = "topleft", bty = "n"),
        cex.names = 0.6)

# Question 2
# Boxplot of Highway MPG by drivetrain (excluding "r" and only for compact cars)
boxplot(hwy ~ drv, data = mpg, subset = (drv != "r" & class == "compact"), 
        las = 1, ylab = "Highway MPG", xlab = "",
        names = c("4-wheel", "Front-wheel"))  # Question 3

# Question 3
plot(hwy ~ displ, data = mpg, las = 1, 
     xlab = "Engine Displacement (L)", 
     ylab = "Highway MPG", main = "")

# Linear model and regression line
m <- lm(hwy ~ displ, data = mpg)
abline(m, col = "red")
coef(m)

# Load necessary library
library(ggplot2)

# Load data
data("mpg")

# Basic scatter plot
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy))

# Load data
library(ggplot2)
data("mpg")
# Question 1
F_tab <- table(mpg$drv,  mpg$class)
barplot(F_tab, col = c("red","green", "blue"),
         ylab = "Frequency", las = 1, 
        legend.text = c ("4-whee", 
                         "Front-wheel",
                         "Rear-wheel"),
        args.legend = list(x = "topleft", bty = "n"),
        cex.names = 0.6)

# Question 2
# Boxplot of Highway MPG by drivetrain (excluding "r" and only for compact cars)
boxplot(hwy ~ drv, data = mpg, subset = (drv != "r" & class == "compact"), 
        las = 1, ylab = "Highway MPG", xlab = "",
        names = c("4-wheel", "Front-wheel"))  # Question 3

# Question 3
plot(hwy ~ displ, data = mpg, las = 1, 
     xlab = "Engine Displacement (L)", 
     ylab = "Highway MPG", main = "")

# Linear model and regression line
m <- lm(hwy ~ displ, data = mpg)
abline(m, col = "red")
coef(m)

# Load necessary library
library(ggplot2)

# Load data
data("mpg")

# Basic scatter plot
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy))

# Alternative code using qplot
qplot(x = displ, y = hwy, data = mpg, geom = "point")

# Scatter plot with labels
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy)) + 
        labs(x = "Number of Cylinders", 
             y = "Highway MPG", 
             title = "Relationship Between MPG and Cylinder Numbers")

# Scatter plot colored by number of cylinders
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy, color = as.factor(cyl)))

# Scatter plot with different shapes for cylinder categories
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy, shape = as.factor(cyl)))

# Scatter plot with size mapped to number of cylinders
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy, size = cyl))

# Scatter plot with alpha transparency based on number of cylinders
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy, alpha = cyl))

# Scatter plot colored by vehicle class with a custom color scale
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy, color = class)) +
        scale_color_brewer(palette = "Set1")

# Scatter plot colored by number of cylinders using a distiller scale
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy, color = cyl)) +
        scale_colour_distiller(palette = "Blues", direction = 1)

# Scatter plot with multiple aesthetics
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy, color = cty, 
                                 size = as.factor(cyl), shape = class)) +
        scale_colour_distiller(palette = "Reds", direction = 1)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = drv)) + 
  facet_wrap(~ drv, scales = "free")

library(gridExtra)
p1 <- ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

p2 <- ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy), linetype = 6)

grid.arrange(p1, p2, nrow = 1)


# Faceted scatter plot by class (2 rows)
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy)) + 
        facet_wrap(~class, nrow = 2)

# Faceted scatter plot using grid layout (columns based on class)
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy)) + 
        facet_grid(. ~ class)

# Faceted scatter plot with rows based on class
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy)) + 
        facet_grid(class ~ .)

# Faceted scatter plot by number of cylinders and drivetrain
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy)) + 
        facet_grid(cyl ~ drv)

# Faceted scatter plot by number of cylinders with custom labels
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy, color = as.factor(cyl))) +
        facet_wrap(~ cyl, nrow = 2) +
        labs(x = "Displacement (Liter)", 
             y = "Highway Miles per Gallon", 
             color = "Number of Cylinders")

library(ggplot2)

ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))

ggplot(data = mpg) + 
        geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
        geom_smooth(mapping = aes(x = displ, y = hwy), color = "red")

ggplot(data = mpg) + 
        geom_smooth(mapping = aes(x = displ, y = hwy, color = drv))

# Left plot
ggplot(data = mpg) + 
        geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

# Right plot
ggplot(data = mpg) + 
        geom_smooth(mapping = aes(x = displ, y = hwy), linetype = 6)

ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy)) + 
        geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
        geom_point() + 
        geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
        geom_smooth() + 
        geom_point()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
        geom_point(mapping = aes(color = drv)) + 
        geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
        geom_smooth(mapping = aes(color = drv)) + 
        geom_point()

ggplot(data = mpg, mapping = aes(y = hwy, x = displ, color = drv)) +
        geom_point() +
        geom_smooth(method = "lm") +
        facet_wrap(~class, nrow = 2) +
        labs(x = "Engine displacement (L)", 
             y = "Highway MPG", 
             title = "Negative relationship between mpg and engine displacement", 
             color = "Drive wheel")

ggplot(data = mpg) + 
        geom_point(mapping = aes(x = cyl, y = hwy))

ggplot(data = mpg) + 
        geom_point(mapping = aes(x = as.factor(cyl), y = hwy))

ggplot(data = mpg) + 
        geom_jitter(mapping = aes(x = as.factor(cyl), y = hwy))

ggplot(data = subset(mpg, cyl != 5)) + 
        geom_jitter(mapping = aes(x = as.factor(cyl), y = hwy))

ggplot(data = subset(mpg, cyl != 5), mapping = aes(x = as.factor(cyl), y = hwy)) +
        geom_jitter() + 
        geom_boxplot()

ggplot(data = subset(mpg, cyl != 5), mapping = aes(x = as.factor(cyl), y = hwy)) +
        geom_boxplot() + 
        geom_jitter()

ggplot(data = subset(mpg, subset = cyl != 5), 
       mapping = aes(x = as.factor(cyl), y = hwy, color = as.factor(year))) +
        geom_boxplot() +
        geom_jitter() +
        labs(x = "Number of cylinders", 
             y = "Highway MPG", 
             title = "Fuel efficiency increased for 4 and 8-cylinder cars from 1999 to 2008", 
             color = "Year")

ggplot(data = mpg, mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy, color = class)) + 
        geom_boxplot() + 
        geom_jitter()

ggplot(data = mpg, mapping = aes(x = reorder(class, -hwy, FUN = median), y = hwy, color = class)) + 
        geom_boxplot()

ggplot(data = mpg, mapping = aes(x = reorder(class, -hwy, FUN = median), y = hwy, color = class)) + 
        geom_violin(draw_quantiles = 0.5)

ggplot(data = mpg) + 
        geom_histogram(mapping = aes(x = hwy, y = ..count..))

ggplot(data = mpg) + 
        geom_histogram(mapping = aes(x = hwy))

ggplot(data = mpg) + 
        geom_histogram(mapping = aes(x = hwy, y = ..density..), bins = 10) +
        geom_density(mapping = aes(x = hwy))

ggplot(data = mpg) + 
        geom_density(mapping = aes(x = hwy, color = substr(trans, 1, 1), fill = substr(trans, 1, 1), alpha = 0.5))

ggplot(data = mpg) + 
        geom_density(mapping = aes(x = hwy, color = substr(trans, 1, 1), fill = substr(trans, 1, 1)), alpha = 0.5)

ggplot(data = mpg) + 
        geom_histogram(mapping = aes(x = hwy, fill = substr(trans, 1, 1)), bins = 10)

ggplot(data = mpg) + 
        geom_bar(mapping = aes(x = class, y = ..count..))

ggplot(data = mpg) + 
        geom_bar(mapping = aes(x = class))

ggplot(data = mpg) + 
        geom_bar(mapping = aes(x = class)) + 
        coord_flip()

ggplot(data = mpg) + 
        geom_bar(mapping = aes(x = class)) + 
        coord_polar()

ggplot(data = mpg) + 
        geom_bar(mapping = aes(x = class, y = ..prop.., group = 1))

mpg$class <- factor(mpg$class, levels = names(sort(table(mpg$class), decreasing = FALSE)))

ggplot(data = mpg) + 
        geom_bar(mapping = aes(x = class))

ggplot(data = mpg) + 
        geom_bar(mapping = aes(x = class, fill = ..count..)) + 
        theme(axis.text.x = element_text(angle = -45))

ggplot(data = mpg) + 
        geom_bar(mapping = aes(x = class, fill = as.factor(cyl)), position = "stack")

ggplot(data = mpg) + 
        geom_bar(mapping = aes(x = class, fill = as.factor(cyl)))

ggplot(data = mpg) + 
        geom_bar(mapping = aes(x = class, fill = as.factor(cyl)), position = "dodge")

ggplot(data = mpg) + 
        geom_bar(mapping = aes(x = class, fill = as.factor(cyl)), position = "fill")

# Practice
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = cty, 
                           size = as.factor(cyl), shape = class)) +
  scale_colour_distiller(palette = "Reds", direction = 1)
## THIS IS STUPID ###

ggplot(data = mpg) +
  geom_point(mapping = aes( x = displ , y = hwy, color = drv)) + 
  facet_wrap(~ class)

ggplot(data = mpg) +
  geom_point(mapping = aes( x = displ , y = hwy, color = cty)) + 
  facet_grid(cyl ~ drv, scales = "free")

# Combine plotting
# make sure mapping is global
p1 <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_smooth(method = "lm",
              se = FALSE)
p2 <- p1 + geom_point()

p2

# practice
p1 <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy, linetype = drv)) +
  geom_smooth()
p1

p2 <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_smooth( linetype = 6)
p2

grid.arrange(p1, p2, nrow=1)


ggplot(data = mpg, mapping = aes(y = hwy, x = displ, color = drv)) +
  geom_point() +
  geom_smooth(method = "lm") +
  facet_wrap(~class, nrow = 2) +
  labs(
    x = "Engine displacement (L)",
    y = "Highway MPG",
    title = "Negative relationship between mpg and engine displacement",
    color = "Drive wheel"
  )




