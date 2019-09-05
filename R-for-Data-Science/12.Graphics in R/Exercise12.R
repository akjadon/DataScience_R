# Exercise 12.1

library(ggplot2)

p<- ggplot(data = diamonds)
p <- p + aes(x = carat, y = depth)
p <- p + geom_point()
p <- p + geom_density2d()
p

# Exercise 12.2
summary(diamonds)

depth.groups<-cut(diamonds$depth,breaks=40+(0:5)*8)

ggplot(diamonds) +
  aes(price, fill=depth.groups) +
  geom_density(alpha=.3)

# Exercise 12.3

library(ggmap)

popdata<-data.frame(state=row.names(state.x77),murder=state.x77[,5])
popdata$state<-as.character(popdata$state)

for (i in 1:nrow(popdata)) {
  latlon = geocode(popdata$state[i])
  popdata$lon[i] = as.numeric(latlon[1])
  popdata$lat[i] = as.numeric(latlon[2])
}

# usa_center = geocode("United States")
USA <-ggmap(get_map(location="United States",zoom=4), extent="panel")

USA + geom_point(aes(x=lon, y=lat), data=popdata, col="black",
                 alpha=0.4, size=popdata$murder)




