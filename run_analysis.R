setwd("~/R/getdata-009/projects/")
packages <- c("data.table", "reshape2", "knitr")
sapply(packages, require, character.only=TRUE, quietly=TRUE)

## file names
path <- getwd()
DataSetPath <- file.path(path, "UCI HAR Dataset")
fnSubjectTrain = file.path(DataSetPath, "train", "subject_train.txt")
fnSubjectTest = file.path(DataSetPath, "test", "subject_test.txt")
fnYTrain = file.path(DataSetPath, "train", "y_train.txt")
fnYTest = file.path(DataSetPath, "test", "y_test.txt")
fnXTrain = file.path(DataSetPath, "train", "X_train.txt")
fnXTest = file.path(DataSetPath, "test", "X_test.txt")

## read subject files
dataSubjectTrain <- fread(fnSubjectTrain)
dataSubjectTest <- fread(fnSubjectTest)

## read activity files
dataActivityTrain <- fread(fnYTrain)
dataActivityTest <- fread(fnYTest)

## read data files
dataTrain <- data.table(read.table(fnXTrain))
dataTest <- data.table(read.table(fnXTest))

# 1) Merges the training and the test sets to create one data set.
## | Concatenate the subject data tables
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
setnames(dataSubject, "V1", "subjectId")

## | Concatenate the activity data table
dataActivity <- rbind(dataActivityTrain, dataActivityTest)
setnames(dataActivity, "V1", "activityId")

## | Concatenate the data
data <- rbind(dataTrain, dataTest)

dataSubject <- cbind(dataSubject, dataActivity)
data <- cbind(dataSubject, data)

setkey(data, subjectId, activityId)

# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
## | Load the feature.txt and name the columns
fnFeatures = file.path(DataSetPath, "features.txt")
features <- fread(fnFeatures)
setnames(features, c("V1", "V2"), c("featureId", "featureName"))

## | extract only the mean and std from the feature datatable
ptn = "mean\\(|std\\("
ndx = grep(ptn, features$featureName, perl=TRUE)
meanStdFeaturesOnly = features[ndx,]

## | Create a new column with feature code
meanStdFeaturesOnly$featureCode <- meanStdFeaturesOnly[, paste("V", sep="", meanStdFeaturesOnly$featureId)]

data <- data[, c(key(data), meanStdFeaturesOnly$featureCode), with = FALSE]

# 3) Uses descriptive activity names to name the activities in the data set
fnActivityLable = file.path(DataSetPath, "activity_labels.txt")
dataActivityNames <- fread(fnActivityLable)
setnames(dataActivityNames, c("V1", "V2"), c("activityId", "activityName"))


# 4) Appropriately labels the data set with descriptive variable names. 
data <- merge(data, dataActivityNames, by = "activityId", all.x = TRUE)

## | add activity name as a key
setkey(data, subjectId, activityId, activityName)

## | Melt the data table
data <-data.table(melt(data, key(data), variable.name = "featureCode"))
data <- merge(data, meanStdFeaturesOnly[,list(featureId, featureCode, featureName)], by = "featureCode", all.x=TRUE)
setnames(data, c("activityName", "featureName"), c("activity", "feature"))

# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## | set the key to the data set to do the average and count
setkey(data, subjectId, activityId, activity, featureCode, feature)
tidyData <- data[, list(count = .N, average = mean(value)), by = key(data)]

## write the file to working directory
fnTidyData = file.path(path, "tidy_data.txt")
write.table (tidyData, file=fnTidyData, sep=",", row.names=FALSE)

## Create codebook
knit("makeCodebook.Rmd", output = "codebook.md", encoding = "ISO8859-1", quiet = TRUE)

## Create Readme file
knit("makeReadme.Rmd", output = "README.md", encoding = "ISO8859-1", quiet = TRUE)
