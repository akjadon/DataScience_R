#### Base Plotting System 
#------------------------

## The core plotting and graphics engine in R is encapsulated in the following packages:
#. graphics: contains plotting functions for the "base" graphing systems, including
#plot, hist, boxplot and many others.
#. grDevices: contains all the code implementing the various graphics devices, including
#X11, PDF, PostScript, PNG, etc.

# ?par - Parameter are set in this. 


## Simple Base Grahics
#---------------------
#---------------------

## Histogram
#------------
library(datasets)

# Draw a new plot on the screen device
hist(airquality$Ozone)

# Boxplot
#--------
# "~" is a formula in R >> y-axis ~ x-axis

# Transforming Month column to factor
airquality <- transform(airquality, Month = factor(Month))
boxplot(Ozone ~ Month, airquality, xlab = "Month", ylab = "Ozone (ppb)")

#The Boxplot shows interesting features. 
#First, the levels of ozone tend to be highest in July and August. Second, the variability of ozone is also highest in July and August.

#Scatterplot
#------------
with(airquality, plot(Wind, Ozone))
# It shows that when the Wind is more Ozone is getting reduced


## Some important Base Graphics Parameters 
#. pch: the plotting symbol (default is open circle)
#. lty: the line type (default is solid line), can be dashed, dotted, etc.
#. lwd: the line width, specified as an integer multiple
#. col: the plotting color, specified as a number, string, or hex code; the colors() function gives you a vector of colors by name
#. xlab: character string for the x-axis label
#. ylab: character string for the y-axis label


##The par() function is used to specify the global graphics parameters that affect all plots in
#an R session. These parameters can be overridden when they are specified as arguments
#to specific plotting functions.

#. las: the orientation of the axis labels on the plot
#. bg: the background color
#. mar: the margin size
#. oma: the outer margin size (default is 0 for all sides)
#. mfrow: number of plots per row, column (plots are filled row-wise)
#. mfcol: number of plots per row, column (plots are filled column-wise)

## Looking default parameters 
par("lty")
par("col")
par("pch")
par("bg")
par("mar")
par("mfrow")

## Base Plotting Functions 
#-------------------------
# The most basic base plotting function is plot(), this makes scatterplot, or other type of plot depending on the class of object being
# plotted. 

## Some key annotation functions are
#. lines: add lines to a plot, given a vector of x values and a corresponding vector of y values (or a 2-column matrix); this function 
# just connects the dots
#. points: add points to a plot
#. text: add text labels to a plot using specified x, y coordinates
#. title: add annotations to x, y axis labels, title, subtitle, outer margin
#. mtext: add arbitrary text to the margins (inner or outer) of the plot
#. axis: adding axis ticks/labels


library(datasets)

# Make the initial plot
with(airquality, plot(Wind, Ozone))

# Add a title
title(main = "Ozone and Wind in New York City")


# Plotting and adding the title as well
with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City"))
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue")) #May with Blue color


#Notice below that when constructing the initial plot, we use the option type = "n" in the call
#to plot(). This is a common paradigm as plot() will draw everything in the plot except
#for the data points inside the plot window. Then you can use annotation functions like
#points() to add data points.

with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City", type = "n"))
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue"))
with(subset(airquality, Month != 5), points(Wind, Ozone, col = "red"))
legend("topright", pch = 1, col = c("blue", "red"), legend = c("May", "Other Months"))


## Base Plot with Regression Line 
#--------------------------------
# We can make regression line over scatterplot using lm() function
with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City", pch = 20)) #pch = 20 means filled circle

## Fit a simple linear regression model
model <- lm(Ozone ~ Wind, airquality)

## Draw regression line on plot
abline(model, lwd = 2)


## Multiple Base Plots 
#--------------------
# Making multiple plots side by side is a useful way to visualize many relationships
# between variables with static 2-D plots.

par(mfrow = c(1, 2)) #One Row and Two Columns
with(airquality, {
 plot(Wind, Ozone, main = "Ozone and Wind")
 plot(Solar.R, Ozone, main = "Ozone and Solar Radiation")
})


##The example below creates three plots in a row by setting par(mfrow = c(1, 3)). Here
#we also change the plot margins with the mar parameter. The various margin parameters,
#like mar, are specified by setting a value for each side of the plot. Side 1 is the bottom of
#the plot, side 2 is the left hand side, side 3 is the top, and side 4 is the right hand side.
#In the example below we also modify the outer margin via the "oma" parameter to create a
#little more space for the plots and to place them closer together.

par(mfrow = c(1, 3), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
with(airquality, {
   plot(Wind, Ozone, main = "Ozone and Wind")
   plot(Solar.R, Ozone, main = "Ozone and Solar Radiation")
   plot(Temp, Ozone, main = "Ozone and Temperature")
   mtext("Ozone and Weather in New York City", outer = TRUE) #Head description
   })
  
# mtext() function was used to create an overall title



