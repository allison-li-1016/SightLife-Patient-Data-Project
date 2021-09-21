#Import packages
library(tidyverse)
library(lintr)
library(styler)

#Import data
patient_data <- read.csv("FINAL LVPEI Bhubaneswar Tx Data Cleaned (2000s).csv")
patient_data$M1_EXAMINED_AT_1MONTH<-ifelse(patient_data$M1_EXAMINED_AT_1MONTH=="Yes",1,0)
patient_data$M3_EXAMINED_AT_1MONTH<-ifelse(patient_data$M3_EXAMINED_AT_1MONTH=="Yes",1,0)
patient_data$Y1_EXAMINED_AT_1MONTH<-ifelse(patient_data$Y1_EXAMINED_AT_1MONTH=="Yes",1,0)

#Make function that receives dataframe, filter variable/column name for M1 data
prop_func <- function(df, list){
  my_vector <- 0
  for(i in list){
    temp_table <- filter(df, GEN_AGE == i)
    sum = sum(temp_table$M1_EXAMINED_AT_1MONTH)
    total = nrow(temp_table)
    prop_value <- (sum/total)
    my_vector <- c(my_vector,prop_value)
  }
  my_vector <- head(my_vector,-1)
  return(my_vector)
}

#Extract unique ages
unique_ages <- unique(patient_data$GEN_AGE) 
unique_ages[unique_ages == 0] <- NA
unique_ages <- na.omit(unique_ages)
unique_ages <- sort(unique_ages)

#extract values for month 1
m1_values <- prop_func(patient_data, unique_ages)
#combine data
total_age_data <- data.frame(unique_ages, m1_values)

#Make function that receives dataframe, filter variable/column name for M3 data
prop_func3 <- function(df, list){
  my_vector <- 0
  for(i in list){
    temp_table <- filter(df, GEN_AGE == i)
    sum = sum(temp_table$M3_EXAMINED_AT_1MONTH)
    total = nrow(temp_table)
    prop_value <- (sum/total)
    my_vector <- c(my_vector,prop_value)
  }
  my_vector <- head(my_vector,-1)
  return(my_vector)
}

#extract values for month 3
m3_values <- prop_func3(patient_data, unique_ages)

#merge table
total_age_data <- data.frame(unique_ages, m1_values,m3_values)

#Make function that receives dataframe, filter variable/column name for Y1 data
prop_func1 <- function(df, list){
  my_vector <- 0
  for(i in list){
    temp_table <- filter(df, GEN_AGE == i)
    sum = sum(temp_table$Y1_EXAMINED_AT_1MONTH)
    total = nrow(temp_table)
    prop_value <- (sum/total)
    my_vector <- c(my_vector,prop_value)
  }
  my_vector <- head(my_vector,-1)
  return(my_vector)
}

#extract values for year 1
y1_values <- prop_func1(patient_data, unique_ages)

#merge table
total_age_data <- data.frame(unique_ages, m1_values,m3_values,y1_values)

#make line plot of all 3 time frames
age_plot_m1 <- ggplot(data = total_age_data) +
  geom_point(mapping = aes(x = unique_ages, y = m1_values), color ="#645D9B") +
  labs(x = "Ages", y = "Proportion Return Visits at Month 1", title = "Age vs. Return Visit Month 1")

age_plot_m3 <- ggplot(data = total_age_data) +
  geom_point(mapping = aes(x = unique_ages, y = m3_values), color ="#645D9B") +
  labs(x = "Ages", y = "Proportion Return Visits at Month 3", title = "Age vs. Return Visit Month 3")

age_plot_y1 <- ggplot(data = total_age_data) +
  geom_point(mapping = aes(x = unique_ages, y = y1_values), color ="#645D9B") +
  labs(x = "Ages", y = "Proportion Return Visits at Year 1", title = "Age vs. Return Visit Year 1")