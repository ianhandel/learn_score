# Parse Learn VPH scores - shiny server

library(shiny)
library(readxl)
library(tidyverse)
library(DT)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  dat_raw <- reactive({
    infile <- input$file

    if (is.null(infile)) {
      return(NULL)
    }

    readxl::read_excel(path = infile$datapath, sheet = 1)
  })

  dat_proc <- reactive({
    dat_raw()
  })


  output$data_raw <- DT::renderDataTable(
    dat_raw()
  )

  output$data_proc <- DT::renderDataTable(
    dat_proc()
  )
})
