# Manipulating data vs working with data
log.airquality<-log(airquality)
summary(log.airquality)

# sapply() and lapply()
my.summary<-function(x){data.frame(Min=min(x,na.rm=TRUE),
                                   Median=median(x,na.rm=TRUE),
                                   Mean=mean(x,na.rm=TRUE),
                                   Max=max(x,na.rm=TRUE))}

sapply(airquality,my.summary)

# tapply(), aggregate(), and by()
set.seed(12345678)
dat<-data.frame(gender=gl(2,5, labels=c("Male", "Female")), height=rpois(10,7))
dat2<-data.frame(gender=dat$gender, tmt=factor(rep(c("active","placebo"), 5)), height=dat$height)

dat

tapply(dat$height, dat$gender, mean)
aggregate(height~gender, data=dat, mean)
by(dat$height, dat$gender, mean)

dat2

tapply(dat2$height, list(dat2$gender,dat2$tmt), mean)

aggregate(height~gender+tmt, data=dat2, mean)

by(dat2$height, list(dat2$gender, dat2$tmt), mean)

set.seed(9876)

# Run times
x<-rnorm(1000000)
y<-sample(1:1000,1000000,replace=T)
groups<-paste("group",1:1000)
my.data<-data.frame(data=rnorm(1000000),
                    group=sample(groups,1000000,replace=T))

time0<-Sys.time()
tapply(my.data$data,my.data$group,mean)
time1<-as.numeric(Sys.time()-time0)

time0<-Sys.time()
aggregate(data~group,mean,data=my.data)
time2<-as.numeric(Sys.time()-time0)

time0<-Sys.time()
by(my.data$data,my.data$group,mean)
time3<-as.numeric(Sys.time()-time0)

my.runtime<-data.frame(tapply=c(time1,time1/time1),
                        aggregate=c(time2,time2/time1),
                        by=c(time3,time3/time1))
rownames(my.runtime)<-c("Time elapsed:","Relative to tapply():")

my.runtime

# Attaching and detaching data
tapply(dat$height, dat$gender, mean)
attach(dat)
tapply(height, gender, mean)

detach(dat)

# Masking R objects
x1<-1:3
my.data<-data.frame(x1=4:6,x2=7:9)
attach(my.data)

cbind(x1,x2)

my.data2<-data.frame(x1=10:12,x2=13:15)
attach(my.data2)

cbind(x1,x2)

# R's search path
searchpaths()[1:3]

detach(my.data,my.data2)

# The with() function
x1<-1:3
my.data<-data.frame(x1=4:6,x2=7:9)
my.data2<-data.frame(x1=10:12,x2=13:15)
attach(my.data)
attach(my.data2)

sum.and.dif<-with(my.data,cbind(x1+x2,x1-x2))
sum.and.dif
cbind(x1+x2,x1-x2)

detach(my.data,my.data2)

# table() and xtabs()
my.table<-with(airquality,table(OzHi = Ozone > 80, Month))
my.table
my.table.2<-addmargins(my.table,1:2)
my.table.2

my.table.3<-prop.table(my.table,2)
my.table.3<-addmargins(my.table.3,1)
my.table.3

round(100*my.table.3)

DF <- as.data.frame(UCBAdmissions)
head(DF)

DF <- as.data.frame(UCBAdmissions)
head(DF)
mytable <- xtabs(Freq ~  Gender + Admit + Dept, data=DF)
ftable(mytable)

# Marginal table
margin.table(mytable,1:2)

prop.table(margin.table(mytable,1:2),1)

prop.table(margin.table(mytable,2:3),1)

prop.table(margin.table(mytable,c(1,3)),1)

DepA<-mytable[,,1]
ftable(DepA)
prop.table(DepA,1)

