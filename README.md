# Getting-and-Cleaning-Data-Course-project

# Part 1
## Merges the training and the test sets to create one data set
## This part was done in 3 steps :
STEP 1 : Prepare train data
* read in subject_train, X_train, y_train data using fread function
* change variable names in subject_train, X_train, y_train data using setnames function
* prepare train data using cbind function
* remove intermediate files using rm function

STEP 2 : Prepare test data
* read in subject_test, X_test, y_test data using fread function
* change variable names in subject_test, X_test, y_test data using setnames function
* prepare test data usinf cbind function
* remove intermediate files using rm function

STEP 3 : Combine train & test data
* combine train and test data usinf rbind function
* remove intermediate files using rm function


# *******************
# part 2
# Extracts only the measurements on the mean and standard deviation for each measurement
# *******************

# STEP 1 : Identify required measurements column names
# read in features_info data
features_info<-read.delim("./features.txt", header=FALSE, sep=" ")

# change variable names in features_info data
setnames(features_info,c("V1","V2"),c("measurement_id","measure_desc"))

# extract measurement on mean and standard deviation
shortlist_features<-features_info[grepl("-mean()",features_info$measure_desc,fixed = TRUE) | grepl("-std()",features_info$measure_desc,fixed = TRUE),]
shortlist_features<-shortlist_features[order(shortlist_features$measurement_id),]

# remove intermediate files
rm(features_info)


# STEP 2 : Extract relevant measurement from combined_data
shortlist_data<-apply(combined_data,1,function(x,n) as.numeric(substring(x["data_set"],((n-1)*16)+1,n*16)),t(shortlist_features$measurement_id))
shortlist_data<-t(shortlist_data)

# add back removed columns (subject, Activity)
shortlist_data<-cbind.data.frame(combined_data$subject,combined_data$Activity,shortlist_data)

# remove intermediate files
rm(combined_data)



# *******************
# part 3
# Uses descriptive activity names to name the activities in the data set
# *******************

# STEP 1 : Identify correct activity description
# read in activity_labels data
activity_labels<-read.delim("./activity_labels.txt", header=FALSE, sep=" ")

# change variable names in activity_labels data
setnames(activity_labels,c("V1","V2"),c("Activity","Activity_name"))

# change variable names in shortlist_data data
setnames(shortlist_data,"combined_data$Activity","Activity")


# STEP 2 : Merge Activity_name into shortlist_data
shortlist_data<-merge(activity_labels,shortlist_data,by="Activity",all=TRUE)

# drop Activity
shortlist_data$Activity<-NULL

# remove intermediate files
rm(activity_labels)



# *******************
# part 4
# Appropriately labels the data set with descriptive variable names
# *******************

# STEP 1 : Create lables for measurements
shortlist_features$measure_label<-apply(shortlist_features,1,function(x) ifelse(grepl("-mean()",x["measure_desc"],fixed = TRUE),paste("Mean of",gsub("-mean()","",x["measure_desc"],fixed = TRUE)),paste("Std dev of",gsub("-std()","",x["measure_desc"],fixed = TRUE))))


# STEP 2 : change names of measurements
setnames(shortlist_data,as.character(seq(1:dim(shortlist_features)[1])),shortlist_features$measure_label)
setnames(shortlist_data,"combined_data$subject","subject_id")

# remove intermediate files
rm(shortlist_features)



# *******************
# part 5
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
# *******************

# STEP 1 : Create summary by activity and subject
library(plyr)
summary<-ddply(shortlist_data,c("Activity_name","subject_id"),numcolwise(mean))


# STEP 2 : Save as txt file
write.table(summary,"final.txt",row.names=FALSE)



# *******************
# END
# *******************

