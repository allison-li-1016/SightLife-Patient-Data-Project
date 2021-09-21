#Import packages
library(tidyverse)
library(lintr)
library(styler)

#Import data
patient_data <- read.csv("FINAL LVPEI Bhubaneswar Tx Data Cleaned (2000s).csv")

#Before this, can filter data by age or gender and create same graph
#do this with server

#Extract Diagnosis
diagnosis_count <- table(patient_data$GEN_INDICATION_OF_PK) 
diagnosis_count <- data.frame(diagnosis_count)
colnames(diagnosis_count) <- c("condition", "patients")

#delete first row full of 0s
diagnosis_count <- diagnosis_count[-1,]

#create additional column with percentages
total <- sum(diagnosis_count$patients)
diagnosis_count$prop <- with(diagnosis_count, patients/total)

#create donut graph
#Compute the cumulative percentages (top of each rectangle)
diagnosis_count$ymax = cumsum(diagnosis_count$prop)

#Compute the bottom of each rectangle
diagnosis_count$ymin = c(0, head(diagnosis_count$ymax, n=-1))

#visualize plot
diagnosis_donut <- ggplot(diagnosis_count, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=condition)) +
  geom_rect() +
  coord_polar(theta="y") + 
  scale_fill_brewer(palette=3) +
  scale_color_brewer(palette=3) +
  xlim(c(2, 4)) +
  theme_void()
