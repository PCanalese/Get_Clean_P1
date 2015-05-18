# Introduction
The files in this repo have been created for John Hopkins Cousera Subject
Getting and Cleaning Data.

This project uses data from the following source:

[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

# License

Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

# Set Up
This code was developed in R Studio Version 0.98.1103 under a Windows 7 environment.
The code uses the "data.table" library and has been developed and tested with version 1.9.4 of this library.

All effort has been made to make the code as generic as possible.

A code book that describes the variables, the data, transformations and work that has been completed is included and is here [CodeBook.md](CodeBook.md) 

# Instructions for use
1. The UCI data should be downloaded and extracted into the saved directory structure.
2. The script file [run_analysis.R](run_analysis.R) should be downloaded and saved in the same directory as the "UCI HAR Dataset" directory.
3. The script file can be loaded and run in R Studio or run using source("run_analysis.R").
4. The output Tidy Data set is saved as a tab delimited text file called [Tidy_Set.txt](Tidy_Set.txt)