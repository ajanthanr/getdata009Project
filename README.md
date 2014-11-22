# Project: Getting and Cleaning Data
====================================

## Overview (Project Instructions)
----------------------------------
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!
--------------

## Steps to generate the tidy data for this project
--------------------------------------------------
1. Download *run_analysis.R* from https://github.com/ajanthanr/getdata009Project.git
2. Open the *run_analysis.R* in a text editor and change the *setwd* to the working directory
3. Place the downloaded zip file into the working directory
4. Download the zip file from  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
5. Download the Makecodebook.Rmd into the working directory


## Output
---------
By executing the *run_analysis.R* the following two outputs are:
1. Tidy dataset file *tidy_data.txt*, which is a comma separated value text file containing the count and the average value for each subject and activity.
2. A markdown *codebook.md* file
3. This README.md file as well

## Step by Step explanation of the *run_analysis.R* script
---------------------------------------------------------_
Set the working directory

```r
setwd("~/R/getdata-009/projects/")
```

Load packages

```r
packages <- c("data.table", "reshape2", "knitr")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
```

```
## data.table   reshape2      knitr 
##       TRUE       TRUE       TRUE
```

get working directory path

```r
path <- getwd()
```

Raw data path

```r
DataSetPath <- file.path(path, "UCI HAR Dataset")
```

Raw data file names
fnSubjectTrain = file.path(DataSetPath, "train", "subject_train.txt")
fnSubjectTest = file.path(DataSetPath, "test", "subject_test.txt")
fnYTrain = file.path(DataSetPath, "train", "y_train.txt")
fnYTest = file.path(DataSetPath, "test", "y_test.txt")
fnXTrain = file.path(DataSetPath, "train", "X_train.txt")
fnXTest = file.path(DataSetPath, "test", "X_test.txt")

Read the files
--------------

Read the subject files

```r
dataSubjectTrain <- fread(fnSubjectTrain)
dataSubjectTest <- fread(fnSubjectTest)
```

Read the activity files

```r
dataActivityTrain <- fread(fnYTrain)
dataActivityTest <- fread(fnYTest)
```

Read the data files

```r
dataTrain <- data.table(read.table(fnXTrain))
dataTest <- data.table(read.table(fnXTest))
```

1) Merges the training and the test sets to create one data set.
----------------------------------------------------------------
Concatenate the subject data tables

```r
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
setnames(dataSubject, "V1", "subjectId")
```

Concatenate the activity data table

```r
dataActivity <- rbind(dataActivityTrain, dataActivityTest)
setnames(dataActivity, "V1", "activityId")
```

Concatenate the data

```r
data <- rbind(dataTrain, dataTest)
```

Merge columns

```r
dataSubject <- cbind(dataSubject, dataActivity)
data <- cbind(dataSubject, data)
```

set key

```r
setkey(data, subjectId, activityId)
```


2) Extracts only the measurements on the mean and standard deviation for each measurement. 
------------------------------------------------------------------------------------------
Load the feature.txt and name the columns

```r
fnFeatures = file.path(DataSetPath, "features.txt")
features <- fread(fnFeatures)
```

Rename the feature data table column names

```r
setnames(features, c("V1", "V2"), c("featureId", "featureName"))
```

Extract only the mean and std from the feature datatable

```r
ptn = "mean\\(|std\\("
ndx = grep(ptn, features$featureName, perl=TRUE)
meanStdFeaturesOnly = features[ndx,]
```

Create a new column with feature code

```r
meanStdFeaturesOnly$featureCode <- meanStdFeaturesOnly[, paste("V", sep="", meanStdFeaturesOnly$featureId)]
```

Subset variables using variable names

```r
data <- data[, c(key(data), meanStdFeaturesOnly$featureCode), with = FALSE]
```


3) Uses descriptive activity names to name the activities in the data set
-------------------------------------------------------------------------
Read activity_lable.txt file and add the descriptive names to activity

```r
fnActivityLable = file.path(DataSetPath, "activity_labels.txt")
dataActivityNames <- fread(fnActivityLable)
```

Rename the activity lable data table columns

```r
setnames(dataActivityNames, c("V1", "V2"), c("activityId", "activityName"))
```


4) Appropriately labels the data set with descriptive variable names
--------------------------------------------------------------------
Merge data table and activity names by activityId

```r
data <- merge(data, dataActivityNames, by = "activityId", all.x = TRUE)
```

Add activity name as a key

```r
setkey(data, subjectId, activityId, activityName)
```

Melt the data table

```r
data <-data.table(melt(data, key(data), variable.name = "featureCode"))
```

Merge the meana nd dtd features only

```r
data <- merge(data, meanStdFeaturesOnly[,list(featureId, featureCode, featureName)], by = "featureCode", all.x=TRUE)
```

Renme the activtyName to activity and featureNmae to feature

```r
setnames(data, c("activityName", "featureName"), c("activity", "feature"))
```


5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
-------------------------------------------------------------------------------------------------------------------------------------------------
Set the key to the data set to do the average and count

```r
setkey(data, subjectId, activityId, activity, featureCode, feature)
```

Create tidy data set with the count and average of each activity and subject

```r
tidyData <- data[, list(count = .N, average = mean(value)), by = key(data)]
```

Write the file to working directory

```r
fnTidyData = file.path(path, "tidy_data.txt")
write.table (tidyData, file=fnTidyData, sep=",", row.names=FALSE)
```

Create codebook

```r
knit("makeCodebook.Rmd", output = "codebook.md", encoding = "ISO8859-1", quiet = TRUE)
```

```
## [1] "codebook.md"
```

Create README.md

```r
knit("makeReadme.Rmd", output = "README.md", encoding = "ISO8859-1", quiet = TRUE)
```





