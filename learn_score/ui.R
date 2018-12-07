# Parse Learn VPH scores - shiny ui

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Process Learn VPH Scores"),

  tabsetPanel(
    tabPanel(
      "Import",
      fileInput(
        inputId = "file",
        label = "Choose input file"
      )
    ),

    tabPanel(
      "Raw data",
      mainPanel(
        DT::dataTableOutput(outputId = "data_raw")
      )
    ),

    tabPanel(
      "Processed data",
      mainPanel(
        DT::dataTableOutput(outputId = "data_proc")
      )
    )
  )
))
