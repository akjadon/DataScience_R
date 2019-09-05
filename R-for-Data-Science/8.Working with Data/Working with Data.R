# Data frames: adding and removing columns
dat <- data.frame(x=LETTERS[1:3], y=1:3)
dat  
dat[,1]
dat$x

dat$z <- dat$y^2
dat$name <- c("Cat", "Vic", "Osc")
dat$y<-NULL
dat

# Mergin data frames
dat1 <- data.frame(name=c("Cat", "Vic", "Osc"), age=c(9,7,4))

dat1

dat2 <- data.frame(names=c("Vic","Cat", "Osc"), gender=c("Male","Female","Male"))

dat2

dat <- merge(dat1, dat2, by.x="name", by.y="names")
dat

# Getting dimension and column info
df <- dat

df

names(df)

class(df$name)
class(df$age)

dim(df)
nrow(df)
ncol(df)

# Object structure
str(df)

head(airquality, 3)

tail(airquality, 3)

# The subset() function
head(airquality, 3)

datA <- airquality[airquality$Temp>80,c("Ozone","Temp")]

datA <- subset(airquality, Temp > 80, select = c(Ozone, Temp))
datB <- subset(airquality, Day == 1, select = -Temp)
datC <- subset(airquality, select = Ozone:Wind)

# The summary() function
summary(airquality$Wind)

summary(airquality)

summary(airquality)

# Missing values
colMeans(airquality)

is.na(NA)

s <- subset(airquality, !is.na(Ozone) )
colMeans(s)

mean(airquality$Ozone, na.rm=TRUE)

# Text manipulation
txt <- c("Hello, my",
         "name is",
         "anders."
         )

grep("name", txt)

grepl("name", txt)

sub("anders", "Anders", txt)

df <- data.frame(
    person.ID = 1:3,
    fruit =
    c("apple: 3  Orange : 9 banana:2",
      " Orange:1 Apple: 3  banana: 10",
      "banana: 3 Apple: 3  Orange : 04 "
      ))

df

# Regular expressions
pattern <- ".*orange[ :]*([0-9]*).*"
sub(pattern, "\\1", df$fruit, ignore.case=TRUE)

connStr <- paste(
    "Server=msedxeus.database.windows.net",
    "Database=DAT209x01",
    "uid=RLogin",
    "pwd=P@ssw0rd",
    "Driver={SQL Server}",
    sep=";"
    )
if(.Platform$OS.type != "windows"){
connStr <- paste(
    "Server=msedxeus.database.windows.net",
    "Database=DAT209x01",
    "uid=RLogin",
    "pwd=P@ssw0rd",
    "Driver=FreeTDS",
    "TDS_Version=8.0",
    "Port=1433",
    sep=";"
    )    
}
library(RODBC)

# Date and Time object
as.Date("2016-03-10")
as.POSIXct("2016-03-10 13:53:38 CET")

conn <- odbcDriverConnect(connStr)
df <- sqlQuery(conn, "SELECT TOP 2000 * FROM bi.sentiment")
class(df$Date)

mean(df$Date)
mean(df$Date+10)

mean(as.Date(df$Date))
mean(as.Date(df$Date)+10)

old.locale<-Sys.getlocale(category = "LC_TIME")
Sys.setlocale("LC_TIME", "English")

table(weekdays(df$Date))
table(months(df$Date))

Sys.setlocale("LC_TIME",old.locale)

close(conn)

