# ---------------------------
# imports
# ---------------------------
library(data.table)
library(reshape2)


# ---------------------------
# download and unzip dataset
# ---------------------------
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "dataset.zip"))
unzip(zipfile = "dataset.zip")



# ---------------------------
# UCI HAR Dataset folder: loads
# ---------------------------
activityLabels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt"), col.names=c("Label", "Activity"))
features <- fread(file.path(path, "UCI HAR Dataset/features.txt"), col.names=c("id", "featureName"))

# filter only parameters that are mean or std
featuresWanted <- grep("(mean|std)\\()", features$featureName)

# clean up names
measurements <- gsub('[()]', '', featuresWanted)



# ---------------------------
# TRAIN dataset
# ---------------------------
# load training values
train <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, featuresWanted, with = FALSE]

# change column names to each measurement
setnames(train, colnames(train), measurements)

# load type of activity for those specific metrics
trainActivities <- fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt"), col.names = c("Activity"))

# load person id using the wearable
trainSubjects <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt"), col.names = c("Subject"))

# merge all data into the train set
train <- cbind(trainSubjects, trainActivities, train)


# ---------------------------
# TEST dataset
# ---------------------------
# load testing values
test <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, featuresWanted, with = FALSE]

# change column names to each measurement
setnames(test, colnames(test), measurements)

# load type of activity for those specific metrics
testActivities <- fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt"), col.names = c("Activity"))
# load person id using the wearable
testSubjects <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt"), col.names = c("Subject"))

# merge all data into the test set
test <- cbind(testSubjects, testActivities, test)



# ---------------------------
# MERGE train and test data
# ---------------------------
traintest <- rbind(train, test)


# ---------------------------
# Change activity and subject 
# values to descriptive labels
# ---------------------------
traintest[["Activity"]] <- factor(traintest[, Activity], levels = activityLabels[["Label"]], labels = activityLabels[["Activity"]])
traintest[["Subject"]] <- as.factor(traintest[, Subject])


# ---------------------------
# Secondary dataset with 
# mean by subject and activity
# ---------------------------

# group by subject and activity
traintest_mean <- melt(traintest, c("Subject", "Activity"))

# create new dataset
traintest_mean <- dcast(traintest_mean, Subject+Activity ~ variable, fun.aggregate = mean)

# assign descriptive column names
traintest_labels <- c("Subject", "Activity", grep("(mean|std)\\()", features$featureName, value=TRUE))
names(traintest_mean) <- traintest_labels

# write dataset to tidyData.txt
fwrite(traintest_mean, file="tidyData.txt", quote=FALSE)
