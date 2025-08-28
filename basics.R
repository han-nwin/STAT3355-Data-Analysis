digits <- 6
round(4.123123123, digits = digits)
digits

ceiling(79.0000001)
pi

sum.function = function(x,y=1) {
  return(x+y)
}

sum.function(1,3)

fun.1 <- function(x, y, z){
  # Multiply the first two inputs and then 
  # add the third
  # x: first input
  # y: second input
  # z: third input
  
  answer <- x*y + z
  return(answer)
}


fun.1 <- function(x, y, z = 0){
  # Multiply the first two inputs and then 
  # add the third
  # x: first input
  # y: second input
  # z: third input
  # z: default = 0
  
  answer <- x*y + z
  return(answer)
}


fun.1(x = 3, y = 4)


output <- fun.1(x = 3, y = 4)
output


fun.2 <- function(x,y) {
  print(x)
  plot(x,y)
}


output2 <- fun.2(x=1:5, y=1:5)
output2

distance <- function(a, b) {
  return abs(a-b)
}


