> CODEBOOK

> Contents

1. Set Up and Libraries
2. Variables
3. Input Data
4. Input actions and Data Transformations
5. Tidy Data Output Set

> 1. Set Up and Libraries

The code has been developed using the following system and R libraries.  The code has been made as generic as possible, but has not been tested on any other platforms.


|Item|Version|
|:--:|:--:|
|OS|Windows 7|
|R Studio|0.98.1103|
|data.library|1.9.4|

> 2. Variables

The following variables have been defined and are used in the transformation of the data into a tidy set.

|Variable Name|Type| Description|
|:--|:--|:--|
|Train| Data Frame| Contains the data from the X_train.txt data set later combined with the subject and Activity data|
|Train_Subject| Data Frame | Contains the data from the subject_train.txt data set|
|Train_Activity | Data Frame | Contains the data from the y_train.txt data set|
|Test | Data Frame| Contains the data from the X_test.txt data set later combined with the subject and Activity data|
|Test_Subject | Data Frame | Contains the data from the subject_test.txt data set|
|Test_Activity |  Data Frame | Contains the data from the y_test.txt data set|
|Train_Subject| Data Frame | Contains the data from the subject_train.txt data set|
|data_files_set| Character Vector | Contains a list of the required data files names |data_err | logical | Takes value of TRUE if required data files are missing |
|data_missing| Integer Vector | List of index numbers of any mssing data file from data_files_set |
|Raw_Data | Data Frame | Contains the combined train and test data|
|Features | Data Frame | Contains the content of the features.txt|
|keep_terms | Character Vector | Contains the key chr sequence in coloumn labels to keep in the tidy set i.e -mean() and -std()|
|pattern | String | String used in grep function to identify the columns to keep in the tidy set|
|Activity_Names | Data Frame | Contains the data from the activity_labels.txt data set|
|actID | Character Vector | Contains activity ID number|
|actName |  Character Vector | Contains activity Name|
|colsToKeep | Integer vector | Vector of the columns numbers to keep in the tidy set|
|Tidy_Data_1 | Data Frame | Contains the tidy data set that includes mean and standard data columns|
|colnames_Tidy | Character Vector | List of the descriptive names to be used in the final Tidy Data Set|
|key_cols | Character Vector | List of the columns to be used as index in final Data Table for Tidy Set|
|Tmp_DT|Data Frame| Temporary data frame used in conversion to final Data Table|
|Tidy_Data_2|Data Table| Data Table for Final Tidy Data Set


> 3. Input Data

The imput data used is sourced from the following source.

This project uses data from the following source:

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

The following information has been extracted from the associated README.txt file that is included in the data set.

==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Universit? degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

#### For each record it is provided:


- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

#### The dataset includes the following files:


- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

#### Notes: 

- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

For more information about this dataset contact: activityrecognition@smartlab.ws

#### License:

Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

> 4. Input actions and Data Transformations

The following steps and actions have been carried out to transform the input data and turn it in to the required Tidy Data Set.

1. First a check is made to check the data files from the UCI set have been extracted into the correct folders.  If any file is missing the process stops and an error is generated and the missing data file(s) are highlighted for the user to resolve.  Auto download and extraction of the data was considered but not included as the aim was to make the code as generic as possible.
2. The input data is read in and the training and test data is joined back with the activity names and subject id.
3. The complete training and test data sets are then joined and saved in the "Raw_Data" data frame variable.
4. Various data frames that stored data set information from the original files are removed from memory as they are no longer needed.
5. Column lables are added to the "Raw_Data" data frame
6. The "Raw_Data"" data frame is then reduced and only data that related to mean and standard deviation values are retained and saved into the new data frame variable "Tidy_Data_1".  In this step the original data with labels of meanFreq have not been included in the final data set.
        + "Tidy_Data_1" data frame consists of 10299 observations of 563 variables and includes a descriptive name for all activities. The set includes all the original results for the retained columns.
7. The column names are updated with more descriptive lables and these are added to "Tidy_Data_1".
8. "Tidy_Data_1" is converted into a temporary data table "Tmp_DT".
9. The column data in "Tmp_DT" is then averaged based on subject ID and activity and result is saved into the final data table "Tidy_Data_2"
10. "Tidy_Data_2" consists of 180 observations on 81 variables.  The 81 variables are listed below:

 [1] "Activity_Name"                                           
 [2] "Subject"                                                 
 [3] "Time Based Body Acceleration mean()-X Axis"              
 [4] "Time Based Body Acceleration mean()-Y Axis"              
 [5] "Time Based Body Acceleration mean()-Y Axis"              
 [6] "Time Based Body Acceleration std()-X Axis"               
 [7] "Time Based Body Acceleration std()-Y Axis"               
 [8] "Time Based Body Acceleration std()-Y Axis"               
 [9] "Time Based Gravity Acceleration mean()-X Axis"           
