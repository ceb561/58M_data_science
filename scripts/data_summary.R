#' Title A function to calculate summary statistics (mean, sample size, standard deviation, standard error) for a numeric variable, 'measure', for each of the levels in 'group'
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
#' data_summary(dat, x, gp)
library(tidyverse)
data_summary <- function(df, measure, group) {
  df %>% 
    group_by({{ group }}) %>% 
    summarise(mean = mean({{ measure }}),
              n = length({{ measure }}),
              sd = sd({{ measure }}),
              se = sd/sqrt(n))
}