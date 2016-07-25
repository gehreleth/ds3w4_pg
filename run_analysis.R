library(reshape2)

if (!dir.exists("./data")) {
  tmp = tempfile(pattern = "src")
  download.file(
    "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
    tmp,
    mode = "wb"
  )
  dir.create("./data")
  unzip(tmp, exdir = "./data")
  file.remove(tmp)
}

read_measurements <- function(filename) {
  data.frame(apply(read.csv(
    filename, header = FALSE, sep = ""
  ), 2, as.numeric))
}

read_labels <- function(filename) {
  retVal = read.csv(
    filename,
    header = FALSE,
    sep = "",
    stringsAsFactors = FALSE
  )
  retVal[, 1] <- as.numeric(retVal[, 1])
  retVal
}

columns_of_interest = c(1:6, 121:126)
column_names <- c("Subject",
  "Activity",
  "BodyAccelerationMeanX" ,
  "BodyAccelerationMeanY",
  "BodyAccelerationMeanZ",
  "BodyAccelerationStdDerivationX",
  "BodyAccelerationStdDerivationY",
  "BodyAccelerationStdDerivationZ",
  "BodyGyroscopeMeanX",
  "BodyGyroscopeMeanY",
  "BodyGyroscopeMeanZ",
  "BodyGyroscopeStdDerivationX",
  "BodyGyroscopeStdDerivationY",
  "BodyGyroscopeStdDerivationZ")

y_test <- read_measurements("./data/UCI HAR Dataset/test/y_test.txt")
X_test <- read_measurements("./data/UCI HAR Dataset/test/X_test.txt")

y_train <- read_measurements("./data/UCI HAR Dataset/train/y_train.txt")
X_train <- read_measurements("./data/UCI HAR Dataset/train/X_train.txt")

subjects_test <- read_measurements("./data/UCI HAR Dataset/test/subject_test.txt")
subjects_train <- read_measurements("./data/UCI HAR Dataset/train/subject_train.txt")

features <- read_labels("./data/UCI HAR Dataset/features.txt")

X_test <- X_test[, columns_of_interest]
X_train <- X_train[, columns_of_interest]

activity_labels <- read_labels("./data/UCI HAR Dataset/activity_labels.txt")

X_test <- cbind(apply(y_test, 1, function(x) {
  activity_labels[activity_labels[1] == x, 2]
}), X_test)

X_train <- cbind(apply(y_train, 1, function(x) {
  activity_labels[activity_labels[1] == x, 2]
}), X_train)

X_test <- cbind(subjects_test, X_test)
X_train <- cbind(subjects_train, X_train)

names(X_test) <- column_names 
names(X_train) <- column_names 

data_merged = rbind(X_test, X_train)

result <- dcast(melt(data_merged, c("Subject", "Activity")), Subject + Activity ~ variable, fun.aggregate = mean)
write.table(result, file="result.table", row.name=FALSE)
