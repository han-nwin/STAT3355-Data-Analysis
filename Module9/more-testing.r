pop_1 <- rgamma(100000, shape = 7, rate = 1/4)

# Pefrom a Z_test
x1 <- sample(pop_1, 67)
y1 <- sample(pop_1[pop_1 > median(x1)], 89)

par(mfrow = c(1, 2))
boxplot(x1)
boxplot(y1)

z <- (mean(x1) - mean(y1))/(sqrt(var(x1)/67 + var(y1)/89))

2*(1 - pnorm(abs(z)))


# Perfom a Z_test
x2 <- sample(pop_1, 67)
y2 <- sample(pop_1, 89)

par(mfrow = c(1, 2))
boxplot(x2)
boxplot(y2)

z <- (mean(x2) - mean(y2))/(sqrt(var(x2)/67 + var(y2)/89))

2*(1 - pnorm(abs(z)))



# Perfom a T_test
x3 <- sample(pop_1, 17)
y3 <- sample(pop_1[pop_1 > median(x3)], 9)

par(mfrow = c(1, 2))
boxplot(x3)
boxplot(y3)

t <- (mean(x3) - mean(y3))/(sqrt(var(x3)/17 + var(y3)/9))

2*(1 - pt(abs(t), df = 8))


# Perfom a T_test
x4 <- sample(pop_1, 17)
y4 <- sample(pop_1, 9)

par(mfrow = c(1, 2))
boxplot(x4)
boxplot(y4)

t <- (mean(x4) - mean(y4))/(sqrt(var(x4)/17 + var(y4)/9))

2*(1 - pt(abs(t), df = 8))


mat <- matrix(c(3, 1, 0, 4), nrow, ncol, byrow = TRUE)
nrow = dim(mat)[1]
ncol = dim(mat)[2]
e <- matrix(NA, nrow, ncol)
tstat = 0
for(i in 1:nrow){
  for(j in 1:ncol){
    e[i, j] <- (sum(mat[i, ])*sum(mat[, j]))/sum(mat)
    
    tstat = tstat + (mat[i, j] - e[i, j])^2/e[i, j]
  }
}

1 - pchisq(tstat, df = (nrow - 1)*(ncol - 1))





# Perform a Chi-Squared Test on population 2 verse 3 and 2 verse 4
pop_2 <- rbinom(100, size = 3, p = 0.3)
pop_3 <- rbinom(100, size = 4, p = 0.3)
pop_4 <- ifelse(pop_2 < 2, rbinom(1, 1, p = 0.2), rbinom(1,1, p = 0.9))


mat <- as.matrix(table(pop_2, pop_3))
#mat <- as.matrix(table(pop_2, pop_4))

nrow <- dim(mat)[1]
ncol <- dim(mat)[2]

nrow = dim(mat)[1]
ncol = dim(mat)[2]
e <- matrix(NA, nrow, ncol)
tstat = 0
for(i in 1:nrow){
  for(j in 1:ncol){
    e[i, j] <- (sum(mat[i, ])*sum(mat[, j]))/sum(mat)
    
    tstat = tstat + (mat[i, j] - e[i, j])^2/e[i, j]
  }
}

1 - pchisq(tstat, df = (nrow - 1)*(ncol - 1))





