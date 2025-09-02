rm (list = ls())
# if else statement
x <- 8
if (x < 10) {
  print(3)
} else {
  if (x > 10) {
    print(87)
  } else {
    if (x == 10) {
      print(102)
    }
  }
}

# short-hand if-else
ifelse(x < 10,
       4, #if true
       8) #if false

# recursion
# Fibonacci recursion function
fibonacci <- function(n) {
  if (n <= 0) {
    return(0)
  } else if (n == 1) {
    return(1)
  } else {
    return(fibonacci(n - 1) + fibonacci(n - 2))
  }
}

# Example usage
fibonacci(10)

10 %% 3 # mod


is.even <- function(n) {
  return(n %% 2 == 0)
}

is.even(2)
