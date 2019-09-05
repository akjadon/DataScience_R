# Exercise 3.1a

negative<-(min(my.data[i,])<0)
count.negatives<-count.negatives + negative

count.negatives<-0

for(i in 1:length(my.data[,1])){
  negative<-(min(my.data[i,])<0)
  count.negatives<-count.negatives+negative
  if(count.negatives<=3 & !negative){
    cat("The mean of row",i,"is",mean(my.data[i,]),"\n")
  }
  if(count.negatives<=3 & negative){
    cat("<Row",i,"contains negative values>\n")
  }
  if(count.negatives>3){
    cat("Too many negative values\n")
    break
  }
}

set.seed(1786)
data.exercise.3.1<-exp(matrix(rnorm(2000),nrow=100))
index1.temp<-sample(1:100,10)
index2.temp<-sample(1:20,10)
for(i in 1:10){
  data.exercise.3.1[index1.temp[i],index2.temp[i]]<--1
}

# Exercise 3.2
k<-10
y<-matrix(rnorm(k^2),nrow=k)
z<-0*y

#loop:
time1<-as.numeric(Sys.time())
for(i in 1:k){
  #loop:
  for(j in 1:k){
    z[i,j]<-y[i,j]^2
  }
}
time2<-as.numeric(Sys.time())
# using object form in R:
time3<-as.numeric(Sys.time())
# using object form in R:
z<-y^2
time4<-as.numeric(Sys.time())
# run time increase factor:
(time2-time1)/(time4-time3)

my.dimensions<-c(10,20,50,100,200,500,800,1000)
my.runtime.factors<-numeric(8)

r<-1
k<-my.dimensions[r]
y<-matrix(rnorm(k^2),nrow=k)
z<-0*y
time1<-as.numeric(Sys.time())
#loop:
for(i in 1:k){
  for(j in 1:k){
    z[i,j]<-y[i,j]^2
  }
}
time2<-as.numeric(Sys.time())
time3<-as.numeric(Sys.time())
# using object form in R:z<-y^2
time4<-as.numeric(Sys.time())
# run time increase factor:
my.runtime.factors[r]<-(time2-time1)/(time4-time3)


plot(my.dimensions^2,my.runtime.factors,
     log="xy",xlab="Number of operations")

# Exercise 3.3

k1<-10
k2<-100000
my.data<-as.data.frame(matrix(rnorm(k1*k2),nrow=k1))

mean1<-numeric(k2)
mean2<-numeric(k2)

for(i in 1:k2){
  mean1[i]<-mean(my.data[,i])
}

time1<-as.numeric(Sys.time())
for(i in 1:k2){
  mean1[i]<-mean(my.data[,i])
}
time2<-as.numeric(Sys.time())

time3<-as.numeric(Sys.time())
mean2<-sapply(my.data,mean)
time4<-as.numeric(Sys.time())

(time2-time1)/(time4-time3)

