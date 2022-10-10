library(ggplot2)
library(dplyr)
library(ggpubr)

group.colors <- c(C1 = "#F3766E", C2 = "#1CBDC2")

basalEnergyBurned <- readRDS("basalEnergyBurned.RDS")
flightsClimbed <- readRDS("flightsClimbed.RDS")
energyBurned <- readRDS("energyBurned.RDS")
heartRate <- readRDS("heartRate.RDS")
heartRateVariabilitySDNN <- readRDS("heartRateVariabilitySDNN.RDS")
stepCount <- readRDS("stepCount.RDS")
walkingHeartRateAverage <- readRDS("walkingHeartRateAverage.RDS")
distanceWalkingRunning <- readRDS("distanceWalkingRunning.RDS")

# capping time points per activity
df_beb <- data.frame(basalEnergyBurned@trajMeans)
df_beb <- filter(df_beb, times < 750)
df_fc <- data.frame(flightsClimbed@trajMeans)
df_fc <- filter(df_fc, times < 125)
df_eb <- data.frame(energyBurned@trajMeans)
df_eb <- filter(df_eb, times < 600)
df_hr <- data.frame(heartRate@trajMeans)
df_hr <- filter(df_hr, times < 400)
df_sdnn <- data.frame(heartRateVariabilitySDNN@trajMeans)
df_sdnn <- filter(df_sdnn, times < 400)
df_sc <- data.frame(stepCount@trajMeans)
df_sc <- filter(df_sc, times < 500)
df_whr <- data.frame(walkingHeartRateAverage@trajMeans)
df_whr <- filter(df_whr, times < 750)
df_dwr <- data.frame(distanceWalkingRunning@trajMeans)
df_dwr <- filter(df_dwr, times < 750)

# adjusting colors for high and low activity clusters for all following plots
beb_plot <- ggplot(data = df_beb, aes(x = times,  y = traj, color = iCenters)) +
    stat_density2d(aes(fill = ..density..^0.50), geom = "tile", contour = FALSE, n = 300, show.legend = FALSE) +
        scale_fill_gradientn(colours = colorRampPalette(c("white", "#009404"))(256)) +
    xlab("Days") +
    ylab("") +
    ggtitle("Basal Energy Burned") +
    scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0)) +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text=element_text(family="Times", size=14)) +
    theme(legend.position="none")

beb_plot <- beb_plot +
    geom_point(aes(colour = factor(iCenters)), size = 0.05) +
    geom_smooth(aes(group=factor(iCenters), color=factor(iCenters)), se = FALSE, show.legend = FALSE) +
    scale_colour_manual(values = c("#FFA185", "#C2FFAE"))


fc_plot <- ggplot(data = df_fc, aes(x = times,  y = traj, color = iCenters)) +
    stat_density2d(aes(fill = ..density..^0.50), geom = "tile", contour = FALSE, n = 300, show.legend = FALSE) +
    scale_fill_gradientn(colours = colorRampPalette(c("white", "#009404"))(256)) +
    xlab("Days") +
    ylab("") +
    ggtitle("Flights climbed") +
    scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0)) +
    ylim(-100,600) +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text=element_text(family="Times", size=14)) +
    theme(legend.position="none")

fc_plot <- fc_plot +
    geom_point(aes(colour = factor(iCenters)), size = 0.05) +
    geom_smooth(aes(group=factor(iCenters), color=factor(iCenters)), se = FALSE, show.legend = FALSE) +
    scale_colour_manual(values = c("#FFA185", "#C2FFAE"))


eb_plot <- ggplot(data = df_eb, aes(x = times,  y = traj, color = iCenters)) +
    stat_density2d(aes(fill = ..density..^0.50), geom = "tile", contour = FALSE, n = 300, show.legend = FALSE) +
    scale_fill_gradientn(colours = colorRampPalette(c("white", "#009404"))(256)) +
    xlab("Days") +
    ylab("") +
    ggtitle("Energy burned") +
    scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0)) +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text=element_text(family="Times", size=14)) +
    theme(legend.position="none")

eb_plot <- eb_plot +
    geom_point(aes(colour = factor(iCenters)), size = 0.05) +
    geom_smooth(aes(group=factor(iCenters), color=factor(iCenters)), se = FALSE, show.legend = FALSE) +
    scale_colour_manual(values = c("#FFA185", "#C2FFAE"))


