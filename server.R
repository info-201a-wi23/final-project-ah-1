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
certs <- full_df %>%  select(Vendor_Formal_Name, certification, Date_Of_Establishment) %>% 
  filter(Date_Of_Establishment != "") %>% separate_rows(certification, Date_Of_Establishment, sep = ",")

certs$Date_Of_Establishment <- format(as.Date(certs$Date_Of_Establishment), "%Y")

certs <- certs %>% group_by(certification, Date_Of_Establishment) %>% summarise(certs_per_year = n()) %>% 
  mutate(full_date_estab = as.Date(paste0(Date_Of_Establishment,"-1-1")))

cert_types <- unique(certs$certification)


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
  
  output$cert_plot <- renderPlotly({
    
    filtered_df <- certs %>%
      filter(certification %in% input$cert_selection) %>%
      filter(Year > input$year_selection[1] & Year < input$year_selection[2])
    
    cert_plot <- ggplot(filtered_df, aes(full_date_estab,certs_per_year, color = 'Certification')) +
      geom_point()+
      labs(title = "", x = "Year", y = "Certifications")
    
    return(cert_plot)
  })
  
}