#' Title A function to calculate the Sums of Squares (the sum of the squared deviations from the mean) for a numeric variable, 'measure', for each of the levels in 'group'
#'
#' @param df a data frame containing at least two columns, measure and group
#' @param measure the variable for which the sums of squares is to be calculated
#' @param group the variable giving the different groups for which sums of squares of measure are to be calculated
#'
#' @return
#' @export
#'
#' @examples
#' # create a data set
#' dat <- data.frame(x = rnorm(20, 10, 1), gp = rep(c("a","b"), each = 10))
#' sum_sq(dat, x, gp)
library(tidyverse)
sum_sq <- function(df, measure, group) {
  df %>% group_by({{ group }}) %>% 
    summarise(ss = sum(({{measure}} - mean({{measure}}))^2))
}
