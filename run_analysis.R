#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names. 
#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Downloading the raw data set
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="data.zip") #download of the original data
data<- unzip("data.zip")

# Reading labes and features lookup tables
act <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names= c("ID_ACT", "Activity"))
features<- read.table("./UCI HAR Dataset/features.txt")


#_____________________________________________________________________________________________
# Reading the test data set and applying the features as coluns names.
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names= features[,2])
require(dplyr)
x_test_mean <- select(x_test, contains("mean")) 
x_test_std <- select(x_test, contains("std"))
x_test<- cbind(x_test_mean, x_test_std)

# Reading identification for the study subjects and activitys.
test_subject_id <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c("ID_SUB")) 
test_activity_id <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c("ID_ACT")) 
# Combinig information to make the test group data frame. 
DF_test <- cbind(test_subject_id , test_activity_id , x_test)

# Setting labes for the activities
library(plyr)
DF_test <- join(DF_test, act, by = "ID_ACT")

#__________________________________________________________________________________________________
# Reading the train data set
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names= features[,2])
require(dplyr)
x_train_mean <- select(x_train, contains("mean")) 
x_train_std <- select(x_train, contains("std"))
x_train<- cbind(x_train_mean, x_train_std)

# Reading identification for the study subjects and activitys.
train_subject_id <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c("ID_SUB")) 
train_activity_id <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c("ID_ACT")) 
# Combinig information to make the test group data frame. 
DF_train <- cbind(train_subject_id , train_activity_id , x_train)


# Setting labes for the activities
library(plyr)
DF_train <- join(DF_train, act, by = "ID_ACT")
#______________________________________________________________________________________________________
#Merging training and the test sets
DF<- rbind(DF_test, DF_train)
#Writing the output file
write.table(DF, file = "tidy_data", row.name=FALSE)
