library(shiny)
library(plotly)

ui <- shinyUI(fluidPage(
  
  titlePanel("My Shiny App"),
  sidebarLayout(
    sidebarPanel(
      numericInput("idnum", label = h3("ID #"), 
                   value = 3)
    ),
    mainPanel(
      plotlyOutput("map"),
      verbatimTextOutput("click")
    )
  )
))

server <- shinyServer(function(input, output) {
  
  output$map <- renderPlotly({
    
    df <- data.frame(id = c(3,6,20,35), lat = c(30.67,32.46,37.83,29.62), lon = c(-97.82, -62.34, -75.67, -85.62))
    
    sub <- df[which(df$id == input$idnum),]
    rownames(sub) <- sub$id
    key <- row.names(sub)
    
    g <- list(
      scope = 'north america',
      showland = TRUE,
      landcolor = toRGB("grey83"),
      subunitcolor = toRGB("white"),
      countrycolor = toRGB("white"),
      showlakes = TRUE,
      lakecolor = toRGB("white"),
      showsubunits = TRUE,
      showcountries = TRUE,
      resolution = 50,
      projection = list(
        type = "miller",
        rotation = list(lon = -100)
      ),
      lonaxis = list(
        showgrid = TRUE,
        gridwidth = 0.5,
        range = c(-140, -55),
        dtick = 5
      ),
      lataxis = list(
        showgrid = TRUE,
        gridwidth = 0.5,
        range = c(20, 60),
        dtick = 5
      )
    )
    
    # plot_ly(sub, lon = ~lon, lat = ~lat, key = ~key, text = ~paste(id), hoverinfo = "text",
    #         marker = list(size = 10),
    #         type = 'scattergeo',
    #         locationmode = 'USA-states') %>%
    #   layout(title = 'Locations', geo = g)
    
    
    plot_geo(sub, lat = ~lat, lon = ~lon, key = ~key) %>%
      add_markers(
        text = ~paste(key),
        symbol = I("square"), size = I(8), hoverinfo = "text"
      ) %>%
      layout(
        title = 'Stores', geo = g
      )
  })
  
  output$click <- renderPrint({
    d <- event_data("plotly_click")
    if (is.null(d)) "Click events appear here" else d
  })
})

shinyApp(ui = ui, server = server)
