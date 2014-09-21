#Code Book for run\_analysis.R

###Assumptions:
1. run\_analsys.R is in the same folder as the Samsung UCI HAR Dataset
2. The Source files are available:
    * ./train/X_train.txt
    * ./train/y_train.txt
    * ./train/subject_train.txt
    * ./test/X_test.txt
    * ./test/y_test.txt
    * ./test/subject_test.txt
    * ./features.txt
    * ./activity_labels.txt
3. R version is at least 3.1.0
4. Packages for the following libraries are installed:
    * data.table
    * dplyr
    * reshape2

### Resulting Columns are:
| columns | description | example data |
| --------|-------------|--------------|
| subject | experiment participant's ID. Range 1-30 | 1, 2, 3 .. 30|
| activity | description of the activity that the participant engaged in.| LAYING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING |
| variable | names of the measures applied to the subject's activity. includes only the mean and standard deviation measures from the original data set. | tBodyAccMag-mean(), tBodyAcc-mean()-X|
| variable_mean | mean of the measures value as per grouping of subject, activity and variable |  0.221598244, -0.040513953 |

  
###Code Sequence

Step 1:

Load train, test and reference data. Variable name coding is based on <column type>.<data set>.

So x.train - is the x columns with 561 features, coming from the training data set. x.test will come from the test data set.



Step 2: Merge via ***Row-bind*** each all like data sets
    maintaining the sequence 
    across the merge  with 1st-train, 2nd-test
    for all data sets


   merge x, y and subjects by rbind
   
   x.both <- rbind(x.train,x.test)
   y.both <- rbind(y.train,y.test)
   subject.both <- rbind(subject.train,subject.test)

Step 3: - Name all columns with descriptive labels
_*Requirement #4 - Uses descriptive activity names to name the activities in the data set*_

make column label descriptive
   names(subject.both)    <- c("subject")
   names(y.both)          <- c("activity.id")
   >names(activity.labels) <- c("activity.id","activity")

convert numeric ids to factor -- handy for tidying later
   >subject.both$subject        <- factor(subject.both$subject)
   >y.both$activity.id          <- factor(y.both$activity.id)
   >activity.labels$activity.id <- factor(activity.labels$activity.id)

assign descriptive variable names to the x data set
   >
   >names(x.both) <- as.vector(features[,2])
   >
   
Step 4: Extract only mean & stdev measures
_*Requirement #2 - Extract only the measurements on the mean and standard deviation for each measurement.*_
   >
   >x.selectfields <- x.both[,c(grep("mean|std",names(x.both)))]
   >
   
Step 5: Column-bind all data sets
   >
   >data.merged <- cbind(subject.both,y.both,x.selectfields)
   >
   
_*Requirement #3: Uses descriptive activity names to name the activities in the data set*_
attach activity labels "walking", "sitting", etc..
   >
   >data.final <- merge(data.merged,activity.labels, by.x="activity.id", by.y="activity.id")
   >


_*Requirement #5 - create a secondary, independent tidy data set with the average of each variable for each activity and each subject*_
Note: Requirement 5 also has multiple steps

Step 1: convert to data table for dplyr
   >
   >data.dplyr <- tbl_df(data.final)
   >

Step 2: remove now redundant activity.id column
   >
   >data.dplyr <- select(data.dplyr, -activity.id)
   >

Step 3: Reduce the 79 mean & stdev columns into variable and value columns 
variable holds the column label 
and value holds the measure for each variable, subject & activity
   >
   >data.melt <- melt(data.dplyr,id=c("subject","activity"))
   >

Step 4: create the secondary, independent data set by grouping according to subject, activity & variable, then summarize by calculating mean of each field.
   >
   >data.secondary <- data.melt %>% 
   >              group_by(subject,activity,variable) %>% 
   >              summarise(variable_mean=mean(value))

output the data to a file
   >
   >write.table(data.secondary,"Train_Test_Measures.txt",sep=",", row.names=FALSE)
   >

done.
