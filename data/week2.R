# Ripsa Niemi, 1.11.2019, week 2 data wrangling

# 2)

# Reading the table from a website

url <- "http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt"

data <- read.table(url, sep ="\t", header = TRUE)

str(data)
dim(data)

# Looking at the structure:
# There are 60 variables, all of them are int-type, except one factor for variable gender.
# There are 184 observations

# Looking at dimensios tells the same result:
# Data has 184 rows (obs) and 60 columns (variables)

# Let's start the wrangling!

library(dplyr)

# 3)

# First let's create variables deep, stra and surf
deep <- select(data, one_of(c("D03","D11","D19","D27","D07","D14","D22","D30","D06","D15","D23","D31")))
deep <- rowMeans(deep)

stra <- select(data, one_of(c("ST01","ST09","ST17","ST25","ST04","ST12","ST20", "ST28")))
stra <- rowMeans(stra)

surf <- select(data, one_of(c("SU02","SU10","SU18","SU26","SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")))
surf <- rowMeans(surf)

# then let's combine these and other 4 variables to new data frame

final_data <- data.frame(data$gender, data$Age, data$Attitude, deep, stra, surf, data$Points)
colnames(final_data) <- c("gender","age","attitude","deep","stra","surf","points")
glimpse(final_data)

# Finally, we'll filter those rows were points are over 0

final_data2 <- filter(final_data, points > 0)
glimpse(final_data2)

# We have wanted 166 obs and 7 variables, yey!

# 4)
# Writing a cvs-file

getwd()
setwd("C:/Users/ripsa/Documents/IODS-project/data")
write.csv(final_data2, file="data/learning2014.csv", row.names=FALSE)

# And let's check that it works..

test <- read.csv("learning2014.csv")

str(test)
head(test) 

# All good, ready to analyze :D!
