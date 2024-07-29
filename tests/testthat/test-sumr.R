library(testthat)
library(easysum)
library(dplyr)
library(skimr)
library(tibble)
library(gapminder)

test_that("sumr works for all numeric variables", {
  result <- sumr(gapminder)
  expect_true("Variable" %in% colnames(result))
  expect_true("CompRate" %in% colnames(result))
  expect_true("Mean" %in% colnames(result))
  expect_true("SD" %in% colnames(result))
  expect_true("Min" %in% colnames(result))
  expect_true("Max" %in% colnames(result))
  expect_true("Hist" %in% colnames(result))
})

test_that("sumr works for specific variables", {
  result <- sumr(gapminder, lifeExp, gdpPercap)
  expect_equal(nrow(result), 2)
  expect_true(all(result$Variable %in% c("lifeExp", "gdpPercap")))
})

test_that("sumr handles missing values correctly", {
  gapminder_na <- gapminder
  gapminder_na[sample(1:nrow(gapminder_na), 100), "lifeExp"] <- NA
  result <- sumr(gapminder_na, lifeExp)
  expect_true("Variable" %in% colnames(result))
  expect_true("CompRate" %in% colnames(result))
  expect_true("Mean" %in% colnames(result))
  expect_true("SD" %in% colnames(result))
  expect_true("Min" %in% colnames(result))
  expect_true("Max" %in% colnames(result))
  expect_true("Hist" %in% colnames(result))
})
