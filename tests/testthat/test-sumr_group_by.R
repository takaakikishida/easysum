library(testthat)
library(easysum)
library(dplyr)
library(skimr)
library(tibble)
library(gapminder)

test_that("sumr_group_by works for grouping variable", {
  result <- sumr_group_by(gapminder, by = continent)
  expect_true("Variable" %in% colnames(result))
  expect_true("continent" %in% colnames(result))
  expect_true("CompRate" %in% colnames(result))
  expect_true("Mean" %in% colnames(result))
  expect_true("SD" %in% colnames(result))
  expect_true("Min" %in% colnames(result))
  expect_true("Max" %in% colnames(result))
  expect_true("Hist" %in% colnames(result))
})

test_that("sumr_group_by works for specific variables and grouping", {
  result <- sumr_group_by(gapminder, by = continent, lifeExp, gdpPercap)
  expect_equal(length(unique(result$Variable)), 2)
  expect_true(all(result$Variable %in% c("lifeExp", "gdpPercap")))
})
