# Exercise 10.1

par(mfrow=c(3,3))

set.seed(779)
for(i in 1:9){
  hist(rnorm(25), probability=TRUE,main=paste("Histogram",i))
  curve(dnorm,add=TRUE,col="red",lwd=3)
}

par(mfrow=c(1,1))

# Exercise 10.2a

my.ozone<-airquality$Ozone[!is.na(airquality$Ozone) & airquality$Ozone>1]
length(my.ozone)

mean.1<-mean(my.ozone)
sd.1<-sd(my.ozone)

length(my.ozone)

set.seed(55789)
simulated.1<-rnorm(115,mean=mean.1,sd=sd.1)

qqplot(simulated.1,my.ozone)
lines(0:200,0:200,type="l",lwd=3,col="red")

# Exercise 10.2b

mean.2<-mean(log(my.ozone))
sd.2<-sd(log(my.ozone))

set.seed(8942)
simulated.2<-rnorm(115,mean=mean.2,sd=sd.2)

qqplot(exp(simulated.2),my.ozone)
lines(0:200,0:200,type="l",lwd=3,col="red")

# Exercise 10.3

doone <- function(){
  x <- sum(sample(1:6,2,replace=TRUE))
  y<-sum(sample(1:6,x,replace=TRUE))
  y
}

set.seed(457778) 
y.values<-replicate(1000,doone())
hist(y.values) 


