library(kmlShape)
library(readr)
library(lubridate)
library(dplyr)
library(ggplot2)

sample_dates <- read_csv("date_data.csv")

# convert column to date format
sample_dates$date <- mdy(sample_dates$date)

# save sample names
sample.names <- sample_dates$subject

# enter activity data directory and extract patient data for relevant activity
activity1.files = list.files(pattern="*.csv")
all.activity1.activity = do.call(rbind, lapply(activity1.files, function(x) read.csv(x, stringsAsFactors = FALSE)))
all.activity1.activity$X <- NULL
colnames(all.activity1.activity) <- c("subject", "activity_date", "activity1")

# filter patients based on starting date availability
all.activity1.activity <- filter(all.activity1.activity, subject %in% sample.names)
useful.samples <- unique(all.activity1.activity$subject)
dim(table(all.activity1.activity$subject))[1] #number of samples/patients

all.activity1.activity$daysdistancefromdate <- -1

# create distance in days
for(i in 1:nrow(all.activity1.activity)) {
  id <- all.activity1.activity[i,1]
  cur.date <- sample_dates$date[sample_dates$subject == id]
  all.activity1.activity[i,4] <- interval(cur.date, all.activity1.activity[i,2]) / ddays(1)
}

# locate start of useful datapoints
useful.dates <- data.frame(object=character(), startDate=character())
for(id in useful.samples) {
  cur.data <- filter(all.activity1.activity, subject == id)
  min.index <- which.min(abs(cur.data$daysdistancefromdate))
  min.date <- cur.data$activity_date[min.index]
  useful.dates <- rbind(useful.dates, c(id,min.date))
}

colnames(useful.dates) <- c("subject","startDate")

all.activity1.activity <- left_join(all.activity1.activity, useful.dates, by = "subject")

# deciding whether a row is useful (after start date)
all.activity1.activity <- all.activity1.activity %>%
        mutate(Use = case_when(
          (interval(startDate, activity_date) / ddays(1)) >= 0 ~ "Yes",
          (interval(startDate, activity_date) / ddays(1)) < 0 ~ "No"
        ))

max.trajectory.points <- max(table(all.activity1.activity$subject))

# Creating input dataframe
clustering.df <- data.frame()
for(id in useful.samples) {
  cur.data <- filter(all.activity1.activity, subject == id)
  clustering.df <- rbind(clustering.df, c(cur.data$activity1,rep(NA, max.trajectory.points - length(cur.data$activity1))))
}
rownames(clustering.df) <- useful.samples
colnames(clustering.df) <- 1:dim(clustering.df)[1]


# selecting 33 senators and 100 timepoints filtering for time series clustering
clustering.df <- as.matrix(clustering.df)
myClds <- cldsWide(clustering.df, id = useful.samples)
reduceTraj(myClds,nbSenators=33,nbTimes=100)
two.clusters <- kmlShape(myClds, nbClusters = 2)

# selecting the two-cluster result
sens <- two.clusters@senators
csens <- two.clusters@clustersSenators
csens <- data.frame(id = names(csens), clusters = csens)
sens <- left_join(sens, csens)
sens.means <- data.frame(two.clusters@trajMeans)
sens.means$times <- as.integer(sens.means$times)
sens.means$traj <- as.integer(sens.means$traj)
sens.means$clusters <- as.factor(sens.means$iCenters)

# plot mean activity trajectories of two clusters
ggplot(data = sens.means) +
  geom_line(aes(x=times, y=traj, group=iCenters, color = clusters), size =1) +
  ylab("Activity") +
  xlab("Days") +
  theme_minimal()

# generate stats
values <- c()

run <- unique(all.activity1.activity$subject)
for (i in run) {
  temp <- filter(all.activity1.activity, Use == "Yes" & subject == i)
  values <- c(values, max(abs(temp$daysdistancefromdate)))
}

values <- data.frame(vals = values)

summary(values)

# results
clusters <- two.clusters@clusters
ids <- names(two.clusters@clusters)
memberships <- data.frame(ids, clusters)
