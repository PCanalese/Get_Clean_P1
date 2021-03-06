# This Script has been created for Project 1 of the Getting and Cleaning Data
# It does the following:
#
#
# 1. Merges the training and the test sets to create one data set
#       It requires the UCI data to be extracted into working directory
#       using the original folder & file structure.
#       code check this and returns error if files are not present in
#       the assumed locataion e.g.
#       Training set stored in  "UCI HAR Dataset/train/x_train.txt"
#       Test set stored in "UCI HAR Dataset/test/X_test.txt"
# 2. Extracts only the measurements on the mean and standard deviation
#       for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set
#       with the average of each variable for each activity and each subject.

# v0.1 - initial 12/05/2015
# v0.2 - 13/05/2015
#        made subject and activity ID joining cleaner, more verbose labels
# v1.0 - 18/05/2015
#       memory clean up -delete tables no longer needed
#       check data files are present

library(data.table)
# Check to see if the data files are stored in the directory

data_files_set <- c("UCI HAR Dataset","UCI HAR Dataset/train",
                    "UCI HAR Dataset/test",
                    "UCI HAR Dataset/activity_labels.txt",
                    "UCI HAR Dataset/features.txt",
                    "UCI HAR Dataset/train/X_train.txt",
                    "UCI HAR Dataset/train/subject_train.txt",
                    "UCI HAR Dataset/train/y_train.txt",
                    "UCI HAR Dataset/test/X_test.txt",
                    "UCI HAR Dataset/test/subject_test.txt",
                    "UCI HAR Dataset/test/y_test.txt")

#initialise variables

data_err <- FALSE
data_missing <- NULL

# check all the required directories and files are as expected
for (i in seq_along(data_files_set)){
        if (!file.exists(data_files_set[i])){
                data_err <- TRUE
                data_missing <- cbind(data_missing,i)
        }
        
}

# if one is missing give and error and identify which is missing
if (data_err) {
        print("The following required data file(s) are missing:")
        for (i in seq_along(data_missing)){
                print(data_files_set[data_missing[i]])
        }
        
        # stop and prompt user to download the set
        # auto download was considered but user maynot be online or have specific
        # system requirements that mean auto download may not work
        stop(c("Please download the required dataset:","\n",
             "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
             "\n","and extract into your working directory using the original folder structure."))
}

# ---------------------------------------------------
# Steps for Requirement 1
# ---------------------------------------------------

#Read in the training set
Train <- read.table("UCI HAR Dataset/train/X_train.txt")

# read in subject and activity data
Train_Subject <- read.table("UCI HAR Dataset/train/subject_train.txt",
                             col.names="Subject")
Train_Activity <- read.table("UCI HAR Dataset/train/y_train.txt",
                              col.names="Activity")

Train <- cbind(Train_Activity,Train_Subject,Train) # join all the info

# Read in the test set
Test <- read.table("UCI HAR Dataset/test/X_test.txt")  

# read in subject and activity data
Test_Subject <- read.table("UCI HAR Dataset/test/subject_test.txt",
                            col.names="Subject")
Test_Activity <- read.table("UCI HAR Dataset/test/y_test.txt",
                            col.names="Activity")

Test <- cbind(Test_Activity,Test_Subject,Test)

Raw_Data <- rbind (Train,Test)                  # Join them to one

# clean up memory
rm(Test)
rm(Test_Activity)
rm(Test_Subject)
rm(Train)
rm(Train_Activity)
rm(Train_Subject)

# ---------------------------------------------------
# Steps for Requirement 2
# For ease of latter manipulation to Raw_Data add header labels to
# these items form part of Requirement 4
# ---------------------------------------------------

Features <- read.table("UCI HAR Dataset/features.txt")[,2] # Read in features
Features <-  c("Activity","Subject",as.vector(Features)) # add initial cols 
colnames(Raw_Data) <- Features    # Attach as col names to Raw_Data
                                                

# Extract the columns required i.e. ones that have mean and std in their 
# name, also need to keep the activity and subject id
keep_terms <- c('-mean()','-std()','Activity','Subject')
pattern <- gsub(',\\s','|',toString(keep_terms))     # create string for grep
colsToKeep <- grep(pattern,colnames(Raw_Data))  # set of columns to keep

Tidy_Data_1 <- Raw_Data[,colsToKeep]  #Tidy Data set with mean and std columns


# ---------------------------------------------------
# Steps for Requirement 3
# ---------------------------------------------------

# Get the activity names
Activity_Names <- read.table("UCI HAR Dataset/activity_labels.txt", 
                             col.names = c("id","Name") ,header = FALSE)

actID <- as.vector(as.character(Activity_Names$id)) #vector of activity ID
actName <- as.vector(Activity_Names$Name)       #vector of activity Name     

# use a factor to assign Activity name base on activity ID
Tidy_Data_1$Activity_Name <- factor(Tidy_Data_1$Activity,
                                    levels=actID, labels=actName)

# Can remove the activity number as we have named the activities
Tidy_Data_1$Activity <- NULL     


# ---------------------------------------------------
# Step 4
# ---------------------------------------------------


# make some of the Col names more verbose and clear - maybe to the extreme....
colnames_Tidy <- colnames(Tidy_Data_1)
colnames_Tidy <- gsub ('tBody','Time Based Body ',colnames_Tidy)
colnames_Tidy <- gsub ('fBodyBody','Frequency Based Body ',colnames_Tidy)
colnames_Tidy <- gsub ('fBody','Frequency Based Body ',colnames_Tidy)
colnames_Tidy <- gsub ('tGravity','Time Based Gravity ',colnames_Tidy)
colnames_Tidy <- gsub ('Mag-',' Magnitude- ',colnames_Tidy)
colnames_Tidy <- gsub ('Acc-','Acceleration ',colnames_Tidy)
colnames_Tidy <- gsub ('-X','-X Axis',colnames_Tidy)
colnames_Tidy <- gsub ('-Y','-Y Axis',colnames_Tidy)
colnames_Tidy <- gsub ('-Z','-Y Axis',colnames_Tidy)
colnames_Tidy <- gsub ('-std','-standard deviation',colnames_Tidy)

colnames(Tidy_Data_1) <- colnames_Tidy

# ---------------------------------------------------
# Step 5 
# ---------------------------------------------------

Tmp_DT <- as.data.table(Tidy_Data_1) # convert Tidy Data set to temp data table

key_cols = c("Activity_Name","Subject")
setkeyv(Tmp_DT,key_cols)       # set key for data table for quick processing

#Calculate the means of the mean and standard Deviation 
Tidy_Data_2 <- Tmp_DT[,lapply(.SD,mean), by = list(Activity_Name,Subject)]
write.table(Tidy_Data_2,"Tidy_Set.txt", row.names = FALSE, sep="\t")

