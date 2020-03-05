#' R Markdown output formats for genin
#'
#' @param ... everything
#'
#' @return
#' @export
#'
#' @examples
genin <- function(...) {

    template <- system.file("rmarkdown/templates/genin/resources/template.tex",
                            package = "hokage")

    # call the base html_document function
    rmarkdown::pdf_document(number_sections = FALSE,
                            highlight = "default",
                            template = template,
                            keep_tex = TRUE)

}
