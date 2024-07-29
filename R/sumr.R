#' Summarize Numeric Variables
#'
#' Summarizes numeric variables in a data frame using the `skimr` package.
#'
#' @param data A data frame to be summarized.
#' @param ... Optional. Specific variables to summarize. If none are specified, all numeric variables are summarized.
#' @return A tibble with summarized statistics for numeric variables.
#' @examples
#' library(dplyr)
#' library(skimr)
#' library(tibble)
#' library(gapminder)
#'
#' @importFrom dplyr filter select rename
#' @importFrom skimr skim
#' @importFrom tibble as_tibble
#' @importFrom rlang enquos
#' @export
sumr <- function(data, ...) {
  vars <- rlang::enquos(...)

  if (length(vars) == 0) {
    data_to_skim <- data
  } else {
    data_to_skim <- dplyr::select(data, !!!vars)
  }

  data_to_skim %>%
    skimr::skim() %>%
    tibble::as_tibble() %>%
    dplyr::filter(skim_type == "numeric") %>%
    dplyr::select(
      skim_variable, complete_rate, numeric.mean, numeric.sd,
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
    dplyr::select(Variable, CompRate, Mean, SD, Min, Max, Hist)
}

# グローバル変数として宣言
utils::globalVariables(c("skim_type", "skim_variable", "complete_rate", "numeric.mean",
                         "numeric.sd", "numeric.p0", "numeric.p100", "numeric.hist",
                         "Variable", "CompRate", "Mean", "SD", "Min", "Max", "Hist"))
