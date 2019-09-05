# set.seed() function
set.seed(123)
rnorm(3)
set.seed(456)
rnorm(3)

set.seed(123)
rnorm(3)

# Simulation examples
runif(5,min=1,max=2)

set.seed(499)

rnorm(5,mean=2,sd=1)

set.seed(297)

rgamma(5,shape=2,rate=1)

set.seed(823)

rbinom(5,size=100,prob=.3)

set.seed(771)

rmultinom(5,size=100,prob=c(.3,.2,.5))

# Monte carlo integration (miniature example)

set.seed(274)

f<-function(x)exp(2*cos(x-pi))
plot(f, 0, 2*pi, ylim=c(0,8), lwd=3)

plot(f, 0, 2*pi, ylim=c(0,8), lwd=3)
x<-runif(1000,0,2*pi)
y<-runif(1000,0,8)
mycol<-ifelse(y<f(x),'green','red')
points(x,y,col=mycol)

# Practical implementation
set.seed(368)

x<-runif(1000000,0,2*pi)
y<-runif(1000000,0,8)
phat.under<-mean(y<exp(2*cos(x-pi)))
phat.under*16*pi

f<-function(x){exp(2*cos(x-pi))}
integrate(f,0,2*pi)$value

# Binomial estimator - rbinom()
set.seed(439)

x <- rbinom(1,50,1/6)
phat <- x/50
phat
x <- rbinom(1,50,1/6)
phat <- x/50
phat
x <- rbinom(1,50,1/6)
phat <- x/50
phat

set.seed(153)

doone <- function(){
  x <- rbinom(1,50,1/6)
  p <- x/50
  p
}
p.sim<-replicate(1000,doone())
hist(p.sim,breaks=15)

# Normally distributed - rnorm()
set.seed(228)

x<-rnorm(1000)
plot(density(x),xlim=c(-8,16))

set.seed(228)

x<-rnorm(1000)
plot(density(x),xlim=c(-8,16))
y<-rnorm(1000,mean=8)
lines(density(y),col="blue")

set.seed(228)

x<-rnorm(1000)
plot(density(x),xlim=c(-8,16))
y<-rnorm(1000,mean=8)
lines(density(y),col="blue")
lines(density(rnorm(1000,sd=2)),col="red")
lines(density(rnorm(1000,mean=8,sd=2)),col="green")

set.seed(228)

x<-rnorm(1000)
plot(density(x),xlim=c(-8,16))
y<-rnorm(1000,mean=8)
lines(density(y), col="blue")
lines(density(rnorm(1000,sd=2)),col="red")
lines(density(rnorm(1000,mean=8,sd=2)),col="green")
lines(density(rnorm(1000,sd=4)),col="purple")
lines(density(rnorm(1000,mean=8,sd=4)),col="cyan")

# Simulation of complex systems

my.text<-"time.ants<-0
          at.anthill<-rep(TRUE,3)
          done.all<-0
          done<-rep(0,3)
          food<-c(rpois(8,lambda=10),0,0)
          site<-c(10,10,10)
          carry<-c(0,0,0)
          visited.sites<-list(numeric(0),numeric(0),numeric(0))
          total.visited.sites<-rep(0,3)"
writeLines(my.text,con="initialize.txt")

my.text2<-"
while(!done.all){
  time.ants<-time.ants+1
  at.anthill<-(site==10)
  done.all<-prod(done)
  done<-ifelse(done,1,
         ifelse(total.visited.sites==8,1,0))
   for(i in 1:3){
     carry[i]<-ifelse(food[site[i]]>0,1,0)
     food[site[i]]<-ifelse(carry[i],food[site[i]]-1,0)
     if(!at.anthill[i] & !carry[i]){
     visited.sites[[i]]<-unique(c(visited.sites[[i]],site[i]))
     total.visited.sites[i]<-length(visited.sites[[i]])}
   }
  site<-ifelse(done,10,
         ifelse(carry,10,
           ifelse(at.anthill,sample(1:8,3,replace=T),
             site+(-1)^rbinom(3,1,0.5))))
  site[site==9]<-1
  site[site==0]<-8}"
writeLines(my.text2,con="loop.txt")

set.seed(996)

total.time<-numeric(100)
for(k in 1:100){
source("initialize.txt")
source("loop.txt")
total.time[k]<-time.ants
}

hist(total.time); box()


