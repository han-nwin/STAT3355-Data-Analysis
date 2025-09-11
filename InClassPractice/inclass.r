# 1.
file <- read.csv("StudentsPerformance.csv", header=TRUE)  # header=TRUE means the first row of the CSV file contains column names
# You can check the column names by:
print(colnames(file))

# 2_a
print("Question 2")
head(file)
# 2_b
library(ggplot2)

# 3
print("Question 3")
numeric_vars <- c("math.score", "reading.score", "writing.score")

for (var in numeric_vars) {
  cat("Summary statistics for", var, ":\n")
  cat("Mean:", mean(file[[var]], na.rm=TRUE), "\n")
  cat("Median:", median(file[[var]], na.rm=TRUE), "\n")
  cat("Standard Deviation:", sd(file[[var]], na.rm=TRUE), "\n")
  cat("Minimum:", min(file[[var]], na.rm=TRUE), "\n")
  cat("Maximum:", max(file[[var]], na.rm=TRUE), "\n\n")
}

# 3_a: Sample data for numeric variables
sample_data <- file[sample(nrow(file), 5), numeric_vars]
print("Sample data for numeric variables:")
print(sample_data)
# 3_a: Calculate specific percentiles for numeric variables
print("3_a: ")
percentiles <- c(0.50, 0.90, 0.99)

for (var in numeric_vars) {
  cat("Percentiles for", var, ":\n")
  # Calculate specified percentiles (quantiles) for the given numeric variable
  # ie. 50 percent of math_score is below p_value
  p_values <- quantile(file[[var]], probs = percentiles, na.rm = TRUE)
  print(p_values)
  cat("\n")
}

# 4_a
print("Question 4_a")
# Convert "parental.level.of.education" to an ordered factor variable
education_levels <- c("some high school", "high school", "some college", "associate's degree", "bachelor's degree", "master's degree")

# check the column names
print(colnames(file))
file$parental.level.of.education <- factor(file$`parental.level.of.education`, ordered = TRUE)

# Print the structure and summary of the parental.level.of.education variable to check
head(file,10)

# 4_b
CheckAvgScore <- function(score_1, score_2, score_3, sub1, sub2, sub3) {
  p_value1 <- quantile(file[[sub1]], probs = 0.6, na.rm = TRUE)
  p_value2 <- quantile(file[[sub2]], probs = 0.6, na.rm = TRUE)
  p_value3 <- quantile(file[[sub3]], probs = 0.6, na.rm = TRUE)

  check_1 <- (score_1 > p_value1)
  check_2 <- (score_2 > p_value2)
  check_3 <- (score_3 > p_value3)

  total_true <- sum(check_1, check_2, check_3)
  return(total_true)
}
CheckAvgScore(1,2,100,'math.score', 'reading.score', 'writing.score')
  
# Using a for loop to apply the function row-wise
file$agg_score <- numeric(nrow(file))  # Initialize the agg_score column

for (i in 1:nrow(file)) {
  file$agg_score[i] <- CheckAvgScore(file$`math.score`[i], file$`reading.score`[i], file$`writing.score`[i], 'math.score', 'reading.score', 'writing.score')
}

# Print the first few rows to verify the new variable
head(file[c("math.score", "reading.score", "writing.score", "agg_score")], 20)

# 5_a
print("Question 5_a")
# Data set 1: Students with agg_score >= 2 (at least two scores above 60th percentile)
data_set1 <- subset(file, agg_score >= 2)

# Data set 2: Students with agg_score < 2 (less than two scores above 60th percentile)
data_set2 <- subset(file, agg_score < 2)

# Print to verify
head(data_set1, 20)
head(data_set2, 20)

# 6_a
