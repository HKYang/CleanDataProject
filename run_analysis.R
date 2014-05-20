#################################################
# Load data from files that were downloaded from
#     https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#################################################

directory <- "getdata-projectfiles-UCI HAR Dataset\\UCI HAR Dataset\\"

# load X_train.txt
filePath <- paste0(directory, "Train\\X_train.txt")
featureValues_Train <- read.table(filePath)

# load y_train.txt
filePath <- paste0(directory, "Train\\y_train.txt")
activities_Train <- read.table(filePath)

# load subject_train.txt
filePath <- paste0(directory, "Train\\subject_train.txt")
subjects_Train <- read.table(filePath)

# aggregate subject, activity, and feature datasets into 
# a complete training dataset
data_Train <- cbind(subjects_Train, activities_Train, featureValues_Train)


# load X_test.txt
filePath <- paste0(directory, "Test\\X_test.txt")
featureValues_Test <- read.table(filePath)

# load y_test.txt
filePath <- paste0(directory, "Test\\y_test.txt")
activities_Test <- read.table(filePath)

# load subject_test.txt
filePath <- paste0(directory, "Test\\subject_test.txt")
subjects_Test <- read.table(filePath)

# aggregate subject, activity, and feature datasets into 
# a complete testing dataset
data_Test <- cbind(subjects_Test, activities_Test, featureValues_Test)


#################################################
# Merge the training and the test sets to create one data set.
#################################################

data_Full <- rbind(data_Train, data_Test)

#################################################
# Extracts only the measurements on the mean and standard deviation 
#     for each measurement.
#################################################

filePath <- paste0(directory, "features.txt")
featureNames <- read.table(filePath)
featureNames <- as.character(featureNames[,2])

colnames(data_Full)[1] = "subject"
colnames(data_Full)[2] = "activity"
colnames(data_Full)[3:(dim(data_Full)[2])] = featureNames


#mu_std <- grepl("(.*?)([Mm]ean|[Ss]td)\\(\\)", featureNames)
masks <- c(TRUE, TRUE, grepl("(.*?)([Mm]ean|[Ss]td)\\(\\)", featureNames))
data_Full <- data_Full[, masks]


#################################################
# Use descriptive activity names to name the activities in the data set 
#################################################

filePath <- paste0(directory, "activity_labels.txt")
activityLabels <- read.table(filePath)
activityLabels <- as.character(activityLabels[,2])

data_Full$activity <- as.factor(data_Full$activity)
levels(data_Full$activity) <- activityLabels

#################################################
# Appropriately label the data set with descriptive activity names 
#################################################

colnames(data_Full) <- sub("[Mm]ean\\(\\)","Mean", colnames(data_Full))
colnames(data_Full) <- sub("[Ss]td\\(\\)","Std", colnames(data_Full))
colnames(data_Full) <- gsub("-","", colnames(data_Full))

#################################################
# Creates a second, independent tidy data set with the average of 
#     each variable for each activity and each subject. 
#################################################

library(data.table)
data_Summary = data.table(data_Full)
data_Summary = data_Summary[, lapply(.SD,mean), by=c("subject", "activity")]
#data_Summary = format(data_Summary, scientific=TRUE)
write.table(data_Summary, file="UCIHARsummary.txt", row.names = FALSE)



