library(readxl)
library(dplyr)
library(stringr)
library(ComplexHeatmap)
library(circlize)
library(readr)
library(scales)

# 
classes_distances_activity <- read_csv("Data/classes_distances_activity.csv")

SC_distances <- read_csv("SC_distances.csv")
HR_distances <- read_csv("HR_distances.csv")
SDNN_distances <- read_csv("SDNN_distances.csv")
WHRA_distances <- read_csv("WHRA_distances.csv")
FC_distances <- read_csv("FC_distances.csv")
DWR_distances <- read_csv("DWR_distances.csv")
BEB_distances <- read_csv("BEB_distances.csv")
EB_distances <- read_csv("EB_distances.csv")

# creating matrix of activity distances for the 8 variables
total <- left_join(classes_distances_activity, SC_distances)
total <- left_join(total, HR_distances)
total <- left_join(total, SDNN_distances)
total <- left_join(total, WHRA_distances)
total <- left_join(total, FC_distances)
total <- left_join(total, DWR_distances)
total <- left_join(total, BEB_distances)
total <- left_join(total, EB_distances)

# Avoiding NAs
data <- as.matrix(total)
data[is.na(data)] <- 0

# symptoms data
h1.data <- data[, 2:11]
ht1 = Heatmap(h1.data, col = c("green","#0571B0"),
              name = "Symptom Classes",
              border = TRUE,
              rect_gp = gpar(col = "white", lwd = 0.15),
              width = 2,
              height = 4)

# activity data
l <- c(12,14,16,18,20,22,24,26)
h2.data <- data[, l]
names <- colnames(h2.data)
h2.data <- matrix(as.numeric(h2.data), ncol = ncol(h2.data))
colnames(h2.data) <- names

# scaling
h2.data <- scale(h2.data)
ht2 = Heatmap(h2.data, col = colorRamp2(c(min(h2.data), 0, max(h2.data)), c("green", "white", "red")),
              name = "Activity Clusters",
              border = TRUE,
              rect_gp = gpar(col = "white", lwd = 0.15),
              cluster_rows = F,
              cluster_columns = F,
              width = 2,
              height = 4,
              cell_fun = function(j, i, x, y, width, height, fill) {
                grid.text(sprintf("%.1f", h2.data[i, j]), x, y, gp = gpar(fontsize = 10))
              })

# composite heatmap
ht1 + ht2