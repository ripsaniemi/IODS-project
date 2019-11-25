# IODS: week 4, Ripsa Niemi, 25.11.2019

library(dplyr)

# Reading the datasets
url1 <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv"
hd <- read.csv(url1, stringsAsFactors = F)

url2 <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv"
gii <- read.csv(url2, stringsAsFactors = F, na.strings = "..")

# Structure of datasets
str(hd)
str(gii)

# Summaries of variables
summary(hd)
summary(gii)

# renaming variables

hd_names <- c("hdi_rank", "country", "hdi", "life_exp", "exp_edu", "mean_edu", "gni", "gni-hdi_rank")
gii_names <- c("gii_rank", "country", "gii", "mater_mor", "ado_birth", "parl_rep", "edu2F", "edu2M", "labourF", "labourM")

colnames(hd) <- hd_names
colnames(gii) <- gii_names

# adding new variables eduRatio and labourRatio
gii <- mutate(gii, eduRatio = edu2F/edu2M)
gii <- mutate(gii, labourRatio = labourF/labourM)

# let's join the datasets with country
human <- inner_join(hd, gii, by = "country")

# check that it has right dimensions
str(human)

# Then let's create a file out of it
write.csv(human, file = "data/human.csv", row.names = FALSE)
