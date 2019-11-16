# IODS 15.11.2019 
# Ripsa Niemi
# data-source: https://archive.ics.uci.edu/ml/datasets/Student+Performance

getwd()

# First let's read the files 
student_mat <- read.csv(file = "data/student-mat.csv", sep = ";")

student_por <- read.csv(file = "data/student-por.csv", sep = ";")

# Then dimensions and structure

dim(student_mat)
dim(student_por)

# Both have 33 variables, but different amount of observations

str(student_mat)
str(student_por)

# then let's join the data-sets

library(dplyr)

join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", 
             "Fjob", "reason", "nursery","internet")


math_por <- inner_join(student_mat, student_por, by = join_by, suffix = c(".math", ".por"))
dim(math_por)

str(math_por)

glimpse(math_por)

# I deciced to copy the following code from datacamp

#create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(student_mat)[!colnames(student_mat) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

glimpse(alc)

# lets create a new column alc_use

alc <- mutate(alc, alc_use = ((Dalc + Walc) / 2))

# new columb high_use

alc <- mutate(alc, high_use = alc_use > 2)

glimpse(alc)

# looks good!

write.csv(alc, file ="data/alc.csv", row.names=FALSE)

