## The ggplot2 Plotting System: Part2

# We wil here explore more of the nitty gritty of how ggplot2 build plots 

## Basic Components of a ggplot2 plot
#-----------------------------------
#. A data frame: stores all of the data that will be displayed on the plot
#. aesthetic mappings: describe how data are mapped to color, size, shape, location
#. geoms: geometric objects like points, lines, shapes.
#. facets: describes how conditional/panel plots should be constructed
#. stats: statistical transformations like binning, quantiles, smoothing.
#. scales: what scale an aesthetic map uses (example: male = red, female = blue).
#. coordinate system: describes the system in which the locations of the geoms will be drawn


## Example : BMI, PM2.5, Asthma
#--------------------------------

# We wil be using the same data as used in previous chapter, but we are interested in below question. 
#"Are overweight individuals, as measured by body mass index (BMI), more
#susceptible than normal weight individuals to the harmful effects of PM2.5
#on asthma symptoms?"

maacs <- read.csv("bmi_pm25_no2_sim.csv")

##There is a suggestion that overweight individuals may be more susceptible to the negative
#effects of inhaling PM2.5. This would suggest that increases in PM2.5 exposure in the
#home of an overweight child would be more deleterious to his/her asthma symptoms
#than they would be in the home of a normal weight child. We want to see if we can see
#that difference in the data from MAACS.

str(maacs)

# The outcome we will look at here, "NocturnalSymp", is the number of days in the past 2 weeks where the child experienced asthma symptoms

## Building up in layers 
#--

# First we will create a ggplot object that stores the dataset and the basic aesthetics for mapping the x and y coordinates for the plot. 
## Here we will eventually be plotting the log of PM 2.5 and NocturnalSymp variable

head(maacs)

g <- ggplot(maacs, aes(logpm25, NocturnalSympt))
summary(g)

class(g)
print(g) # Plot will come up but our object actually does not contains enough information to make plot yet.

## First Plot with Point Layer

g + geom_point()

# Data Appers rather noisy, it would be better to add smoother on top of the points to see if there is a trend in the data with PM2.5
g + geom_point() + geom_smooth()


# The default smoother is a loess smoother, which is flexible and nonparametric but might
#be too flexible for our purposes. Perhaps we'd prefer a simple linear regression line to
#highlight any first order trends.
g + geom_point() + geom_smooth(method = "lm")


#Here, we can see there appears to be a slight increasing trend, suggesting that higher
#levels of PM2.5 are associated with increased days with nocturnal symptoms.


## Adding more layers : Facets 
# We can stratify the scatterplot of PM2.5 and nocturnal symtoms by the BMI category 

g + geom_point(aes(color = bmicat)) + geom_smooth(method = "lm") +
  facet_grid(. ~ bmicat) +xlab("Log of pm2.5") +ylab("Nocturnal Smptoms") + ggtitle("Plot of Nocturnal Symptoms vs Lof of pm 2.5")

# Above xlab and ylab are used for x and y axis labels, ggtitles for specifying plot titles 
# labs() function is more generic and can be used to modify multiple types of lables at once. 

##Now it seems clear that the relationship between PM2.5 and nocturnal symptoms is
#relatively flat amongst normal weight individuals, while the relationship is increasing
#amongst overweight individuals. This plot suggests that overweight individuals may be
#more susceptible to the effects of PM2.5.


## For things that only make sense globally, use theme(), i.e. theme(legend.position =
#"none"). Two standard appearance themes are included
#. theme_gray(): The default theme (gray background)
#. theme_bw(): More stark/plain


## Modifying Geom Properties
# We can modify properties of geoms by specifying options to their respective geoms_* functions. 
# For e.x. below we modify the points in the scatterplot to make the color "steelblue", the size larger, and the alpha, and the alpha
# transparency greater. 

g + geom_point(color = "steelblue", size = 4, alpha = 1/2)

# We even can map aesthatic color to variable as well, for this we have to use aes 
g + geom_point(aes(color = bmicat), size = 4, alpha = 1/2)


