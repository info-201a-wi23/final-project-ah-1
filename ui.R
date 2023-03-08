library("shiny")
library("ggplot2")
library("plotly")
library("markdown")
library("bslib")
library("tidyverse")

# load any data needed here (for widget choices)

# BootSwatch Theme setup (if anyone would like to switch themes/make a custom one, go ahead!)
my_theme <- bs_theme_update(my_theme, bootswatch = "cosmo")


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

ethnicity_viz_tab <- tabPanel(
  "TAB NAME",
  sidebarLayout(
    sidebarPanel(
    ),
    mainPanel(
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
    selected = 
  )

slider_widget <- sliderInput(
  inputId = "year_selection",
  label = "year",
  min = min(certs$full_date_estab),
  max = max(certs$full_date_estab),
  value = c(1915, 2015),
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


# Williams tabs (partially commented out as the files dont exist yet)

intro_tab <- tabPanel(
  "Introduction",
  fluidPage(
    column(
    # includeMarkdown("intro.md")
    ),
    column(
    # image here?
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
  theme = my_theme,
  # Home page title
  "Home",
  intro_tab,
  zipcode_viz_tab,
  ethnicity_viz_tab,
  time_vis_tab,
  conclusion_tab
)