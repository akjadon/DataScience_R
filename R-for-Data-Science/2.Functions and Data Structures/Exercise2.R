# Exercise 2.1

paste("R Session",1)

data.frame(x=1:3,y=4:6)+2

data.frame(x=1:3,y=4:6)+2

data.frame(x=1:3,y=c("A","B","C"))+2


# Exercise 2.2

my.standard<-function(x){(x-mean(x))/sd(x)}

# Exercise 2.3

f<-function(x){3*sin(x/2)+x}

f(0)
f(1)
f(pi)


f<-function(x){3*sin(x/2)+x}
curve(f,-7,7)
