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
    req(dat_raw())
    dat_raw() %>% 
      janitor::clean_names() %>% 
      mutate(score = coalesce(manual_score, auto_score)) %>% 
      mutate(question = str_remove(question, "^SPOT Question "),
             question = str_extract(question, "^\\d+")) %>% 
      group_by(username, last_name, first_name, question) %>% 
      summarise(total = sum(score, na.rm = TRUE),
                max = sum(possible_points, na.rm = TRUE))
  })

  output$uniq_names <- renderText({
    n <- length(unique(dat_proc()$username))
    str_glue("There are {n} unique ID's")
  })
  
  output$plot <- renderPlot({
    req(dat_proc())
    ggplot(dat_proc(), aes(x = total, fill = question)) +
      geom_dotplot() +
      facet_wrap(~question) +
      labs(x = "score",
           y = "Number of students",
           title = "Processed results") +
      theme(legend.position = "none")
  })

  output$data_raw <- DT::renderDataTable(
    dat_raw()
  )

  output$data_proc <- DT::renderDataTable(
    dat_proc()
  )
  
  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      str_replace(input$file$name, "(\\.xlsx|\\.xls)", "_processed\\.xlsx")
    },
    content = function(file) {
      writexl::write_xlsx(dat_proc(), file)
    }
  )
  
})
