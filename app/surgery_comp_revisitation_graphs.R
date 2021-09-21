
#Import packages
library(tidyverse)
library(lintr)
library(styler)

#Import data
patient_data <- read.csv("FINAL LVPEI Bhubaneswar Tx Data Cleaned (2000s).csv")
patient_data$M1_EXAMINED_AT_1MONTH<-ifelse(patient_data$M1_EXAMINED_AT_1MONTH=="Yes",1,0)
patient_data$M3_EXAMINED_AT_1MONTH<-ifelse(patient_data$M3_EXAMINED_AT_1MONTH=="Yes",1,0)
patient_data$Y1_EXAMINED_AT_1MONTH<-ifelse(patient_data$Y1_EXAMINED_AT_1MONTH=="Yes",1,0)

patient_data$M1_SURGERY_COMPLICATIONS_YORN<-ifelse(patient_data$M1_SURGERY_COMPLICATIONS_YORN=="Yes",1,0)
patient_data$M3_SURGERY_COMPLICATIONS_YORN<-ifelse(patient_data$M3_SURGERY_COMPLICATIONS_YORN=="Yes",1,0)
patient_data$Y1_SURGERY_COMPLICATIONS_YORN<-ifelse(patient_data$Y1_SURGERY_COMPLICATIONS_YORN=="Yes",1,0)

#calculate revisitation rates
total = nrow(patient_data)
m1_revisit_rate <- sum(patient_data$M1_EXAMINED_AT_1MONTH)/total
m3_revisit_rate <- sum(patient_data$M3_EXAMINED_AT_1MONTH)/total
y1_revisit_rate <- sum(patient_data$Y1_EXAMINED_AT_1MONTH)/total
revisitation_rate <- c(m1_revisit_rate,m3_revisit_rate,y1_revisit_rate)
#calculate surgery complication rate
m1_comp_rate <- sum(patient_data$M1_SURGERY_COMPLICATIONS_YORN)/total
m3_comp_rate <- sum(patient_data$M3_SURGERY_COMPLICATIONS_YORN)/total
y1_comp_rate <- sum(patient_data$Y1_SURGERY_COMPLICATIONS_YORN)/total
comp_rate <- c(m1_comp_rate,m3_comp_rate,y1_comp_rate)
months <- c(1,3,12)
gen_revisit_data <- data.frame(months, revisitation_rate)
gen_comp_data <- data.frame(months, comp_rate)
#create graph made from data, can filter by months later on
colors <- c("Revisitation Rate" = "#645D9B", "Surgery Complication Rate" = "#82D8D5")
p = ggplot() + 
  geom_line(data = gen_revisit_data, aes(x = months, y = revisitation_rate, color = "Revisitation Rate"), size = 1.5) +
  geom_line(data = gen_comp_data, aes(x = months, y = comp_rate, color = "Surgery Complication Rate"), size = 1.5) +
  labs(x = "Months", y = "Proportion", title = "Revisitation and Surgery Complication Rates over Time") +
  scale_color_manual(values = colors)