#0. Prepare the environment by downloading and unzipping necessary files.
#Clear environment variables.
rm(list=ls())
#Download the file if necessary.
if(!file.exists("dataset.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","dataset.zip")
}
#Unzip the downloaded file if necessary.
if(!file.exists("UCI HAR Dataset")){
  unzip("dataset.zip")
}

#1. Merges the training and the test sets to create one data set.
#Read in the training information.
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
#Read in the test informaiton.
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
#Combine the similar datasets.
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
sub_data <- rbind(sub_train,sub_test)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("UCI HAR Dataset/features.txt")
column_locations <- grep(".*mean.*|.*std.*", features[,2])
subset_x_data <- x_data[,column_locations]
names(subset_x_data) <- features[column_locations, 2]

#3. Uses descriptive activity names to name the activities in the data set
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
#Map the activity in the Y data to the activity name from the activities table.
y_data[,1] <- activities[y_data[,1],2]
#Rename the column name.
names(y_data) <- c("activity")

#4. Appropriately labels the data set with descriptive variable names.
names(sub_data) <- c("subject")
#Create one dataset from the three by binding columns togther.
final_data <- cbind(sub_data,y_data,subset_x_data)

#5.          From the data set in step 4, creates a second, independent tidy data set
#with the average of each variable for each activity and each subject.
agg_data <- aggregate(final_data, by=list(subject = final_data$subject,activity = final_data$activity), FUN=mean, na.rm=TRUE)
#Remove the redundant columns for clarity.
agg_data <- subset(agg_data, select = -c(3,4))
#Order the dataset by the subject then activity.
agg_data <- agg_data[order(agg_data$subject,agg_data$activity),]
#Write to a file.
write.table(agg_data, "tidy.txt", row.names = FALSE, quote = FALSE)