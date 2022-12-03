# Executes all the R Script files and runs the shinyApp.

source(file.path("./global.R"))
source(file.path("./server.r"))
source(file.path("./ui.R"))

shinyApp(ui, server)