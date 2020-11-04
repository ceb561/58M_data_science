#Tidying task 3 proteomic data from five immortalised mesenchymal stromal 
#cell (MSC) lines

rm(list=ls()) #clear environment
library(tidyverse)
###################################

# define file name
filesol <- "data_raw/Y101_Y102_Y201_Y202_Y101-5.csv"
# skip first two lines
sol <- read_csv(filesol, skip = 2) %>% 
  janitor::clean_names()

#filtering rows

# filter out the bovine proteins and those proteins identified from fewer than 2 peptides
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

# Extract the genename from the description and put it in a column.
sol <- sol %>%
  mutate(genename =  str_extract(description,"GN=[^\\s]+") %>% 
           str_replace("GN=", ""))

#Extract the top protein identifier from the `accession` column and put it in a column called `protid`. The top protein identifier is the first Uniprot ID after the "1::" in the `accession` column. 

# trying it out on one value
accession <- sol$accession[2]
protid <- str_extract(accession, "1::[^;]+") %>% 
  str_replace("1::", "")

# adding a new column 
sol <- sol %>%
  mutate(protid =  str_extract(accession, "1::[^;]+") %>% 
           str_replace("1::", ""))

#Create a second dataframe, `sol2` in which the protein abundances 
#are in a single column, `abundance` and the cell lineage and replicate,
#`lineage_rep`, is indicated in another. All the other variables should also be in the new data frame. 
sol2 <- sol %>% pivot_longer(names_to = "lineage_rep",
                             values_to = "abundance",
                             cols = starts_with("y"))


#Create separate columns in `sol2` for the cell lineage and the replicate.
sol2 <- sol2 %>%
  extract(lineage_rep,
          c("line", "rep"),
          "(y[0-9]{3,4})\\_([a-c])")


file <-  "/data_processed/sol2.txt"
write.table(sol2, 
            file, 
            quote = FALSE,
            row.names = FALSE)