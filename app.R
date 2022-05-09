## ---------------------------
## R SHINY DEMO
##
## Description: This script gives a quick demonstration of building an R shiny app.
##              Prepared for GEOG 28602 / 38602, Spring 2022 at the University of Chicago.
##
##              This demo will help students create an R shiny app... about themselves!
##              The R shiny app will a main panel and a side panel. The side panel
##              will be an "About me" section, and the main panel will be a map of
##              significant places in their life.
##
## Author: Susan Burtner
##
## Date Last Modified: 9 May 2022
##
## ---------------------------
## CODE SECTION

# Load in necessary libraries
# (Install libraries if not already installed)
#install.packages("shiny")
#install.packages("leaflet")
library(shiny)
library(leaflet)

# Create dataframe of favorite places
favoritePlaces <- data.frame(id = c(1, 2, 3, 4),
                             name = c("name1", "name2", "name3", "name4"),
                             description = c("desc1", "desc2", "desc3", "desc4"),
                             lat = c(0.0, 0.0, 0.0, 0.0),
                             lon = c(0.0, 0.0, 0.0, 0.0), stringsAsFactors = FALSE
)

favoritePlaces[1, 2:5] <- list("The Habit", "The best burgers in Santa Barbara, CA.", 34.435697928641154, -119.82472536515486)
favoritePlaces[2, 2:5] <- list("Eller's Donuts", "The best donuts in Santa Barbara, CA.", 34.4405625217812, -119.76693903719358)

## ---------------------------
## UI SECTION
ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(h2("About me"), width = 3),
        mainPanel(fluidRow(leafletOutput("map"), width = 9),
                  br(),
                  fluidRow(h3(textOutput("text"))))
    )
)

## ---------------------------
## SERVER SECTION
server <- function(input, output, session){
    # Inputs
    clickData <- reactiveValues(clickedMarker = NULL)
    
    observeEvent(input$map_marker_click, {
        clickData$clickedMarker <- input$map_marker_click
    })
    
    # Outputs
    output$map <- renderLeaflet({
        leaflet(data = favoritePlaces) %>%
            addTiles() %>%  
            addCircleMarkers(lng = ~lon, lat = ~lat, popup = ~name, layerId = ~id)
    })
    
    output$text <- renderText({
        if (is.null(clickData$clickedMarker)) {
            return(NULL)
        }
        return(favoritePlaces[favoritePlaces$id == clickData$clickedMarker$id, ]$description)
    })
}

## ---------------------------
## Create / render Shiny app
shinyApp(ui = ui, server = server)

## END SCRIPT