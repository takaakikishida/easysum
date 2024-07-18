#' @import gapminder
NULL

#' Create a Summary Table
#'
#' Summarizes the data by the specified columns, adds row totals, and formats
#' the percentages using the `janitor` package.
#'
#' @param data A data frame to be summarized.
#' @param ... Columns to group by.
#' @return A data frame with row totals and formatted percentages.
#' @examples
#' library(dplyr)
#' library(janitor)
#' library(gapminder)
#'
#' # Example with the gapminder dataset
#' gapminder %>% tab(continent)
#' @importFrom dplyr %>%
#' @importFrom janitor tabyl adorn_totals adorn_pct_formatting
#' @importFrom magrittr %>%
#' @export
tab <- function(data, ...) {
  data %>%
    janitor::tabyl(...) %>%
    janitor::adorn_totals("row") %>%
    janitor::adorn_pct_formatting(digits = 2)
}
