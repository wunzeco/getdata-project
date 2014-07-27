Getting and Cleaning Data Course Project 
--------------------------
In this assignment a R script called **run_analysis.R** was created. The script produces tidy data of data collected from the accelerometers from the Samsung Galaxy S smartphone, which can be found here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Features
----
The script, run_analysis.R, does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

How the script works
-----
The main function of the script is called run_analysis(). It takes as argument the full or relative path of the raw data set directory or defaults to the raw data set directory under the current working directory (i.e. "./UCI HAR Dataset"). A list of the following is returned
- merged data: a data set which is a merge of train and test data sets.  
- mean and standard deviation measurements extract
- summarized data: independent tidy data set with the average of each variable for each activity and each subject.

The **merged** and **summarized** data sets are written to separate files called merged\_data.txt and summarized\_data.txt respectively.

```
r <- run_analysis(directory = "../UCI HAR Dataset/")
names(r)
names(r)
## [1] "merged_data"     "extract"        "summarized_data"
```