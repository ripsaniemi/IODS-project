# IODS 2019, Ripsa Niemi, 8.12.2019 
# meet_and_repeat wrangle

library(dplyr); library(tidyr)
# 1) reading tables

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt",
                   sep = " ", header = TRUE)

str(BPRS)
colnames(BPRS)
summary(BPRS)
# wide format of BPRS has 40 obs and 11 variables. Variable treatment tells which treatment was used,
# var subject tells the "id" code for each person, week0-8 show the psychiatric rating scale (BPRS) 
# measured on that week

RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", 
                   sep = "\t", header = TRUE)

str(RATS)
colnames(RATS)
summary(RATS)
# wide format of RATS has 16 obs and 13 variables. Vars are id, group and WD 1-64, which show weigth of
# the rat on that measure moment

# 2) factoring

BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# 3) converting to long form

BPRSL <- BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <- BPRSL %>% mutate(week = as.integer(substr(BPRSL$weeks, 5,5)))


RATSL <- RATS %>% gather(key = WD, value = weight, -ID, -Group)
RATSL <- RATSL %>% mutate(Time = as.integer(substr(RATSL$WD, 3, 4)))
glimpse(RATSL)

# 4) taking a serious look on these datasets

colnames(BPRSL)
str(BPRSL)
summary(BPRSL)
# now we have 5 vars instead of 16 and 360 obs instead of 40

colnames(RATSL)
str(RATSL)
summary(RATSL)
# colnames are different, now we have 5 vars instead of 13, and 176 obs instead of 16

# Basically what was done, is that our columns week and wd are now individual rows
# In wide format there was only one row for each ID/subject, now there are several rows for each ID/subject
# and each weighting/measuring point is a seperate observation

# Then let's write these datasets

write.csv(RATSL, file ="data/RATSL.csv", row.names = FALSE)
write.csv(BPRSL, file ="data/BPRSL.csv", row.names = FALSE)
