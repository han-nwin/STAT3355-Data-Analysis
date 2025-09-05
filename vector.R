x <- 5
class(x) # numeric


x <- "5" # character
x <- as.numeric(x)
class(x) # numeric
x


x <- 3 == 5
x
class(x) # logical

vec1 <- c(5, 6, 7, 8, 9, 10)
vec1
vec1[4] # 1-idexing


vec1[2:5] # range 2 -> 5 ie 2, 3 ,4 ,5

vec2 <- 2:5
vec2
vec1[vec2]

vec3 <- 4:1000
vec4 <- vec3 %% 3 == 0 #vec4 = [True, False, False, True, ...]
vec3[vec4] # only numbers that has TRUE 
vec3[which(vec4)] # only indexes of numbers that has TRUE 


vec5 <- c("+", "-", "*", "/")
names(vec5) <- c("plus", "minus", "times", "division")
vec5


vec5[c("plus", "times")]

vec6 <- 76:230000
vec7 <- c(87, 43, 109, 230000)  

vec7 %in% vec6


vec7[vec7 %in% vec6]

which(vec7 %in% vec6)

vec8 <- c(1, 2, 3, 4, NA)
max(vec8, na.rm = TRUE)


whales_tx <- c(74, 122, 235, 111, 292, 111, 211, 133, 156, 79)
names(whales_tx) <- 1990:1999

length(whales_tx)

whales_fl <- c(89, 254, 306, 292, 274, 233, 294, 204, 204, 90)
names(whales_fl) <- names(whales_tx)

whales_fl - whales_tx

vec9 <- c(1,1,1,1,2,2,2,3)
unique(vec9)

letters #built in leters
LETTERS


# Enter data
commute <- c(17, 16, 20, 24, 18)

# Name data
names(commute) <- c("Mon", "Tue", "Wed", "Thu", "Fri")

# Find the total commute time
print(sum(commute))

# Find the day with greatest change
commute_diff <- diff(commute)
commute_diff
abs_ <- abs(commute_diff)
print(names(which.max(abs_))) 
# Use which.max to get the index of the max value, max would return the max value itself

seq(1, 10, length = 9)

rep(c(1, 2, 3), each = 3)
rep(c(1, 2, 3), times = 3)


paste("hello", "there")
vec10 <- 1:10
paste("a_", vec10, sep = "")
paste("a_", vec10, sep = "1")

vec11 <- 2:100
c(1, paste(1, "/", vec11, sep = ""))


Print_primes <- function(n){
  
  if(n %in% c(1, 2, 3)){
    return(1:n)
  }else{
    
    track <- NULL
    for(i in 1:n){
      if(sum(i %% 1:i == 0) == 2){
        track <- c(track, i)
      }else{
        next
      }
    }
  }
  
  return(c(track))
}

Print_primes(21)

vec12 <- c(1,paste(1,"/",vec11,sep=""))
for(i in vec12){
  
  if(i %in% c("1/5", "1/10", "1/13")){
    print(i)
  }
}


for(i in vec12[1:20]){
  
  if(i %in% c("1/5", "1/10", "1/13")){
    next
  }
  print(i)
}

for(i in 1:10){
  for(cat in 3:4){
    print(c(i, cat))
  }
}

i <- 0
while(i < 10){
  print(i)
  i <- i + 1
}

All_Primes <- function(n){
  if(n %in% c(2,3)){
    return(2:n)
  }else{
    
    track <- c()
    for(i in 1:n){
      if(sum(i%%1:i == 0) == 2){
        track <- c(track, i)
      }
    }
    
  }
  
  return(track)
}

  All_Primes_2 <- function(n) {
    if (n < 2) {
      return(integer(0))
    }
    if (n == 2) {
      return(2)
    }
    if (n == 3) {
      return(c(2, 3))
    }
    primes <- c(2, 3)
    for (i in 4:n) {
      is_prime <- TRUE
      limit <- floor(sqrt(i))
      for (j in 2:limit) {
        if (i %% j == 0) {
          is_prime <- FALSE
          break
        }
      }
      if (is_prime) {
        primes <- c(primes, i)
      }
    }
    return(primes)
  }

all_prim_n <- All_Primes(20)
all_prim_n
all_prim_2_n <- All_Primes_2(20)
all_prim_2_n
