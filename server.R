# server.R
library(shiny)
library(quantmod)
library(ggplot2)
library(dplyr)
library(lubridate)
library(plotly)

server <- function(input, output) {
  # Stock Data Tab
  stock_data <- eventReactive(input$get_data, {
    tryCatch({
      getSymbols(input$stock, from = input$start_date, to = input$end_date, auto.assign = FALSE)
    }, error = function(e) {
      showNotification(paste("Error fetching data:", e$message), type = "error")
      NULL
    })
  })

  output$stock_plot <- renderPlot({
    data <- stock_data()
    if (!is.null(data)) {
      chartSeries(data, name = input$stock)
    }
  })

  output$stock_table <- renderDataTable({
    data <- stock_data()
    if (!is.null(data)) {
      as.data.frame(data) %>%
        mutate(Date = index(data)) %>%
        select(Date, everything())
    }
  })

  # Stock vs Nifty Tab
  stock_nifty_data <- eventReactive(input$get_data_nifty, {
    tryCatch({
      stock <- getSymbols(input$stock_nifty, from = input$start_date_nifty, to = input$end_date_nifty, auto.assign = FALSE)
      nifty <- getSymbols("^NSEI", from = input$start_date_nifty, to = input$end_date_nifty, auto.assign = FALSE)

      if (ncol(stock) >= 6) {
        stock <- stock[, 6]
      } else {
        showNotification(paste("Adjusted price not available for", input$stock_nifty), type = "warning")
        return(NULL)
      }

      if (ncol(nifty) >= 6) {
        nifty <- nifty[, 6]
      } else {
        showNotification("Adjusted price not available for Nifty 50", type = "warning")
        return(NULL)
      }

      list(stock = stock, nifty = nifty)
    }, error = function(e) {
      showNotification(paste("Error fetching data:", e$message), type = "error")
      NULL
    })
  })

  output$stock_nifty_plot <- renderPlotly({
    data <- stock_nifty_data()
    if (!is.null(data) && !is.null(data$stock) && !is.null(data$nifty)) {
      stock_df <- data.frame(Date = index(data$stock), Price = as.numeric(data$stock))
      nifty_df <- data.frame(Date = index(data$nifty), Price = as.numeric(data$nifty))

      p <- plot_ly(stock_df, x = ~Date, y = ~Price, type = "scatter", mode = "lines", name = input$stock_nifty, yaxis = "y2", line = list(color = "blue")) %>%
        add_trace(data = nifty_df, x = ~Date, y = ~Price, type = "scatter", mode = "lines", name = "Nifty 50", yaxis = "y1", line = list(color = "red")) %>%
        layout(
          yaxis = list(side = "left", title = "Nifty 50 Price"),
          yaxis2 = list(side = "right", overlaying = "y", title = paste(input$stock_nifty, "Price")),
          legend = list(x = 0.1, y = 0.9)
        )
      p
    }
  })
}
