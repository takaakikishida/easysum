#' Summarize Numeric Variables with Full Statistics
#'
#' Summarizes numeric variables in a data frame using the `skimr` package, providing a comprehensive set of statistics.
#'
#' @param data A data frame to be summarized.
#' @param ... Optional. Specific variables to summarize. If none are specified, all numeric variables are summarized.
#' @return A tibble with comprehensive summarized statistics for numeric variables.
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
sumr_full <- function(data, ...) {
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
      skim_variable, n_missing, complete_rate, numeric.mean, numeric.sd,
      numeric.p0, numeric.p25, numeric.p50, numeric.p75, numeric.p100, numeric.hist
    ) %>%
    dplyr::rename(
      Variable = skim_variable,
      Missing = n_missing,
      CompRate = complete_rate,
      Mean = numeric.mean,
      SD = numeric.sd,
      Min = numeric.p0,
      Q25 = numeric.p25,
      Median = numeric.p50,
      Q75 = numeric.p75,
      Max = numeric.p100,
      Hist = numeric.hist
    ) %>%
    dplyr::select(Variable, Missing, CompRate, Mean, SD, Min, Q25, Median, Q75, Max, Hist)
}

# Global variables for skimr
utils::globalVariables(c("skim_type", "skim_variable", "n_missing", "complete_rate", "numeric.mean",
                         "numeric.sd", "numeric.p0", "numeric.p25", "numeric.p50", "numeric.p75",
                         "numeric.p100", "numeric.hist", "Variable", "Missing", "CompRate", "Mean",
                         "SD", "Min", "Q25", "Median", "Q75", "Max", "Hist"))
