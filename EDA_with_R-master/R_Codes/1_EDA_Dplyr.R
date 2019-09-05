### EDA with R
library(tidyverse)

## Using city of chicago air pollution data can be downloaded from below link
# http://www.biostat.jhsph.edu/~rpeng/leanpub/rprog/chicago_data.zip


# Loading the data
chicago <- readRDS("chicago.rds")

dim(chicago) #6940 rows with 8 columns
str(chicago)

# Exploring the data
#-------------------

names(chicago)[1:3]

## Select function in dplyr
subset1 <- select(chicago, city:dptp) #Selecting first 3 columns
head(subset1) #Selecting first few rows

subset2 <- select(chicago, ends_with("2")) #Selecting columns which ends with 2
str(subset2)

subset3 <- select(chicago, starts_with("d")) #Selecting columns which starts with "d"
str(subset3)


## Filter function in dplyr
chic.f <- filter(chicago, pm25tmean2 > 30) #Filtering the records having "pm25tmean2 > 30
str(chic.f)


chic.f_1 <- filter(chicago, pm25tmean2 > 30 & tmpd > 80)
select(chic.f_1, date, tmpd, pm25tmean2) #Only 17 rows we got 


## Arrange function in dplyr
chicago_date <- arrange(chicago, date) #Arranging on the basis of date
head(select(chicago_date, date, pm25tmean2), 3) #First 3 rows
tail(select(chicago_date, date, pm25tmean2), 3) #Last 3 rows

chicago_date_desc <- arrange(chicago, desc(date)) #Arranging with descending order of dates
head(select(chicago_date_desc, date, pm25tmean2), 3) #First 3 rows
tail(select(chicago_date_desc, date, pm25tmean2), 3) #Last 3 rows

## Rename function in dplyr 
head(chicago[ , 1:5], 3)

chicago_rnm <- rename(chicago, dewpoint = dptp, pm25 = pm25tmean2) #Renaming few columns
head(chicago_rnm[ ,1:5], 3)

## Mutate function in dplyr
chicago_mutat <- mutate(chicago_rnm, pm25detrend = pm25 - mean(pm25, na.rm = TRUE)) #Creating a new column which is pm25 - mean of pm25
head(chicago_mutat)


## Transmute function drops all the non-transformed variables
head(transmute(chicago_rnm,
               pm10detrend = pm10tmean2 - mean(pm10tmean2, na.rm = TRUE),
               o3detrend = o3tmean2 - mean(o3tmean2, na.rm = TRUE))) 


## Group_by - This function is used to do the grouping 

# Creating a new column year
chicago_year <- mutate(chicago, year = as.POSIXlt(date)$year + 1900) 
head(chicago_year)

year <- group_by(chicago_year, year)
summarize(year, pm25 = mean(pm25tmean2, na.rm = TRUE),  
          o3 = max(o3tmean2, na.rm = TRUE), 
          no2 = median(no2tmean2, na.rm = TRUE))


## If we want to know what are the average levels of ozone(o3) and nitrogran dio oxide(no2) within quintiles of pm25. 

# Creating a categorical variable of pm25 divided into quintiles
qp <- quantile(chicago$pm25tmean2, seq(0, 1, 0.2), na.rm = TRUE)
chicago_qntile <- mutate(chicago, pm25_quint = cut(pm25tmean2, qp))

# Grouping the data frame by pm25_quint variable
quint <- group_by(chicago_qntile, pm25_quint)

#Finally we compute the mean of o3 and no2 within quintiles of pm25
summarize(quint, o3 = mean(o3tmean2, na.rm = TRUE), 
          no2 = mean(no2tmean2, na.rm = TRUE))


## "%>%" - Pipe function
#------

# Same above example in one syntax
mutate(chicago_rnm, pm25.quint = cut(pm25, qp)) %>%
  group_by(pm25.quint) %>%
  summarize(o3  = mean(o3tmean2, na.rm = TRUE),
            no2 = mean(no2tmean2, na.rm = TRUE))

# Average Pollutant by month
mutate(chicago_rnm, month = as.POSIXlt(date)$mon + 1) %>%
   group_by(month) %>%
   summarize(pm25 = mean(pm25, na.rm = TRUE),
               o3 = max(o3tmean2, na.rm = TRUE),
               no2 = median(no2tmean2, na.rm = TRUE))




