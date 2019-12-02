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

###############################
# WEEK 5, wrangling continues #
###############################

# reading the data

human <- read.csv(file = "data/human.csv")
str(human)
dim(human)
# data has 195 observations and 19 variables
# Variables are for example HDI index and rank, GNI indekx, GII index and rank, country, life expectancy, education mean 
# expectancy, maternity mortality, women's parlament represenment, women and mens education and labour ratios

# 1) mutating GNI variable to numeric
human$gni <- as.numeric(human$gni)

# 2) excluding unwanted varibles, keeping ( "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", 
# "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

human_ <- dplyr::select(human, one_of("country", "eduRatio", "labourRatio", "exp_edu", "life_exp", 
                                      "gni", "mater_mor", "ado_birth", "parl_rep"))

# 3) Removing missing rows

complete.cases(human_)

h <- data.frame(human_[-1], comp = complete.cases(human_))

# filter out all rows with NA values
human__ <- filter(human_, h$comp == TRUE)

# 4) remove regions

tail(human__, n = 10)
human__ <- slice(human__, 1:155)
tail(human__)

# 5) countries as rownames

rownames(human__) <- human__$country

human__ <- dplyr::select(human__, - country)

# extra: changing colnames since I didnt like the ones I made up myself
colnames(human__) <- c("Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

str(human__)
head(human__)

summary(human__)

write.table(human__, file = "data/human.csv", sep = ",", row.names = T, dec = ".")
