## Exploratory Graphs
#--------------------

# Visualizing the data graphics can be important at the beginning stages of data analysis to understand basic properties of the data,
# to find simple patterns in data, and to suggest possible modelling strategies. 

# The goal of making exploratory graphs is usually developing a personal understanding of the data and to prioritize tasks for follow up.
# Details like axis orientation or legends, while present, are generally cleaned up and prettified if the graph is going to be used for 
# communication later. Often colour and plot symbol size are used to convey various dimensions of information.


## Data we will be using from the air pollutions data of united states, which coming from U.S.Environmental Protection Agency(EPA)
## One of the ambient air quality standards in the U.S. concerns the long-term average level of fine particle pollution, also referred
# to as PM2.5. Here, the standard says that the "annual mean, averaged over 3 years" can't exceed 12 micrograms per cubic meter. 

## One of the key question we are interested in "Are there any counties in the U.S. that exceed the national standard for fine particle 
#pollution?"

## Getting the data
#------------------
class <- c("numeric", "character", "factor", "numeric", "numeric")
pollution <- read.csv("avgpm25.csv", colClasses = class)

head(pollution) #First few rows of the data

str(pollution) #More information about the data
#576 rows having 5 variables


## Data Exploration :
#--------------------

#. Five-number summary: This gives the minimum, 25th percentile, median, 75th
#percentile, maximum of the data and is quick check on the distribution of the data
#(see the fivenum())
#. Boxplots: Boxplots are a visual representation of the five-number summary plus
#a bit more information. In particular, boxplots commonly plot outliers that go
#beyond the bulk of the data. This is implemented via the boxplot() function
#. Barplot: Barplots are useful for visualizing categorical data, with the number of
#entries for each category being proportional to the height of the bar. Think "pie
#chart" but actually useful. The barplot can be made with the barplot() function.
#. Histograms: Histograms show the complete empirical distribution of the data,
#beyond the five data points shown by the boxplots. Here, you can easily check
#skewwness of the data, symmetry, multi-modality, and other features. The hist()
#function makes a histogram, and a handy function to go with it sometimes is the
#rug() function.
#. Density plot: The density() function computes a non-parametric estimate of the
#distribution of a variables

#5 quadrants for pm25
fivenum(pollution$pm25)

summary(pollution$pm25) #For interactive work, summary function adds the mean of the data as well
# Mean is quite similar to median

#Boxplot - Anything that is stick out above and below the box have a length of 1.5 times the IQR is marked as an "outlier", 
#and is plotted seperately as an individual point
boxplot(pollution$pm25, col = "blue")

# From the boxplot we can see that there are few points on both the high and low end that appear to be outliers according to boxplot.
# From the plot, it appears that the high points are all above the level of 15, so we can take a look at those data points directly

library(dplyr)
filter(pollution, pm25 > 15)

# These countries are all in the western US(region == west) and in fact are all in California because the first two digits of the fips code are 06

# We can make a quick map of these countries to get a sense of where they are in california 

library(maps)
map("county", "california")
with(filter(pollution, pm25 > 15), points(longitude, latitude))

# Histogram - very useful if we want to see more detail on the full distribution of the data
hist(pollution$pm25, col = "green")

# Distribution is interesting because there appears to be a high concentration of counties in the neighbourhood of 9 to 12 micrograms
# per cubic meter. We can get little more detail with rug() function
hist(pollution$pm25, col = "green")
rug(pollution$pm25) # The large cluster of data points in the 9 to 12 is perhaps not surprising in this context. 


#There are still quite a few counties above the level of 12, which may be worth investigating.
hist(pollution$pm25, col = "green", breaks = 100) #Breaking into more detail
rug(pollution$pm25)

#Now we see that there is a large spike 9 microgram per cubic metre


## Overlaying Features 
#-----
# Once we start seeing interesting features in our data, it's often useful to lay down annotations on our plots as reference points are 
# markers. For e.x. in our boxplot above, we might want to draw a horizontal line at 12 where the national standard is. 

boxplot(pollution$pm25, col = "blue")
abline(h = 12) # We can see that the reasonable portion of the distribution as displayed by the boxplot is above the line. 


# Histogram is also a great choice to display abline 
hist(pollution$pm25, col = "green")
abline(v = 12, lwd = 2) #v - vertical
abline(v = median(pollution$pm25), col = "magenta", lwd = 2)



## Barplot - they are useful for summarizing categorical data. Here we have one categorical variable, the region in which a county resides
# (east or west). We can see how many western and eastern counties are there with barplot(). 

library(dplyr)
table(pollution$region) %>% barplot(col = "wheat")

# There are many counties in the eastern U.S. in this dataset than in the western U.S.

## Two dimensions and beyond - Simple summaries 
#---------------------------------------------
#Multiple or overlayed 1-D plots (Lattice/ggplot2): Using multiple boxplots or
#multiple histograms can be useful for seeing the relationship between two variables,
#especially when one is naturally categorical.
#.Scatterplots: Scatterplots are the natural tool for visualizing two continuous
#variables. Transformations of the variables (e.g. log or square-root transformation)
#may be necessary for effective visualization.
#. Smooth scatterplots: Similar in concept to scatterplots but rather plots a 2-D
#histogram of the data. Can be useful for scatterplots that may contain many many
#data points.


