## Data Analysis Case Study : Changes in Fine Particle Air Pollution in the U.S.
#------------------------------------------------------------------------------

## This chapter presents an example data analysis looking at changes in fine particulate
#matter (PM) air pollution in the United States using the Environmental Protection
#Agencies

## Synopsis :
# In this chapter we aim to describe the changes in fine particle (PM2.5) outdoor air
# pollution in the United States between the years 1999 and 2012. Our overall hypothesis
# is that out door PM2.5 has decreased on average across the U.S. due to nationwide
# regulatory requirements arising from the Clean Air Act. To investigate this hypothesis,
# we obtained PM2.5 data from the U.S. Environmental Protection Agency which is
# collected from monitors sited across the U.S. We specifically obtained data for the years
# 1999 and 2012 (the most recent complete year available). From these data, we found
# that, on average across the U.S., levels of PM2.5 have decreased between 1999 and 2012.
# At one individual monitor, we found that levels have decreased and that the variability
# of PM2.5 has decreased. Most individual states also experienced decreases in PM2.5,
# although some states saw increases.


## Reading the 1999 data first and we are skipping some commented lines in the beginning of the file and initially we do not read the header 

pm0 <- read.table("RD_501_88101_1999-0.txt",
                  comment.char = "#",
                  header = FALSE,
                  sep = "|",
                  na.strings = "")

dim(pm0) #28 columns with 117421 rows

# We then attach the column headers to the dataset and make sure that they are properly formated for R data frames.
cnames <- readLines("RD_501_88101_1999-0.txt", 1)
cnames <- strsplit(cnames, "|", fixed = TRUE)

## Ensure names are properly formatted
names(pm0) <- make.names(cnames[[1]])
head(pm0[, 1:13])

# The column we are interested in the Sample.Value column which contains the PM2.5 measurements. 
x0 <- pm0$Sample.Value
summary(x0)


## Missing values are a common problem with environmental data and so we check to se
#what proportion of the observations are missing (i.e. coded as NA).

## Are missing values important here?
mean(is.na(x0)) #0.1125608
#Because the proportion of missing values is relatively low (0.1125608), we choose to ignore missing values for now.

# Reading in the 2012 data in the same manner in which we read 1999 data 
pm1 <- read.table("RD_501_88101_2012-0.txt", 
                  comment.char = "#", 
                  header = FALSE, 
                  sep = "|", 
                  na.strings = "",
                  nrows = 1304290)

## We also set the column names (they are the same as the 1999 dataset) and extract the Sample.Value column from this dataset.

names(pm1) <- make.names(cnames[[1]])

## Since we will be comparing the two years of data, it makes sense to combine them into a single data frame
library(dplyr)
pm <- rbind(pm0, pm1)


# Creating a factor variable indicating which year the data comes from. We also rename the Sample.Value variable to a more sensible PM. 
pm <- mutate(pm, year = factor(rep(c(1999, 2012), c(nrow(pm0), nrow(pm1))))) %>%
        rename(PM = Sample.Value)


## Entire U.S. Analysis 
#----------------------

# In order to show aggregate changes in PM across the entire monitoring network, we can boxplots of all monitor values in 1999 and 2012. 
# Here we take the log of the PM values to adjust for the skew in the data. 

library(ggplot2)

## Take a random sample, because it is faster 
set.seed(2015)
idx <- sample(nrow(pm), 1000)

qplot(year, log2(PM), data = pm[idx, ], geom = "boxplot")


# From the raw boxplot, it seems that on average, the levels of PM in 2012 are lower than they were in 1999. Interestingly, there also 
# appears to be much greater variation in PM in 2012 than there was in 1999. We can make some summaries of the two year's worth data to 
# get at actual numbers.

with(pm, tapply(PM, year, summary))

## Interestingly, from the summary of 2012 it appears there are some negative values of
#PM, which in general should not occur. We can investigate that somewhat to see if there is anything we should worry about.
filter(pm, year == "2012") %>% summarize(negative = mean(PM < 0, na.rm = TRUE))


# There is a relatively small proportion of values that are negative, which is perhaps reassuring. 
#In order to investigate this a step further we can extract the date of each
#measurement from the original data frame. The idea here is that perhaps negative values
#occur more often in some parts of the year than other parts. However, the original data
#are formatted as character strings so we convert them to R's Date format for easier
#manipulation.

dates <- filter(pm, year == "2012")$Date
dates <- as.Date(as.character(dates), "%Y%m%d")

#We can then extract the month from each of the dates with negative values and attempt
#to identify when negative values occur most often.

