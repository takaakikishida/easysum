#' Summarize Numeric Variables by Group
#'
#' Summarizes numeric variables in a data frame by a specified grouping variable using the `skimr` package.
#'
#' @param data A data frame to be summarized.
#' @param by A variable to group by.
#' @param ... Optional. Specific variables to summarize. If none are specified, all numeric variables are summarized.
#' @return A tibble with summarized statistics for numeric variables by group.
#' @examples
#' library(dplyr)
#' library(skimr)
#' library(tibble)
#' library(gapminder)
#'
#' # Using the sumr_group_by function for specific variables
#' sumr_group_by(gapminder, by = continent, lifeExp, gdpPercap)
#'
#' # Using the sumr_group_by function for all numeric variables
#' sumr_group_by(gapminder, by = continent)
#' @importFrom dplyr group_by filter select rename
#' @importFrom skimr skim
#' @importFrom tibble as_tibble
#' @importFrom rlang enquos
#' @export
sumr_group_by <- function(data, by, ...) {
  vars <- rlang::enquos(...)

  grouped_data <- dplyr::group_by(data, {{ by }})

  if (length(vars) == 0) {
    data_to_skim <- grouped_data
  } else {
    data_to_skim <- dplyr::select(grouped_data, !!!vars, {{ by }})
  }

  data_to_skim %>%
    skimr::skim() %>%
    tibble::as_tibble() %>%
    dplyr::filter(skim_type == "numeric") %>%
    dplyr::select(
      skim_variable, {{ by }}, complete_rate, numeric.mean, numeric.sd,
      numeric.p0, numeric.p100, numeric.hist
    ) %>%
    dplyr::rename(
      Variable = skim_variable,
      CompRate = complete_rate,
      Mean = numeric.mean,
      SD = numeric.sd,
      Min = numeric.p0,
      Max = numeric.p100,
      Hist = numeric.hist
    ) %>%
    dplyr::select(Variable, {{ by }}, CompRate, Mean, SD, Min, Max, Hist)
}

# Global variables for skimr
utils::globalVariables(c("skim_type", "skim_variable", "complete_rate", "numeric.mean",
                         "numeric.sd", "numeric.p0", "numeric.p100", "numeric.hist",
                         "{{ by }}", "Variable", "CompRate", "Mean", "SD", "Min", "Max", "Hist"))
