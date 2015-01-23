# initial book keeping
rm(list=ls())
library(data.table)

# *******************
# part 1
# Merges the training and the test sets to create one data set
# *******************

# STEP 1 : Prepare train data
# read in subject_train, X_train, y_train data
subject_train<-fread(input = "./train/subject_train.txt",sep="\n", header = FALSE, verbose = FALSE)
X_train<-fread(input = "./train/X_train.txt",colClasses = "character",sep="\n", header = FALSE, verbose = FALSE)
y_train<-fread(input = "./train/y_train.txt",sep="\n", header = FALSE, verbose = FALSE)

# change variable names in subject_train, X_train, y_train data
setnames(subject_train,"V1","subject")
setnames(X_train,"V1","data_set")
setnames(y_train,"V1","Activity")

# cbind test data
training_data<-cbind.data.frame(subject_train,X_train,y_train)

# remove intermediate files
rm(subject_train,X_train,y_train)


# STEP 2 : Prepare test data
# read in subject_test, X_test, y_test data
subject_test<-fread(input = "./test/subject_test.txt",sep="\n", header = FALSE, verbose = FALSE)
X_test<-fread(input = "./test/X_test.txt",colClasses = "character",sep="\n", header = FALSE, verbose = FALSE)
y_test<-fread(input = "./test/y_test.txt",sep="\n", header = FALSE, verbose = FALSE)

# change variable names in subject_test, X_test, y_test data
setnames(subject_test,"V1","subject")
setnames(X_test,"V1","data_set")
setnames(y_test,"V1","Activity")

# cbind test data
test_data<-cbind.data.frame(subject_test,X_test,y_test)

# remove intermediate files
rm(subject_test,X_test,y_test)


# STEP 3 : Combine train & test data
combined_data<-rbind.data.frame(training_data,test_data)

# remove intermediate files
rm(training_data,test_data)



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
