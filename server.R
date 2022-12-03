server <- function(input, output, session) {
  
  # Create a reactive variable (values) and assign them default values
  values <- reactiveValues()
  values$breed <- ""
  values$living_condition <- ""
  values$coat_type <- ""
  values$coat_length <- ""
  values$breed_traits_original <- breed_traits

  ###
  # Observes the "Apply Filter" action button,
  # filters the dataset according to the user input filters,
  # and renders a input selection of breed based on that filtered data
  ###
  observeEvent(input$apply, {
    
    breed_traits_filtered <- breed_traits             # Resets the filtered data whenever the user applies filter
    
    # Records the user inputted filters
    values$living_condition <- input$living_condition 
    values$coat_type <- input$coat_type
    values$coat_length <- input$coat_length
    
    # Filtering of data based on user inputted filters:
    # Filters for dogs with more than 3 points in the chosen trait with a specific value. If the opposite value is selected, no filter
    # will be applied (reset at the start)
    
    if (input$living_condition == 'Living with Family'){
      # Users living with family members
      breed_traits_filtered <- breed_traits_filtered %>% filter(breed_traits_filtered['Affectionate With Family'] > 3)
    }
    
    if (input$children == 'Yes'){
      # Users living with young children
      breed_traits_filtered <- breed_traits_filtered %>% filter(breed_traits_filtered['Good With Young Children'] > 3)
    }
    
    if (input$dogs == 'Yes'){
      # Users living with other dogs
      breed_traits_filtered <- breed_traits_filtered %>% filter(breed_traits_filtered['Good With Other Dogs'] > 3)
    }
    
    if (input$strangers == 'Yes') {
      # Users that have frequent visitors
      breed_traits_filtered <- breed_traits_filtered %>% filter(breed_traits_filtered['Openness To Strangers'] > 3)
    }
    
    # Filtering of data based on preferred coat type/length
    breed_traits_filtered <- breed_traits_filtered %>% filter(breed_traits_filtered['Coat Type'] == values$coat_type)     
    breed_traits_filtered <- breed_traits_filtered %>% filter(breed_traits_filtered['Coat Length'] == values$coat_length) 
    
    # Renders the drop down selection of breeds that
    # meet the filter requirements
    output$breed_list <- renderUI({
      breed_names <- breed_traits_filtered$Breed 
      
      if (dim(breed_traits_filtered)[1] == 0) {
        # No suitable dogs based on filters
        selectInput(inputId = "breed",
                    label = "Select Breed:",
                    choices = ("No suitable dog can be found. Please try another filter."))}
      else {
        # Shows the suitable dogs and allows users to select one
        selectInput(inputId = "breed",
                    label = "Select Breed:",
                    choices = breed_names)}
    })
  })

  ###
  # Observes the user selected breed from the drop down list
  # after filter has been applied and renders the attribute values
  # in the form of a scatterpolar graph
  ###
  observeEvent(input$breed, {

    if (input$breed != "No suitable dog can be found. Please try another filter.") {
      # If there are suitable dogs after filter, render the scatterpolar graph
      values$breed <- input$breed                                           # Assign the user selected breed to the reactive value
      selected_breed <- breed_traits_filtered %>%                           # Filter the dataset to only that selected breed
        filter(breed_traits_filtered$Breed == values$breed)
      
      # Calls the plot_scatterpolar function which
      # takes in selected_breed as a parameter
      output$plot_traits <- renderPlotly(
        plot_scatterpolar(selected_breed))}
    
    else {
      # If there are no suitable dogs after filter, render an empty scatter polar graph
      values$breed <- "NA"
      output$plot_traits <- renderPlotly(
        plot_scatterpolar_empty)
      # Render a pop up message to alert the user that no dogs can be found based on the filters
      shinyalert(title = "No suitable dog can be found. Please try another filter.",
                 type = "error"
      )}
  })
  
  ###
  # Display information when 'about' button is clicked
  ###
  observeEvent(input$about, {
    shinyalert(title = "About",
               html = TRUE,
               text = "
               <h2> Dog Breed Selector </h2>
               <p> By: <a herf = 'https://github.com/jkengs'>jkengs</a> </p>
               <p> Data Source: <a href = 'https://github.com/rfordatascience/tidytuesday/blob/master/data/2022/2022-02-01/readme.md'>TidyTuesday</a>",
               type = "info",
               closeOnEsc = TRUE)})
  
  
  ###
  # Display information on the attributes levels when "More Information" button is clicked
  # Description source: https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-02-01/trait_description.csv
  ###
  observeEvent(input$info, {
    shinyalert(title = "More Info",
               html = TRUE,
               text = "<h2> Scale </h2>
               <p> The scale used is from 1 (lowest) to 5 (highest). </p>
               <h3> Shedding Level </h2>
               <p> Breeds with high shedding will need to be brushed more frequently, are more likely to trigger certain types of allergies, 
                   and are more likely to require more consistent vacuuming and lint-rolling. </p>
               <h3> Drooling Level </h2>
               <p> How drool-prone a breed tends to be. If you're a neat freak, dogs that can leave ropes of slobber on your arm or big wet 
                   spots on your clothes may not be the right choice for you.  </p>
               <h3> Playfulness Level </h2>
               <p> How enthusiastic about play a breed is likely to be, even past the age of puppyhood. Some breeds will continue wanting to 
                   play tug-of-war or fetch well into their adult years, while others will be happy to just relax on the couch with you most of the time. </p>
               <h3> Adaptability Level </h2>
               <p> How easily a breed handles change. This can include changes in living conditions, noise, weather, daily schedule, and other variations in day-to-day life.</p>               
               <h3> Trainability Level </h2>
               <p> How easy it will be to train your dog, and how willing your dog will be to learn new things. Some breeds just want to make their owner proud, while others prefer
                   to do what they want, when they want to, wherever they want!  </p>
               <h3> Energy Level </h2>
               <p> The amount of exercise and mental stimulation a breed needs. High energy breeds are ready to go and eager for their next adventure. They'll spend their time running,
                   jumping, and playing throughout the day. Low energy breeds are like couch potatoes - they're happy to simply lay around and snooze. </p>               
               <h3> Barking Level </h2>
               <p> How often this breed vocalizes, whether it's with barks or howls. While some breeds will bark at every passer-by or bird in the window, others will only bark in particular
                   situations. Some barkless breeds can still be vocal, using other sounds to express themselves.  </p>",
               closeOnEsc = TRUE)})
  
  
  ###
  # Plot Functions
  ###
  
  # Plot the scatterpolar graph based on the dog's attributes,
  # which includes their shedding, drooling, playfulness, adaptability, trainability,
  # energy and barking level.
  plot_scatterpolar <- function(selected_breed) {
    plot_ly(
      type = 'scatterpolar',
      mode = 'lines + markers',
      fill = 'toself',
      fillcolor = 'grey',
      opacity = 0.2,
      text = selected_breed,
      hoverinfo = "text",
      width = 750,
      height = 600,
      marker = list(size = 12,
                    color = 'grey',
                    opacity = 1,
                    line = list(color = 'rgba(145,163,176'),
                    width = 3) 
    ) %>% add_trace(
      r = c(selected_breed %>% pull("Shedding Level"),
            selected_breed %>% pull("Drooling Level"),
            selected_breed %>% pull("Playfulness Level"), 
            selected_breed %>% pull("Adaptability Level"), 
            selected_breed %>% pull("Trainability Level"), 
            selected_breed %>% pull("Energy Level"),
            selected_breed %>% pull("Barking Level")),
      theta = c("Shedding", "Drooling", "Playfulness", "Adaptability", 
                "Trainability", "Energy", "Barking"),
      showlegend = FALSE,
      mode = "lines + markers",
      line=list(color='rgb(0,0,255)'),
      name = values$breed)
  } %>% config(scrollZoom = F, displayModeBar = F, displaylogo = F) 
  
  
  # Plot an empty scatterpolar graph with
  # zeroes to the traits
  plot_scatterpolar_empty <- plot_ly(
    type = 'scatterpolar',
    mode = 'lines + markers',
    fill = 'toself',
    fillcolor = 'red',
    text = "",
    hoverinfo = "text",
    opacity = 0.2,
    width = 750,
    height = 600
  ) %>% 
    add_trace(
      r = c(0,0,0,0,0,0,0),
      theta = c("Shedding", "Drooling", "Playfulness", "Adaptability", 
                "Trainability", "Energy", "Barking"),
      showlegend = FALSE,
      mode = "line + markers",
      name = "N/A"
    ) %>% config(scrollZoom = F, displayModeBar = F, displaylogo = F)
  
}    
