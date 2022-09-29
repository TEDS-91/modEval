
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Overview

<!-- badges: start -->
<!-- badges: end -->

The goal of **modEval** package is to allow users to perform statistical
model evaluation and comparison. Package developed as part of the
requirements of the package development course offered by
[**Curso-R**](https://curso-r.com/).

## Installation

You can install the development version of modEval from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("TEDS-91/modEval")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(modEval)

## Model evaluation - metrics

predicted <- data_template$`Full Model`

observed <- data_template$observed

model_eval(obs_values = observed, pred_values = predicted)
#> # A tibble: 1 x 11
#>   Intercept Slope     r    r2        MB        MAE   MSE  RMSE   CCC    CD    ME
#>       <dbl> <dbl> <dbl> <dbl>     <dbl>      <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1   0.00480  1.00 0.857 0.734 -0.000313 0.00000977 1209.  34.8 0.847  1.36 0.734
```

# The “model_eval_ui()” function

If you run **model_eval_ui()** a graphical user interface will pop up on
your screen. It is a shiny application where you are able to download a
template **.xlsx** file, fill it up with your own data and upload the
**.xlsx** to feed to the app.
