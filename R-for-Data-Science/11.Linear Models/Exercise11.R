# Exercise 11.1

my.analysis<-lm(log(Ozone)~Solar.R+Wind+Temp,data=airquality[airquality>1,])

qqnorm(my.analysis$res)
sd.1<-sd(my.analysis$res)
lines((-3):3,((-3):3)*sd.1,type="l",lwd=3,col="red")

# Exercise 11.2

my.analysis<-lm(log(Ozone)~Solar.R+Wind+Temp+
                  Solar.R:Wind+Solar.R:Temp+Wind:Temp,
                data=airquality[airquality>1,])

summary(my.analysis)

drop1(my.analysis,test="F")

my.analysis<-update(my.analysis,~.-Solar.R:Wind)

summary(my.analysis)

drop1(my.analysis,test="F")

my.analysis<-update(my.analysis,~.-Wind:Temp)

summary(my.analysis)

drop1(my.analysis,test="F")

# Exercise 11.3a

library(glm2)
data(crabs)
head(crabs)

crab.data<-data.frame(satellite=1*(crabs$Satellites>0),width=crabs$Width)

my.analysis<-glm(satellite~width,family=binomial,data=crab.data)
my.analysis

# Exercise 11.3b
my.linear.predictor<-data.frame(
  prediction=predict(my.analysis,se.fit=TRUE)$fit,
  lower=predict(my.analysis,se.fit=TRUE)$fit-
    1.96*predict(my.analysis,se.fit=TRUE)$se.fit,
  upper=predict(my.analysis,se.fit=TRUE)$fit+
    1.96*predict(my.analysis,se.fit=TRUE)$se.fit)

# Exercise 11.3c
my.linear.predictor<-my.linear.predictor[order(crab.data$width),]

logistic<-function(x){exp(x)/(1+exp(x))}
my.predictor<-logistic(my.linear.predictor)

plot(sort(crab.data$width),my.predictor$prediction,type="l",
     xlab='width',ylab='p(satellite)')
lines(sort(crab.data$width),my.predictor$upper,type="l",lty=2)
lines(sort(crab.data$width),my.predictor$lower,type="l",lty=2) 

# Exercise 11.3d
summary(crab.data$width)

my.cut<-cut(crab.data$width,breaks=20+(0:5)*3) 

my.means<-tapply(crab.data$satellite,my.cut,mean) 

lines(20+(0:4)*3+1.5,my.means,type="p",pch=16) 

# Exercise 11.4

diabetes.data<-read.csv2("my.diabetes.data.csv")
new.diabetes.data<-read.csv2("my.new.diabetes.data.csv")

diabetes.data<-diabetes.data[,-1]
new.diabetes.data<-new.diabetes.data[,-1]

my.model<-"gender"
for(i in 2:17){my.model<-paste(my.model,"+",names(diabetes.data)[i])}
my.formula<-as.formula(paste("readmi_class~",my.model))
my.analysis<-glm(my.formula,family=binomial(link=logit),
                 data=diabetes.data)

my.linear.predictor<-c(predict(my.analysis,newdata=new.diabetes.data))

logistic<-function(x){exp(x)/(1+exp(x))}
predict.diabetes<-logistic(my.linear.predictor)

plot(density(predict.diabetes[new.diabetes.data$readmi_class=="YES"]),
     main="Fitted values",ylim=c(0,4))
lines(density(predict.diabetes[new.diabetes.data$readmi_class=="NO"]),lty=2)
