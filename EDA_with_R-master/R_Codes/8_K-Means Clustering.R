## K-Means Clustering 
#----------------------

## The K-means approach, like many clustering methods, is highly algorithmic (can't be
#summarized in a formula) and is iterative. The basic idea is that you are trying to find
#the centroids of a fixed number of clusters of points in a high-dimensional space. In two
#dimensions, you can imagine that there are a bunch of clouds of points on the plane and
#you want to figure out where the centers of each one of those clouds is.

#One requirement is that you must pre-specify how many clusters there are


#1. Fix the number of clusters at some integer greater than or equal to 2
#2. Start with the "centroids" of each cluster; initially you might just pick a random set
#of points as the centroids
#3. Assign points to their closest centroid; cluster membership corresponds to the
#centroid assignment
#4. Reclaculate centroid positions and repeat.

## Illustration of K-Means Algorithm
#-----------------------------------

set.seed(1234)
x <- rnorm(12, mean = rep(1:3, each = 4), sd = 0.02)
y <- rnorm(12, mean = rep(c(1,2,1), each = 4), sd = 0.2)
plot(x, y, col = "blue", pch = 19, cex = 2)
text(x + 0.05, y + 0.05, labels = as.character(1:12))

# We will assume that there are three clusters 

## Using the K-mean funtion we can implement the algorithm

dataframe <- data.frame(x,y)
kmeansobj <- kmeans(dataframe, centers = 3)
names(kmeansobj)

# Looking at the points belongs to which cluster
kmeansobj$cluster #It is able to provide the correct clustering


# Building heatmaps from k-means solutions 
## Heat map plays crucial role to see multidimensional data when dimensions are very high

set.seed(1234)
datamatrix <- as.matrix(dataframe)[sample(1:12), ]
kmeansobj <- kmeans(datamatrix, centers = 3)

# Then we can make image plot using the K-means cluster

par(mfrow = c(1, 2))
image(t(datamatrix)[, nrow(datamatrix):1], yaxt = "n", main = "Original Data")
image(t(datamatrix)[, order(kmeansobj$cluster)], yaxt = "n", main = "Clustered Data")
