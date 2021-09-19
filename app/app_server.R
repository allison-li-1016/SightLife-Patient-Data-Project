#Import necessary libraries
library(shiny)
library(tidyverse)
library(ggplot2)
library(plotly)
source("C:\\Users\\allis\\Desktop\\SightLife-Patient-Data-Project\\analysis\\gender_return_visit_graphs.R")
source("C:\\Users\\allis\\Desktop\\SightLife-Patient-Data-Project\\analysis\\age_return_visit_graphs.R")
source("C:\\Users\\allis\\Desktop\\SightLife-Patient-Data-Project\\analysis\\surgery_comp_revisitation_graphs.R")





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
  
  #M1 Age/Return Visit Graph 
  output$scatter_M1 <- renderPlotly({
    #filter by age input
    m1_plot_data <- reactive({
      m1_filtered <- total_age_data %>% 
        filter(unique_ages <= input$m1_age_choice[2],unique_ages >= input$m1_age_choice[1])
    })
    #visualizing plot
    age_plot_m1 <- ggplot(data = m1_plot_data) +
      geom_point(mapping = aes(x = unique_ages, y = m1_values), color ="#645D9B") +
      labs(x = "Ages", y = "Proportion Return Visits at Month 1", title = "Age vs. Return Visit Month 1")
    #doing the plot
    ggplotly(m1_plot_data) 
  })
  
  #M3 Age/Return Visit Graph 
  output$scatter_M3 <- renderPlotly({
    #filter by age input
    m3_plot_data <- reactive({
      m3_filtered <- total_age_data %>% 
        filter(unique_ages <= input$m3_age_choice[2],unique_ages >= input$m3_age_choice[1])
    })
    #visualizing plot
    age_plot_m3 <- ggplot(data = m3_plot_data) +
      geom_point(mapping = aes(x = unique_ages, y = m1_values), color ="#645D9B") +
      labs(x = "Ages", y = "Proportion Return Visits at Month 3", title = "Age vs. Return Visit Month 3")
    #doing the plot
    ggplotly(m3_plot_data) 
  })
  
  #Y1 Age/Return Visit Graph 
  output$scatter_Y1 <- renderPlotly({
    #filter by age input
    y1_plot_data <- reactive({
      y1_filtered <- total_age_data %>% 
        filter(unique_ages <= input$y1_age_choice[2],unique_ages >= input$y1_age_choice[1])
    })
    #visualizing plot
    age_plot_y1 <- ggplot(data = y1_plot_data) +
      geom_point(mapping = aes(x = unique_ages, y = y1_values), color ="#645D9B") +
      labs(x = "Ages", y = "Proportion Return Visits at Year 1", title = "Age vs. Return Visit Year 1")
    #doing the plot
    ggplotly(y1_plot_data) 
  })
  
  #Surgery Complications vs. Revisitation Graph
  output$line <- renderPlotly({
    #filter by age input
    revisitation_data <- reactive({
      revisit_filtered <- gen_revisit_data%>% 
        filter(months <= input$months_choice[2],months >= input$months_choice[1])
    })
    comp_data <- reactive({
      comp_filtered <- gen_comp_data%>% 
        filter(months <= input$months_choice[2],months >= input$months_choice[1])
    })
    #visualizing plot
    p = ggplot() + 
      geom_line(data = revisitation_data, aes(x = months, y = revisitation_rate, color = "Revisitation Rate"), size = 1.5) +
      geom_line(data = comp_data, aes(x = months, y = comp_rate, color = "Surgery Complication Rate"), size = 1.5) +
      labs(x = "Months", y = "Proportion", title = "Revisitation and Surgery Complication Rates over Time") +
      scale_color_manual(values = colors)
    #doing the plot
    ggplotly(p) 
  })
  
  #Diagnosis Distribution Graph
  output$pie <- renderPlotly({
    #filter by age input
    final_patient_data <- reactive({
        filtered_patients<- patient_data%>% 
          group_by(GEN_AGE) %>% 
          filter(GEN_AGE <= input$diagnosis_age_choice[2],GEN_AGE >= input$diagnosis_age_choice[1])
    })
    diagnosis_count <- table(final_patient_data$GEN_INDICATION_OF_PK) 
    diagnosis_count <- data.frame(diagnosis_count)
    colnames(diagnosis_count) <- c("condition", "patients")
    diagnosis_count <- diagnosis_count[-1,]
    total <- sum(diagnosis_count$patients)
    diagnosis_count$prop <- with(diagnosis_count, patients/total)
    diagnosis_count$ymax = cumsum(diagnosis_count$prop)
    diagnosis_count$ymin = c(0, head(diagnosis_count$ymax, n=-1))
    #visualizing plot
    diagnosis_donut <- ggplot(diagnosis_count, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=condition)) +
      geom_rect() +
      coord_polar(theta="y") + 
      scale_fill_brewer(palette=3) +
      scale_color_brewer(palette=3) +
      xlim(c(2, 4)) +
      theme_void()
    #doing the plot
    ggplotly(diagnosis_donut) 
  })
}