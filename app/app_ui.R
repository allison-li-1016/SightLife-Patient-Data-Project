#import necessary libraries
library(shiny)
library(ggplot2)
source("app_server.R")
source("C:\\Users\\allis\\Desktop\\SightLife-Patient-Data-Project\\analysis\\map_graphs.R")
source("C:\\Users\\allis\\Desktop\\SightLife-Patient-Data-Project\\analysis\\age_return_visit_graphs.R")

#Graph display components

#Filter by time period (gender vs. patient drop-off rate)
time_period_input <- selectInput(
  inputId = "time_period_choice",
  choices = sort(unique(visitation_period)),
  selected = sort(unique(visitation_period))[1],
  label  = "Choose a time period"
)

#Filter by time period (comp vs. revisitation)
month_input <- selectInput(
  inputId = "months_choice",
  choices = months,
  label  = "Choose a time period"
)

#Filter by age m1_age_graph
m1_age_input  <- sliderInput(
  inputId = "m1_age_choice", 
  label = "choose a age range for the data to display",
  min = min(unique_ages),
  max = max(unique_ages),
  value = c(18, 45), 
  step = 30,
  animate = animationOptions(interval = 300, loop = TRUE)
)

#Filter by age m3_age_graph
m3_age_input  <- sliderInput(
  inputId = "m3_age_choice", 
  label = "choose a age range for the data to display",
  min = min(unique_ages),
  max = max(unique_ages),
  value = c(18, 45), 
  step = 30,
  animate = animationOptions(interval = 300, loop = TRUE)
)


#Filter by age y1_age_graph
y1_age_input  <- sliderInput(
  inputId = "y1_age_choice", 
  label = "choose a age range for the data to display",
  min = min(unique_ages),
  max = max(unique_ages),
  value = c(18, 45), 
  step = 30,
  animate = animationOptions(interval = 300, loop = TRUE)
)

#Filter by age diagnosis donut
diagnosis_age_input  <- sliderInput(
  inputId = "diagnosis_age_choice", 
  label = "choose a age range for the data to display",
  min = min(unique_ages),
  max = max(unique_ages),
  value = c(18, 45), 
  step = 30,
  animate = animationOptions(interval = 300, loop = TRUE)
)

#Page aesthetics 

#Page one intro page
page_one <- tabPanel(
  "Introduction", 
  #put in sightlife images
  tags$img(alt="Covid-19", src="COVID-19.png"),
  tags$h1("Project Overview and Introduction"),
  p("copy/paste summary here"),
  #put in sightlife and LVPEI logo image
  tags$img(alt="Covid-19", src="COVID-19.png")
)

#page 2 - map of India/patient locations
page_two <- tabPanel(
  "Location Analysis", 
  titlePanel("Observing Distribution of Patients by Location"),
  br(),
  mainPanel(
    plotlyOutput(outputId = "map"),
  ),
  br(),
  #Why included chart and what patterns shown 
  p("put the actual analysis info here.")
)

#page 3 - patient drop-off rates by age, gender, surgery complications
page_three <- tabPanel(
  "Patient Revisitation Rate Analysis", 
  titlePanel("Observing Patient Revisitation Rates by Gender"),
  br(),
  sidebarLayout(
    sidebarPanel(
      time_period_input 
    ),
    mainPanel(
      plotlyOutput(outputId = "barchart_gen"),
    )
  ),
  br(),
  titlePanel("Observing Patient Revisitation Rates by Age"),
  sidebarLayout(
    sidebarPanel(
      m1_age_input 
    ),
    mainPanel(
      plotlyOutput(outputId = "output$scatter_M1"),
    )
  ),
  br(),
  sidebarLayout(
    sidebarPanel(
      m3_age_input 
    ),
    mainPanel(
      plotlyOutput(outputId = "output$scatter_M3"),
    )
  ),
  sidebarLayout(
    sidebarPanel(
      y1_age_input 
    ),
    mainPanel(
      plotlyOutput(outputId = "output$scatter_Y1"),
    )
  ),
  br(),
  titlePanel("Observing Patient Revisitation Rates by Surgery Complications"),
  sidebarLayout(
    sidebarPanel(
      month_input
    ),
    mainPanel(
      plotlyOutput(outputId = "line"),
    )
  ),
  br(),
  #Why included chart and what patterns shown 
  p("summary of info ")
)

#page 4 - diagnosis analysis
page_four <- tabPanel(
  "Diagnosis Analysis", 
  titlePanel("Observing Diagnosis Proportions by Age"),
  br(),
  plotlyOutput(outputId = "pie"),
  br(),
  #Why included chart and what patterns shown 
  p("diagnosis summary.")
)

ui <- navbarPage(
  "SightLife Patient Data Analysis", 
  page_one,         
  page_two,
  page_three,
  page_four
)
