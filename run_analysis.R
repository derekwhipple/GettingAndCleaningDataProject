# assume data (.zip file) already downloaded and "UCI HAR Dataset" folder
# extracted into current working directory

# This script has the goal of:
# - combining 2 separate data sets (training and test)
# - setting the column names based on another data set containing the variables
# - selecting only the columns with "std()" and "mean()" in the column names
# - changing the values representing activity to the string desription
# - summarizing column averages for each combination of activity and subject


################################################################
# Merges the training and the test sets to create one data set #
################################################################

# get variable names
featuresFrame <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
featureVector <- featuresFrame[,2]

# get the 3 TRAINING data sets
subjectTrainFrame <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
yTrainFrame <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
xTrainFrame <- read.table("./UCI HAR Dataset/train/x_train.txt", header = FALSE)

# re-set the column names in the x-frame - labeling data set with descriptive names
colnames(xTrainFrame) <- featureVector

# the 3 training data sets have the same number of rows, so combining these three data sets makes sense

# get vectors that comprise the subject and y data sets (these 2 data sets only have 1 column)
tmpYVector <- yTrainFrame[,1]
tmpSubjectVector <- subjectTrainFrame[,1]

# add the vectors to the x training data frame
xTrainFrame["Activity"] <- tmpYVector
xTrainFrame["Subject"] <- tmpSubjectVector

# get the 3 TEST data sets
subjectTestFrame <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
yTestFrame <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
xTestFrame <- read.table("./UCI HAR Dataset/test/x_test.txt", header = FALSE)

# re-set the column names in the x-frame - labeling data set with descriptive names
colnames(xTestFrame) <- featureVector

# the 3 test data sets have the same number of rows, so combining these three data sets makes sense

# get vectors that comprise the subject and y data sets (these 2 data sets only have 1 column)
tmpYVector <- yTestFrame[,1]
tmpSubjectVector <- subjectTestFrame[,1]

# add the vectors to the x test data frame
xTestFrame["Activity"] <- tmpYVector
xTestFrame["Subject"] <- tmpSubjectVector

# now combine the test and training frames
combinedFrame <- rbind(xTestFrame, xTrainFrame)

##########################################################################################
# Extracts only the measurements on the mean and standard deviation for each measurement #
# (while also keeping the activity and subjects columns)                                 #
##########################################################################################

# get the column names for the combined data set
columnNames <- names(combinedFrame)
matchingColNames <- grep("mean\\(\\)|std\\(\\)|Activity|Subject", columnNames, perl = TRUE, value = TRUE)

# subset combined frame based on mean/std columns
meanStdCombinedFrame <- combinedFrame[,matchingColNames]

###########################################################################
# Uses descriptive activity names to name the activities in the data set. #
###########################################################################

# change activity numbers to string values for actual activities

# I'm sure there's a more elegant way to do this...
meanStdCombinedFrame$Activity[meanStdCombinedFrame$Activity == 1] <- "WALKING"
meanStdCombinedFrame$Activity[meanStdCombinedFrame$Activity == 2] <- "WALKING_UPSTAIRS"
meanStdCombinedFrame$Activity[meanStdCombinedFrame$Activity == 3] <- "WALKING_DOWNSTAIRS"
meanStdCombinedFrame$Activity[meanStdCombinedFrame$Activity == 4] <- "SITTING"
meanStdCombinedFrame$Activity[meanStdCombinedFrame$Activity == 5] <- "STANDING"
meanStdCombinedFrame$Activity[meanStdCombinedFrame$Activity == 6] <- "LAYING"

######################################################################
# Appropriately labels the data set with descriptive variable names. #
######################################################################

# see above where I reset the column names within the (search colnames() above)

###########################################################################
# From the data set in step 4, create a second, independent tidy data set #
# with the average of each variable for each activity and each subject.   #
###########################################################################

# group by Activity and Subject, then summarize the means of all other columns
finalFrame <- meanStdCombinedFrame %>% group_by(Activity, Subject) %>% summarize_all(mean)

# create a file from the data set
write.table(finalFrame, file = "tidyData.txt", row.names = FALSE)
