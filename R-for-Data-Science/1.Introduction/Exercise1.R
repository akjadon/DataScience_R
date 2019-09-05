# Exercise 1.1
exp(0-1/2)
exp(0+1/2)

x<-rnorm(1000)
y<-exp(x)

mean(y)

# Exercise 1.2
A<-1
B<-3
C<-1
options(digits=1)
my.vector<-c((-B+sqrt(B^2-4*A*C))/(2*A), (-B-sqrt(B^2-4*A*C))/(2*A))
my.vector

options(digits=6)
c(-0.4,-2.6)/my.vector-1

# Exercise 1.3
x <- rnorm(100, mean=.5, sd=.3)

mean(x)
sd(x)

hist(x)
hist(x,axes=FALSE,ylab="")
axis(1)
axis(4)
