#Import necessary libraries
library(shiny)
library(tidyverse)
library(ggplot2)
library(plotly)
source("C:\\Users\\allis\\Desktop\\SightLife-Patient-Data-Project\\analysis\\gender_return_visit_graphs.R")

#Import data - might not need this at all
patient_data <- read.csv("C:\\Users\\allis\\Desktop\\SightLife-Patient-Data-Project\\data\\FINAL LVPEI Bhubaneswar Tx Data Cleaned (2000s).csv")



#Display outputs
server <- function(input, output){
  #Gender/DropOff Analysis/Graph
  output$barchart_gen <- renderPlotly({
    #filter by time input
    gender_plot_data <- gender_prop_data %>% 
      filter(visitation_period == input$time_period_choice)
    #visualizing plot
    gender_plot <- ggplot(data =gender_plot_data) +
      geom_col(mapping = aes(x = visitation_period, y = visitation_prop, fill = gender)) +
      scale_fill_manual('Product', values=c("#645D9B","#D5D1E9")) +
      labs(x = "Time after first visit", y = "Proportion of return visits", title = "Return visits by gender")
    #doing the plot
    ggplotly(gender_plot) 
  })
  
}