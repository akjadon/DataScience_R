## Plotting and Color in R
#-------------------------

# The default color scheme in R is horrendous, but we can use specification to handle color but for that we should know how it works

# Colors 1,2 and 3
#--
#Quite often, with plots made in R, you'll see something like the following Christmasthemed plot

set.seed(19)
x <- rnorm(30)
y <- rnorm(30)

plot(x, y, col = rep(1:3, each = 10), pch =19)
legend("bottomright", legend = paste("Group", 1:3), col = 1:3, pch = 19, bty = "n")

# Black is denoted by 1, red by 2 and green by 3

## Another set of color scheme used in R, this time via the image() function
par(mfrow = c(1,2))  
image(volcano, col = heat.colors(10), main = "heat.colors()")
image(volcano, col = topo.colors(10), main = "topo.colors()")


## Connecting colors with data

# It is very important to choose right color for the right plot to display different dimensions 


## Color Utilities with Data
#----------------------------

# R has a number of utilities for dealing with colors and color palettes in your plots. For
# starters, the grDevices package has two functions

# colorRamp: Take a palette of colors and return a function that takes values between
# 0 and 1, indicating the extremes of the color palette (e.g. see the gray() function)

# colorRampPalette: Take a palette of colors and return a function that takes integer
# arguments and returns a vector of colors interpolating the palette (like
# heat.colors() or topo.colors())

## colorRamp()
##------------

# Imagine you are painter and you have Red and Blue color, which you can use to mix and make different colore. So ColorRamp and 
# ColorRampPalette() does that

# Let's start with "red" and "blue" colors and pass them to colorRamp()

pal <- colorRamp(c("red", "blue"))
pal(0) # It gives a function of colors 

## blue
pal(1)

#purple-ish
pal(0.5)


# We can also pass a sequence of number to pal function
pal(seq(0,1, len=10))


## The idea here is that colorRamp() gives you a function that allows you to interpolate
#between the two colors red and blue. You do not have to provide just two colors in your
#initial color palette; you can start with multiple colors and colorRamp() will interpolate
#between all of them.

## colorRampPalette()
##------------------

#The colorRampPalette() function works in manner similar to colorRamp((), however the
#function that it returns gives you a fixed number of colors that interpolate the palette.

pal <- colorRampPalette(c("red", "yellow"))

#now, the pal() function takes an integer argument specifing the number of interpolated colors to return.

## Just return red and yellow
pal(2)


#Note that the colors are represented as hexadecimal strings. After the # symbol, the first
#two characters indicate the red amount, the second two the green amount, and the last
#two the blue amount. Because each position can have 16 possible values (0-9 and A-F),
#the two positions together allow for 256 possibilities per color. In this example above,
#since we only asked for two colors, it gave us red and yellow, the two extremes of the
#palette.  


## Return 10 colors in between red and yellow
pal(10)

#You'll see that the first color is still red ("FF" in the red position) and the last color is
#still yellow ("FF" in both the red and green positions). But now there are 8 more colors
#in between.

#Note that the rgb() function can be used to produce any color via red, green, blue
#proportions and return a hexadecimal representation.

rgb(0, 0, 234, maxColorValue = 255)


### RColorBrewer Package - 
#-----------------------

#RColorBrewer packge offers three types of palettes
# Sequential: for numerical data that are ordered
# Diverging: for numerical data that can be positive or negative, often representing deviations from some norm or baseline
# Qualitative: for qualitative unordered data

#All of these palettes can be used in conjunction with the colorRamp() and colorRampPalette().

library(RColorBrewer)
display.brewer.all()


### Using the RColorBrewer palettes
#----------------------------------

#The only real function in the RColorBrewer package is the brewer.pal() function which
#has two arguments
#. name: the name of the color palette you want to use
#. n: the number of colors you want from the palette (integer)


#BuGn" palette, which is a sequential palette
cols <- brewer.pal(3, "BuGn")
cols

pal <- colorRampPalette(cols) #Passing above palettes to coloramppalett

# Plotting Volcano using pal
image(volcano, col = pal(20)) #Continous ordered, numerical data for which sequential plaette is appropriate


## The smoothScatter() function
#------------------------------

#A function that takes advantage of the color palettes in RColorBrewer is the smooth-
#Scatter() function, which is very useful for making scatterplots of very large datasets.
#The smoothScatter() function essentially gives you a 2-D histogram of the data using a
#sequential palette (here "Blues").

set.seed(1)
x <- rnorm(10000)
y <- rnorm(10000)
smoothScatter(x, y)


## Adding transparency
##-----------------------

##Color transparency can be added via the alpha parameter to rgb() to produce color
#specifications with varying levels of transparency

rgb(1, 1, 0, 0.1) #0.1 is tranparency
#Transparency can be useful when you have plots with a high density of points or lines.

set.seed(2)
x <- rnorm(2000)
y <- rnorm(2000)
plot(x, y, pch = 19) #Lots of overplotted points with no transparency

plot(x, y, pch = 19, col = rgb(1, 0.2, 0, 0.15)) ## Having Transparency







