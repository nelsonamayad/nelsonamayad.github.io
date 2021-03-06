# Packages ####
library(rworldmap)
library(leaflet)
library(leaflet.providers)
library(sp)
library(lubridate)
library(shiny)
library(shinythemes)
library(RColorBrewer)
library(raster)
library(rgeos)
library(tidyverse)
library(plotly)

# Centroids ####
wmap <- getMap(resolution="high") 
centroids <- gCentroid(wmap, byid=TRUE) %>% 
  as.data.frame() %>%
  rownames_to_column("country") %>%
  rename("long"=x,"lat"=y) %>%
  mutate(country=if_else(str_detect(country,"United States of America"),"US",country),
         country=if_else(str_detect(country,"Timor"),"Timor-Leste",country),
         country=if_else(str_detect(country,"Bahamas"),"Bahamas",country),
         country=if_else(str_detect(country,"Ivory"),"Cote d'Ivoire",country),
         country=if_else(str_detect(country,"Czech"),"Czechia",country),
         country=if_else(str_detect(country,"South Korea"),"Korea, South",country),
         country=if_else(str_detect(country,"Republic of Serbia"),"Serbia",country),
         country=if_else(str_detect(country,"Taiwan"),"Taiwan*",country)
  ) 

# Data - Adjustment on 25/03/2020 for different reporting from source ####
df <- list(length(3))
for (i in c("confirmed","deaths")) {
  df[[i]] <- read_csv(paste0("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_",i,"_global.csv")) %>% 
    mutate(type=i)
}
df[[1]] <- NULL
df <- map_df(df,bind_rows) %>% 
  gather(key="date",value="cases",-`Province/State`,-`Country/Region`,-Lat,-Long,-type) %>%
  mutate(date = mdy(date),
         country=case_when(str_detect(`Country/Region`,"China") ~ "China",
                           str_detect(`Country/Region`,"Australia") ~ "Australia",
                           !str_detect(`Country/Region`,"China") & !str_detect(`Country/Region`,"Australia") ~ `Country/Region`)) %>%
  left_join(centroids,by="country") %>%
  select(-Lat,-Long)


# Colombia ####
col <- getData('GADM', country="COL", level=2) %>%
  fortify(region = "NAME_2") %>%
  right_join(read_csv("https://raw.githubusercontent.com/nelsonamayad/nelsonamayad.github.io/master/covid19/covid19_col_19032020.csv") %>%
               mutate(fecha = dmy(fecha),
                      ciudad = if_else(str_detect(ciudad,"Bog"),"Santafé de Bogotá",ciudad)) %>%
               group_by(ciudad,fecha) %>%
               count(id), by=c("id"="ciudad")) %>% 
  filter(!is.na(n))

# UI ####
ui <- fluidPage(
  theme = shinytheme("lumen"),
  titlePanel(p(strong("COVID-19 tracker"))),
  sidebarPanel(
    hr("This test Shiny App to visualizes the latest international data on the spread of the Coronavirus. \nIt uses the latest updates from the", 
       a(href="https://coronavirus.jhu.edu/","Johns Hopkins Coronavirus Resource Center"),"data uploaded in Github. 
       It's work in progress, created for pedagogical purposes, so please excuse any errors."),
    br(),
    br(),
    p(strong("Last update: 27/03/2020")),
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
    selectInput("country","Select country:",choices = sort(unique(df$country)),selected="France"),
    br()
  ),
  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("Map",leafletOutput("map")),
                tabPanel("Most affected countries", plotlyOutput("top20")),
                tabPanel("By country", plotOutput("plot"))
                
    )
  )
)

# Server ####
server <- function(input,output) {
  
  data <- eventReactive(input$update,{
    df <- list(length(3))
    for (i in c("confirmed","deaths")) {
      df[[i]] <- read_csv(paste0("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_",i,"_global.csv")) %>% 
        mutate(type=i)
    }
    df[[1]] <- NULL
    df <- map_df(df,bind_rows) %>% 
      gather(key="date",value="cases",-`Province/State`,-`Country/Region`,-Lat,-Long,-type) %>%
      mutate(date = mdy(date),
             country=case_when(str_detect(`Country/Region`,"China") ~ "China",
                               str_detect(`Country/Region`,"Australia") ~ "Australia",
                               !str_detect(`Country/Region`,"China") & !str_detect(`Country/Region`,"Australia") ~ `Country/Region`)) %>%
      left_join(centroids,by="country") %>%
      select(-Lat,-Long)
    
  })
  
  output$map <- renderLeaflet({
    
    data() %>%
      filter(type==input$type,
             date==input$date,
             !is.na(cases), cases!=0) %>%
      group_by(country, input$type) %>%
      mutate(total = sum(cases)) %>%
      group_by(country) %>%
      distinct(country, .keep_all=T) %>% # ERROR: Drops coords with countries
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
  
  output$top20 <- renderPlotly({
    
    p <- data() %>%
      filter(type==input$type,
             !is.na(cases), cases!=0) %>%
      group_by(country,date) %>%
      mutate(total = sum(cases)) %>%
      distinct(country, .keep_all=T) %>%
      group_by(total) %>%
      top_n(20) %>%
      ggplot(aes(x=date, y=total, color=country))+
      geom_line(show.legend = F)+
      labs(x=NULL,y=paste0("Registered cases: ",input$type),
           title=paste0("Progression in 20 most affected countries: ",input$type),
           caption = "Source: Johns Hopkins Coronavirus Resource Center \nhttps://coronavirus.jhu.edu/")+
      scale_fill_distiller(direction=1) #+
    #theme_classic()+
    theme(panel.background = element_rect(fill="gray85"),
          legend.position='none')
    
    ggplotly(p)
    
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
           subtitle="Blue dotted line: Exponential trend  (coefficient = 1)",
           caption = "Source: Johns Hopkins Coronavirus Resource Center \nhttps://coronavirus.jhu.edu/")+
      scale_y_log10()+
      scale_fill_distiller(direction=1)+
      theme_classic()+
      theme(panel.background = element_rect(fill="gray75"))
  })
  
}

# Run the app ####
shinyApp(ui,server)
