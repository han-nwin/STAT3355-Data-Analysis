mat1 <- matrix(1:12,3,4)
mat1

mat2 <- matrix(13:24, 3, 4, byrow = TRUE)
mat2

mat1 + mat2

mat1 * mat2  # Element-wise multiplication of two matrices mat1 and mat2

t(mat2)
#
# mat1 %% t(mat2)  # Element-wise modulo operation between mat1 and the transpose of mat2

mat3 <- matrix(c(1, 3, 7, 9), 2, 2)

e3 <- eigen(mat3)

e3$values
e3$vectors

mat4 <- matrix(c(1, "a", 7, 9), 2, 2)
mat4

rbind(mat3,mat4)  # Bind rows of mat3 and mat4 together, creating a new matrix by stacking mat4's rows below mat3's rows
rbind(mat4,mat3) 


cbind(mat3,mat4)  # Bind columns of mat3 and mat4 together, creating a new matrix by placing mat4's columns to the right of mat3's columns
cbind(mat4,mat3) 


colnames(mat3) <- c("col1", "col2")
rownames(mat3) <- c("row1", "row2")
mat3

mat3[1, 1]
mat3[1, 2]

mat3[1, ]
print('--------------')
mat3[, 1]


print('-------------------------------')
mat3[, 1, drop = FALSE]


print('-------------------------------')
mat4 <- matrix(runif(100), 20, 5)
mat4

mat4[1:3, 2:4] # matrix
print('return numeric')
mat4[, 1] # numeric
print('mantained as matrix below')
mat4[, 1, drop = FALSE] # maintained as a matrix



print('IN CLASS PROBLEM')

# Inputting whales data
whales_tx <- c(74, 122, 235, 111, 292, 111, 211, 133, 156, 79)
names(whales_tx) <- 1990:1999
whales_fl <- c(89, 254, 306, 292, 274, 233, 294, 204, 204, 90)
names(whales_fl) <- 1990:1999

# Create a whale matrix
whales <- rbind(whales_tx, whales_fl)       # rows = states, cols = years
whales <- cbind(whales_tx, whales_fl)       # cols = states (overwrites previous)

# Build with column names, then row names (showing both styles as in original)
whales <- cbind(whales_tx, whales_fl)
colnames(whales) <- c("texas", "florida")
rownames(whales)
whales <- rbind(whales_tx, whales_fl)
rownames(whales) <- c("texas", "florida")
colnames(whales)

whales

print('Nmber of whales in Floria in 1998')
whales["florida", "1998"]


print('Nmber of whales in Texas btw 1995-1998')
sum(whales["texas", as.character(1995:1998)])

print('Number of whales in Florida exclude 1998')
sum(whales["florida", -which(colnames(whales) == "1998")])


mat4 <- matrix(runif(100), 10, 10)
mat4

# Apply the median function to each column of mat4 (MARGIN=2 means apply it to columns)
print('apply')
apply(mat4, MARGIN = 2, median)

print('apply')

# Define a simple function that calculates the difference between median and mean of a vector
simp_func <- function(x){
  a1 <- median(x)
  a2 <- mean(x)
  
  return(a1 - a2)
}

# Apply simp_func to each row of mat4 (MARGIN=1 means rows)
apply(mat4, 1, simp_func)

# Get the dimensions of mat4 (number of rows and columns)
dim(mat4)

# Get the number of rows in mat4
dim(mat4)[1]

# Get the number of columns in mat4
dim(mat4)[2]

# Create a vector of letters a to e
x <- letters[1:5]

# Create a numeric vector 1 to 5
y <- 1:5

# Concatenate corresponding elements of x and y with an underscore separator
z <- paste(x, y, sep = "_")

# Create a data frame from vectors x, y, and z
df1 <- data.frame(x, y, z)
df1

df1[, 1]
df1[, 2]
df1[, 3]

df1 <- data.frame(col1 = x, col2 = y, col3 = z)
df1$col2  # Access the column named 'col2' from the data frame df1, returning its contents as a vector

nam_all <- c("col1", "col2", "col3")
for (i in nam_all) {
  print(df1$i)
}

df1[, c("col1", "col3")]

df2 <- data.frame(matrix(1:12, 4, 3, by = TRUE))
df2

print("l1")
l1 <- list("one" = x, "two" = y, "ten" = 4, mat2, df2)
l1


print('----ggplot2-----')
library(ggplot2)

# Example: Create a simple scatter plot using ggplot2

# Create a sample data frame
df <- data.frame(
  x = rnorm(100),
  y = rnorm(100),
  group = sample(c("A", "B"), 100, replace = TRUE)
)

# Basic scatter plot with color grouping
ggplot(df, aes(x = x, y = y, color = group)) +
  geom_point() +
  labs(title = "Scatter Plot Example",
       x = "X Axis",
       y = "Y Axis",
       color = "Group") +
  theme_minimal()

