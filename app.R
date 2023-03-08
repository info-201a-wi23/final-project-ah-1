# install.packages("plotly")
# may need more installed packages to run app
library("shiny")
library("ggplot2")
library("plotly")

# Source files
source("ui.R")
source("server.R")

# Run the application (both ui and server)
shinyApp(ui = my_ui, server = my_server)