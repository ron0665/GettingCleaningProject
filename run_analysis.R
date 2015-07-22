    ##Setting Working Directory and removing any current files from global environment
setwd('/Users/rsamuel/Datascience Specialization/')
rm(list=ls())

##Downloading the files and re-setting the working directory
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Dataset.zip")
unzip(zipfile="./Dataset.zip",exdir="./GettingCleaningProject")
setwd('/Users/rsamuel/Datascience Specialization/GettingCleaningProject/UCI HAR Dataset/')


##Reading and storing the files

##The Activity files
dataActivityTest <- read.table('./test/Y_test.txt', header = FALSE)
dataActivityTrain <- read.table('./train/Y_train.txt', header = FALSE)
##The Subject files
dataSubjectTest <- read.table('./test/subject_test.txt', header = FALSE)
dataSubjectTrain <- read.table('./train/subject_train.txt', header = FALSE)
##The Feature files
dataFeaturesTest <- read.table('./test/X_test.txt', header = FALSE)
dataFeaturesTrain <- read.table('./train/X_train.txt', header = FALSE)


##Step 1. Merging the training and test sets to create one data set


##Concatenate the data tables by rows
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)
##set names to variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table('./features.txt',head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2
##Merge columns to get the data frame for all data
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)



##Step 2&3. Extracts only the measurements on the mean and standard deviation for each measurement
##Names the activities in the data sets



#Take names of Features with mean or std
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
##Subset data by selected feature names
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)


##Step 4. Appropriately labels the data set with descriptive variable names


##Read descriptive names from "activity_labels.txt"
activityLabels <- read.table('./activity_labels.txt',header = FALSE)
##Replace activity in "Data" data.frame with "activitylables"
Data[,68] <- activityLabels[Data[,68],2]
##Lable Data names with descriptive variable names
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))


##Step 5. Creates a second data set with the average of each activity and each subject


##Tidy Dataset for output
library(plyr)
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)