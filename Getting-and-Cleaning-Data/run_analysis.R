# Getting and Cleaning Data - Course Project

#Getting and Cleaning Data R script does the following:
#       1. Download the dataset if it does not already exist in the working directory
#       2. Load the activity and feature details
#       3. Loads training dataset (only Mean, Std columns), activities and subjects. Column bind these datasets
#       4. Loads test dataset (only Mean, Std columns), activities and subjects. Column bind these datasets
#       5. Merges the two datasets
#       6. Converts the `activity` and `subject` columns into factors
#       7. Creates a tidy dataset as mean of each variable by each subject and activity
#
#       Save end result in the file `tidy.txt`.


setwd("E:/NASIR/SME/CourseRA/3. Data Cleaning/ProjectWork")

library(reshape2)

filename <- "ucihar_dataset.zip"

#1. download and unzip data
        if (!file.exists(filename)) {
                fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                download.file(fileurl, destfile = filename, method = "libcurl")
        }
        if (!file.exists("UCI HAR Dataset")) {
                unzip(filename)
        }

#2. Load Activity and Features
        activityNames <- read.table("UCI HAR Dataset/activity_labels.txt")
        activityNames[,2] <- as.character(activityNames[,2])
        
        #Load Features
        AllFeatures <- read.table("UCI HAR Dataset/features.txt")
        AllFeatures[,2] <- as.character(AllFeatures[,2])
        
        RequiredFeatures <- AllFeatures[grep(".*mean.*|.*std.*", AllFeatures[,2]),]
        RequiredFeatures[,2] <- gsub("-mean", "Mean", RequiredFeatures[,2])
        RequiredFeatures[,2] <- gsub("-std", "Std", RequiredFeatures[,2])
        RequiredFeatures[,2] <- gsub("[()]","", RequiredFeatures[,2])

#3. Loads training dataset (only Mean, Std columns), activities and subjects. Column bind these datasets
        training_set <- read.table("UCI HAR Dataset/train/X_train.txt")[RequiredFeatures[,1]]
        training_set.activities <- read.table("UCI HAR Dataset/train/Y_train.txt")
        training_set.subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
        training_set <- cbind(training_set.subjects, training_set.activities, training_set)

#4. Loads test dataset (only Mean, Std columns), activities and subjects. Column bind these datasets
        test_set <- read.table("UCI HAR Dataset/test/X_test.txt")[RequiredFeatures[,1]]
        test_set.activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
        test_set.subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
        test_set <- cbind(test_set.subjects, test_set.activities, test_set)

#5. Merges the two datasets (row binding using rbind)
        allData <- rbind(training_set, test_set)
        colnames(allData) <- c("subject", "activity", RequiredFeatures[,2])

#6. Converts the `activity` and `subject` columns into factors
        allData$activity <- factor(allData$activity, levels = activityNames[,1], labels = activityNames[,2])
        allData$subject <- as.factor(allData$subject)
        
#7. Creates a tidy dataset as mean of each variable by each subject and activity
        allData.melted <- melt(allData, id=c("subject", "activity"))
        allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)        

        #Saved final results into file `tidy.txt`
        write.table(allData, "tidy.txt", row.names = FALSE, quote = FALSE)
        

