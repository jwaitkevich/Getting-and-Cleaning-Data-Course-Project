library(dplyr)
library(data.table)

setwd("C:\Users\jwaitkevich\Documents")

# read in data about trains
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")

Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")

Subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# read data from test folder
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")

Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")

Subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# read in data from features
variable_names <- read.table("./UCI HAR Dataset/features.txt")

# read in data from activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# 1. Merges the training and the test sets to create one data set.
X_total <- rbind(X_train, X_test)

Y_total <- rbind(Y_train, Y_test)

Subject_total <- rbind(Subject_train, Subject_test)

#remove old data tables for tidiness
rm(X_train, X_test, Y_train, Y_test, Subject_train, Subject_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]

X_total <- X_total[,selected_var[,1]]


# 3. Uses descriptive activity names to name the activities in the data set
colnames(Y_total) <- "activity"

Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))

activitylabel <- Y_total[,-1]

# 4. Appropriately labels the data set with descriptive variable names.
colnames(X_total) <- variable_names[selected_var[,1],2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(Subject_total) <- "subject"

total <- cbind(X_total, activitylabel, Subject_total)

total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(mean)

write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
