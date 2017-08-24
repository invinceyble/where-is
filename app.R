#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# rsconnect::deployApp('~/Documents/repos/WhereIs')

library(shiny)
library(leaflet)

get_result <- function(data, input_date){
  # look up the latitude, longitude, city and country on the given date
  result = c()
  result$lat = data$lat[match(input_date, data$date)]
  result$long = data$long[match(input_date, data$date)]
  result$city = data$city[match(input_date, data$date)]
  result$country = data$country[match(input_date, data$date)]
  # check if search result is Null
  if (is.na(result$city)){
    result$lat = -33.8688
    result$long = 151.2093
  }
  # return search result
  return(result)
}


# Define UI for application that displays the map
ui <- fluidPage(
  
  # Application title
  titlePanel("Where is Vincey?"),
  p("Select a date in the drop down to find out where I'll be. Let me know if you're around; I'd be super keen to catch up!"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      
      dateInput("date", label = h5("Date"), value = NULL, min = NULL, max = NULL,
                format = "dd/mm/yyyy", startview = "month", weekstart = 0,
                language = "en", width = NULL),
      #numericInput("lat", label = h4("Latitude:"), value = 30.51470),
      #numericInput("long", label = h4("Longitude:"), value = 11.242828),
      actionButton("recalc", "Find her", width='100%'),
      
      br(""),
      textOutput("text1")
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      leafletOutput("mymap", height="600px")
    )
  ),
  p(""),
  p("Data last updated on 24 August 2017. Message me to confirm I'll be around.", align="right")
  # p(a("Message"), href="https://facebook.com/invinceyble")
)


# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  data<-read.csv("./data/data.csv", header=TRUE)
  data[[1]] <- as.Date(data[[1]],"%d/%m/%Y")
  
  points <- eventReactive(input$recalc, {
    cbind(get_result(data,input$date)$long, get_result(data,input$date)$lat)
  }, ignoreNULL = FALSE)
  
  output$mymap <- renderLeaflet({
    result = get_result(data,input$date)
    leaflet() %>%
      setView(lat = result$lat, lng = result$long, zoom = 9) %>%
      addProviderTiles("Stamen.Terrain",
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addMarkers(data = points())
  })
  
  output$text1 <- renderText({
    result = get_result(data,input$date)
    if (is.na(result$city)) {
      paste("Data not available. Message me and find out!")
    } else if (input$date < Sys.Date()) {
      paste("I was in ", result$city, ", ", result$country, ".", sep="")
    } else if (input$date == Sys.Date()) {
      paste("I'm currently in ", result$city, ", ", result$country, ".", sep="")
    } else {
      paste("I'll be in ", result$city, ", ", result$country, ".", sep="")
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)


