#Import necessary libraries
library(shiny)
library(tidyverse)
library(ggplot2)
library(plotly)
source("C:\\Users\\allis\\Desktop\\SightLife-Patient-Data-Project\\analysis\\gender_return_visit_graphs.R")
source("C:\\Users\\allis\\Desktop\\SightLife-Patient-Data-Project\\analysis\\age_return_visit_graphs.R")
source("C:\\Users\\allis\\Desktop\\SightLife-Patient-Data-Project\\analysis\\surgery_comp_revisitation_graphs.R")
source("C:\\Users\\allis\\Desktop\\SightLife-Patient-Data-Project\\analysis\\map_graphs.R")
source("C:\\Users\\allis\\Desktop\\SightLife-Patient-Data-Project\\analysis\\diagnosis_graphs.R")

#Display outputs
server <- function(input, output, session){
  #Location Data
  output$map <- renderPlotly({
    #visualizing plot
    map_plot <- ggplot() + 
      geom_polygon(data = India_df, aes(x = long, y = lat, group = group, fill = n), color = "black", size = 0.1)  +
      scale_fill_continuous(low = "#D5D1E9", high = "#645D9B") +
      labs(title = "Patients by State in India", x = "", y = "", fill = "Number of Patients") +
      blank_theme
    #doing the plot
    ggplotly(map_plot) 
  })
  
   #Gender/DropOff Analysis/Graph
  output$barchart_gen <- renderPlotly({
    #filter by time input
    gender_plot_data <- gender_prop_data %>% 
      filter(visitation_period == input$time_period_choice)
    #visualizing plot
    gender_plot <- ggplot(data =gender_plot_data) +
      geom_col(mapping = aes(x = visitation_period, y = visitation_prop, fill = gender)) +
      scale_fill_manual('Gender', values=c("#645D9B","#D5D1E9")) +
      labs(x = "Time after first visit", y = "Proportion of return visits", title = "Return visits by gender")
    #doing the plot
    ggplotly(gender_plot) 
  })
  
  #M1 Age/Return Visit Graph 
  output$scatter_M1 <- renderPlotly({
    #filter by age input
    m1_plot_data <- reactive({
      m1_filtered <- total_age_data %>% 
        filter(unique_ages <= input$m1_age_choice[2],unique_ages >= input$m1_age_choice[1])
    })
    #visualizing plot
    age_plot_m1 <- ggplot(m1_plot_data()) +
      geom_point(mapping = aes(x = unique_ages, y = m1_values), color ="#645D9B") +
      labs(x = "Ages", y = "Proportion Return Visits at Month 1", title = "Age vs. Return Visit Month 1")
    #doing the plot
    ggplotly(age_plot_m1) 
  })
  
  #M3 Age/Return Visit Graph 
  output$scatter_M3 <- renderPlotly({
    #filter by age input
    m3_plot_data <- reactive({
      m3_filtered <- total_age_data %>% 
        filter(unique_ages <= input$m3_age_choice[2],unique_ages >= input$m3_age_choice[1])
    })
    #visualizing plot
    age_plot_m3 <- ggplot(m3_plot_data()) +
      geom_point(mapping = aes(x = unique_ages, y = m3_values), color ="#645D9B") +
      labs(x = "Ages", y = "Proportion Return Visits at Month 3", title = "Age vs. Return Visit Month 3")
    #doing the plot
    ggplotly(age_plot_m3) 
  })
  
  #Y3 Age/Return Visit Graph 
  output$scatter_Y1 <- renderPlotly({
    #filter by age input
    y1_plot_data <- reactive({
      y1_filtered <- total_age_data %>% 
        filter(unique_ages <= input$y1_age_choice[2],unique_ages >= input$y1_age_choice[1])
    })
    #visualizing plot
    age_plot_y1 <- ggplot(y1_plot_data()) +
      geom_point(mapping = aes(x = unique_ages, y = y1_values), color ="#645D9B") +
      labs(x = "Ages", y = "Proportion Return Visits at Year 1", title = "Age vs. Return Visit Year 1")
    #doing the plot
    ggplotly(age_plot_y1) 
  })
  
  #Surgery Complications vs. Revisitation Graph
  output$line <- renderPlotly({
    #visualizing plot
    colors = c("Revisitation Rate" = "#645D98", "Surgery Complication Rate" = "#82D8D5")
    p = ggplot() + 
      geom_line(data = gen_revisit_data, mapping = aes(x = months, y = revisitation_rate, color = "Revisitation Rate"), size = 1.5) +
      geom_line(data = gen_comp_data, mapping = aes(x = months, y = comp_rate, color = "Surgery Complication Rate"), size = 1.5) +
      labs(x = "Months", y = "Proportion", title = "Revisitation and Surgery Complication Rates over Time", color = "Legend") +
      scale_color_manual(values = colors) 
    #doing the plot
    ggplotly(p) 
  })
  
  #Diagnosis Distribution Graph
  output$pie <- renderPlotly({
    #visualize plot
    diagnosis_donut <- ggplot(data =diagnosis_count) +
      geom_col(mapping = aes(x = condition, y = prop, fill = condition)) +
      scale_fill_manual("Diagnosis Names", values = c("Active microbial keratitis" = "#645D9B", "Corneal edema" = "#9991C6", "Corneal scar" = "#D5D1E9", "Dystrophy" = "#499996", "Ectatic disorder" = "#82D8D5", "Failed graft " = "#f2c380", "Others  specify the diagnosis" = "#BF6059")) +
      labs(x = "Condition", y = "Proportion of Patient Conditions", title = "Diagnosis Proportions") +
      theme(axis.text.x=element_blank(),
            axis.ticks.x=element_blank())
    ggplotly(diagnosis_donut) 
  })
}