---
title: "Getting and Cleaning Data Course Project"
output: html_notebook
---

**This is for the week 4 final assignment.**

*You should create one R script called run_analysis.R that does the following.*

  *1. Merges the training and the test sets to create one data set.*
  
  *2. Extracts only the measurements on the mean and standard deviation for each measurement.*
  
  *3. Uses descriptive activity names to name the activities in the data set*
  
  *4. Appropriately labels the data set with descriptive variable names.*
  
  *5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.*



## Variable description

**activityLabels**: labels each activity name with a number.

**features**: every parameter measured by the technology, labeled with a unique id.

**train**: the train data containing all measurements and respective subject and activity performed.

**trainActivities**: column that encodes each activity with a number for modelling purposes.

**trainSubjects**: column that encodes each subject with a number for modelling purposes.

**test**: the test data containing all measurements and respective subject and activity performed.

**testActivities**: column that encodes each activity with a number for modelling purposes.

**testSubjects**: column that encodes each subject with a number for modelling purposes.

**traintest**: the merged train and data subsets.

**traintest_mean**: the final tidy dataset containing mean values of all parameters collected for each explicit activity and subject that used the technology.

## The data
One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


## Cleaning procedure

#### 1. Imports
```{r}
library(data.table)
library(reshape2)
```

#### 2. Download and unzip dataset
```{r}
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "dataset.zip"))
unzip(zipfile = "dataset.zip")
```

#### 3. UCI HAR Dataset folder: loads
```{r}
activityLabels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt"), col.names=c("Label", "Activity"))
features <- fread(file.path(path, "UCI HAR Dataset/features.txt"), col.names=c("id", "featureName"))

# filter only parameters that are mean or std
featuresWanted <- grep("(mean|std)\\()", features$featureName)

# clean up names
measurements <- gsub('[()]', '', featuresWanted)
```

#### 4. TRAIN dataset
```{r}
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
```

#### 5. TEST dataset
```{r}
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
```

#### 6. MERGE train and test data
```{r}
# ---------------------------
# MERGE train and test data
# ---------------------------
traintest <- rbind(train, test)
```

#### 7. Change activity and subject values to descriptive labels
```{r}
traintest[["Activity"]] <- factor(traintest[, Activity], levels = activityLabels[["Label"]], labels = activityLabels[["Activity"]])
traintest[["Subject"]] <- as.factor(traintest[, Subject])
```

#### 8. Secondary dataset with mean by subject and activity
```{r}
# group by subject and activity
traintest_mean <- melt(traintest, c("Subject", "Activity"))

# create new dataset
traintest_mean <- dcast(traintest_mean, Subject+Activity ~ variable, fun.aggregate = mean)

# assign descriptive column names
traintest_labels <- c("Subject", "Activity", grep("(mean|std)\\()", features$featureName, value=TRUE))
names(traintest_mean) <- traintest_labels

# write dataset to tidyData.txt
fwrite(traintest_mean, file="tidyData.txt", quote=FALSE)
```

