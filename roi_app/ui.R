#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Home purchase ROI"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      numericInput("home_price","Purchase Price:",400000),
      numericInput("downpay_pct","Down payment percent:", 20),
      numericInput("int_rate_30","30 yr fixed loan interest rate (%):", 3.75),
      numericInput("int_rate_15","15 yr fixed loan interest rate (%):", 3.00),
      numericInput("tax_rate","Property Tax Rate (%):", 2.23),
      numericInput("ins_rate", "Homeowner Insurance rate (%):", 1.00),
      numericInput("growth_rate", "Est annual property value growth (%):", 3.33)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("15 yr fixed", plotOutput("plot_15")),
                  tabPanel("30 yr fixed", plotOutput("plot_30")),
                  tabPanel("Comparison", tableOutput("comp_table"))
      )
    )
  )
))

