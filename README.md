
# easysum

<!-- badges: start -->
<!-- badges: end -->

The goal of easysum is to provide easy-to-use wrapper functions for commonly used summary statistics, simplifying the process by reducing the amount of code needed to perform these operations.

- `tab()`: Create a one-way tabulation (frequency table) with totals and percentages.
- [`tab()`: Create a one-way tabulation (frequency table) with totals and percentages.](#example-1-one-way-tabulation-tab)
- `sumr()`: Summarize numeric variables with basic statistics. 
- `sumr_full()`: Summarize numeric variables with a comprehensive set of statistics.
- `sumr_group_by()`: Summarize numeric variables by a grouping variable.
- `sumr_na()`: Summarize missing values and unique factor levels.


**Any feedback, comments, or suggestions to improve `{easysum}` are highly appreciated**. Please feel free to open an issue or submit a pull request on this [GitHub repository](https://github.com/takakishi/easysum).


## Installation

You can install the development version of `{easysum}` from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("takakishi/easysum")
library(easysum)
```


## Example: Setup

In the following examples, we use the [`{gapminder}`](https://cran.r-project.org/web/packages/gapminder/readme/README.html) dataset for demonstration, including missing in some variables to check the behavior of the functions.

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

introduce_na <- function(data, column, na_percentage, seed = NULL) {
  column_sym <- sym(column)
  column_type <- data %>%
    dplyr::pull(!!column_sym) %>%
    class()

  data %>%
    dplyr::mutate(!!column_sym := dplyr::if_else(
      runif(n()) < na_percentage,
      if (column_type %in% c("numeric", "double")) NA_real_ else if (column_type == "integer") NA_integer_ else if (column_type == "character") NA_character_ else NA,
      !!column_sym
    ))
}

gapminder_na <- gapminder %>%
  introduce_na("continent", 0.01, seed = 123) %>%
  introduce_na("lifeExp", 0.2, seed = 123) %>%
  introduce_na("gdpPercap", 0.1, seed = 123) 
```


## Example 1: One-way Tabulation `tab()`

We can easily tabulate a single variable using the `tab()` function, a pipe-able tabulate function based on [`{janitor}`](https://sfirke.github.io/janitor/index.html).

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

<details>
  <summary> (Almost) equivalent code using <code>{janitor}</code>, <code>{rstatix}</code>, and <code>{dplyr}</code> (click to expand). </summary>

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

  And similar to: 

  ```r
  gapminder %>% rstatix::freq_table(continent)
  # A tibble: 5 × 3
  #   continent     n  prop
  #   <fct>     <int> <dbl>
  # 1 Africa      624  36.6
  # 2 Americas    300  17.6
  # 3 Asia        396  23.2
  # 4 Europe      360  21.1
  # 5 Oceania      24   1.4
  ```

  ```r
  gapminder %>% dplyr::count(continent)
  # A tibble: 5 × 2
  #   continent     n
  #   <fct>     <int>
  # 1 Africa      624
  # 2 Americas    300
  # 3 Asia        396
  # 4 Europe      360
  # 5 Oceania      24
  ```
</details>


**Note:** When there are `NA`s in the data:

```r
gapminder_na %>% tab(continent)
# continent    n percent valid_percent
#    Africa  618  36.27%        36.61%
#  Americas  299  17.55%        17.71%
#      Asia  389  22.83%        23.05%
#    Europe  358  21.01%        21.21%
#   Oceania   24   1.41%         1.42%
#      <NA>   16   0.94%             -
#     Total 1704 100.00%       100.00%
```


## Example 2: (Basic) Summary Statistics `sumr()`

A summary statisitcs function based on [`{skimr}`](https://github.com/ropensci/skimr).

Summarize all numeric variables in a data frame: 

```r
gapminder_na %>% sumr()
#   A tibble: 4 × 7
#   Variable  CompRate       Mean          SD     Min          Max Hist 
#   <chr>        <dbl>      <dbl>       <dbl>   <dbl>        <dbl> <chr>
# 1 year         1         1980.         17.3  1952         2007   ▇▅▅▅▇
# 2 lifeExp      0.798       59.3        13.1    23.6         82.6 ▁▆▇▇▇
# 3 pop          1     29601212.  106157897.  60011   1318683096   ▇▁▁▁▁
# 4 gdpPercap    0.903     7223.       9951.    241.      113523.  ▇▁▁▁▁
```

Summarize specific numeric variables in a data frame:

```r
gapminder_na %>% sumr(gdpPercap, lifeExp)
#   A tibble: 2 × 7
#   Variable  CompRate   Mean     SD   Min      Max Hist 
#   <chr>        <dbl>  <dbl>  <dbl> <dbl>    <dbl> <chr>
# 1 gdpPercap    0.903 7223.  9951.  241.  113523.  ▇▁▁▁▁
# 2 lifeExp      0.798   59.3   13.1  23.6     82.6 ▁▆▇▇▇
```


## Example 3: (Full) Summary Statistics `sumr_full()`
```r
#   A tibble: 4 × 11
#   Variable  Missing CompRate       Mean          SD     Min       Q25  Median    Q75    Max Hist 
#   <chr>       <int>    <dbl>      <dbl>       <dbl>   <dbl>     <dbl>   <dbl>  <dbl>  <dbl> <chr>
# 1 year            0    1         1980.         17.3  1952      1966.   1.98e3 1.99e3 2.01e3 ▇▅▅▅▇
# 2 lifeExp       322    0.811       59.4        13.0    23.6      48.1  6.03e1 7.09e1 8.26e1 ▁▆▇▇▇
# 3 pop             0    1     29601212.  106157897.  60011   2793664    7.02e6 1.96e7 1.32e9 ▇▁▁▁▁
# 4 gdpPercap     174    0.898     7309.      10096.    241.     1182.   3.53e3 9.40e3 1.14e5 ▇▁▁▁▁
```


## Example 4: Summary Statistics by Group `sumr_group_by()`
```r
gapminder %>% sumr_group_by(by = continent)
#   A tibble: 20 × 8
#    Variable  continent CompRate       Mean           SD       Min          Max Hist 
#    <chr>     <fct>        <dbl>      <dbl>        <dbl>     <dbl>        <dbl> <chr>
#  1 year      Africa           1     1980.         17.3     1952         2007   ▇▅▅▅▇
#  2 year      Americas         1     1980.         17.3     1952         2007   ▇▅▅▅▇
#  3 year      Asia             1     1980.         17.3     1952         2007   ▇▅▅▅▇
#  4 year      Europe           1     1980.         17.3     1952         2007   ▇▅▅▅▇
#  5 year      Oceania          1     1980.         17.6     1952         2007   ▇▅▅▅▇
#  6 lifeExp   Africa           1       48.9         9.15      23.6         76.4 ▁▆▇▃▁
#  7 lifeExp   Americas         1       64.7         9.35      37.6         80.7 ▁▂▅▇▅
#  8 lifeExp   Asia             1       60.1        11.9       28.8         82.6 ▁▅▆▇▃
#  9 lifeExp   Europe           1       71.9         5.43      43.6         81.8 ▁▁▁▇▅
# 10 lifeExp   Oceania          1       74.3         3.80      69.1         81.2 ▇▅▃▂▅
# 11 pop       Africa           1  9916003.   15490923.     60011    135031164   ▇▁▁▁▁
# 12 pop       Americas         1 24504795.   50979430.    662850    301139947   ▇▁▁▁▁
# 13 pop       Asia             1 77038722.  206885205.    120447   1318683096   ▇▁▁▁▁
# 14 pop       Europe           1 17169765.   20519438.    147962     82400996   ▇▁▁▁▁
# 15 pop       Oceania          1  8874672.    6506342.   1994794     20434176   ▇▁▂▂▂
# 16 gdpPercap Africa           1     2194.       2828.       241.       21951.  ▇▁▁▁▁
# 17 gdpPercap Americas         1     7136.       6397.      1202.       42952.  ▇▁▁▁▁
# 18 gdpPercap Asia             1     7902.      14045.       331       113523.  ▇▁▁▁▁
# 19 gdpPercap Europe           1    14469.       9355.       974.       49357.  ▇▆▃▁▁
# 20 gdpPercap Oceania          1    18622.       6359.     10040.       34435.  ▇▇▃▂▂
```

```r
gapminder %>%
  sumr_group_by(lifeExp, by = continent) %>%
  dplyr::arrange(desc(Mean))
#   A tibble: 5 × 8
#   Variable continent CompRate  Mean    SD   Min   Max Hist 
#   <chr>    <fct>        <dbl> <dbl> <dbl> <dbl> <dbl> <chr>
# 1 lifeExp  Oceania          1  74.3  3.80  69.1  81.2 ▇▅▃▂▅
# 2 lifeExp  Europe           1  71.9  5.43  43.6  81.8 ▁▁▁▇▅
# 3 lifeExp  Americas         1  64.7  9.35  37.6  80.7 ▁▂▅▇▅
# 4 lifeExp  Asia             1  60.1 11.9   28.8  82.6 ▁▅▆▇▃
# 5 lifeExp  Africa           1  48.9  9.15  23.6  76.4 ▁▆▇▃▁
```


## Example 5: Summary of Missing Values and Unique Factors `sumr_na()`

```r
gapminder_na %>% sumr_na()
#   A tibble: 6 × 4
#   Variable  Missing CompRate Factor_N_Unique
#   <chr>       <int>    <dbl>           <int>
# 1 country         0    1                 142
# 2 continent      16    0.991               5
# 3 year            0    1                  NA
# 4 lifeExp       322    0.811              NA
# 5 pop             0    1                  NA
# 6 gdpPercap     174    0.898              NA
```

```r
gapminder_na %>% sumr_na(country, lifeExp, gdpPercap)
#   A tibble: 3 × 4
#   Variable  Missing CompRate Factor_N_Unique
#   <chr>       <int>    <dbl>           <int>
# 1 country         0    1                 142
# 2 lifeExp       322    0.811              NA
# 3 gdpPercap     174    0.898              NA
```
