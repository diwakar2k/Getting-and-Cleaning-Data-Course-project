# Getting-and-Cleaning-Data-Course-project

# Part 1
## Merges the training and the test sets to create one data set
## This part was done in 3 steps :
STEP 1 : Prepare train data
* read in subject_train, X_train, y_train data using fread function (every row of X_train was read in as a single text string)
* change variable names in subject_train, X_train, y_train data using setnames function
* prepare train data using cbind function
* remove intermediate files using rm function

STEP 2 : Prepare test data
* read in subject_test, X_test, y_test data using fread function (every row of X_test was read in as a single text string)
* change variable names in subject_test, X_test, y_test data using setnames function
* prepare test data usinf cbind function
* remove intermediate files using rm function

STEP 3 : Combine train & test data
* combine train and test data usinf rbind function
* remove intermediate files using rm function


# Part 2
## Extracts only the measurements on the mean and standard deviation for each measurement
## This part was done in 2 steps
STEP 1 : Identify required measurements column names
* read in features_info data using read.delim function
* change variable names in features_info data using setnames function
* extract measurement on mean and standard deviation using grepl function (look for exact presence of "-mean()" or "-std()"
* remove intermediate files using rm function

STEP 2 : Extract relevant measurement from combined_data
* extract relevant columns from the combined data using apply & substring function (the exact location for substring is provided by the field measurement_id for the identified measurements)
* add columns for subject & Activity to shortlist_data using cbind function
* remove intermediate files using rm function


# Part 3
## Uses descriptive activity names to name the activities in the data set
## This part was done using 2 steps
STEP 1 : Identify correct activity description
* read in activity_labels data using read.delim function
* change variable names in activity_labels data using setnames function
* change variable names in measurement using setnames function

STEP 2 : Merge Activity_name into shortlist_data
* merge datasets using merge function
* drop Activity_id column
* remove intermediate files using rm function


# Part 4
## Appropriately labels the data set with descriptive variable names
## This part was done using 2 steps
STEP 1 : Create lables for measurements
* create variable names from the provided measure description using functions apply, ifelse, grepl and paste
STEP 2 : change names of measurements
* rename variables in merged data using setname function
* remove intermediate files using function rm



# Part 5
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
## This part was done using 2 steps
STEP 1 : Create data summary
* summarize data by activity and subject using function ddply (library plyr)
STEP 2 : Save as txt file
* save data as txt file using function write.table
