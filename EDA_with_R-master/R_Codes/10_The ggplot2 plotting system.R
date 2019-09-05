### The ggplot2 Plotting System : Part 1
#---------------------------------------

## Considered following plot 

with(airquality, {
  plot(Temp, Ozone)
  lines(loess.smooth(Temp, Ozone))
})

# There are some drawbacks of base system like :
# 1. You can't go back once the plot has started (e.g. to adjust margins), so there is in fact a need to plan in advance. 
# 2. It is difficult to translate a plot to others because there is no formal graphical language; each plot is just a series of R commands

## Here is the same plot made using ggplot2 

library(ggplot2)
ggplot(airquality, aes(Temp, Ozone)) + 
  geom_point() +
  geom_smooth(method = "loess", se = FALSE)

# Note that the outputs is equaivalent to that of base plot, but ggplot allows, but ggplot2
# allows for a more elegant way of expressing the components of the plot.

#The ggplot2 system essentially takes the good parts of both the base graphics and lattice
#graphics system. It automatically handles things like margins and spacing, and also has
#the concept of "themes" which provide a default set of plotting symbols and colors.


## The basics : qplot()
#------------

#The qplot() function in ggplot2 is meant to get you going quickly. It works much like
#the plot() function in base graphics system. It looks for variables to plot within a data
#frame, similar to lattice, or in the parent environment. In general, it's good to get used to
#putting your data in a data frame and then passing it to qplot().

##Plots are made up of aesthetics (size, shape, color) and geoms (points, lines). Factors play an
#important role for indicating subsets of the data (if they are to have different properties)
#so they should be labeled properly.


# It is very important to label the dataframe and the label should be informative and descriptive labels on your data. 
# More generally, your data should have appropriate metadata so that you can quickly look at a dataset and know 
# @ what the variables are 
# @ what the values of each variable mean 

## Some examples of ggpplot2 package 

# We are using mpg dataset which contains the fuel economy of 38 popular models for car from 1999 to 2008. 

library(ggplot2)
str(mpg) # We can see that all the factors variables are approriately coded with meaningful labels. 
# This will come in handy when we qplot() has to label different aspects of a plot. 

# We can make a quick scatterplot of the engine displacement(displ) and the highway per gallon(hwy)
qplot(displ, hwy, data = mpg)

## Modifying aesthetatics 
#---------------

# We can introduce a third variable into the plot by modifying the color of the points based on the value of that third variable. 
# Color is an aesthatic and the color of each point can be mapped to a variable. 

qplot(displ, hwy, data = mpg, color = drv)

# Now we can see that the front wheel drive tend to have lower displacement relative to the 4-wheel or rear wheel drive cars. 
# Also, it is clear that the 4-wheel drive cars have the lowest highway gas mileage. 

## Adding a geom 
# Sometimes it is nice to add a smoother to a scatterplot or highlight any trends. 
# Trends can be difficult to see if the data are very noisy or there are many data points obscuring the view. 
# A smooth is a geom that you can add along with your data points. 

qplot(displ, hwy, data = mpg, geom = c("point", "smooth"))

## Note that previously, we didn't have to specify geom = "point" because that was done
#automatically. But if you want the smoother overlayed with the points, then you need to
#specify both explicitly.

## Here it seems that engine displacement and highway mileage have a nonlinear U-shaped
# relationship

### Histograms 
#------------

# The qplot() function can be use to plot 1-dimensional data too. 
qplot(hwy, data = mpg, fill = drv, binwidth = 2)

#Having the different colors for each drive class is nice, but the three histograms can be a
#bit difficult to separate out. Side-by-side boxplots is one solution to this problem.

# Plotting boxplot for the same 
qplot(drv, hwy, data = mpg, geom = "boxplot")


## Another solution is to plot the histograms in seperate panels using facets. 

### Facets
#---------

# Facets are a way to create multiple panels of plots based on the levels of categorical variable.

#The facets argument expects a formula type of input, with a ~ separating the left hand
#side variable and the right hand side variable. The left hand side variable indicates how
#the rows of the panels should be divided and the right hand side variable indicates how
#the columns of the panels should be divided.

## Here, we just want three rows of histograms
# (and just one column), one for each drive class, so we specify drv on the left hand side
# and . on the right hand side indicating that there's no variable there (it's empty).

qplot(hwy, data = mpg, facets = drv ~ ., binwidth = 2)

