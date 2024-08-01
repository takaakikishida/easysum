library(testthat)
library(easysum)
library(dplyr)
library(skimr)
library(tibble)
library(gapminder)

test_that("sumr_na works for all variables", {
  gapminder_na <- gapminder
  gapminder_na[sample(1:nrow(gapminder_na), 100), "lifeExp"] <- NA
  result <- sumr_na(gapminder_na)
  expect_true("Variable" %in% colnames(result))
  expect_true("Missing" %in% colnames(result))
  expect_true("CompRate" %in% colnames(result))
})

test_that("sumr_na works for specific variables", {
  gapminder_na <- gapminder
  gapminder_na[sample(1:nrow(gapminder_na), 100), "lifeExp"] <- NA
  result <- sumr_na(gapminder_na, lifeExp, gdpPercap)
  expect_equal(nrow(result), 2)
  expect_true(all(result$Variable %in% c("lifeExp", "gdpPercap")))
})