hr_plot <- ggplot(data = df_hr, aes(x = times,  y = traj, color = iCenters)) +
    stat_density2d(aes(fill = ..density..^0.50), geom = "tile", contour = FALSE, n = 300, show.legend = FALSE) +
    scale_fill_gradientn(colours = colorRampPalette(c("white", "#009404"))(256)) +
    xlab("Days") +
    ylab("") +
    ggtitle("Heart rate") +
    scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0)) +
    ylim(1.2,1.8) +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text=element_text(family="Times", size=14)) +
    theme(legend.position="none")

hr_plot <- hr_plot +
    geom_point(aes(colour = factor(iCenters)), size = 0.05) +
    geom_smooth(aes(group=factor(iCenters), color=factor(iCenters)), se = FALSE, show.legend = FALSE) +
    scale_colour_manual(values = c("#FFA185", "#C2FFAE"))


sdnn_plot <- ggplot(data = df_sdnn, aes(x = times,  y = traj, color = iCenters)) +
    stat_density2d(aes(fill = ..density..^0.50), geom = "tile", contour = FALSE, n = 300, show.legend = FALSE) +
    scale_fill_gradientn(colours = colorRampPalette(c("white", "#009404"))(256)) +
    xlab("Days") +
    ylab("") +
    ggtitle("Heart rate variability SDNN") +
    scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0)) +
    ylim(0,120) +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text=element_text(family="Times", size=14)) +
    theme(legend.position="none")

sdnn_plot <- sdnn_plot +
    geom_point(aes(colour = factor(iCenters)), size = 0.05) +
    geom_smooth(aes(group=factor(iCenters), color=factor(iCenters)), se = FALSE, show.legend = FALSE) +
    scale_colour_manual(values = c("#FFA185", "#C2FFAE"))


sc_plot <- ggplot(data = df_sc, aes(x = times,  y = traj, color = iCenters)) +
    stat_density2d(aes(fill = ..density..^0.50), geom = "tile", contour = FALSE, n = 300, show.legend = FALSE) +
    scale_fill_gradientn(colours = colorRampPalette(c("white", "#009404"))(256)) +
    xlab("Days") +
    ylab("") +
    ggtitle("Step count") +
    scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0)) +
    ylim(0,20000) +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text=element_text(family="Times", size=14)) +
    theme(legend.position="none")

sc_plot <- sc_plot +
    geom_point(aes(colour = factor(iCenters)), size = 0.05) +
    geom_smooth(aes(group=factor(iCenters), color=factor(iCenters)), se = FALSE, show.legend = FALSE) +
    scale_colour_manual(values = c("#FFA185", "#C2FFAE"))


whr_plot <- ggplot(data = df_whr, aes(x = times,  y = traj, color = iCenters)) +
    stat_density2d(aes(fill = ..density..^0.50), geom = "tile", contour = FALSE, n = 300, show.legend = FALSE) +
    scale_fill_gradientn(colours = colorRampPalette(c("white", "#009404"))(256)) +
    xlab("Days") +
    ylab("") +
    ggtitle("Walking heart rate average") +
    scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0)) +
    ylim(1.6,1.8) +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text=element_text(family="Times", size=14)) +
    theme(legend.position="none")

whr_plot <- whr_plot +
    geom_point(aes(colour = factor(iCenters)), size = 0.05) +
    geom_smooth(aes(group=factor(iCenters), color=factor(iCenters)), se = FALSE, show.legend = FALSE) +
    scale_colour_manual(values = c("#FFA185", "#C2FFAE"))


dwr_plot <- ggplot(data = df_dwr, aes(x = times,  y = traj, color = iCenters)) +
    stat_density2d(aes(fill = ..density..^0.50), geom = "tile", contour = FALSE, n = 300, show.legend = FALSE) +
    scale_fill_gradientn(colours = colorRampPalette(c("white", "#009404"))(256)) +
    xlab("Days") +
    ylab("") +
    ggtitle("Walking running distance") +
    scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0)) +
    ylim(0,17500) +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(text=element_text(family="Times", size=14)) +
    theme(legend.position="none")

dwr_plot <- dwr_plot +
    geom_point(aes(colour = factor(iCenters)), size = 0.05) +
    geom_smooth(aes(group=factor(iCenters), color=factor(iCenters)), se = FALSE, show.legend = FALSE) +
    scale_colour_manual(values = c("#FFA185", "#C2FFAE"))

# aggregating plots
ggarrange(beb_plot, fc_plot,
          eb_plot, hr_plot,
          sdnn_plot, sc_plot,
          whr_plot, dwr_plot,
          ncol = 2, nrow = 4)
