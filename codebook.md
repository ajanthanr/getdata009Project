# Codebook
========

## Overview
-----------
The tidy data is generated using the raw data extracted from the following site:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

## Variable list and descriptions
---------------------------------
Variable name   | Description
----------------|-----------------
subjectId	| Subject's ID who performed the activity.  Range from 1 to 30
activityId	| Activity ID ```{r}unique(tidyData$activity)```
activity	| Activity names: walking, walking_upstairs, walking_downstairs, sitting, standing and laying
featureCode	| Code of each features
feature		| Feature names, there are 33 unique mean variables and 33 unique standard deviation variables
count		| Number of counts for each feature
average		| Average of each feature for each activity of the subject

## Dimension
------------

```r
dim(tidyData)
```

```
## [1] 11880     7
```

## Dataset structure
------------------

```r
str(tidyData)
```

```
## Classes 'data.table' and 'data.frame':	11880 obs. of  7 variables:
##  $ subjectId  : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ activityId : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ activity   : chr  "WALKING" "WALKING" "WALKING" "WALKING" ...
##  $ featureCode: chr  "V1" "V121" "V122" "V123" ...
##  $ feature    : chr  "tBodyAcc-mean()-X" "tBodyGyro-mean()-X" "tBodyGyro-mean()-Y" "tBodyGyro-mean()-Z" ...
##  $ count      : int  95 95 95 95 95 95 95 95 95 95 ...
##  $ average    : num  0.2773 -0.0418 -0.0695 0.0849 -0.4735 ...
##  - attr(*, "sorted")= chr  "subjectId" "activityId" "activity" "featureCode" ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

## List of key variables in the data table
--------------------------------------------------

```r
key(tidyData)
```

```
## [1] "subjectId"   "activityId"  "activity"    "featureCode" "feature"
```

## Sample dataset
---------------------

```r
tidyData
```

```
##        subjectId activityId activity featureCode               feature
##     1:         1          1  WALKING          V1     tBodyAcc-mean()-X
##     2:         1          1  WALKING        V121    tBodyGyro-mean()-X
##     3:         1          1  WALKING        V122    tBodyGyro-mean()-Y
##     4:         1          1  WALKING        V123    tBodyGyro-mean()-Z
##     5:         1          1  WALKING        V124     tBodyGyro-std()-X
##    ---                                                                
## 11876:        30          6   LAYING         V82 tBodyAccJerk-mean()-Y
## 11877:        30          6   LAYING         V83 tBodyAccJerk-mean()-Z
## 11878:        30          6   LAYING         V84  tBodyAccJerk-std()-X
## 11879:        30          6   LAYING         V85  tBodyAccJerk-std()-Y
## 11880:        30          6   LAYING         V86  tBodyAccJerk-std()-Z
##        count       average
##     1:    95  0.2773307587
##     2:    95 -0.0418309635
##     3:    95 -0.0695300462
##     4:    95  0.0849448173
##     5:    95 -0.4735354859
##    ---                    
## 11876:    70  0.0107680190
## 11877:    70 -0.0003741897
## 11878:    70 -0.9774637756
## 11879:    70 -0.9710497781
## 11880:    70 -0.9795178961
```

## Summary of varibales
-----------------------------

```r
summary(tidyData)
```

```
##    subjectId      activityId    activity         featureCode       
##  Min.   : 1.0   Min.   :1.0   Length:11880       Length:11880      
##  1st Qu.: 8.0   1st Qu.:2.0   Class :character   Class :character  
##  Median :15.5   Median :3.5   Mode  :character   Mode  :character  
##  Mean   :15.5   Mean   :3.5                                        
##  3rd Qu.:23.0   3rd Qu.:5.0                                        
##  Max.   :30.0   Max.   :6.0                                        
##    feature              count          average        
##  Length:11880       Min.   :36.00   Min.   :-0.99767  
##  Class :character   1st Qu.:49.00   1st Qu.:-0.96205  
##  Mode  :character   Median :54.50   Median :-0.46989  
##                     Mean   :57.22   Mean   :-0.48436  
##                     3rd Qu.:63.25   3rd Qu.:-0.07836  
##                     Max.   :95.00   Max.   : 0.97451
```

