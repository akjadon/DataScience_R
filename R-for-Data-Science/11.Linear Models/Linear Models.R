# Linear models example
set.seed(9876542)
X<-rchisq(100,df=1)
Y<-1+0.5*X+0.7*rnorm(100)

plot(X,Y,xlab='X',ylab='Y')
lines(sort(X),1+0.5*sort(X),lwd=3,col="red")

residuals.Y<-Y-(1+0.5*X)

f<-function(x){dnorm(x,sd=sd(residuals.Y))}
par(mfrow=c(1,2))
plot(X,residuals.Y)
hist(residuals.Y,probability=TRUE,ylim=c(0,0.7))
curve(f,col="red", lwd=3, add=TRUE)

# Fitting linear models - The lm() function
analysis<-lm(Y~X)
analysis

# my.formula<-formula(y~x+z+w)
# fit<-lm(my.formula)
# fit<-lm(y~0+x+z+w)
# fit<-lm(y~-1+x+z+w)

analysis<-lm(Y~X); par(mfrow=c(2,2)); plot(analysis)

analysis<-lm(Y~X)
names(analysis)

analysis$coef

analysis<-lm(Y~X)
summary(analysis)

analysis<-lm(Y~X)
names(summary(analysis))

summary(analysis)$sigma^2

# Modeling nonlinear relations with lm()
set.seed(448)
Y=20+5*X+40*X^2+35*rnorm(100)

plot(X,Y)
lines(sort(X),predict(lm(Y~X))[order(X)])

analysis<-lm(Y~X+I(X^2))
plot(X,Y)
lines(sort(X),predict(analysis)[order(X)],type="l" )

set.seed(28435)
my.data<-data.frame(Sex=c(rep("Male",50),rep("Female",50)), 
                    Age=runif(100,18,78))
my.data<-data.frame(my.data,
           Y= 1+0.5*(my.data$Sex=="Male")+0.2*my.data$Age+
              0.05*my.data$Age*(my.data$Sex=="Male")+ rnorm(100))

summary(my.data)

# Factors and interactions
plot(my.data$Age, my.data$Y,xlab='',ylab='Y',col=my.data$Sex)
legend(20,20,c("Female","Male"),col=1:2,pch=1)

analysis<-lm(Y~Age+Sex+Age:Sex,data=my.data)
drop1(analysis,test="F")

summary(analysis)

my.data2<-data.frame(my.data[order(my.data$Age),],
                     predicted=predict(analysis)[order(my.data$Age)])
with(my.data2,{
  plot(Age,Y,xlab='Age',ylab='Y',col=Sex)
  lines(Age[Sex=="Female"],predicted[Sex=="Female"],col=1,type="l")
  lines(Age[Sex=="Male"],predicted[Sex=="Male"],col=2,type="l")
  legend(20,20,c("Female","Male"),col=1:2,pch=1)
  })

# Formulas when transforming data into normality
set.seed(123456)
par(mfrow=c(1,2))
u<-runif(100,0,1)
y<-u*2+rnorm(100,sd=.3)
plot(exp(u*2),exp(y)-exp(u*2), xlab='Prediction', ylab='Residual', main="Raw data")
plot(u*2,y-(u*2), xlab='Prediction', ylab='Residual', main="Log transformed")

# Logistic regression example
mice<-data.frame(
  stillb=c(15, 17, 22, 38, 144),
  total=c(297, 242, 312, 299, 285),
  conc=c(0, 62.5, 125, 250, 500))
mice$resp <- cbind(mice$stillb,mice$total-mice$stillb)

mice.glm <- glm(resp ~ conc,
                family = binomial(link = logit), 
                data = mice)

options(useFancyQuotes = FALSE) 

summary(mice.glm)

p<-mice$stillb/mice$total
logit<-log(p/(1-p))
plot(mice$conc,logit, las=1, ylim=c(-3.5,0.1), xlab='Concentration', ylab="logit(still born fraction)")
abline(coef(mice.glm))

