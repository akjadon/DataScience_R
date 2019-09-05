# Exercise 5.1
my.data.frame<-
  read.table("data.exercise5.1.dat",
             skip=1, header=T)
head(my.data.frame)

# Exercise 5.2
my.data.frame<-read.table("data.exercise5.2.dat",
                          skip=1,header=TRUE,
                          sep=";",dec=",")
head(my.data.frame)

# Exercise 5.3

read.csv2("Exercise 5.3.csv",na.strings="",skip=2)[,-1]

# Exercise 5.4a

f1<-file("Exercise 5.4a.txt", open="r")
my.names<-scan(f1,what="",nlines=1,skip=1)
my.data<-read.table(f1)
close(f1)

my.names<-paste(my.names[c(1,3,5)],my.names[c(2,4,6)])
names(my.data)<-my.names
my.data

# Exercise 5.4b
my.data<-list()	
my.names<-character(2)
f1<-file("Exercise 5.4b.txt", open="r")

my.names[1]<-scan(f1,what="",nlines=1,skip=1)
my.data[[1]]<-scan(f1,nlines=1)

my.names[2]<-scan(f1,what="",nlines=1)
my.data[[2]]<-matrix(scan(f1),nrow=4,byrow=T)

close(f1)

names(my.data)<-my.names
my.data