[10] "Time Based Gravity Acceleration mean()-Y Axis"           
[11] "Time Based Gravity Acceleration mean()-Y Axis"           
[12] "Time Based Gravity Acceleration std()-X Axis"            
[13] "Time Based Gravity Acceleration std()-Y Axis"            
[14] "Time Based Gravity Acceleration std()-Y Axis"            
[15] "Time Based Body AccJerk-mean()-X Axis"                   
[16] "Time Based Body AccJerk-mean()-Y Axis"                   
[17] "Time Based Body AccJerk-mean()-Y Axis"                   
[18] "Time Based Body AccJerk-standard deviation()-X Axis"     
[19] "Time Based Body AccJerk-standard deviation()-Y Axis"     
[20] "Time Based Body AccJerk-standard deviation()-Y Axis"     
[21] "Time Based Body Gyro-mean()-X Axis"                      
[22] "Time Based Body Gyro-mean()-Y Axis"                      
[23] "Time Based Body Gyro-mean()-Y Axis"                      
[24] "Time Based Body Gyro-standard deviation()-X Axis"        
[25] "Time Based Body Gyro-standard deviation()-Y Axis"        
[26] "Time Based Body Gyro-standard deviation()-Y Axis"        
[27] "Time Based Body GyroJerk-mean()-X Axis"                  
[28] "Time Based Body GyroJerk-mean()-Y Axis"                  
[29] "Time Based Body GyroJerk-mean()-Y Axis"                  
[30] "Time Based Body GyroJerk-standard deviation()-X Axis"    
[31] "Time Based Body GyroJerk-standard deviation()-Y Axis"    
[32] "Time Based Body GyroJerk-standard deviation()-Y Axis"    
[33] "Time Based Body Acc Magnitude- mean()"                   
[34] "Time Based Body Acc Magnitude- std()"                    
[35] "Time Based Gravity Acc Magnitude- mean()"                
[36] "Time Based Gravity Acc Magnitude- std()"                 
[37] "Time Based Body AccJerk Magnitude- mean()"               
[38] "Time Based Body AccJerk Magnitude- std()"                
[39] "Time Based Body Gyro Magnitude- mean()"                  
[40] "Time Based Body Gyro Magnitude- std()"                   
[41] "Time Based Body GyroJerk Magnitude- mean()"              
[42] "Time Based Body GyroJerk Magnitude- std()"               
[43] "Frequency Based Body Acceleration mean()-X Axis"         
[44] "Frequency Based Body Acceleration mean()-Y Axis"         
[45] "Frequency Based Body Acceleration mean()-Y Axis"         
[46] "Frequency Based Body Acceleration std()-X Axis"          
[47] "Frequency Based Body Acceleration std()-Y Axis"          
[48] "Frequency Based Body Acceleration std()-Y Axis"          
[49] "Frequency Based Body Acceleration meanFreq()-X Axis"     
[50] "Frequency Based Body Acceleration meanFreq()-Y Axis"     
[51] "Frequency Based Body Acceleration meanFreq()-Y Axis"     
[52] "Frequency Based Body AccJerk-mean()-X Axis"              
[53] "Frequency Based Body AccJerk-mean()-Y Axis"              
[54] "Frequency Based Body AccJerk-mean()-Y Axis"              
[55] "Frequency Based Body AccJerk-standard deviation()-X Axis"
[56] "Frequency Based Body AccJerk-standard deviation()-Y Axis"
[57] "Frequency Based Body AccJerk-standard deviation()-Y Axis"
[58] "Frequency Based Body AccJerk-meanFreq()-X Axis"          
[59] "Frequency Based Body AccJerk-meanFreq()-Y Axis"          
[60] "Frequency Based Body AccJerk-meanFreq()-Y Axis"          
[61] "Frequency Based Body Gyro-mean()-X Axis"                 
[62] "Frequency Based Body Gyro-mean()-Y Axis"                 
[63] "Frequency Based Body Gyro-mean()-Y Axis"                 
[64] "Frequency Based Body Gyro-standard deviation()-X Axis"   
[65] "Frequency Based Body Gyro-standard deviation()-Y Axis"   
[66] "Frequency Based Body Gyro-standard deviation()-Y Axis"   
[67] "Frequency Based Body Gyro-meanFreq()-X Axis"             
[68] "Frequency Based Body Gyro-meanFreq()-Y Axis"             
[69] "Frequency Based Body Gyro-meanFreq()-Y Axis"             
[70] "Frequency Based Body Acc Magnitude- mean()"              
[71] "Frequency Based Body Acc Magnitude- std()"               
[72] "Frequency Based Body Acc Magnitude- meanFreq()"          
[73] "Frequency Based Body AccJerk Magnitude- mean()"          
[74] "Frequency Based Body AccJerk Magnitude- std()"           
[75] "Frequency Based Body AccJerk Magnitude- meanFreq()"      
[76] "Frequency Based Body Gyro Magnitude- mean()"             
[77] "Frequency Based Body Gyro Magnitude- std()"              
[78] "Frequency Based Body Gyro Magnitude- meanFreq()"         
[79] "Frequency Based Body GyroJerk Magnitude- mean()"         
[80] "Frequency Based Body GyroJerk Magnitude- std()"          
[81] "Frequency Based Body GyroJerk Magnitude- meanFreq()" 

11. The final Tidy Data Set is saved with file name "Tidy_Set.txt" in tab delimited format.


------------EOF----------------
