library(data.table)
library(dplyr)
library(reshape2)

## -----------------------------------------
## Requirement #1 - Merges the training and 
##                  the test sets to create 
##                  one data set.
## -----------------------------------------
## Note: To complete requirement#1, I'm taking the "scenic route."
##       It takes 5 steps. Along the way, requirements 4, 2 & 3
##       gets done.
##
##       There's ways to make the flow less circuitous but I'm afraid
##       it will make the data reshaping more cumbersome/complex.
##       I've tried making each step as simple as possible to
##       make sure errors are easier to find and less likely to cause
##       unintended side-effects to the integrity of the data
##
##       So here goes..
##
## Step 1:
## ------
## load all data sets

## Load train data
x.train <- read.table('./train/X_train.txt',header=FALSE, strip.white=TRUE)
y.train <- read.table('./train/y_train.txt')
subject.train <- read.table('./train/subject_train.txt')

## Load test data
x.test <- read.table('./test/X_test.txt',header=FALSE, strip.white=TRUE)
y.test <- read.table('./test/y_test.txt',header=FALSE, strip.white=TRUE)
subject.test <- read.table('./test/subject_test.txt',header=FALSE, strip.white=TRUE)

## load reference data
## ..assuming this data applies to both train and test sets
##
features <- read.table('./features.txt',header=FALSE, strip.white=TRUE)
activity.labels <- read.table('./activity_labels.txt',header=FALSE, strip.white=TRUE)

## Step 2:
## ------
## Merge via ***Row-bind*** each all like data sets
##
##   I'm maintaining the sequence 
##   across the merge  with 1st-train, 2nd-test
##   for all data sets
##
## merge x.****
x.both <- rbind(x.train,x.test)

## merge y.****
y.both <- rbind(y.train,y.test)

## merge subjects
subject.both <- rbind(subject.train,subject.test)

## Step 3: - Name all columns with descriptive labels
## ------
## Note: this step applies to Requirement 4:
##
## ----------------------------------------------------------
## Requirement #4: Appropriately labels the data set with 
##                 descriptive variable names. 
## ----------------------------------------------------------
##
##
## make column label descriptive
names(subject.both)    <- c("subject")
names(y.both)          <- c("activity.id")
names(activity.labels) <- c("activity.id","activity")

## convert numeric id's to factor -- handy for tidying later
subject.both$subject        <- factor(subject.both$subject)
y.both$activity.id          <- factor(y.both$activity.id)
activity.labels$activity.id <- factor(activity.labels$activity.id)

## assign descriptive variable names to the x data set
names(x.both) <- as.vector(features[,2])

##
## Step 4: Extract only mean & stdev measures
## ------
##
## ----------------------------------------------------------
## Requirement #2: Extract only the measurements on the mean 
##                 and standard deviation for each measurement. 
## ----------------------------------------------------------
x.selectfields <- x.both[,c(grep("mean|std",names(x.both)))]

## Step 5: Column-bind all data sets
## ------
## subject, y-activity, x-mean & std
data.merged <- cbind(subject.both,y.both,x.selectfields)

## ----------------------------------------------------------
## Requirement #3: Uses descriptive activity names to name the 
##                 activities in the data set
## ----------------------------------------------------------
## attach activity labels "walking", "sitting", etc..
data.final <- merge(data.merged,activity.labels, by.x="activity.id", by.y="activity.id")


##---------------------------------------------------------------
## Requirement #5 - create a secondary, independent tidy data set
##                  with the average of each variable for each
##                  activity and each subject
##---------------------------------------------------------------

## Step 1:
## ------
## convert to data table for dplyr
data.dplyr <- tbl_df(data.final)

## Step 2:
## ------
## remove now redundant activity.id column
data.dplyr <- select(data.dplyr, -activity.id)

## Step 3:
## ------
## Reduce the 79 mean & stdev columns into variable and value columns 
## variable holds the column label 
## and value holds the measure for each variable, subject & activity
data.melt <- melt(data.dplyr,id=c("subject","activity"))

## Step 4:
## data.secondary as secondary, independent data set
##      the merged data grouped accdg to subject & activity & variable
##      summarised by taking the mean of each variable (mean's and std's)
data.secondary <- data.melt %>% 
                  group_by(subject,activity,variable) %>% 
                  summarise(variable_mean=mean(value))

## output the data to a file
write.table(data.secondary,"Train_Test_Measures.txt",sep=",", row.names=FALSE)

## done