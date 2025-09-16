mpg <- read.table("/Users/han/Desktop/GitHub/STAT3355-Data-Analysis/Practice 2/auto-mpg.data", header = FALSE)

# Assign column names based on the auto-mpg dataset documentation
colnames(mpg) <- c("mpg", "cylinders", "displacement", "horsepower", "weight", "acceleration", "year", "origin", "car_name")

# Problem 1
# Find index which corresponds to the year of 1971 (year column stores year as 71 for 1971)
index <- which(mpg$year == 71)
mean(mpg$mpg[index])

# Problem 2
sum(mpg$origin == 1) / length(mpg$origin)

