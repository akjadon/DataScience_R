# Exercise 9.1
names(presidents)
presidents  

tapply(presidents,cycle(presidents),mean,na.rm=T)

# Exercise 9.2

summary(airquality$Wind)

my.cut<-cut(airquality$Wind,breaks=2*(1:11)-1)
tapply(airquality$Solar.R,my.cut,mean,na.rm=TRUE)

# Exercise 9.3

summary(swiss)

my.cut2<-cut(swiss$Agriculture,breaks=10*(0:10))
my.cut3<-cut(swiss$Catholic,breaks=10*(0:10))

tapply(swiss$Fertility,list(my.cut2,my.cut3),mean,na.rm=TRUE)

