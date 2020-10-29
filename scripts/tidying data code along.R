#Tidying data code along
########################

library(tidyverse)

#generate 10 random proportions
nums <- sample((1:100)/100, size = 10, replace = FALSE)


tnums <- log(sqrt(nums))

sqrtnums <- sqrt(nums)
tnums <- log(sqrtnums)

tnums <- nums %>% 
  sqrt() %>% 
  log()

#converting wide to long
biomass <- read_table2("data_raw/biomass.txt")

#gather all columns apart from rep_tray
biomass2 <- biomass %>% 
  pivot_longer(names_to = "spray", 
               values_to = "mass",
               cols = -rep_tray)

#write tidy data to file
write.table(biomass2, 
            "data_processed/biomass2.txt", 
            quote = FALSE,
            row.names = FALSE)


#splitting column components

#separate the replicate number from the tray identity
#and put them in two separate columns

# use regex. A regex defines a pattern for matching text.

#Extract parts of rep_tray and put in new columns replicate_number, tray_id:
biomass3 <- biomass2 %>% 
  extract(rep_tray, 
          c("replicate_number", "tray_id"),
          "([0-9]{1,2})\\_([a-z])")

# The patterns to save into columns are inside ( ).
# The pattern going into replicate_number, [0-9]{1,2}, means 1 or 2 numbers.
# The pattern going into tray_id, [a-z] means one lowercase letter.
# the bit between the two ( ), \_ is a pattern that matches what is in 
# rep_tray but is not to be saved.



# Real example
##########################
# Genever lab stuff

# define file name
filesol <- "data_raw/Y101_Y102_Y201_Y202_Y101-5.csv"

install.packages("janitor")
library(janitor)
# skip first two lines
sol <- read_csv(filesol, skip = 2) %>% 
  janitor::clean_names() #gives access to a package's functions without using library()

#filtering rows

#This dataset includes bovine serum proteins from the medium on which the
#cells were grown which need to be filtered out.

#and filter out proteins with less than 2 peptides
#detected as you can't be confident about their identity

#Keep rows of human proteins identified by more than one peptide:
sol <- sol %>% 
  filter(str_detect(description, "OS=Homo sapiens")) %>% 
  filter(x1pep == "x")

#str_detect is string detect

#extract gene name and put it in a col
#practice on 2 value
sol$description[1]
one_description <- sol$description[1]
str_extract(one_description,"GN=[^\\s]+")

# [ ] means some characters
# ^ means 'not' when inside [ ]
# \s means white space
# the \ before is an escape character to indicate that the next character, \ should not be taken literally (because it's part of \s)
# + means one or more

#So GN=[^\\s]+ means GN= followed by one or more characters that are not 
#whitespace. This means the pattern stops matching at the first white space 
#after "GN=".

#remove GN= by replacing it with nothing
str_extract(one_description, "GN=[^\\s]+") %>% 
  str_replace("GN=", "") 

# Add a variable genename which contains the processed string from 
# the description variable:
sol <- sol %>%
  mutate(genename =  str_extract(description,"GN=[^\\s]+") %>% 
           str_replace("GN=", ""))

