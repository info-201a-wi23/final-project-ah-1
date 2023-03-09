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
zipcodes_lat <- full_df %>% group_by(Vendor_Formal_Name) %>% summarize(reverse_zipcode(ZIP)[8])

zipcodes_long <- full_df %>% group_by(Vendor_Formal_Name) %>% summarize(reverse_zipcode(ZIP)[9])

zipcode_df <- left_join(full_df, zipcodes_lat, by = "Vendor_Formal_Name")

zipcode_df <- left_join(zipcode_df, zipcodes_long, by = "Vendor_Formal_Name")

zipcode_df <- zipcode_df %>% select(certification, lat, lng, Vendor_Formal_Name, City, State)

us_shape <- map_data("state")

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
# Noors work

# Zachs work
certs_2 <- full_df %>%  select(Vendor_Formal_Name, certification, Date_Of_Establishment) %>% 
  filter(Date_Of_Establishment != "") %>% separate_rows(certification, Date_Of_Establishment, sep = ",")

certs_2$Date_Of_Establishment <- (substr(certs_2$Date_Of_Establishment, 1, 4))

certs_2 <- certs_2 %>% group_by(certification, Date_Of_Establishment) %>% summarise(certs_per_year = n()) %>% 
  mutate(full_date_estab = as.Date(paste0(Date_Of_Establishment,"-01-01")))


# renders - please keep data in this section to a minimum
server <- function(input, output) {
  
  # Williams image
  output$img <- renderImage({
    
    list(src = "infoFinal.png",
         width = "100%",
         align = "center")
    
  }, deleteFile = F)
  
  # Williams writing
  output$introduction <- renderUI({
    p1 <- paste("For our final project, we will be analyzing New York City's Minority and
                Women-owned Business Enterprise (M/WBE), Emerging Business Enterprise (EBE),
                and Locally-based Business Enterprise (LBE) certified businesses related to the construction industry.")
    p2 <- paste("We intend to explore to which extent do minority and women-owned businesses are
                represented in NYC's diverse communities, to identify potential areas of opportunity for
                contractors and vendors, and to analyze trends in the growth and success of certified businesses over time.")
    p3 <- paste("Despite the efforts to promote diversity, there are still disparities and
                inequalities in the distribution of business opportunities.
                Through this project, we aim to answer the following research questions:")
    p4 <- paste("1. In terms of race and ethnicity, how does the demographic representation of minority-owned
                businesses in New York City compare to the city's overall demographic?
                The purpose of this question is to reveal how well these minority- and
                women-owned certified businesses represent the city's diverse communities.")
    p5 <- paste("2. What is the city's geographic distribution of certified businesses?
                The purpose of this question is to reveal inequalities in the distribution of
                opportunities for minority- and women-owned businesses across the city.")
    p6 <- paste("3. What has happened to the number of certified businesses over time?
                The purpose of this question is to reveal trends and patterns in the growth and success of
                the city's minority and women-owned businesses, which can be used to help decide
                future policies regarding this certification program.")
    p7 <- paste("The dataset that we will be using is titled: the NYC M/WBE, LBE, and EBE Certified Business List dataset,
                which is publicly available on the New York City Department of Small Business Services (SBS) website
                as well as on Kaggle where we obtained it.")
    p8 <- paste("This dataset contains information on M/WBEs, LBEs, and EBEs certified by the city
                (thus the dataset contain business from outside New York, in fact, it is spreaded to over 33 states)
                and includes details such as the company name, address, industry, certification type, and more.
                The dataset is regularly updated to reflect changes in the certification status of businesses.")
    p9 <- paste("Dataset: https://www.kaggle.com/datasets/new-york-city/nyc-m-wbe,-lbe,-and-ebe-certified-business-list?select=m-wbe-lbe-and-ebe-certified-business-list.csv")
    p10 <- paste("Like all data, this dataset has limitations and ethical questions we need to consider.
                 For example, it only includes businesses certified by NYC as M/WBE, LBE, or EBE, leaving out other diverse businesses.
                 This lack of representation could lead to issues of equity.
                 Also, we don't know how often women and minorities receive EBE and LBE licenses,
                 and there may be an overlap between owners of these licenses.
                 Additionally, the data doesn't provide information on how the city chooses who gets licenses,
                 which could create inequity in distribution. There are also concerns about data accuracy due to
                 bias and selection bias, as well as potential privacy issues since the dataset includes personal information.")
    p11 <- paste("Overall, this project is intended to explore minority and women owned business mainly in New York City,
                 in order to use the analysis to identify opportunity for both vendor and potential contractor.
                 Additionally, we are also raising concern regarding ethical question and limitation of the dataset used.")
    p12 <- paste("Below is a stable diffusion generated image of “diverse community of minority contributing to live of major city”")
    
    HTML(paste(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12, sep = '<br/><br/>'))
  })
  
  
  # Audreys render
  output$zipcode_map <- renderPlotly({
    
    # zipcode
    zipcode_filtered <- zipcode_df %>% filter(certification %in% input$zipcode_choice)
    
    zipcode_map <- ggplot(data = us_shape) +
      geom_polygon(aes(x = long,
                       y = lat,
                       group = group)) +
      geom_point(data = zipcode_filtered,
                 aes(x = lng,
                     y = lat,
                     text = paste("Vendor:", Vendor_Formal_Name, "<br>", "<br>", "Location:", City, State),
                     color = certification)) +
      coord_map() +
      blank_theme
    
    
    return(ggplotly(zipcode_map))
  })
  
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
  
  output$cert_plot <- renderPlotly({
    
    filtered_df <- certs_2 %>%
      filter(certification %in% input$cert_selection) %>%
      filter(full_date_estab > as.Date(paste0(input$year_selection[1], "-01-01")) & full_date_estab < as.Date(paste0(input$year_selection[2], "-01-01")))
    
    cert_plot <- ggplot(filtered_df, aes(full_date_estab,certs_per_year, color = certification)) +
      geom_point()+
      labs(title = "Certifications Over Time", x = "Year", y = "Certifications")
    
    return(cert_plot)
  })
  
}
  