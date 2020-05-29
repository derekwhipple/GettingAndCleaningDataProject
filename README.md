# GettingAndCleaningDataProject

## Goals
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## How this works

### Assumptions
- .zip file containing Samsung activity data has (1) already been downloaded, and (2) has been extracted into the  "UCI HAR Dataset" folder in the working directory

### Steps
This script (at a high-level) performs these steps (these essentially mimic the goals from above):
1. combining 2 separate data sets (training and test)
2. setting the column names based on another data set containing the variables
3. selecting only the columns with "std()" and "mean()" in the column names
4. changing the values representing activity to the string desription
5. summarizing column averages for each combination of activity and subject

For more details, see comments in source code
