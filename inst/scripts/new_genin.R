library(shiny)
library(miniUI)

txt_input <- function(..., width = '100%') shiny::textInput(..., width = width)

ui <- miniUI::miniPage(
    miniUI::miniContentPanel(
        txt_input('title', 'Title', placeholder = 'pdf Title'),
        txt_input('subtitle', 'Subtitle', placeholder = 'pdf Subtitle'),
        shiny::br(),
        shiny::fillRow(
            txt_input('professor', 'Professor', width = '98%'),
            shiny::dateInput('date', 'Date', Sys.Date(), width = '98%'),
            shiny::selectizeInput(
                'subdir', 'Subdirectory', list.dirs(path = ".",
                                                    full.names = FALSE,
                                                    recursive = FALSE),
                width = '98%', multiple = FALSE,
                options = list(create = TRUE, placeholder = '(optional)')
            ),
            height = '70px'
        ),
        shiny::fillRow(
            txt_input('lecture', 'Lecture', width = '98%'),
            txt_input('lecture_code', 'Code', width = '98%'),
            txt_input('university', 'University', width = '98%'),
            height = '70px'
        ),
        shiny::fillRow(
            txt_input('assistant', 'Assistant', width = '98.5%'),
            txt_input('email', 'Email', width = '98.5%'),
            height = '70px'
        ),
        shiny::br(),
        shiny::fillRow(
            txt_input('int1', 'Instruction 1', width = '98.5%'),
            txt_input('int2', 'Instruction 2', width = '98.5%'),
            height = '70px'
        ),
        shiny::fillRow(
            txt_input('int3', 'Instruction 3', width = '98.5%'),
            txt_input('int4', 'Instruction 4', width = '98.5%'),
            height = '70px'
        ),
        shiny::br(),
        shiny::fillRow(
            shiny::radioButtons('cite', 'Do you want to add a cite? (optional)', inline = TRUE,
                                c('Yes' = 'y', 'No' = 'n')),
            height = '70px'
        ),
        shiny::fillRow(
            txt_input('citetxt', 'Cite', width = '98.5%'),
            txt_input('author', 'Author', width = '98.5%'),
            txt_input('ref', 'Reference', width = '98.5%'),
            height = '70px'
        ),
        shiny::downloadButton("report", "Generate .Rmd")
    )
)

server <- function(input, output, session) {

    output$report <- shiny::downloadHandler(

        filename = "Untitled.pdf",

        content = function(file) {

            tmp <- file.path(here::here(input$subdir), "Untitled.Rmd")

            sink(tmp)
            cat(
                "---",
                paste0("\ntitle: ", paste0("\'", input$title, "\'")),
                paste0("\nhomework_name: ", paste0("\'", input$subtitle, "\'")),
                "\n",
                paste0("\ndate: ", paste0("\'", input$date, "\'")),
                paste0("\nprofessor: ", paste0("\'", input$professor, "\'")),
                paste0("\nassistant: ", paste0("\'", input$assistant, "\'")),
                paste0("\nassistant_mail: ", paste0("\'", input$email, "\'")),
                paste0("\ncourse_name: ", paste0("\'", input$lecture, "\'")),
                paste0("\ncourse_code: ", paste0("\'", input$lecture_code, "\'")),
                paste0("\nuniversity: ", paste0("\'", input$university, "\'")),
                "\n",
                paste0("\nlogo: ", paste0("\'", "logo.jpg", "\'")),
                paste0("\nwidth_logo: ", paste0("\'", "1cm", "\'")),
                "\n",
                paste0("\ninstruction_1: ", paste0("\'", input$int1, "\'")),
                paste0("\ninstruction_2: ", paste0("\'", input$int2, "\'")),
                paste0("\ninstruction_3: ", paste0("\'", input$int3, "\'")),
                paste0("\ninstruction_4: ", paste0("\'", input$int4, "\'")),
                "\n",
                paste0("\ncite: ", paste0("\'", input$citetxt, "\'")),
                paste0("\nauthor_cite: ", paste0("\'", input$author, "\'")),
                paste0("\nreference_cite: ", paste0("\'", input$ref, "\'")),
                "\n",
                paste0("\ncolor_pdf: ", paste0("\'", "astral", "\'")),
                paste0("\ncolor_url: ", paste0("\'", "magenta", "\'")),
                "\n",
                paste0("\nfontsize: 11pt"),
                paste0("\ngeometry: margin=1in"),
                "\n",
                paste0("\noutput: hokage::genin"),
                "\n---",
                paste0("
                \n```{r setup, include=FALSE}
                \nknitr::opts_chunk$set(echo = TRUE, eval = TRUE, message = FALSE, warning = FALSE)
                \n```"),
                "\n",
                paste0("\n# Pregunta 1"),
                "\n",
                paste0("\n```{r}"),
                paste0("\nlibrary(tidyverse)\n"),
                paste0("\nknitr::kable(mtcars[1:5, 1:6], booktabs = T)"),
                "\n```")

            sink()

            logo_jpg <- system.file("rmarkdown/templates/genin/skeleton/logo.jpg",
                                    package = "hokage")

            file.copy(logo_jpg, here::here(input$subdir))

            rmarkdown::render(tmp, output_file = file,
                              envir = new.env(parent = globalenv()))

            # remove log file
            filenames <- list.files(path = here::here(input$subdir), recursive=TRUE)
            log_file <- filenames[grep(".log", filenames)]
            file.remove(here::here(input$subdir, log_file))

        }
    )
}

shiny::runGadget(shiny::shinyApp(ui, server),
                 viewer = shiny::dialogViewer('New Genin', height = 1500))
