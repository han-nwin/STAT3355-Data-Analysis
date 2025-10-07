install.packages("gridExtra")
# Load data
library(ggplot2)
data("mpg")
# Question 1
F_tab <- table(mpg$drv,  mpg$class)
barplot(F_tab, col = c("red","green", "blue"),
         ylab = "Frequency", las = 1, 
        ylm = c(0, 100),
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

