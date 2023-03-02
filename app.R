install.packages("plotly")
library("shiny")
library("ggplot2")
library("plotly")
source("ui.R")
source("server.R")


# Runs the application (both ui and server)
shinyApp(ui = my_ui, server = my_server)