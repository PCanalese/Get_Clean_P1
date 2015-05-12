# This Script has been created for Project 1 of the Getting and Cleaning Data
# It does the following:
#
 
# 1. Merges the training and the test sets to create one data set
#       Training set stored in  "./UCI HAR Dataset/train/X_train.txt"
#       Test set stored in "./UCI HAR Dataset/test/X_test.txt"
# 2. Extracts only the measurements on the mean and standard deviation
#       for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set
#       with the average of each variable for each activity and each subject.

library(data.table)

## Steps for Requirement 1
Train <- read.table("./UCI HAR Dataset/train/X_train.txt",
                    header = FALSE)             # Read in the training set

Test <- read.table("./UCI HAR Dataset/test/X_test.txt",
                   header = FALSE)              # Read in the test set

Raw_Data <- rbind (Train,Test)                  # Join them to one

# Steps for Requirement 2
# For ease of latter manipulation to Raw_Data we want to add subject and 
# activity ids as well as header labels - these items form part 
# of Requirement 4

Features <- read.table("./UCI HAR Dataset/features.txt",row.names=1)
colnames(Raw_Data) <- as.vector(Features$V2)    # Read in features and 
                                                # Attach as col names

# add in subject and activity data
Train_Subject <- read.table("./UCI HAR Dataset/train/subject_train.txt",
                                      header = FALSE)
Train_Activity <- read.table("./UCI HAR Dataset/train/y_train.txt",
                             header = FALSE)

Test_Subject <- read.table("./UCI HAR Dataset/test/subject_test.txt",
                            header = FALSE)
Test_Activity <- read.table("./UCI HAR Dataset/test/y_test.txt",
                             header = FALSE)

# Add the above information to the Raw_Data


Raw_Data$Subject <- as.vector(c(Train_Subject$V1,Test_Subject$V1))
Raw_Data$Activity <- as.vector(c(Train_Activity$V1,Test_Activity$V1))

# Extract the columns required i.e. ones that have mean and std in their 
# name, also need to keep the activity and subject id
keep_terms <- c('mean()','std()','Activity','Subject')
pattern <- gsub(',\\s','|',toString(keep_terms))     # create string for grep
colsToKeep <- grep(pattern,colnames(Raw_Data))  # set of columns to keep

Tidy_Data_1 <- Raw_Data[,colsToKeep]  #Tidy Data set with mean and std columns


## Steps for Requirement 3
# Get the activity names
Activity_Names <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                             col.names = c("id","Name") ,header = FALSE)

actID <- as.vector(as.character(Activity_Names$id)) #vector of activity ID
actName <- as.vector(Activity_Names$Name)       #vector of activity Name     

# use a factor to assign Activity name base on activity ID
Tidy_Data_1$Activity_Name <- factor(Tidy_Data_1$Activity,
                                    levels=actID, labels=actName)

# Can remove the activity number as we have named the activities
Tidy_Data_1$Activity <- NULL     



## Step 4

## Already done as part of Step 2


## Step 5 

Tmp_DT <- as.data.table(Tidy_Data_1) # convert Tidy Data set to temp data table

key_cols = c("Activity_Name","Subject")
setkeyv(Tmp_DT,key_cols)       # set key for data table for quick processing

#Calculate the means of the mean and standard Deviation 
Tidy_Set_2 <- Tmp_DT[,lapply(.SD,mean), by = list(Activity_Name,Subject)]
write.table(Tidy_Set_2,"Tidy_Set", row.names = FALSE)

