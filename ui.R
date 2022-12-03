
# Title Panel
title_panel <- tabPanel(
  'Header',
  titlePanel(h1('Dog Breed Selector', align = "center")),
)

#SideBar 
sidebar_content <- sidebarPanel(
  
  h5('Select Filters'),
  width = 4,
  height = 10,
  
  # Selection for Coat Type
  selectInput(inputId = 'coat_type', label = 'Coat Type',
                     choices = c('Double' = 'Double',
                                 'Smooth' = 'Smooth',
                                 'Wavy' = 'Wavy',
                                 'Wiry' = 'Wiry',
                                 'Corded' = 'Corded',
                                 'Rough' = 'Rough',
                                 'Curly' = 'Curly',
                                 'Hairless' = 'Hairless',
                                 'Silky' = 'Silky'
                                 )),
  # Selection for Coat Length
  selectInput(inputId = 'coat_length', label = 'Coat Length',
                     choices = c('Short' = 'Short',
                                 'Medium' = 'Medium',
                                 'Long' = 'Long'
                                 )),
  # Selection for Living Condition
  radioButtons(inputId = 'living_condition', label = 'Living Conditions', 
               choices = c('Living with Family' = 'Living with Family',
                           'Living Alone' = 'Living Alone'
               )),
  # Selection for whether there are children at Home
  radioButtons(inputId = 'children', label = 'Young Children at Home', 
               choices = c('Yes' = 'Yes',
                           'No' = 'No'
               )),
  # Selection for whether there are other Dogs at Home
  radioButtons(inputId = 'dogs', label = 'Other Dogs at Home', 
               choices = c('Yes' = 'Yes',
                           'No' = 'No'
               )),
  
  # Selection for whether there are frequent visitors 
  radioButtons(inputId = 'strangers', label = 'Frequent Visitors', 
               choices = c('Yes' = 'Yes',
                           'No' = 'No'
               )),
  # Action button to apply the filters above on the dataset
  actionButton(inputId= 'apply', icon("filter"),label = "Apply Filter", width = NULL)
  
  )

# Scatterpolar plot and the render of drop down selection for filtered breeds
main_content <- mainPanel(
  uiOutput("breed_list"),
  plotlyOutput('plot_traits')
  )     

# Combine both sidebar and main content into the sidebarLayout
# And also renders two buttons for "About" and "More Info"
main_tab <- tabPanel(
  'Main',
  sidebarLayout(sidebar_content,main_content),
  actionButton(inputId= 'about',label = "About", width = NULL, icon("circle-info"), 
               style="color: #fff; background-color: #9FAFB0; border-color: #000000"),
  actionButton(inputId= 'info',label = "More Info", width = NULL, icon("circle-info"),
               style="color: #fff; background-color: #9FAFB0; border-color: #000000")
)

# Fluidpage: Display all content and panels in one page,
# and also add the image below the title.
ui <- fluidPage (theme = shinytheme("flatly"), 
                 title_panel,
                 fluidRow(column(12, align = "center", div(style='display: block;',
                          img(src = "main_page.png")))),
                 main_tab)