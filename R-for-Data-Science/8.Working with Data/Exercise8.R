# Exercise 8.1

data.frame.x<-data.frame(names=c("Gretha","Robert","John","Heather"),
                         age=c(30,18,25,70),
                         nickname=c("Quicksilver","The Man","Nifty","Starlight"))
data.frame.y<-data.frame("Person_name"=c("William","Nancy","Charlotte","Henry"),
                         age=c(15,75,32,51),
                         "pet_dog"=c("King","Whity","Captain Vom","Doggie"))
data.frame.x
data.frame.y

merge(data.frame.x,data.frame.y)
merge(data.frame.y,data.frame.x)

data.frame.z<-merge(data.frame.y,data.frame.x,
                    by.x=c("Person_name","age"),
                    by.y=c("names","age"),all=TRUE)
data.frame.z

# Exercise 8.2

names(iris)
levels(iris$Species)
median(iris$Sepal.Length)

setosa.data<-subset(iris, 
                    Species == "setosa" & Sepal.Length<median(Sepal.Length),
                    select = -Species) 

summary(setosa.data)

# Exercise 8.3
my.text<-"Over the last decade, bluetongue virus have spread northwards from the mediterranean area. Initially this was ascribed to climate changes, but it has since been realized that a major contributing factor has been new transmitting vectors, culicoides obsoletus and culicoides pulicaris, which have the ability to aquire and transmit the disease. Recently, schmallenberg virus has emerged in northern europe, transmitted by biting midges as well."

my.lowercase<-c("bluetongue","culicoides","europe","mediterranean",
                "northern","schmallenberg")
my.uppercase<-c("Bluetongue","Culicoides","Europe","Mediterranean",
                "Northern","Schmallenberg")

my.new.text<-my.text
for(i in 1:length(my.lowercase)){
  my.new.text<-gsub(my.lowercase[i],my.uppercase[i],my.new.text)
}

my.new.text

# Exercise 8.4
Set.seed(885)
my.posixct<-as.POSIXct(sample((60*60*24*365*50):(60*60*24*365*55),20), origin = as.Date("1960-01-01"))

my.posixct

2*60*60+30*60+10

my.posixct2<- my.posixct+9010

head(data.frame(my.posixct,my.posixct2))
