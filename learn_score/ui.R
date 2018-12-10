# Parse Learn VPH scores - shiny ui

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Process Learn VPH Scores"),

  tabsetPanel(
    tabPanel(
      "Import/export",
      
      br(),
      
      fileInput(
        inputId = "file",
        label = "Choose input file"
      ),
      
      downloadButton("downloadData", "Download CSV file"),
      
      
      br(),
      br(),
      
      h3(
        textOutput(outputId = "uniq_names")
        ),
      
      br(),
      br(),
      
      plotOutput(outputId = "plot")
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
