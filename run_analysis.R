library(data.table)
library(dplyr)

getFiles <- function(folder) {
  # create the data_frame that will contain all the data in the folder

  fullfolder<-paste0(datafolder,folder,'/') # generate folder name
  message(fullfolder)
  filename<-paste0(fullfolder,'subject_',folder,'.txt') # load subject identifiers
  message(filename)
  subject<-read.table(filename,header=F)
  colnames(subject)<-c("subject")

  filename<-paste0(fullfolder,'y_',folder,'.txt') # load activities
  message(filename)
  y<-read.table( filename, header=F)
  colnames(y)<-c("activity")
  
  filename<-paste0(fullfolder,'X_',folder,'.txt') # load measurements
  message(filename)
  x<-read.table(filename,header=F )
  
  subjectyx<-data.frame(subject,y,x) # concat the three files
  
  subjectyx # return the 
}

# read labels for activities
getLabelsActivities <- function(){
  filename<-paste0(datafolder,'activity_labels.txt')
  activities<-read.table(filename, header=F, stringsAsFactors=F )
  activities<-select(activities,-1) # remove the first column
  colnames(activities)<-c("activity") # name the column properly
  activities
}

# read features file
getLabelsFeatures <- function(){
  filename<-paste0(datafolder,'features.txt')
  features<-read.table(filename, header=F )
  features<-select(features,-1)    # remove the first column
  colnames(features)<-c("feature") # name the column properly
  features
}

#set the data folder
datafolder<-"./UCI HAR Dataset/"   # root folder that contains the data in the working directory


# load files with activities and features

# PART 1: MERGE TRAIN and TEST
#load data
trte<-c("test","train")  # the two folders to read

data<-data.frame()
for (folder in trte){
  p<-getFiles(folder)
  data<-rbind(data,p)   # rows are put together
}

# PART 2: EXTRACT COLUMNS WITH MEAN OR STD

#load all features names
features<-getLabelsFeatures()
# obtain columns that include mean or std
idxs<-grep("mean\\(|std\\(",as.vector(features$feature))
#ADJUSTED IDXS, we add 2 because subject and activity come first
idxs<-c(1,2,idxs+2)
txts<-grep("mean\\(|std\\(",as.vector(features$feature),value=T)
#COLUMN TITLES modified with make.names to
txts<-make.names(c("subject","activity",txts))
#SELECT COLUMNS MATCHING
data<-select(data,idxs)
#ASSIGN NAMES TO COLUMNS (temporarily)
colnames(data)<-txts


# PART 3: USE DESCRIPTIVE ACTIVITY NAMES
activities<-getLabelsActivities()
data$activity<-sapply(data$activity,function(x){activities[[x,1]]})

# PART 4: DESCRIPTIVE VARIABLE NAMES
txts<-gsub("^f", "Freq", txts)  # Change f by Freq
txts<-gsub("^t", "Time", txts)  # Change t by Time
txts<-gsub("\\.", "", txts)     # Remove dots
txts<-gsub("mean", "Mean", txts)# Uppercase Mean
txts<-gsub("std", "Std", txts)  # Uppercase Std
colnames(data)<-txts

# PART 5: AVERAGE FOR ACTIVITY AND SUBJECT
# I have taken as tidy the "wide" format where all variables of the same activity and subject 
# are in the same row: 68 columns x 180 rows
agg<-aggregate(data=data, . ~ subject + activity,FUN=mean)

write.table(agg,"tidydata.txt",row.name=F)