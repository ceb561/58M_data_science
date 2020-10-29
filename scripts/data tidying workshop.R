#data tidying workshop

#connect to github
usethis::use_git_config(user.name = "Claire Brown",
                        user.email = "ceb561@york.ac.uk")

#define filename
file_hdi <- ("data_raw/Human-development-index.csv")

#read in file and tidy filenames
hdi <- read_csv(file_hdi) %>% 
  janitor::clean_names()

#gather all columns apart from hdi_rank 2018 and country
hdi2 <- hdi %>% 
  pivot_longer(names_to = "year", 
               values_to = "index",
               cols = -c(hdi_rank_2018, country))%>%
  mutate(year =  str_extract(year,"x[^\\s]+") %>% #remove "x" from year
           str_replace("x", ""))

#remove na rows
hdi_no_na <- hdi2 %>% 
  drop_na(index)

#summarise df
hdi_summary <- hdi_no_na %>% 
  group_by(country) %>% 
  summarise(mean_index = mean(index),
            n          = length(index),
            std_index  = sd(index),
            se_index   = std_index/sqrt(n))

#filter to get 10 lowest
hdi_summary_low <- hdi_summary %>% 
  filter(rank(mean_index) < 11)

hdi_summary_low

#plot the 10 lowest indexes
low_hdi_fig <- hdi_summary_low %>% 
  ggplot() +
  geom_point(aes(x = country,
                 y = mean_index)) +
  geom_errorbar(aes(x = country,
                    ymin = mean_index - se_index,
                    ymax = mean_index + se_index)) +
  scale_y_continuous(limits = c(0, 0.5),
                     expand = c(0, 0),
                     name = "HDI") +
  scale_x_discrete(expand = c(0, 0),
                   name = "") +
  theme_classic() +
  coord_flip()
low_hdi_fig

#parameters for saving figs
units = "in"
fig_w <- 6
fig_h <- 2
dpi <- 100
device <- "tiff"

ggsave("figures/fig1_low_hdi.tif", 
       plot = low_hdi_fig, 
       device = device,
       width = fig_w, 
       height = fig_w,
       units = units,
       dpi = dpi)

