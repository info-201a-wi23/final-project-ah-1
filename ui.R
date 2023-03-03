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

time_vis_tab <- tabPanel(
  "TAB NAME",
  sidebarLayout(
    sidebarPanel(
    ),
    mainPanel(
    )
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