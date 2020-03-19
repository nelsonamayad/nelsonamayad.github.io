# Packages ####
library(leaflet)
library(leaflet.providers)
library(tidyverse)
library(lubridate)
library(shiny)
library(shinythemes)
library(RColorBrewer)

# Data ####
df <- list(length(3))
for (i in c("Confirmed","Recovered","Deaths")) {
  df[[i]] <- read_csv(paste0("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-",i,".csv")) %>% 
    mutate(type=i)
}
df[[1]] <- NULL
df <- map_df(df,bind_rows) %>% 
  gather(key="date",value="cases",-`Province/State`,-`Country/Region`,-Lat,-Long,-type) %>%
  mutate(date = mdy(date),
         country=case_when(str_detect(`Country/Region`,"China") ~ "China",
                           str_detect(`Country/Region`,"Australia") ~ "Australia",
                           !str_detect(`Country/Region`,"China") & !str_detect(`Country/Region`,"Australia") ~ `Country/Region`)) 

# UI ####
ui <- fluidPage(
  theme = shinytheme("lumen"),
  titlePanel(p(strong("COVID-19 tracker"))),
  sidebarPanel(
    hr("This test Shiny App to visualizes the latest international data on the spread of the Coronavirus. \nIt uses the latest updates from the", 
       a(href="https://coronavirus.jhu.edu/","Johns Hopkins Coronavirus Resource Center"),"data uploaded in Github. 
       It's work in progress, so please excuse any errors."),  
    br(),
    br(),
    actionButton("update","Load latest data", icon = icon("refresh")),
    br(),
    br(),
    selectInput("type","Select type of case:",choices=unique(df$type)),
    br(),
    dateInput("date","Select date:",
              min=min(df$date),
              max=max(df$date), 
              value=max(df$date)),
    br(),
    selectInput("country","Select country:",choices=unique(df$country),selected="France"),
    br()
  ),
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Map",leafletOutput("map")),
                tabPanel("By country", plotOutput("plot"))
                                  )
    )
  )

# Server ####

server <- function(input,output) {
  
  data <- eventReactive(input$update,{
    df <- list(length(3))
    for (i in c("Confirmed","Recovered","Deaths")) {
      df[[i]] <- read_csv(paste0("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-",i,".csv")) %>% 
        mutate(type=i)
    }
    df[[1]] <- NULL
    df <- map_df(df,bind_rows) %>% 
      gather(key="date",value="cases",-`Province/State`,-`Country/Region`,-Lat,-Long,-type) %>%
      mutate(date = mdy(date),
             country=case_when(str_detect(`Country/Region`,"China") ~ "China",
                               str_detect(`Country/Region`,"Australia") ~ "Australia",
                               !str_detect(`Country/Region`,"China") & !str_detect(`Country/Region`,"Australia") ~ `Country/Region`)) 
    
  })
  
  output$map <- renderLeaflet({
    
    data() %>%
      filter(type==input$type,
             date==input$date,
             !is.na(cases), cases!=0) %>%
      group_by(country, input$type) %>%
      mutate(total = sum(cases)) %>%
      distinct(country, .keep_all=T) %>%
      leaflet() %>%
      addTiles() %>%
      addProviderTiles(providers$Hydda.Base) %>%
      addCircleMarkers(radius = ~log(total),
                       color = ~c("blue"),
                       label= ~paste0(country,": ",total)) %>%
      addCircleMarkers(data = data() %>% 
                         filter(type==input$type,
                                date==input$date,
                                country==input$country) %>%
                         group_by(country, input$type) %>%
                         mutate(total = sum(cases)) %>%
                         distinct(country, .keep_all=T),
                       color = ~c("red"),
                       label= ~paste0(input$country,": ",total))
  })
  
  output$plot <- renderPlot({
    
    data() %>%
      filter(type==input$type,
             date<=input$date,
             country==input$country,
             !is.na(cases), cases!=0) %>%
      group_by(country,date) %>%
      mutate(total = sum(cases)) %>%
      distinct(country, .keep_all=T) %>%
      ggplot(aes(x=date, y=total, fill=total))+
      geom_line(color="red2",size=2,show.legend = F)+
      geom_smooth(method="lm",se=F, color="turquoise3", fill="turquoise1",linetype="twodash",show.legend = F)+
      labs(x=NULL,y=paste0("Log of registered cases: ",input$type),
           title=paste0("Progression in ",input$country),
           subtitle="Blue dotted line = Exponential trend",
           caption = "Source: Johns Hopkins Coronavirus Resource Center \nhttps://coronavirus.jhu.edu/")+
      scale_y_log10()+
      scale_fill_distiller(direction=1)+
      theme_classic()+
      theme(panel.background = element_rect(fill="gray75"))
  })
  
  }

# Run the app ####
shinyApp(ui,server)
