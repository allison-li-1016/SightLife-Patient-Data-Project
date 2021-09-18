#Import packages
library(tidyverse)
library(lintr)
library(styler)

#Import data
patient_data <- read.csv("C:\\Users\\allis\\Desktop\\SightLife-Patient-Data-Project\\data\\FINAL LVPEI Bhubaneswar Tx Data Cleaned (2000s).csv")

#Filter by gender, M1, M3, Y1 visits 
gender_data <- patient_data[,c("GEN_SEX", "M1_EXAMINED_AT_1MONTH","M3_EXAMINED_AT_1MONTH","Y1_EXAMINED_AT_1MONTH")]
gender_data$M1_EXAMINED_AT_1MONTH<-ifelse(gender_data$M1_EXAMINED_AT_1MONTH=="Yes",1,0)
gender_data$M3_EXAMINED_AT_1MONTH<-ifelse(gender_data$M3_EXAMINED_AT_1MONTH=="Yes",1,0)
gender_data$Y1_EXAMINED_AT_1MONTH<-ifelse(gender_data$Y1_EXAMINED_AT_1MONTH=="Yes",1,0)

#create new chart with proportions according to gender and month
#find individual proportions according to gender and month
female <- gender_data %>% 
  group_by(GEN_SEX) %>% 
  filter(GEN_SEX == "Female")
female_m1_prop <- sum(female$M1_EXAMINED_AT_1MONTH)/nrow(female)
female_m3_prop <- sum(female$M3_EXAMINED_AT_1MONTH)/nrow(female)
female_y1_prop <- sum(female$Y1_EXAMINED_AT_1MONTH)/nrow(female)
male <- gender_data %>% 
  group_by(GEN_SEX) %>% 
  filter(GEN_SEX == "Male")
male_m1_prop <- sum(male$M1_EXAMINED_AT_1MONTH)/nrow(male)
male_m3_prop <- sum(male$M3_EXAMINED_AT_1MONTH)/nrow(male)
male_y1_prop <- sum(male$Y1_EXAMINED_AT_1MONTH)/nrow(male)

#put components back into single dataframe
gender <- c("Female", "Female", "Female", "Male", "Male", "Male")
visitation_period <- c("1 Month", "3 Months", "Year 1", "1 Month", "3 Months", "Year 1")
visitation_prop <- c(female_m1_prop, female_m3_prop, female_y1_prop, male_m1_prop, male_m3_prop, male_y1_prop)
gender_prop_data <- data.frame(gender,visitation_period, visitation_prop)
#Filter by gender -> filter gender_prop_data by gender

#create graph from new table 
gender_plot <- ggplot(data =gender_prop_data) +
  geom_col(mapping = aes(x = visitation_period, y = visitation_prop, fill = gender)) +
  scale_fill_manual('Product', values=c("#645D9B","#D5D1E9")) +
  labs(x = "Time after first visit", y = "Proportion of return visits", title = "Return visits by gender")