#For visualizing data in more than 2 dimensions, without resorting to 3-D animations (or
#glasses!), we can often combine the tools that we've already learned:
#  . Overlayed or multiple 2-D plots; conditioning plots (coplots): A conditioning
#plot, or coplot, shows the relationship between two variables as a third (or more)
#variable changes. For example, you might want to see how the relationship between
#air pollution levels and mortality changes with the season of the year. Here, air
#pollution and mortality are the two primary variables and season is the third
#variable varying in the background.
#. Use color, size, shape to add dimensions: Plotting points with different colors or
#shapes is useful for indicating a third dimension, where different colors can indicate
#different categories or ranges of something. Plotting symbols with different sizes
#can also achieve the same effect when the third dimension is continuous.
#. Spinning/interactive plots: Spinning plots can be used to simulate 3-D plots
#by allowing the user to essentially quickly cycle through many different 2-D
#projections so that the plot feels 3-D. These are sometimes helpful to capture
#unusual structure in the data, but I rarely use them.
#. Actual 3-D plots (not that useful): Actual 3-D plots (for example, requiring 3-
#                                                         D glasses) are relatively few and far between and are generally impractical for
#communicating to a large audience. Of course, this may change in the future with
#improvements in technology..


## Multiple Boxplots
#-------------------

# Side by side multiple boxplots
boxplot(pm25 ~ region, data = pollution, col = "red")


## Muliple Histograms 
#--------------------
# Similar to side by side boxplots and it is much useful to see the changes in distribution of a variable across different categories. 
par(mfrow = c(2, 1), mar = c(4, 4, 2, 1)) #mfrow shows the number of objects in row and column, while mar shows the margin
hist(subset(pollution, region == "east")$pm25, col = "green")
hist(subset(pollution, region == "west")$pm25, col = "green")


## Scatterplots 
#--------------
# For continous variables, most common visualization technique is the scatterplot.
with(pollution, plot(latitude, pm25))
abline(h=12, lwd = 2, lty = 5)

#As we go from south to north we can see that the highest level of pm2.5 tend to be in the middle region of the country


## Scatterplot - Using Color
#--------------------------

# Suppose if we want to add third dimension let say the region variable, we can use color

# Indicating east as black and west as red
with(pollution, plot(latitude, pm25, col = region))
abline(h=12, lwd = 2, lty = 5)

levels(pollution$region) #East - Black and West - Red

  
## Multiple Scatterplots 
#-----------------------
#Using multiple scatterplots can be necessary when overlaying points with different
#colors or shapes is confusing (sometimes because of the volume of data).

par(mfrow = c(1, 2), mar = c(5, 4, 2, 1))
with(subset(pollution, region == "west"), plot(latitude, pm25, main = "West"))
with(subset(pollution, region == "east"), plot(latitude, pm25, main = "East"))


#These kinds of plots, sometimes called panel plots, are generally easier to make with
#either the lattice or ggplot2 system, which we will learn about in greater detail in later
#chapters..
## Lattice
library(lattice)
xyplot(pm25 ~ latitude | region, data = pollution)

## ggplot2
library(ggplot2)
qplot(latitude, pm25, data = pollution, facets = . ~ region)



## Creating plots with file devices
#----------------------------------

pdf(file = "myplot.pdf") #Open pdf device, create file in work directory

with(faithful, plot(eruptions, waiting)) #Create plot and send it to a file 

title(main = "Old faithful Geyser Data") #Add title 

dev.off() #Close the pdf file device


#Graphics File Devices
#There are two basic types of file devices to consider: vector and bitmap devices. Some of
#the key vector formats are
#. pdf: useful for line-type graphics, resizes well, usually portable, not efficient if a
#plot has many objects/points
#. svg: XML-based scalable vector graphics; supports animation and interactivity,
#potentially useful for web-based plots
#. win.metafile: Windows metafile format (only on Windows)
#. postscript: older format, also resizes well, usually portable, can be used to create
#encapsulated postscript files; Windows systems often donâ???Tt have a postscript
#viewer
  

#Some examples of bitmap formats are
#. png: bitmapped format, good for line drawings or images with solid colors, uses
#lossless compression (like the old GIF format), most web browsers can read this
#format natively, good for plotting many many many points, does not resize well
#. jpeg: good for photographs or natural scenes, uses lossy compression, good for
#plotting many many many points, does not resize well, can be read by almost any
#computer and any web browser, not great for line drawings
#. tiff: Creates bitmap files in the TIFF format; supports lossless compression
#. bmp: a native Windows bitmapped format


dev.cur() #To check the currently active graphics device

dev.copy() #Used to copy a plot from one device to another 


## Copy the plot 
library(datasets)

## Create plot on screen device
with(faithful, plot(eruptions, waiting))

## Add a main title
title(main = "Old Faithful Geyser data")

## Copy my plot to a PNG file
dev.copy(png, file = "geyserplot.png")

## Don't forget to close the PNG device!
dev.off()



