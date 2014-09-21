Train\_Test\_Measures.txt" & run_analysis.R
===================================================

**Last Revision: 21 September 2014
**by Allan Cuenca (allan.cuenca@yahoo.com)


This is a course work towards the completion of requirements under 
the Getting and Cleaning Data course at Coursera.org,
provided by the Johns Hopkins instructions 

GOAL:
-----
The goal of the run_analysis.R script is to produce a secondary tidy data set with descriptively labeled columns, containing only the mean and standard deviation measures from both the training and test sets combined.


How the script works
--------------------
The script sequence is as follows:
    1. Load all data (train, test and reference - features, activity)
    2. Combine by row bind train and test data
    3. Apply descriptive column labels
    4. Using the labels on #3, extract only mean and standard deviation measures
    5. Combine by columns the Subject, activity and train+test data
    6. Create a Descriptive name to Activity and remove the numeric Activity field 
    7. Transpose all measure fields into one field and another for their values
    8. Calculate the mean of the values for each Subject, Activity and Measure (variable)
    

Note on Tidy Data:
------------------

The Train_Test_Measures.txt data is organized into 4 columns with a column each for variables and numeric values. The variables can be further refined to suit a data analysts requirements. 

For example, x, y and z axes measures can be transposed into columns. Mean and standard deviation measures can be transposed in their own fields as well. All taking into account that it is easier to "describe functional relationships between variable"-- columns and "it is easier to make comparison between groups of observations"--rows (Hadley Wickham, Tidy Data, Journal of Statistical Software http://vita.had.co.nz/papers/tidy-data.pdf).

The current structure allows other analysts to transform the data as per their needs. For the generic purpose of this course, the current structure is tidy.

REQUIREMENTS:
------------

R version 3.1.0 (2014-04-10) or later

Libraries:
    data.table
    dplyr
    reshape2
    
The script must be in same folder as the source data folders. The script expects the following folders to be available containing the following source data files:

    Test data:
    .\test\subject_test.txt
    .\test\X_test.txt
    .\test\y_test.txt

    Training data:
    .\train\subject_train.txt
    .\train\X_train.txt
    .\train\y_train.txt
    
    Lookup or Reference data:
    .\activity_labels.txt
    .\features.txt
    

---
Acknowledgements:
---------------------------------------------
Source data for this project is from:
    Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
    Smartlab - Non Linear Complex Systems Laboratory
    DITEN - Università degli Studi di Genova.
    Via Opera Pia 11A, I-16145, Genoa, Italy.
    activityrecognition@smartlab.ws
    www.smartlab.ws

from their data set collection titled:

    [Human Activity Recognition Using Smartphones Dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
    Version 1.0

.. which is available at 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
---

Thank you to Jeff Leek,PhD instructor of the Getting and Cleaning Data, all the community TA's and fellow students for the lessons, tips and insights that made this project possible.
