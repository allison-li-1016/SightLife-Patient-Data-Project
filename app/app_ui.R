#import necessary libraries
library(shiny)
library(ggplot2)
source("app_server.R")
source("map_graphs.R")
source("age_return_visit_graphs.R")

#Graph display components

#Filter by time period (gender vs. patient drop-off rate)
time_period_input <- selectInput(
  inputId = "time_period_choice",
  choices = sort(unique(visitation_period)),
  selected = sort(unique(visitation_period))[1],
  label  = "Choose a time period"
)

#Filter by age m1_age_graph
m1_age_input  <- sliderInput(
  inputId = "m1_age_choice", 
  label = "choose a age range for the data to display",
  min = min(unique_ages),
  max = max(unique_ages),
  value = c(18, 45), 
  step = 1,
  animate = animationOptions(interval = 300, loop = TRUE)
)

#Filter by age m3_age_graph
m3_age_input  <- sliderInput(
  inputId = "m3_age_choice", 
  label = "choose a age range for the data to display",
  min = min(unique_ages),
  max = max(unique_ages),
  value = c(18, 45), 
  step = 1,
  animate = animationOptions(interval = 300, loop = TRUE)
)


#Filter by age y1_age_graph
y1_age_input  <- sliderInput(
  inputId = "y1_age_choice", 
  label = "choose a age range for the data to display",
  min = min(unique_ages),
  max = max(unique_ages),
  value = c(18, 45), 
  step = 1,
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
  tags$img(alt="Cover", src="coverPhoto.png"),
  tags$h1("Project Overview and Introduction"),
  p("This database holds extensive clinical data from patients who've received corneal transplant surgeries from hospitals in the developing areas of Bhubaneswar and Vizag in India. While corneal transplant surgery remains an effective choice for patients with advanced corneal disease, the long-term prognosis of these allografts is especially diminished for developing countries. Since the patient records are collected from tertiary hospitals, this data will provide a good indication of the level of patient burden within developing areas such as these secondary cities in India."),
  br(),
  p("This data set contains corneal transplant clinical records from 1513 patients at the LV Prasad Eye Institute of Bhubaneswar and Vizag in India. The LVPEI Institute in Bhubaneswar and Vizag are both tertiary level hospitals for eye and cornea health in their respective cities. These patient records hold a collective of 7-10 years of data, mostly from local patients within a 200-kilometer radius from the hospital."),
  br(),
  p("The goal of this database is to identify trends that point to barriers of access or poor clinical results, in hopes of bettering post-transplant regiments to optimize patient outcomes for corneal transplants. This database will be utilized to enrich post-transplant research, create better post-transplant protocols for all clinical settings, and to build a clinical algorithm that predicts 1-year post-transplant outcomes."),
  #put in sightlife and LVPEI logo image
  tags$img(alt="Logo", src="logos.png")
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
  p("Out of the 1513 patients included in this dataset, 1 patient's home was in Bangladesh while the other 1512 all lived in India. All of the patients were within a 200 KM distance of a LVPEI Institute in either Bhubaneswar or Vizag. 1430 of the 1513 patients came from the state of Odisha, making it the most common home state of the patients in this sample.")
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
      plotlyOutput(outputId = "scatter_M1"),
    )
  ),
  br(),
  sidebarLayout(
    sidebarPanel(
      m3_age_input 
    ),
    mainPanel(
      plotlyOutput(outputId = "scatter_M3"),
    )
  ),
  sidebarLayout(
    sidebarPanel(
      y1_age_input 
    ),
    mainPanel(
      plotlyOutput(outputId = "scatter_Y1"),
    )
  ),
  br(),
  titlePanel("Observing Patient Revisitation Rates by Surgery Complications"),
  plotlyOutput(outputId = "line"),
  br(),
  #Why included chart and what patterns shown 
  p("Above are observations of successful return visits at 1, 3, and 12 months correlated to gender, age, and the presence of surgery complications. As a summary, according to the data women patients had a higher return visit rate at 12 months in comparison to men, while men had a higher return visit rate at 1 and 3 months. In general, there were little to no correlation between age and return visit rate. While return visit rate decreased over time, surgery complications also slightly decreased, though the rate remained around the same over time.")
)

#page 4 - diagnosis analysis
page_four <- tabPanel(
  "Diagnosis Analysis", 
  titlePanel("Observing Diagnosis Proportions by Age"),
  br(),
  plotlyOutput(outputId = "pie"),
  br(),
  #Why included chart and what patterns shown 
  p("Above is a graph of the proportion of reported conditions from all the patients in the database. Since the highest reported condition was listed under 'Other' (46%), most of the patients had more specific and unique conditions that were not of the listed set. The highest reported condition of the listed set was Active Microbial Keratitis (24%) with Corneal Scar following in second (15%).")
)

ui <- navbarPage(
  "SightLife Patient Data Analysis", 
  page_one,         
  page_two,
  page_three,
  page_four
)
