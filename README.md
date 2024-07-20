
# easysum

<!-- badges: start -->
<!-- badges: end -->

The goal of easysum is to provide easy-to-use wrapper functions for commonly used summary statistics, simplifying the process by reducing the amount of code needed to perform these operations.


## Installation

You can install the development version of easysum from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("takakishi/easysum")
library(easysum)
```


## Example

In this example, we use the [`gapminder`](https://cran.r-project.org/web/packages/gapminder/readme/README.html) dataset for demonstration.

```r
library(dplyr)
library(gapminder)

# Display the gapminder dataset
gapminder
# A tibble: 1,704 × 6
#    country     continent  year lifeExp      pop gdpPercap
#    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
#  1 Afghanistan Asia       1952    28.8  8425333      779.
#  2 Afghanistan Asia       1957    30.3  9240934      821.
#  3 Afghanistan Asia       1962    32.0 10267083      853.
#  4 Afghanistan Asia       1967    34.0 11537966      836.
#  5 Afghanistan Asia       1972    36.1 13079460      740.
#  6 Afghanistan Asia       1977    38.4 14880372      786.
#  7 Afghanistan Asia       1982    39.9 12881816      978.
#  8 Afghanistan Asia       1987    40.8 13867957      852.
#  9 Afghanistan Asia       1992    41.7 16317921      649.
# 10 Afghanistan Asia       1997    41.8 22227415      635.
# ℹ 1,694 more rows
# ℹ Use `print(n = ...)` to see more rows
```

### 1. One Variable: `tab()`

We can easily tabulate a single variable using the `tab()` function, a pipe-able tabulate function based on [`janitor`](https://sfirke.github.io/janitor/index.html).

``` r
gapminder %>% tab(continent)
# continent    n percent
#    Africa  624  36.62%
#  Americas  300  17.61%
#      Asia  396  23.24%
#    Europe  360  21.13%
#   Oceania   24   1.41%
#     Total 1704 100.00%
```

This is equivalent as:

``` r
gapminder %>%
  janitor::tabyl(continent) %>%
  janitor::adorn_totals("row") %>%
  janitor::adorn_pct_formatting(digits = 2)
# continent    n percent
#    Africa  624  36.62%
#  Americas  300  17.61%
#      Asia  396  23.24%
#    Europe  360  21.13%
#   Oceania   24   1.41%
#     Total 1704 100.00%
```
