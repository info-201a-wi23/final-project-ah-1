library("shiny")
library("ggplot2")
library("plotly")
library("tidyverse")
library("scales")
library("maps")
library("dplyr")
library("zipcodeR")

# load in data
full_df <- read.csv("fulldataframe.csv")

# Audreys work

# Noors work

# Zachs work


# renders - please keep data in this section to a minimum
server <- function(input, output) {
  
  # Audreys render
  output$zipcode_map <- renderPlotly({
    
    
    return(zipcode_map)
  })
  
  # Noors render
  
  output$NAME_HERE <- renderPlotly({
    
    
    return(NAME_HERE)
  })
  
  # Zachs render
  
  output$NAME_HERE <- renderPlotly({
    
    
    return(NAME_HERE)
  })
  
}