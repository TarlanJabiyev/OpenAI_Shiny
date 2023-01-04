library(tidyverse)
library(openai)
library(shiny)
library(shinythemes)
library(shinymanager)

ui <- fluidPage(
  navbarPage(
    title = "OpenAI Shiny", 
    theme = shinytheme(theme = "readable"), 
    
    fluidRow(
      column(
        width = 1
      ),
      column(
        width = 10,
        textAreaInput("ask_something", "Ask something", "", width = "1100px"),
        actionButton("action", "Response", icon = icon("fa-solid fa-pen-nib", style = "color: #1E90FF")),
        br(),hr()
      ),
      column(
        width = 1
      )
    ),
    fluidRow(
      column(
        width = 1
      ),
      column(
        width = 8,
        textOutput("response1")
      ),
      column(
        width = 1
      )
    )
  )
)

# credentials ----
credentials <- data.frame(
  user = c("Harmony"),
  password = c("Super1@User2"), 
  stringsAsFactors = F
)
ui <- secure_app(ui)

server <- function(input, output, session) {
  
  res_auth <- secure_server(
    check_credentials = check_credentials(credentials)
  )
  reactive_credentials <- reactive({reactiveValuesToList(res_auth)})
  
  # Page 1 ----
  response <- reactive({
    api_key <- "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    
    text_prompt <- input$ask_something
    
    chatGHP <- create_completion(
      model = "text-davinci-003",
      prompt = text_prompt,
      max_tokens = 1000,
      openai_api_key = api_key,
      temperature = 0
    )
    
    chatGHP$choices$text
  })
  
  output$response1 <- renderText({
    input$action
    isolate(response())
  })
}

shinyApp(ui, server)
