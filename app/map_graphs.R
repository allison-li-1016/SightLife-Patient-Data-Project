#importing libraries
library(plyr)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(sp)
library(raster)
library(rgdal)
library(mapproj)

#import data 
location_data <- read.csv("FINAL LVPEI Bhubaneswar Tx Data Cleaned (2000s).csv")

#build map chart based on countries - India vs. Bangladesh 
countries <- location_data['GEN_COUNTRY']
num_countries = unique(countries)


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
num_states = as_tibble(table(states))
names(num_states)[names(num_states) == "states"] <- "NAME_1"

#build state shapes for Indian states
India <- getData('GADM', country='IN', level=1)
India_UTM<-spTransform(India, CRS("+init=EPSG:24383"))
India_UTM@data$NAME_1
India_UTM@data$id <- rownames(India_UTM@data)
India_UTM@data <- join(India_UTM@data, num_states, by="NAME_1")
India_df <- fortify(India_UTM)
India_df <- join(India_df,India_UTM@data, by="id")

#map graph aesthetics
map_plot <- ggplot() + 
  geom_polygon(data = India_df, aes(x = long, y = lat, group = group, fill = n), color = "black", size = 0.1)  +
  scale_fill_continuous(low = "#D5D1E9", high = "#645D9B") +
  labs(title = "Patients by State in India", x = "", y = "", fill = "Number of Patients") +
  blank_theme
