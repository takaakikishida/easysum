#' Summarize Missing Values and Unique Factors
#'
#' Summarizes missing values and unique factor levels for specified variables in a data frame using the `skimr` package.
#'
#' @param data A data frame to be summarized.
#' @param ... Optional. Specific variables to summarize. If none are specified, all variables are summarized.
#' @return A tibble with summarized statistics for missing values and unique factor levels.
#' @examples
#' library(dplyr)
#' library(skimr)
#' library(tibble)
#' library(gapminder)
#'
#' # Creating a gapminder dataset with some missing values
#' gapminder_na <- gapminder
#' gapminder_na[sample(1:nrow(gapminder_na), 100), "lifeExp"] <- NA
#'
#' # Using the sumr_na function for specific variables
#' sumr_na(gapminder_na, lifeExp, gdpPercap)
#'
#' # Using the sumr_na function for all variables
#' sumr_na(gapminder_na)
#' @importFrom dplyr filter select rename
#' @importFrom skimr skim
#' @importFrom tibble as_tibble
#' @importFrom rlang enquos
#' @export
sumr_na <- function(data, ...) {
  vars <- rlang::enquos(...)

  if (length(vars) == 0) {
    data_to_skim <- data
  } else {
    data_to_skim <- dplyr::select(data, !!!vars)
  }

  skimmed_data <- data_to_skim %>%
    skimr::skim() %>%
    tibble::as_tibble()

  if ("factor.n_unique" %in% names(skimmed_data)) {
    skimmed_data %>%
      dplyr::select(
        skim_variable, n_missing, complete_rate, factor.n_unique
      ) %>%
      dplyr::rename(
        Variable = skim_variable,
        Missing = n_missing,
        CompRate = complete_rate,
        Factor_N_Unique = factor.n_unique
      ) %>%
      dplyr::select(Variable, Missing, CompRate, Factor_N_Unique)
  } else {
    skimmed_data %>%
      dplyr::select(
        skim_variable, n_missing, complete_rate
      ) %>%
      dplyr::rename(
        Variable = skim_variable,
        Missing = n_missing,
        CompRate = complete_rate
      ) %>%
      dplyr::select(Variable, Missing, CompRate)
  }
}

# Global variables for skimr
utils::globalVariables(c("skim_type", "skim_variable", "n_missing", "complete_rate", "factor.n_unique",
                         "Variable", "Missing", "CompRate", "Factor_N_Unique"))
