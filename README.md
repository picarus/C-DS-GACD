# Getting and Cleaning Data README FILE

This file explains how the project for the Getting and Cleaning Data MOOC has been designed and implemented.

## Loading Data

The script in run_analysis.R expects the data from the zip file to be extracted in the working directory directly. This way there will be a folder UCI HAR Dataset in the working directory.
This folder will contain the 'activity\_labels.txt' and features.txt and the test and train folder that contain each the respective 'subject\_' , 'X\_', and 'y\_' files.

The information is not downloaded as part of the script, for performance and for being able to work offline. 

The data is loaded using the following functions:

* getFiles, loads the test or train folders
* getLabelsActivities, loads the activity_labels
* getLabelsFeatures, loads the feature names

## Data Processing

Once the Data has been loaded, the processing is done sequentially following the steps in the project assignment description. There are no separated functions for each step but the code is separated with comments into sections.

### Merges the training and the test sets to create one data set.

Each of the folders is loaded separately, using getFiles, and then combined in a single data frame

### Extracts only the measurements on the mean and standard deviation for each measurement.

The list of features loaded with getFeatures is filtered to retain only the features that contain mean() or std() in their name. Other features that only include mean are not considered.

The names are made compliant with names constraints for columns using make.names

The columns in the dataset that correspond to the features are selected.

Note that because we have activity and user as first and second columns, the indexes of the columns have an offset of two.

### Uses descriptive activity names to name the activities in the data set

The numeric ids of the activities are replaced by its descriptive string.
This is done based on its order in the file.

### Appropriately labels the data set with descriptive variable names. 

The names of the columns in the dataset are modified to increase its interpretability.

For doing so, the following changes are introduced:

* Leading t is converted into Time
* Leading f is converted into Freq
* The dots introduced by make.names are removed
* mean and std are capitalized into Mean and Std respectively

While a more thorough work could be done, for the purpose of the exercise this should be considered enough.

### From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

For the final tidy data set, I have decided to target what in the FAQ is referred as _wide format_, meaning that each activity and user will have all the features in one row, for a total of 180 rows. The alternative would have been having one row per user, activity and feature but in this case this doesn't help any purpose.

The mean aggregation is calculated using the aggregate command with subject and activity as grouping variables for the rest of the dataset.