p<-mice$stillb/mice$total
plot(mice$conc,p, las=1, ylim=c(0,.6), xlab='Concentration', ylab="Still born fraction")
xx<-seq(0,max(mice$conc))
yy<-coef(mice.glm)[1]+coef(mice.glm)[2]*xx
lines(xx,exp(yy)/(1+exp(yy)))

mice.glm <- glm(formula = resp ~ conc,
                family = binomial(link = logit),
                data = mice
               )

# Application: Classification models

tempdata<-read.csv("Diabetes_Data _Clean_.csv")
tempdata2<-tempdata[,-c(21:25,28,30:33,36:40,44)]
tempdata3<-tempdata2[!tempdata2$gender=="Unknown/Invalid",]
tempdata3$gender<-as.factor(as.character(tempdata3$gender))
tempdata3<-tempdata3[tempdata3$race=="Caucasian",]
set.seed(545986)
sample<-sample(1:length(tempdata3[,1]),10000)
tempdata4<-tempdata3[sample,]
tempdata3<-tempdata3[-sample,]
diabetes.data<-tempdata3[,-c(1,6,9,15,16,19,20,22,23,24,26)]
new.diabetes.data<-tempdata4[,-c(1,6,9,15,16,19,20,22,23,24,26)]

dim(diabetes.data)
names(diabetes.data)

my.model<-"gender"
for(i in 2:17){my.model<-paste(my.model,
                               "+",
                               names(diabetes.data)[i])}
my.formula<-as.formula(paste("readmi_class~",my.model))

analysis<-glm(my.formula,
              family=binomial(link=logit),
              data=diabetes.data)

logit<-function(p){log(p/(1-p))}
fp<-numeric(99)
tp=numeric(99)
for(i in 1:99){
  predict.diabetes<-1*(predict(analysis,
                    newdata=new.diabetes.data)>logit(i/100))
  temp<-tapply(predict.diabetes,
               new.diabetes.data$readmi_class,
               mean)
  fp[i]<-temp[1]
  tp[i]<-temp[2]
  }

par(pty="s")
plot(sort(fp),tp[order(fp)],type="l",
     xlab='False Positive Rate',
     ylab='True Positive Rate')
lines(c(0,1),c(0,1),type="l",col="red")

set.seed(123456)
duration<-round(runif(100,0,4000))
tmt<-as.factor(rep(c(0,1), each=50))
sex<-as.factor(rep(c('M','F','M','F'), each=25))
X<-model.matrix(~-1+sex+tmt:duration)
y<-X%*%c(2.3,5,1/1000,3/1000)+rnorm(100,sd=.7)

filen<-"lm.dat"
cat("y\tsex\ttmt\tdur\n",file=filen)
write.table(cbind(round(y,2),sex,tmt,duration), row.names=FALSE, col.names=FALSE, append=TRUE, file=filen, sep="\t")

plot(y~duration, col=as.numeric(tmt), pch=as.numeric(sex))
legend('topleft', legend=c("F : Placebo", "M : Placebo", "F : Treatment", "M : Treatment"), pch=c(1,2,1,2), col=c(1,1,2,2), bty='n')

set.seed(123456)
bottom<-gl(4,5)
rates<-rep(c(9,12,5,5.5), each=5)
counts<-rpois(20,rates)
dat<-data.frame(bottom=bottom, counts=counts)

dat

fit<-glm(counts~bottom, family=poisson(link=log), data=dat)
drop1(fit, test="Chisq")
fit<-glm(counts~bottom-1, family=poisson(link=log), data=dat)
exp(coef(fit))
exp(confint(fit))

set.seed(123)

individual <- gl(50,2)
treatment <- gl(2,1,100,labels=c("before","after"))
y <- rnorm(50)[individual] + c(0.2,0)[treatment] + rnorm(100,sd=0.1)

plot(y,pch=16,col=unclass(individual))

set.seed(123)
logx <- runif(100,log(10),log(100))
loga<-log(0.00001)
b<-3.076
y<-b*logx+loga+rnorm(100,sd=.2)
W<-exp(y)
L<-exp(logx)
dat<-data.frame(W=round(W,3),L=round(L,2))
write.table(dat,file="snapper.dat", row.names=FALSE, quote=FALSE, sep="\t\t")

