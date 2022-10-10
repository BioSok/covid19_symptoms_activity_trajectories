library(dplyr)
library(TSdist)
library(act1ales)

# read activity series clustering result
activity1 <- readRDS("activity_result.RDS")

trajectories <- activity1@trajWide
means <- activity1@trajMeans
clusters <- activity1@clusters

# extracting results per cluster 
c1 <- filter(means, iCenters == 1)
c2 <- filter(means, iCenters == 2)

c1.tj <- c1$traj
c2.tj <- c2$traj

# which cluster is above mean?
if(mean(c1$traj) > mean(c2$traj)) {
  high <- "1"
} else {
  high <- "2"
}

# which cluster's vector is shorter (less time points)?
if(length(c1.tj) >= length(c2.tj)) {
  c2.tj <- c(c2.tj, rep(NA, length(c1.tj) - length(c2.tj)))
} else {
  c1.tj <- c(c1.tj, rep(NA, length(c2.tj) - length(c1.tj)))
}

avg.df <- data.frame(c1 = c1.tj, c2 = c2.tj)

# Generating centers of each cluster's trajectory
clusters.center.tj <- rowMeans(avg.df)

names <- rownames(trajectories)

act1.distances <- data.frame(distance.center = rep(NA, length(names)), distance.center.act1aled = rep(NA, length(names)))
rownames(act1.distances) <- names


# calculate distance of each patient trajectory from its cluster
for (i in names) {
  temp <- TSDistances(trajectories[i,], clusters.center.tj, distance = "frechet")
  if(activity1@clusters[i] == high) {
    act1.distances[i,1] <- temp
  } else {
    act1.distances[i,1] <- -temp
  }
}

act1.distances$distance.center.scaled <- rescale(act1.distances$distance.center, to=c(-1,1))
colnames(act1.distances) <- c("act1_dist","act1_dist_scaled")