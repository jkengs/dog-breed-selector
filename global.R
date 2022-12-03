
# Load up the relevant packages (install first if not done before, using install.packages('package_name'))
library("shinythemes")
library("shiny")
library("plotly")
library("tidytuesdayR") 
library("shinyWidgets")
library('shinyjs')
library("dplyr")
library("shinyalert")
library("fontawesome")


# Read the data in csv format and assign to a variable
breed_traits <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-02-01/breed_traits.csv')
breed_traits_filtered <- breed_traits