# We can also plot scatterplots using facets, so instead of histrograms we could look at scatterplots of engine displacement 
# and highway mileage by drive class 

qplot(displ, hwy, data = mpg, facets = . ~ drv)

# We can add smoother to each of this plot
qplot(displ, hwy, data = mpg, facets = . ~ drv) + geom_smooth()

# We could have geom arguments to qplot() inside the qplot()
qplot(displ, hwy, data = mpg, facets = . ~ drv, geom = c("point", "smooth"))


#### Case Study :: MAACS Cohort
##-----------------------------
# This case study will use data based on the Mouse Allergen and Asthma Cohort Study (MAACS).
# This study was aimed at characterizing the indoor (home) environment and
# its relationship with asthma morbidity amonst children aged 5-17 living in Baltimore,
# MD. The children all had persistent asthma, defined as having had an exacerbation in
# the past year.

load(file = "maacs.Rda")

str(maacs) #750 observation with 5 variables 

#The key variables are:
#. mopos: an indicator of whether the subject is allergic to mouse allergen (yes/no)
#. pm25: average level of PM2.5 over the course of 7 days (micrograms per cubic meter)
#. eno: exhaled nitric oxide


#The outcome of interest for this analysis will be exhaled nitric oxide (eNO), which is a
#measure of pulmonary inflamation.


#We can get a sense of how eNO is distributed in this
#population by making a quick histogram of the variable. Here, we take the log of eNO
#because some right-skew in the data.

qplot(log(eno), data = maacs) #Histogram

#A quick glance suggests that the histogram is a bit "fat", suggesting that there might
#be multiple groups of people being lumped together. We can stratify the histogram by
#whether they are allergic to mouse.

qplot(log(eno), data = maacs, fill = mopos)

#We can see from this plot that the non-allergic subjects are shifted slightly to the left,
#indicating a lower eNO and less pulmonary inflammation. That said, there is significant overlap between the two groups.
#An alternative to histograms is a density smoother, which sometimes can be easier to
#visualize when there are multiple groups. Here is a density smooth of the entire study population.

qplot(log(eno), data = maacs, geom = "density")

## And here are the densities straitified by allergic status. We can map the color aesthetic to
#the mopos variable.

qplot(log(eno), data = maacs, geom = "density", color = mopos)

#These tell the same story as the stratified histograms, which should come as no surprise.
#Now we can examine the indoor environment and its relationship to eNO. Here, we use
#the level of indoor PM2.5 as a measure of indoor environment air quality.

qplot(log(pm25), log(eno), data = maacs, geom = c("point", "smooth"))

## The relationship appears modest at best, as there is substantial noise in the data.
#However, one question that we might be interested in is whether allergic individuals are
#prehaps more sensitive to PM2.5 inhalation than non-allergic individuals.

# We can stratify the data into two groups using different shapes 
qplot(log(pm25), log(eno), data = maacs, shape = mopos)


#Because there is substantial overlap in the data it is a bit challenging to discern the circles
#from the triangles. Part of the reason might be that all of the symbols are the same color(black).
#We can plot each group a different color to see if that helps.

qplot(log(pm25), log(eno), data = maacs, color = mopos)

#This is slightly better but the substantial overlap makes it difficult to discern any trends in
#the data. For this we need to add a smoother of some sort. Here we add a linear regression
#line (a type of smoother) to each group to see if there's any difference.

qplot(log(pm25), log(eno), data = maacs, color = mopos) + geom_smooth(method = "lm")


#Here we see quite clearly that the red group and the green group exhibit rather different
#relationships between PM2.5 and eNO. For the non-allergic individuals, there appears
#to be a slightly negative relationship between PM2.5 and eNO and for the allergic
#individuals, there is a positive relationship. This suggests a strong interaction between
#PM2.5 and allergic status, an hypothesis perhaps worth following up on in greater detail
#than this brief exploratory analysis.


#Another, and perhaps more clear, way to visualize this interaction is to use separate
#panels for the non-allergic and allergic individuals using the facets argument to qplot().

qplot(log(pm25), log(eno), data = maacs, facets = . ~ mopos) + geom_smooth(method = "lm")

## Summary : The qplot() function in ggplot2 is the analog of plot() in base graphics but with many
#built-in features that the traditionaly plot() does not provide. The syntax is somewhere
#in between the base and lattice graphics system.
