#importing libraries
library(tidyverse)
library(ggplot2)
#library(rgeos)
#library(maptools)
#library(ggmap)
library(sp)
library(raster)
library(plyr)
library(rgdal)

#import data 
location_data <- read.csv("C:\\Users\\allis\\Desktop\\SightLife-Patient-Data-Project\\data\\FINAL LVPEI Bhubaneswar Tx Data Cleaned (2000s).csv")

View(location_data)

#build map chart based on countries - India vs. Bangladesh 
countries <- location_data['GEN_COUNTRY']
num_countries = unique(countries)
View(countries)
View(num_countries)

#create blank theme for map plots
blank_theme <- theme_bw() +
  theme(
    axis.line = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    plot.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank()
  )

#build map chart based on states in India
states <- location_data['GEN_STATE'] 
states <- na_if(states,0)
states <- na.omit(states)
num_states = table(states) 
View(num_states)

#build state shapes for Indian states
India <- getData('GADM', country='IN', level=1)