missing.months <- month.name[as.POSIXlt(dates)$mon + 1]

tab <- table(factor(missing.months, levels = month.name))

round(100 * tab / sum(tab))

## From the table above it appears that bulk of the negative values occur in the first six
#months of the year (January-June). However, beyond that simple observation, it is not
#clear why the negative values occur. That said, given the relatively low proportion of
#negative values, we will ignore them for now.


## Changes in PM levels at an Individual Monitor
#---

#So far we have examined the change in PM levels on average across the country. One
#issue with the previous analysis is that the monitoring network could have changed in
#the time period between 1999 and 2012. So if for some reason in 2012 there are more
#monitors concentrated in cleaner parts of the country than there were in 1999, it might
#appear the PM levels decreased when in fact they didn't. In this section we will focus on a
#single monitor in New York State to see if PM levels at that monitor decreased from 1999
#to 2012.

#Our first task is to identify a monitor in New York State that has data in 1999 and 2012
#(not all monitors operated during both time periods). First we subset the data frames to
#only include data from New York (State.Code == 36) and only include the County.Code
#and the Site.ID (i.e. monitor number) variables.

sites <- filter(pm, State.Code == 36) %>% select(County.Code, Site.ID, year) %>% unique

#Then we create a new variable that combines the county code and the site ID into a single string.

sites <- mutate(sites, site.code = paste(County.Code, Site.ID, sep = "."))
str(sites)

##Finally, we want the intersection between the sites present in 1999 and 2012 so that we
#might choose a monitor that has data in both periods.

site.year <- with(sites, split(site.code, year))
both <- intersect(site.year[[1]], site.year[[2]])
print(both)

#Here (above) we can see that there are 10 monitors that were operating in both time
#periods. However, rather than choose one at random, it might best to choose one that
#had a reasonable amount of data in each year.

count <- mutate(pm, site.code = paste(County.Code, Site.ID, sep = ".")) %>%
   filter(site.code %in% both)


#Now that we have subsetted the original data frames to only include the data from the
#monitors that overlap between 1999 and 2012, we can count the number of observations
#at each monitor to see which ones have the most observations.

group_by(count, site.code) %>% summarize(n = n())


#A number of monitors seem suitable from the output, but we will focus here on County 63 and site ID 2008.

pmsub <- filter(pm, State.Code == 36 & County.Code == 63 & Site.ID == 2008)


#Now we plot the time series data of PM for the monitor in both years.
pmsub <- mutate(pmsub, date = as.Date(as.character(Date), "%Y%m%d"))
rng <- range(pmsub$PM, na.rm = TRUE)

par(mfrow = c(1, 2), mar = c(4, 5, 2, 1))

with(filter(pmsub, year == "1999"), {
   plot(date, PM, ylim = rng)
   abline(h = median(PM, na.rm = TRUE))
   })
 
with(filter(pmsub, year == "2012"), {
   plot(date, PM, ylim = rng)
   abline(h = median(PM, na.rm = TRUE))
   })

## From the plot above, we can that median levels of PM (horizontal solid line) have
#decreased a little from 10.45 in 1999 to 8.29 in 2012. However, perhaps more interesting
#is that the variation (spread) in the PM values in 2012 is much smaller than it was in 1999.
#This suggest that not only are median levels of PM lower in 2012, but that there are fewer
#large spikes from day to day. One issue with the data here is that the 1999 data are from
#July through December while the 2012 data are recorded in January through April. It
#would have been better if we'd had full-year data for both years as there could be some
#seasonal confounding going on.


## Changes in state-wide PM levels
#---------------------
#Although ambient air quality standards are set at the federal level in the U.S. and hence
#affect the entire country, the actual reduction and management of PM is left to the
#individual states. States that are not "in attainment" have to develop a plan to reduce PM
#so that that the are in attainment (eventually). Therefore, it might be useful to examine
#changes in PM at the state level.

#What we do here is calculate the mean of PM for each state in 1999 and 2012

mn <- group_by(pm, year, State.Code) %>% summarize(PM = mean(PM, na.rm = TRUE))
head(mn)

tail(mn)

#Now make a plot that shows the 1999 state-wide means in one "column" and the 2012
#state-wide means in another columns. We then draw a line connecting the means for
#each year in the same state to highlight the trend.

qplot(xyear, PM, data = mutate(mn, xyear = as.numeric(as.character(year))),
       color = factor(State.Code),
       geom = c("point", "line"))

#This plot needs a bit of work still. But we can see that many states have decreased the
#average PM levels from 1999 to 2012 (although a few states actually increased their levels).

