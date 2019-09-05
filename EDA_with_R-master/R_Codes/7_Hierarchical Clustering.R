#### Hierarchical Clustering 
#----------------------------

## This is a bread and butter for visualiing high dimensional and multidimensional data. 
# It actually organize things or observations that are close to each other and seperate them into groups. 


##Hierarchical clustering, as is denoted by the name, involves organizing your data into
#a kind of hierarchy. The common approach is what's called an agglomerative approach.
#This is a kind of bottom up approach, where you start by thinking of the data as individual
#data points. Then you start lumping them together into clusters little by little until
#eventually your entire data set is just one big cluster.


## Start with two closest points and merge them to make a new point and then do like this 

# Distance that we use in this algo 
#----
#  Euclidean distance: A continuous metric which can be thought of in geometric
# terms as the "straight-line" distance between two points.
#  Correlation similarity: Similar in nature to Euclidean distance
#  "Manhattan" distance: on a grid or lattice, how many "city blocks" would you have
#  to travel to get from point A to point B?

set.seed(1234)
x <- rnorm(12, rep(1:3, each = 4), 0.2)
y <- rnorm(12, rep(c(1,2,1), each = 4), 0.2)
plot(x, y, col = "blue", pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels = as.character(1:12))

## distance
dataFrame <- data.frame(x = x, y = y)
dist(dataFrame) #Default is Eculidean

# First an agglomerative clustering approach attempts to find the two points that are closest together.
rdistxy <- as.matrix(dist(dataFrame))

## Remove the diagonal from consideration
diag(rdistxy) <- diag(rdistxy) + 100000

# Find the index of the points with minimum distance
ind <- which(rdistxy == min(rdistxy), arr.ind = TRUE)
ind

# Now we can plot and check
plot(x, y, col = "blue", pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels = as.character(1:12))
points(x[ind[1, ]], y[ind[1, ]], col = "orange", pch = 19, cex = 2)

# The next step would be to start drawing the tree, the first step would be to merge these two points together 
par(mfrow = c(1, 2))
plot(x, y, col = "blue", pch = 19, cex = 2, main = "Data")
text(x + 0.05, y + 0.05, labels = as.character(1:12))
points(x[ind[1, ]], y[ind[1, ]], col = "orange", pch = 19, cex = 2)


# Make a cluster and cut it at the right height
library(dplyr)
hcluster <- dist(dataFrame) %>% hclust
dendro <- as.dendrogram(hcluster)
cutDendro <- cut(dendro, h = (hcluster$height[1] + 0.00001))
plot(cutDendro$lower[[11]], yaxt = "n", main = "Begin building tree")

#Now that we've merged the first two "leaves" of this tree, we can turn the algorithm crank
#and continue to build the tree. Now, the two points we identified in the previous iteration
#will get "merged" into a single point


# We need to search the distance matrix for the next two closest points, ignoring the first
#two that we already merged.
nextmin <- rdistxy[order(rdistxy)][3]
ind <- which(rdistxy == nextmin,arr.ind=TRUE)
ind


# In this way if continue doing we will get complete dendogram
hClustering <- data.frame(x=x,y=y) %>% dist %>% hclust
plot(hClustering) #Ther are three clusters with 4 points each


x## More aesthatic Dendogram
#--------------------------

myplclust <- function(hclust, lab = hclust$labels, lab.col = rep(1, length(hclust$labels)),
                       hang = 0.1, ...) {
   ## modifiction of plclust for plotting hclust objects *in colour*! Copyright
     ## Eva KF Chan 2009 Arguments: hclust: hclust object lab: a character vector
     ## of labels of the leaves of the tree lab.col: colour for the labels;
     ## NA=default device foreground colour hang: as in hclust & plclust Side
     ## effect: A display of hierarchical cluster with coloured leaf labels.
     y <- rep(hclust$height, 2)
     x <- as.numeric(hclust$merge)
     y <- y[which(x < 0)]
     x <- x[which(x < 0)]
     x <- abs(x)
     y <- y[order(x)]
     x <- x[order(x)]
     plot(hclust, labels = FALSE, hang = hang, ...)
     text(x = x, y = y[hclust$order] - (max(hclust$height) * hang), labels = lab[hclust$order],
          col = lab.col[hclust$order], srt = 90, adj = c(1, 0.5), xpd = NA, ...)
}

hClustering <- data.frame(x = x, y = y) %>% dist %>% hclust
myplclust(hClustering, lab = rep(1:3, each = 4), lab.col = rep(1:3, each = 4))     



## Heatmap is a handy way to visualize the matrix data
#The basic idea is that heatmap() sorts the rows and columns of a matrix according to the clustering
#determined by a call to hclust(). Conceptually, heatmap() first treats the rows of a
#matrix as observations and calls hclust() on them, then it treats the columns of a matrix
#as observations and calls hclust() on those values. The end result is that you get a
#dendrogram associated with both the rows and columns of a matrix, which can help
#you to spot obvious patterns in the data.

dataMatrix <- data.frame(x=x,y=y) %>% data.matrix
heatmap(dataMatrix)


## Hierarchical clustering is sensitive to Null values, picking a different distance metrics, changing the scale of one variable 
# It can be used to explore the data and get relationshiip

