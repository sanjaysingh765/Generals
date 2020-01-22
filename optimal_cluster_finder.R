#load required libraries
library(factoextra)
library(NbClust)


#################################################################################################
#
#                                 Data load and expoitation
#
##################################################################################################


#upload expression data
filter_data<- read.csv("TF_average.csv",header=TRUE,row.names=1)
head(filter_data)
heatdata <- log2(filter_data+1)

#################################################################################################
#
#                                 Search for optimal cluster number
#
##################################################################################################


#search for optimal cluster number
nb <- NbClust(heatdata,  #matrix or dataset.
              distance = "euclidean", #"euclidean", "maximum", "manhattan", "canberra", "binary", "minkowski" 
              min.nc = 2, #minimal number of clusters
              max.nc = 10, #maximal number of clusters
              method = "complete", # "ward.D", "ward.D2", "single", "complete", "average", "mcquitty", "median", "centroid", "kmeans".
              index ="all" # index to be calculated. This should be one of : "kl", "ch", "hartigan", "ccc", "scott", "marriot", "trcovw", "tracew", "friedman", "rubin", "cindex", "db", "silhouette", "duda", "pseudot2", "beale", "ratkowsky", "ball", "ptbiserial", "gap", "frey", "mcclain", "gamma", "gplus", "tau", "dunn", "hubert", "sdindex", "dindex", "sdbw", "all" (all indices except GAP, Gamma, Gplus and Tau), "alllong"
)
# Print the result
nb
optial_cluster <- fviz_nbclust(nb) + theme_minimal()
ggsave(optial_cluster , file="optial_cluster.png", units="in", family="Times New Roman",  width=4, height=2, pointsize = 9)


