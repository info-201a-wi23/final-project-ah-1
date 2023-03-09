library("shiny")
library("ggplot2")
library("plotly")
library("markdown")
library("bslib")
library("tidyverse")

# load any data needed here (for widget choices)

# load in data
full_df <- read.csv("fulldataframe.csv")

# BootSwatch Theme setup (if anyone would like to switch themes/make a custom one, go ahead!)
# my_theme <- bs_theme_update(my_theme, bootswatch = "cosmo")


# Audreys tab

zipcode_viz_tab <- tabPanel(
  "Zipcode Map",
  sidebarLayout(
    sidebarPanel(
    ),
    mainPanel(
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
  "Ethnicity Analysis",
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
    choices = cert_types,
    selectize = TRUE,
    # True allows you to select multiple choices...
    multiple = TRUE,
    selected = "WBE"
  )

slider_widget <- sliderInput(
  inputId = "year_selection",
  label = "year",
  min = 1984-01-01,
  max = 2018-01-01,
  value = c(1984-01-01, 2018-01-01),
  sep = "")

# Put a plot in the middle of the page
main_panel_plot <- mainPanel(
  # Make plot interactive
  plotlyOutput(outputId = "cert_plot")
)
time_vis_tab <- tabPanel(
  "Certifications over time",
  sidebarLayout(
    sidebarPanel(
      select_widget,
      slider_widget
    ),
    mainPanel
  )
)


intro_tab <- tabPanel(
  "Introduction",
  fluidPage(
    column(
      htmlOutput("introduction", align="center")
    ),
    column(
      imageOutput("img")
    )
  )
)

conclusion_tab <- tabPanel(
  "Conclusion",
  fluidPage(
    # includeMarkdown("conclusion.md")
  )
)


# ui creation
ui <- navbarPage(
  # Select Theme
  # theme = my_theme,
  
  # Home page title
  "Home",
  intro_tab,
  zipcode_viz_tab,
  ethnicity_viz_tab,
  time_vis_tab,
  conclusion_tab,
  theme = bs_theme(bootswatch = "minty")
)