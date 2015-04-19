## Read files
features      = read.table('UCI HAR Dataset/features.txt', header=FALSE); 
activity_labels  = read.table('UCI HAR Dataset/activity_labels.txt', header=FALSE);

# Read training data
subject_train  = read.table('UCI HAR Dataset/train/subject_train.txt', header=FALSE); 
x_train        = read.table('UCI HAR Dataset/train/X_train.txt', header=FALSE); 
y_train        = read.table('UCI HAR Dataset/train/y_train.txt', header=FALSE);

# Read testing data
subject_test    = read.table('UCI HAR Dataset/test/subject_test.txt', header=FALSE); 
x_test          = read.table('UCI HAR Dataset/test/X_test.txt', header=FALSE); 
y_test          = read.table('UCI HAR Dataset/test/y_test.txt', header=FALSE); 

# Modify headers
colnames(activity_labels)   = c('ActivityID','ActivityName');

colnames(subject_train)      = "SubjectID";
colnames(y_train)           = "ActivityID";
colnames(x_train)           = features[,2]; 

colnames(subject_test) = "SubjectID";
colnames(y_test)       = "ActivityID";
colnames(x_test)       = features[,2]; 

# Bind training and test data sets
ds_train  = cbind(subject_train, y_train, x_train);
ds_test   = cbind(subject_test, y_test, x_test);

## 1. Merges the training and the test sets to create one data set
ds_all      = rbind(ds_train, ds_test); 

## 2. Extract only the measurements on the mean and standard deviation for each measurement 
col_names   = colnames(ds_all);

# Create helping variable detecting mean or std rows
is_mean_or_std = grepl("mean|std", col_names, ignore.case=TRUE)
is_mean_or_std[1:2] = TRUE; # SubjectID, ActivityID, 

# Filter just rows with mean and std  
ds_all = ds_all[is_mean_or_std==TRUE];


## 3. Uses descriptive activity names to name the activities in the data set
ds_all = merge(x=ds_all, y=activity_labels, by='ActivityID', all.x=TRUE);

# Update columns vector
col_names <- colnames(ds_all);

## 4. Appropriately labels the data set with descriptive variable names
col_names <- gsub("\\(|\\)", "", col_names);
col_names <- gsub("\\-|\\,", "", col_names);

col_names <- gsub("BodyBody", "Body", col_names);
col_names <- gsub("Acc", "Accelerometer", col_names);
col_names <- gsub("Gyro", "Gyroscope", col_names);
col_names <- gsub("Mag", "Magnitude", col_names);

col_names <- gsub("^t", "Time", col_names);
col_names <- gsub("^f", "Frequency", col_names);
col_names <- gsub("tBody", "TimeBody", col_names)

col_names <- gsub("mean", "Mean", col_names, ignore.case = TRUE);
col_names <- gsub("std", "Std", col_names, ignore.case = TRUE);
col_names <- gsub("freq", "Frequency", col_names, ignore.case = TRUE);

col_names <- gsub("angle", "Angle", col_names);
col_names <- gsub("gravity", "Gravity", col_names);

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
ds_all_tidy <- aggregate(. ~SubjectID + ActivityID + ActivityName, ds_all, mean);

# Write tidy data set
write.csv(ds_all_tidy, "Tidy.txt", row.names=FALSE);
