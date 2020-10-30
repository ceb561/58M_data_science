#Tidying task 2 buoy data

rm(list=ls()) #clear environment
library(tidyverse)
###################################

file <- "http://www.ndbc.noaa.gov/view_text_file.php?filename=44025h2011.txt.gz&dir=data/historical/stdmet/"

#read in file without headers
buoy44025 <- read_table(file, 
                        col_names = F,
                        skip = 2)
#read in measure (top line, 18 elements)
measure <- scan(file, 
                  what=" ",
                  nmax = 18) %>% 
  str_replace_all("[[:punct:]]", " ")

#read in units (line 2, 18 elements)
units <- scan(file, 
          what=" ",
          nmax = 18,
          skip=1)%>% 
  str_replace_all("[[:punct:]]", " ")

#make df from measure and units and paste to make combined column
df <- data.frame(measure, units) %>% 
  mutate(measure_units = paste(measure, units, sep="_"))

names(buoy44025) <- df$measure_units

write.table(buoy44025, 
            "data_processed/tidy_buoy_data.txt", 
            quote = FALSE,
            row.names = FALSE)



units <- scan(file, 
              skip = 1,
              nlines = 1, 
              what = character()) %>% 
  str_remove("#") %>% 
  str_replace("/", "_per_")
# paste the variable name and its units together for the column names
names(buoy44025) <- paste(measure, units, sep = "_")   
