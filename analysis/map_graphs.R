#importing libraries
library(tidyverse)
library(lintr)
library(styler)
library(usdata)
library(ggplot2)
library(mapproj)

#import data 
location_data <- read.csv("C:\\Users\\allis\\Desktop\\SightLife-Patient-Data-Project\\data\\FINAL LVPEI Bhubaneswar Tx Data Cleaned (2000s).csv")

View(location_data)

#build map chart based on countries - India vs. Bangladesh 
countries <- location_data['GEN_COUNTRY']
num_countries = unique(countries)
View(countries)
View(num_countries)

#build map chart based on states in India
states <- location_data['GEN_STATE'] 
states <- states[!(apply(states, 1, function(y) any(y == 0))),]
num_states = unique(states)
View(num_states)
