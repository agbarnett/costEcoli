# for cost of resistant e-coli
# Feb 2017
library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("ResImpact- tracking drug resistance for action"),
  
  
p("ResImpact, is an open-access tool based on a validated and transparent model developed as part of the Health and Economic Modelling of Antimicrobial resistance in Australia (HEMAA) project.", tags$a(href="http://www.cre-rhai.org.au/projects/health-economic-modelling-of-antimicrobial-resistance-in-australia---hemaa", "Click here"), "to read about the HEMAA project."),  

# Radio button for disease

  sidebarLayout(
    sidebarPanel(
      
      radioButtons("bug", "Organism:",
                   c("ceftriaxone-resistant E. coli" = "ecoli",
                     "ceftriaxone-resistant K. pneumoniae" = "Klebsiella",
                     "ceftazidime-resistant P. aeruginosa" = "Pseudomonas",
                     "MRSA" = "MRSA",
                     "VRE" = "VRE"), selected='ecoli'),
      
      # BSI resistance
        numericInput(inputId = "pDrugResBSI",
                     label = "Probability BSI drug resistance:",
                     min = 0,
                     max = 1,
                     step = 0.01,
                     value=0.05),
    

    # Respiratory resistance
    conditionalPanel(
      condition = "input.bug == 'Pseudomonas' | input.bug == 'MRSA'",
      numericInput(inputId = "pDrugResResp",
                 label = "Probability respiratory drug resistance:",
                 min = 0,
                 max = 1,
                 step = 0.01,
                 value=0.05)),

# UTI resistance
conditionalPanel(
  condition = "input.bug == 'VRE'",
  numericInput(inputId = "pDrugResUTI",
             label = "Probability UTI drug resistance:",
             min = 0,
             max = 1,
             step = 0.01,
             value=0.05))),

mainPanel(h3('Additional cost of treatment', tags$a(href="http://www.cre-rhai.org.au/projects/antibiotic-management-of-drug-resistant-infections-a-survey-of-clinical-practice", "(bloodstream infections only)")),
    textOutput(outputId = 'cost_text'),
    h2('Total accounting cost of bed days and treatment'),
    textOutput(outputId = 'account_text'),
    h2('Total opportunity cost of bed days and treatment'),
    textOutput(outputId = 'opp_text')
  )), # end of main panel
  

p("If you use ResImpact in your research or policy work, or if you have any other queries, then we would like to hear from you. E-mail", tags$a(href='mailto:teresa.wozniak@menzies.edu.au', 'Teresa Wozniak'), '.'),
p("Reference:"),
p(tags$a(href="https://bmchealthservres.biomedcentral.com/articles/10.1186/s12913-017-2079-5", "Katie Page, et al"), ". What is a hospital bed day worth? A contingent valuation study of hospital Chief Executive Officers. BMC Health Services Research 2017;17:137.")

))

