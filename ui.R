library("shiny")
library("ggplot2")
library("plotly")
library("markdown")
library("bslib")
library("tidyverse")

# load in data
full_df <- read.csv("fulldataframe.csv")

my_theme <- bs_theme(
  bg = "#edf2f4",
  fg = "#264653",
  primary = "#000814"
)

# Audreys tab

zipcode_viz_tab <- tabPanel(
  
  "Zipcode Map",
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput(
        inputId = "zipcode_choice",
        label = "Certification Type",
        choices = unique(full_df$certification),
        selectize = TRUE,
        # True allows you to select multiple choices...
        multiple = TRUE,
        selected = "MBE")
      
    ),
    
    mainPanel(
      
      plotlyOutput("zipcode_map"),
      h4("Description"),
      paste("This map displays the locations of each vendor assigned a certification from the New York City government. We can see the wide range of businesses (not all in New York as one might expect), along with compare densities of businesses in different regions of New York and other states. The widget allows easier visual comparison by limiting the types of businesses on the map, and the map itself can be zoomed in on. Understanding the geographic distribution of certified vendors can provide us with valuable insights into the business distribution in New York. It can also help us identify areas with a lack of certain types of businesses, which could be useful for economic development planning and determining areas where extra resources and support should be allocated.")
      
    )
  )
)

# Noors tab

select_widget <- selectInput(
  inputId = "city_selection",
  label = "Cities",
  choices = unique(full_df$City),
  selected = "New York",
  multiple = F
)

bar_plot <- plotlyOutput(outputId = "ethnicity_plot")

heading <- h4("Description")
plot_description <- paste("This chart displays vendor information in an attempt to answer the question: Which ethnicities are more represented/are underrepresented among businesses in certain cities in New York? I chose to represent ethnicity data in the form of a bar plot where a user can select their desired city. This provides users with a clear and easy-to-interpret visualization of the distribution of ethnicities among various cities in the state of New York. By displaying the number of vendors for each ethnicity, my plot provides insights into the diversity of NY businesses and highlights disparities and imbalances among their representation. This information can allow us to identify which cities need more attention and resources allocated to allow minority and women-owned businesses to thrive.")

ethnicity_viz_tab <- tabPanel(
  "Ethnicity Distribution",
  sidebarLayout(
    sidebarPanel(
      select_widget
    ),
    mainPanel(
      bar_plot,
      heading,
      plot_description
    )
  )
)
# Zachs tab

select_widget <-
  selectInput(
    inputId = "cert_selection",
    label = "Certification Type",
    choices = unique(full_df$certification),
    selectize = TRUE,
    # True allows you to select multiple choices...
    multiple = TRUE,
    selected = "WBE"
  )

slider_widget <- sliderInput(
  inputId = "year_selection",
  label = "year",
  min = 1904,
  max = 2019,
  value = c(1904, 2019),
  sep = "")

# Put a plot in the middle of the page

scatter_plot <- plotlyOutput(outputId = "cert_plot")

heading_2 <- h4("Description")
plot_description_2 <- paste("The plot above displays the number of certifications (WBE, MBE, LBE, EBE) per year. This data visualization is attempting to answer the question: ‘How have the number of certifications (frequency and rate of certification) changed over time?’ The data can be filtered by certification type, which is essential when the user would like to compare two or more certifications longitudinally. There is also a slider widget to filter the years in which the plot displays. This can be important when the user is focused on a specific range of dates, like “2000-2021” or “1990-1999”. By displaying the data over a range of dates, the plot provides information on how often certifications are being awarded, and historical patterns of such certifications. This allows us to understand the breadth of the certification process and how it is growing (or shrinking) over time.")

time_vis_tab <- tabPanel(
  "Certifications Over Time",
  sidebarLayout(
    sidebarPanel(
      select_widget,
      slider_widget
    ),
    mainPanel(
      scatter_plot,
      heading_2,
      plot_description_2
    )
  )
)


intro_tab <- tabPanel(
  "Introduction",
  fluidPage(
    column(
      width = 12, 
      h3("Introduction", align = "center"),
      htmlOutput("introduction")
    ),
    column(
      width = 12, 
      imageOutput("img")
    )
  )
)


conclusion_tab <- tabPanel(
  "Conclusion",
  fluidPage(
    h3("Conclusion", align = "center"),
    htmlOutput("conclusion")
  )
)


# ui creation
ui <- navbarPage(

  # Home page title
  "NY Businesses Analysis",
  intro_tab,
  zipcode_viz_tab,
  ethnicity_viz_tab,
  time_vis_tab,
  conclusion_tab,
  theme = my_theme
)