## Modifying Labels

# Below is an example of modifying the title and the x and y labels to make the plot a bit more informative 

g + geom_point(aes(color = bmicat)) +
  labs(title = "MAACS Cohort") +
  labs(x = expression("log " * PM[2.5]), y = "Nocturnal Symptoms")


## Customizing the smooth

#We can also customize aspects of the smoother that we overlay on the points with geom_-
#smooth(). Here we change the line type and increase the size from the default. We also
#remove the shaded standard error from the line.

g + geom_point(aes(color = bmicat), size = 2, alpha = 1/2) +
  geom_smooth(size = 4, linetype = 3, method = "lm", se = FALSE)


## Changing the themes 

#The default theme for ggplot2 uses the gray background with white grid lines. If you
#don't find this suitable, you can use the black and white theme by using the theme_bw()
#function. The theme_bw() function also allows you to set the typeface for the plot, in case
#you don't want the default Helvetica. Here we change the typeface to Times.

g + geom_point(aes(color = bmicat)) + theme_bw(base_family = "Times")

## More Complex Examples 
#------------------------

# Now we get the sense that plots in the ggplot2 system are constructed by successively
#adding components to the plot, starting with the base dataset and maybe a scatterplot.
#In this section we will show a slightly more complicated example with an additional
#variable. Now, we will ask the question

## "How does the relationship between PM2.5 and nocturnal symptoms vary by
#BMI category and nitrogen dioxide (NO2)?"

# Unlike our previous BMI variable, NO2 is a continous variable, so we need to make NO2 categorical so we can condition it on the plotting
# We can use cut() function for this purpose, which will divide the NO2 variable into tertiles. 

cutpoints <- quantile(maacs$logno2_new, seq(0,1, length = 4), na.rm = TRUE)

#Then we will divide the original logno2_new variable into the ranges defined by the cut points computed above
maacs$no2tert <- cut(maacs$logno2_new, cutpoints)

#The not2tert variable is now a categorical factor variable containing 3 levels, indicating
#the ranges of NO2 (on the log scale).

## See the levels of the newly created factor variable
levels(maacs$no2tert)

## The final plots shows the relationship between PM2.5 and nocturnal symptoms by BMI category and NO2 tertile
## Setup ggplot with data frame
g <- ggplot(maacs, aes(logpm25, NocturnalSympt))


## Adding layers 
g + geom_point(alpha = 1/3) +
  facet_wrap(bmicat ~ no2tert, nrow = 2, ncol = 4) +
  geom_smooth(method="lm", se=FALSE, col="steelblue") +
  theme_bw(base_family = "Avenir", base_size = 10) +
  labs(x = expression("log " * PM[2.5])) +
  labs(y = "Nocturnal Symptoms") +
  labs(title = "MAACS Cohort")


# From the plot we can easily see that the for Overweight Nocturnal Symptoms is directly proportional to the log Pm2.5 for every 
# NO2 range, where as NO2 is affecting the combination of logpm2.5 and nocturnal symptoms

## Quick aside about Axis limits 
#------------------------------

## Sometimes we want to restrict the range of the y-axis while plotting all the data, 
testdata <- data.frame(x = 1:1000, y = rnorm(100))

testdata[50, 2] <- 100 ## Outlier
plot(testdata$x, testdata$y, type = "l", ylim = c(-3,3))

# We have restricted the y-axis range to be between -3 and 3, even though there is a clear outlier in the data 
g1 <- ggplot(testdata, aes(x = x, y = y))
g1 + geom_line()


##Modifying the ylim() attribute would seem to give you the same thing as the base plot, but it doesn't.
g1 + geom_line() + ylim(-3, 3)

#Effectively, what this does is subset the data so that only observations between -3 and 3
#are included, then plot the data.
#To plot the data without subsetting it first and still get the restricted range, you have to
#do the following.
g1 + geom_line() + coord_cartesian(ylim = c(-3, 3))

