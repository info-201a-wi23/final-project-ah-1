library("shiny")
library("ggplot2")
library("plotly")
library("tidyverse")
library("scales")
library("maps")
library("dplyr")
library("zipcodeR")

# Load in relevant data
full_df <- read.csv("fulldataframe.csv")

# Audreys work

# Noors work

# Zachs work


# renders - please keep data in this section to a minimum
server <- function(input, output) {
  
  # Audreys render
  # output$zipcode_map <- renderPlotly({
  #   
  #   
  #   return(zipcode_map)
  # })
  
  # Noors render
  
  output$ethnicity_plot <- renderPlotly({
    
    # Filter for relevant data
    selected_df <- full_df %>% 
      filter(Ethnicity != "N/A") %>% 
      filter(City %in% input$city_selection) %>% 
      group_by(Ethnicity, State) %>% 
      summarise(num_vendors = n_distinct(Vendor_Formal_Name, na.rm = T))
    
    # Create bar plot
    ethnicity_plot <- ggplot(data = selected_df) +
      geom_col(mapping = aes(
        x = num_vendors,
        y = reorder(Ethnicity, +num_vendors),
        fill = Ethnicity,
        text = paste("Number of Vendors:", num_vendors, '\n', "State:", State)
      )) +
      scale_fill_manual(
        values =
          c("#bc6c25", "#606c38", "#dda15e", "#283618")
      ) +
      labs(
        title = paste("Representation of Ethnicities Among", input$city_selection, "Businesses"),
        x = "Number of Vendors",
        y = "Ethnicity"
      ) +
      theme(panel.background = element_rect(fill = "#f5ebe0"))
    
    return(ggplotly(ethnicity_plot, tooltip = "text"))
  })
  
  # Zachs render
  
  # output$NAME_HERE <- renderPlotly({
  #   
  #   
  #   return(NAME_HERE)
  # })
  
}