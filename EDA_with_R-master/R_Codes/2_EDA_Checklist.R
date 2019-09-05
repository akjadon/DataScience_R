## EDA_ Checklist
#----------------

#1. Formulate your question
#2. Read in your data
#3. Check the packaging
#4. Run str()
#5. Look at the top and the bottom of your data
#6. Check your "n"s
#7. Validate with at least one external data source
#8. Try the easy solution first
#9. Challenge your solution
#10. Follow up

# 1. Formulating the question
#----------------------------

# We have to be more specific about the questions so the exploration will be narrowed it down to be as specific as possible

# We wil be using pollution data and focusing on specific questions :
# Which Countries in the US have the highest levels of ambient ozone pollution ?

# 2. Read in your data
#---------------------
# Downloading the data from below website 
#https://aqs.epa.gov/aqsweb/airdata/download_files.html

# We have downloaded hourly ozone data for year 2014

# It has 9,060,698 Rows, using readr package to load the data
library(readr)
ozone <- read_csv("hourly_44201_2014.csv", 
                  col_types = "iiiiinnccccccncncccicccc") #Here we have defined column type so that we can read it fast

names(ozone) <- make.names(names(ozone)) #Removing any spaces in columns

#3. Check the packaging
#----------------------
dim(ozone) #9060698 rows with 24 columns

#4. Run str()
#------------
str(ozone) # Structure of the data

#5. Look at the top and the bottom of your data
#----------------------------------------------

#Checking only few columns
##
head(ozone[, c(6:7, 10)])
tail(ozone[, c(6:7, 10)])

# It is necessary to check end of the dataframes to make sure there is not issue in data

#6. Check your "n"s
#-------------------

# We need to identify some landmarks before checking the numbers 

# Here we will check if the dataset contains the hourly data for the entire country. These will be our two lanfmarks for comparison.

# We have continous hourly data and to look we will explore Time.Local column
table(ozone$Time.Local) #Yes it is hourly data

# Checking Number of unique states where EPA monitors the ozone
select(ozone, State.Name) %>% unique %>% nrow ## 53 States

# Only 50 states are there in USA, checking all the states
unique(ozone$State.Name) #Washington, District of Columnbia, Puerto Rico and Country of Mexico are the extra states, they are part of the 
# U.S but not official states of the union, it seems okay.


#7. Validate with at least one external data source
#--------------------------------------------------
# Making sure your data matches something outside of the dataset is very important


#In the U.S. we have national ambient air quality standards, and for ozone, the current
#standard2 set in 2008 is that the "annual fourth-highest daily maximum 8-hr concentration,
#averaged over 3 years" should not exceed 0.075 parts per million (ppm).

# Let's take a look the hourly measurements of ozone. 
summary(ozone$Sample.Measurement) #From the summary we can see that the maximum hourly concentration is quite high but that in general, 
# the bulk of the distribution is far below 0.075.

# Checking the quantiles
quantile(ozone$Sample.Measurement, seq(0,1,0.1))

# We can see that the range of the distribution looks good, only less than 10% of the data are above 0.075 but this may be reasonable

#8. Try the easy solution first
#------------------------------

## Our original question was

## Which Counties in the United States have the highest levels of ambient ozone pollution?

# We will use a combination of State.Name and County.Name to check highest levels of ambient ozone pollutions

ranking <- group_by(ozone, State.Name, County.Name) %>%
  summarize(ozone = mean(Sample.Measurement)) %>%
  as.data.frame %>%
  arrange(desc(ozone))

head(ranking, 10)

# Out of 10 four counties are in California itself

tail(ranking, 10) #Puerto Rico has three Counties with lowest ozone

# Checking how many observations are there for "Clear Creek" county and State Name = "Colorado"
filter(ozone, State.Name == "Colorado" & County.Name == "Clear Creek") %>% nrow #6447 rows

# Some what close to 8760 = 24 * 365 (Number of hours multiply by days)
# Sometimes counties use alternate methods of measurement during the year so there may be "extra" measurements

# We can take a look how ozone varies through the year in the county by looking at monthly averages. 
# First we need to convert the date variable into a Date Class

ozone <- mutate(ozone, Date.Local = as.Date(Date.Local))

filter(ozone, State.Name == "Colorado" & County.Name == "Clear Creek") %>%
  mutate(month = factor(months(Date.Local), levels = month.name)) %>%
  group_by(month) %>%
  summarize(ozone = mean(Sample.Measurement))

## Few things stands out here. First, ozone appears to be higher in the summer months and lower in the winter months, 
## second March month is missing from the data

## Now, let's take a look at the lowest level counties Catano, Puerto Rico
filter(ozone, State.Name == "Puerto Rico" & County.Name == "Catano") %>% nrow #8038 rows

# Checking if anything funny is going on
filter(ozone, State.Name == "Puerto Rico" & County.Name == "Catano") %>%
   mutate(month = factor(months(Date.Local), levels = month.name)) %>%
  group_by(month) %>%
  summarize(ozone = mean(Sample.Measurement))

# We can see that the levels of ozone is quite low in this county

## 9. Challenge your solution
#----------------------------

# Easy solution seemed to work okay, However, it raised some issues. For e.x, some counties do not have measurements every month 
# We can shuffle the data to get more sense 
set.seed(123)
N <- nrow(ozone)
idx <- sample(N, N, replace = TRUE)
ozone2<- ozone[idx, ]
head(idx)

# Now we can construct the ranking of the counties based on this resampled data. 
ranking2 <- group_by(ozone2, State.Name, County.Name) %>%
  summarize(ozone = mean(Sample.Measurement)) %>%
  as.data.frame %>%
  arrange(desc(ozone))


# We can compare the top 10 counties from our original ranking and the top 10 counties from above ranking based on the resampled data
cbind(head(ranking, 10),
       head(ranking2, 10)) ## 2 states have have flipped and it suggest that the original rannking is somehwat stable


# We can also look at the bottom of the list as well
cbind(tail(ranking, 10), 
      tail(ranking2, 10)) # Only 1 county is different in both


# 10. Follow up questions
#------------------------

# Do you have the right data?
# Do you need other data ?
# Do you have the right question ?



