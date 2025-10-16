
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

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy),
              method = "lm",
              se = FALSE)

p1 <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv))

p2 <- p1 + geom_smooth(method = "lm", se = FALSE)


P2

grid.arrange(p1, p2, nrow = 1)



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


band_new <- data %>% 
  filter(instrument %in% c("guitar", "drums")) %>%
  arrange(substr(name, nchar(name), nchar(name))) %>%
  select(name) 
  

library(dplyr)


band <- data.frame(
  name = c("John", "George", "Ringo", "Steven", "Paul", "Peter"),
  instrument = c("guitar", "drums", "bass", "bass", "guitar", "drums"),
  years = c(2, 7, 4, 1, 3, 6)
)

band_new <- filter(data, instrument == "guitar")
band_new <- filter(data, years >= 2 & years <= 4)
band_new <- filter(data, between(years, 2, 4))
band_new <- data[which(data$instrument == "guitar"), ]
band_new <- subset(data, instrument == "guitar")
band_new <- filter(data, instrument == "guitar")
band_new <- data %>% filter(instrument == "guitar")

band_new <- arrange(data, years)
band_new <- arrange(data, desc(years))

band_new <- data[order(data$years), ]
band_new <- data[order(data$years, decreasing = TRUE), ]
band_new <- arrange(data, years)
band_new <- data %>% arrange(years)

band_new <- select(data, name, instrument)
band_new <- select(data, -years)
band_new <- data[, c("name", "instrument")]
band_new <- data[, which(colnames(data) %in% c("name", "instrument"))]
band_new <- select(data, name, instrument)
band_new <- data %>% select(name, instrument)

band_new <- mutate(data, months = 12 * years)
band_new <- mutate(data, months = 12 * years, days = 365 * years)

band_new <- data
band_new$months <- band_new$years * 12
band_new <- mutate(data, months = 12 * years)
band_new <- data %>% mutate(months = 12 * years)

# Load data
library(ggplot2)
setwd("~/Downloads")
bnames <- read.csv("bnames.csv", stringsAsFactors = FALSE)
bnames_new <- filter(bnames, name == "Kevin")
bnames_new <- arrange(bnames_new, desc(prop))
bnames_new <- select(bnames_new, -soundex)
bnames_new <- mutate(bnames_new, numbers = round(1000 * prop, 0))

# Quiz 7
bnames <- read.csv(file = "bnames.csv", stringsAsFactors = FALSE)

bnames$sex <- factor(bnames$sex, levels = c("girl", "boy"))

# How many unique first names? Answer: 6782
print(length(unique(bnames$name)))

# How many unique sound-like names? Answer: 1392
print(length(unique(bnames$soundex)))

# Use pipe operator
bnames_new <- bnames %>%
  filter(name == "Kevin") %>%
  arrange(desc(prop)) %>%
  select(-soundex) %>%
  mutate(numbers = round(1000 * prop, 0))

bnames <- read.csv(file = "bnames.csv", stringsAsFactors = FALSE)
bnames$sex <- factor(bnames$sex, levels = c("girl", "boy"))
print(length(unique(bnames$name)))
print(length(unique(bnames$soundex)))

ggplot(data = subset(bnames, name == "Kevin")) +
  geom_line(mapping = aes(x = year, y = prop))

ggplot(data = subset(bnames, name == "Kevin")) +
  geom_line(mapping = aes(x = year, y = prop, color = sex)) +
  labs(x = "Year", y = "Proportion", title = "The trend of the name Kevin", color = "Gender")

bnames %>%
  filter(name == "Brandon") %>%
  arrange(desc(prop)) %>%
  select(-soundex) %>%
  mutate(numbers = round(1000 * prop, 0)) %>%
ggplot() +
  geom_line(mapping = aes(x = year, y = prop, color = sex)) +
  labs(x = "Year", y = "Proportion",
       title = "The trend of the name Kevin", color = "Gender")



###
band_new <- band %>%
  group_by(instrument) %>%
  summarise(mean = mean(years, na.rm = TRUE)) %>%
  ungroup() %>%
  left_join(band, by = "instrument")

# Create band_2 data frame
band_2 <- data.frame(
  name = c("John", "George", "Ringo", "Paul", "Brian"), 
  band = c(FALSE, TRUE, TRUE, FALSE, TRUE)
)

# Perform various joins with band and band_2
band_new <- left_join(band, band_2, by = "name")
band_new <- right_join(band, band_2, by = "name")
band_new <- inner_join(band, band_2, by = "name")
band_new <- full_join(band, band_2, by = "name")

# Load data
bnames <- read.csv("bnames.csv", stringsAsFactors = FALSE)
births <- read.csv("births.csv", stringsAsFactors = FALSE)

# Join the two datasets
bnames <- left_join(bnames, births, by = c("year", "sex"))

# Create a new variable for the total number of births per name/sex/year
bnames <- bnames %>% 
  mutate(numbers = round(births * prop, 0))

# Summarize the data by name and sex
temp <- bnames %>%
  group_by(name, sex) %>%
  summarise(total = sum(numbers, na.rm = TRUE)) %>%
  ungroup() %>%
  data.frame()

# Sort the data
pop <- arrange(temp, desc(total))
pop_boy <- filter(pop, sex == "boy")[1, ]
pop_girl <- filter(pop, sex == "girl")[1, ]

# Use pipe operator to process data for boys (change "boy" to "girl" for girl results)
bnames %>%
  left_join(births, by = c("year", "sex", "births")) %>%
  filter(between(year, 1880, 2008)) %>%
  mutate(numbers = round(births * prop, 0)) %>%
  group_by(name, sex) %>%
  summarise(total = sum(numbers, na.rm = TRUE)) %>%
  group_by(sex) %>%
  reframe(max = max(total), name, total) %>%
  filter(total == max)


# Mapping data
borders <- read.csv("map_texas.csv", stringsAsFactors = FALSE)
ggplot(borders) + geom_point(mapping = aes(x = long, y = lat)) + coord_quickmap()
ggplot(borders) + geom_line(mapping = aes(x = long, y = lat)) + coord_quickmap()

ggplot(borders) + geom_polygon(mapping = aes(x = long, y = lat, group = group)) + coord_quickmap()

ggplot(borders) + geom_polygon(mapping = aes(x = long, y = lat, group = group, fill = pop)) +
  coord_quickmap() +
  scale_fill_distiller(palette = "Reds", direction = 1)

borders$bin <- cut(
  borders$pop,
  breaks = c(0, 1000, 10000, 100000, 901000, Inf),
  labels = c(
    "0-999",
    "1,000-9,999",
    "10,000-99,999",
    "100,000-900,999",
    "1,000,000+"
  )
)

ggplot(subset(borders, !is.na(bin))) +
  geom_polygon(mapping = aes(x = long, y = lat, group = group, fill = bin)) +
  coord_quickmap() +
  scale_fill_brewer(palette = "Oranges", direction = 1) +
  labs(title = "Population of Texas Counties", fill = "Population") +
  theme_void()

# Load US map data
library(maps)
us_map <- map_data("state")
data("USArrests")
us_arrest <- USArrests
us_arrest$region <- tolower(rownames(USArrests))
us_map <- left_join(us_map, us_arrest, by = "region")

ggplot(us_map) + geom_polygon(mapping = aes(x = long, y = lat, group = group, fill = Murder)) +
  coord_quickmap() + scale_fill_gradient(low = "white", high = "#e87500")

ggplot(us_map) + geom_polygon(mapping = aes(x = long, y = lat, group = group, fill = Assault)) +
  coord_quickmap() + scale_fill_gradient(low = "white", high = "#e87500")


