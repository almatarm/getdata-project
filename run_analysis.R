# *****************************************************************************
# Global variables                                                            *
# *****************************************************************************
data_dir <- "UCI HAR Dataset";

#General Files
features_file        = paste(data_dir, "features.txt",                sep="/");
activity_labels_file = paste(data_dir, "activity_labels.txt",         sep="/");
  
#Training Files
train_subject_file       = paste(data_dir, "train/subject_train.txt", sep="/");
train_X_file             = paste(data_dir, "train/X_train.txt",       sep="/");
train_Y_file             = paste(data_dir, "train/Y_train.txt",       sep="/");

#Test Files
test_subject_file       = paste(data_dir, "test/subject_test.txt",    sep="/");
test_X_file             = paste(data_dir, "test/X_test.txt",          sep="/");
test_Y_file             = paste(data_dir, "test/Y_test.txt",          sep="/");

# *****************************************************************************
# Preprocessing:                                                              *
# *****************************************************************************

# Check if the data directory exist
if(!file.exists(data_dir)) {
  #fatal error, no data directory
  stop(paste("Fatal Error: No data directory[", data_dir, "] found in the 
             current working directory"));
}

# 'features.txt': List of all features.
features = read.table(features_file)
names(features) <- c("id", "name")

# 'activity_labels.txt': Links the class labels with their activity name.
activity = read.table(activity_labels_file)
names(activity) <- c("id", "desc")


#Read training and test data sets
# 'train/subject_train.txt': Each row identifies the subject who performed the 
# activity for each window sample. Its range is from 1 to 30.
train_subject = read.table(train_subject_file)
names(train_subject) <- c("id")

# 'train/X_train.txt': Training set.
train_X = read.table(train_X_file)
names(train_X) <- features$name

# 'train/y_train.txt': Training labels.
train_Y = read.table(train_Y_file)
names(train_Y) <- c("training_type")

# create train table, which combines all training data in one place
train_data <- cbind(train_subject, train_Y, train_X)
rm(train_subject, train_X, train_Y)

# 'test/subject_test.txt': Each row identifies the subject who performed the 
# activity for each window sample. Its range is from 1 to 30.
test_subject = read.table(test_subject_file)
names(test_subject) <- c("id")

# 'test/X_test.txt': testing set.
test_X = read.table(test_X_file)
names(test_X) <- features$name

# 'test/y_test.txt': testing labels.
test_Y = read.table(test_Y_file)
names(test_Y) <- c("training_type")

# create test table, which combines all testing data in one place
test_data <- cbind(test_subject, test_Y, test_X)
rm(test_subject, test_X, test_Y)

# *****************************************************************************
# Merges the training and the test sets to create one data set.               *
# *****************************************************************************
data <- rbind(train_data, test_data)
rm(features, test_data, train_data)

# *****************************************************************************
# Extracts only the measurements on the mean and standard deviation for each  *
# measurement.                                                                *
# *****************************************************************************
col_filter = grepl("mean^F|std", names(data))
col_filter[1:2] = TRUE
data = data[, col_filter]

# *****************************************************************************
# Uses descriptive activity names to name the activities in the data set      *
# *****************************************************************************
data$training_type = cut(data$training_type, 6, labels = activity$desc)

# *****************************************************************************
# Appropriately labels the data set with descriptive activity names.          *
# *****************************************************************************
#See above

# *****************************************************************************
# Creates a second, independent tidy data set with the average of each        *
# variable for each activity and each subject.                                *
# *****************************************************************************
data = aggregate(data[-(1:2)], data[(1:2)], mean)
write.csv(data, file="data.txt")