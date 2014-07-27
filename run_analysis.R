## You should create one R script called run_analysis.R that does the following. 
##   1. Merges the training and the test sets to create one data set.
##   2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##   3. Uses descriptive activity names to name the activities in the data set
##   4. Appropriately labels the data set with descriptive variable names. 
##   5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## This function returns a list of functions. Each function object returned takes
## a file as argument and returns a vector except for "dataset" function, which
## returns a data frame.
prep_dataset <- function() {
    subject <- function(subject_file) {
        s <- read.table(subject_file)
        s[[1]]
    }
    activity <- function(activity_label_file) {
        y <- read.table(activity_label_file)
        y[[1]]
    }
    features <- function(features_file) {
        f <- read.table("features.txt")  
        features <- as.character(f[[2]])
    }
    dataset <- function(dataset_file) {
        data <- read.table(dataset_file)
        data
    }
    
    list(subject = subject,
         activity = activity,
         features = features,
         dataset = dataset)
}

## This function takes as argument the directory of the raw data
##   -  binds subject ids vector from subject files (subject_{train|test}.txt)
##      and activity labels from activity files (y__{train|test}.txt) to each 
##      corresponding data set.
##   -  merges resulting data set of train and test activities
##   -  uses the features vector (from features.txt) to labels the data set with 
##      descriptive variable names
##   -  returns the resulting data frame, which is a merge of both data sets. 
## Arguments:
##  -  directory: full/relative path of raw data set directory
merge_data <- function(directory) {
    prev_wd <- getwd()
    setwd(directory)
    message("Currently in data set directory: ", getwd())
    
    p <- prep_dataset()
    
    # This function returns a data frame of (subject_id, activity, c(561-feature vector))
    complete_dataset <- function(dataset_file, activity_label_file, subject_file) {
        cbind(p$subject(subject_file),
              p$activity(activity_label_file),
              p$dataset(dataset_file))
    }
    
    features <- p$features("features.txt")
    
    train_dataset <- complete_dataset("train/X_train.txt",
                                      "train/y_train.txt",
                                      "train/subject_train.txt")
    test_dataset <- complete_dataset("test/X_test.txt",
                                     "test/y_test.txt",
                                     "test/subject_test.txt")
    
    setwd(prev_wd)
    data <- merge(train_dataset, test_dataset, all=TRUE)
    names(data) <- c("subject", "activity", features)
    data
}

## This function extracts only the measurements on the mean and standard deviation 
## for each measurement. 
## Arguments:
##  -  df: merged data set
extract_mean_std <- function(df) {
    mean_columns <- grep("mean()", names(df))
    std_columns <- grep("std()", names(df))
    df[c(mean_columns, std_columns)]
}

## This function uses descriptive activity names from "activity_labels.txt" to 
## name the activities in the data set. 
## Arguments:
##  -  df: data frame of merged data
##  -  directory: full/relative path of raw data set directory
label_activities <- function(df, directory) {
    activity_name_file = paste(directory, "/", "activity_labels.txt", sep="")
    if(!file.exists(activity_name_file)) error("Labels file does not exist")
    a <- read.table(activity_name_file)
    activities <- a[[2]]
    x <- df$activity
    y <- factor(x)
    levels(y) <- activities
    df$activity <- y
    df
}

## This function computes the average of each variable for each activity and each 
## subject, and returns the resulting data frame. 
## Argument
##  -  df: merged data set
summarize_data <- function(df) {
    library(plyr)
    ddply(df, .(subject, activity), function(x) colMeans(x[-c(1,2)]))
}

## Main function
## This function takes as argument the raw data directory and performs analysis
## on the data sets as per assignment requirements/instructions.
run_analysis <- function(directory = "./UCI HAR Dataset") {
    ##   1. Merges the training and the test sets to create one data set.
    ##   3. Uses descriptive activity names to name the activities in the data set
    d <- merge_data(directory)
    
    ##   2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    e <- extract_mean_std(d)
    
    ##   4. Appropriately labels the data set with descriptive variable names. 
    d <- label_activities(d, directory)
    write.table(d, file = "./merged_data.txt")
    
    ##   5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
    s <- summarize_data(d)
    write.table(d, file = "./summarized_data.txt")
    
    list( merged_data = d,
          mean_std_extract = e, 
          summarized_data = s )
}
    