test_that("tab function works correctly", {
  library(dplyr)
  library(gapminder)
  result <- gapminder %>% tab(continent)
  expect_true("continent" %in% colnames(result))
  expect_true("Total" %in% result[[1]])
})
