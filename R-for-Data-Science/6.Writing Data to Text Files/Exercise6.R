# Exercise 6.1

set.seed(9007)
my.data<-data.frame(x=rnorm(10),y=rnorm(10)+5,z=rchisq(10,1))
additional.data<-data.frame(x=rnorm(3),y=rnorm(3)+5,z=rchisq(3,1))

write.table(my.data,"Exercise 6.1.txt",row.names=FALSE,
            col.names=FALSE)

write.table(additional.data,"Exercise 6.1.txt",row.names=FALSE,
            col.names=FALSE,append=T)

# Exercise 6.2
set.seed(45)
my.data<-data.frame(x=rnorm(10),y=rnorm(10),z=rnorm(10))

write.csv(my.data,"Exercise 6.2.csv")

# Exercise 6.3
my.data<-data.frame(a=LETTERS[1:5],b=1:5)
my.data
write.table(my.data,file="Exercise 6.3a.txt", sep=";",row.names=FALSE)

my.text<-"TITLE extra line\n2 3 5 7\n11 13 17 \nOne more line"
writeLines(my.text,con="Exercise 6.3b.txt")

# Exercise 6.4
set.seed(45)
my.data<-data.frame(x=rnorm(10),y=rnorm(10),z=rnorm(10))

save(my.data,file="Exercise 6.4.Rdata")
rm(my.data)
my.data

load("Exercise 6.4.Rdata")
head(my.data)
