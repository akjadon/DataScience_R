# Graphics in R - ggplot2
options(width=70)

demo(graphics)

library(lattice)
demo(lattice)

library(ggplot2)
example(qplot)

library(ggplot2)
head(diamonds)

# qplot()

qplot(carat, price, data=diamonds)

qplot(carat,
      price,
      data=diamonds,
      color = cut,
      log="xy",
      facets=~clarity,
      main="Diamonds")

# Incremental plot construction

p <- ggplot(data = diamonds)

p <- p + aes(x = carat, y = price)

p <- p + geom_point()

p

# Change the plot type (geom)
example(geom_boxplot)
example(geom_polygon)
example(geom_raster)

p + geom_density2d()

# Change the coordinate transformation
p + coord_flip()

p + coord_polar()

# Change to multipanel display
p + facet_grid(. ~ cut)

p + facet_grid(cut ~ .)

p + facet_grid(cut ~ color)

# Density plot and alpha blending
ggplot(diamonds) + 
    aes(price, fill=cut) + 
    geom_density(alpha=.3)


# Application: Maps
myLocation<-"University of Washington"

myLocation<-c(lon= -106.4407, lat = 31.76788)

library(ggmap)

mapData1 <- get_map(location = c(lon = -0.016179, lat = 51.538525),
                         color = "color",source = "google",
                         maptype = "satellite",zoom = 16)
 
ggmap(mapData1,extent = "panel",ylab = "Latitude",xlab = "Longitude")

library(ggmap)

mapData <- get_map(location = c(lon = -0.016179, lat = 51.538525),
                         color = "color",source = "google",
                         maptype = "roadmap",zoom = 16)
 
ggmap(mapData,extent = "panel",ylab = "Latitude",xlab = "Longitude")

library(ggmap)

mapData <- get_map(location = c(lon = -0.016179, lat = 51.538525),
                         color = "color",source = "google",
                         maptype = "hybrid",zoom = 16)
 
ggmap(mapData,extent = "panel",ylab = "Latitude",xlab = "Longitude")

library(ggmap)

geocode("University of Washington")

USA <- ggmap(get_map(location="United States", source="google",zoom=4), 
             extent="panel")  
USA

mydata<-read.csv("vehicle_accidents.csv")
mydata$State <- as.character(mydata$State)  
mydata$MV.Number = as.numeric(mydata$MV.Number)  
mydata = mydata[mydata$State != "Alaska", ]  
mydata = mydata[mydata$State != "Hawaii", ]
mydata = mydata[mydata$State != "USA", ]    
mv_collisions<-data.frame(mydata$State,mydata$MV.Number) 
colnames(mv_collisions)<-c("state","collisions")
mv_collisions$state<-as.character(mv_collisions$state)

head(mv_collisions)

for (i in 1:nrow(mv_collisions)) {  
  latlon = geocode(mv_collisions$state[i])
  mv_collisions$lon[i] = as.numeric(latlon[1])
  mv_collisions$lat[i] = as.numeric(latlon[2])
}

usa_center = geocode("United States")
USA <- ggmap(get_map(location=usa_center,zoom=4), extent="panel")  

circle_scale<-0.04
USA + geom_point(aes(x=lon, y=lat), data=mv_collisions, col="red", 
                 alpha=0.4, size=mv_collisions$collisions*circle_scale)
