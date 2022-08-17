#download data set
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "C:/Users/yukka/Desktop/Coursera-Data Science/Clean data/Final_project.zip"
download.file(fileURL, filename, method="curl")
unzip(filename) 

#read test data set from files
file1<-"C:/Users/yukka/Desktop/Coursera-Data Science/Clean data/UCI HAR Dataset/test/X_test.txt"
file2<-"C:/Users/yukka/Desktop/Coursera-Data Science/Clean data/UCI HAR Dataset/test/y_test.txt"
file3<-"C:/Users/yukka/Desktop/Coursera-Data Science/Clean data/UCI HAR Dataset/test/subject_test.txt"

Test_data<-read.table(file= file1,header = FALSE)
Test_y<-read.table(file= file2,header = FALSE)
Test_subject<-read.table(file= file3,header = FALSE)


#read column name from file
file4<-"C:/Users/yukka/Desktop/Coursera-Data Science/Clean data/UCI HAR Dataset/features.txt"
column_name<-read.table(file= file4,header = FALSE)

#name the columns
names(Test_data)<-column_name$V2
names(Test_subject)<-"subject"
names(Test_y)<-"activity"

#combine Test_data,Test_subject,Test_y into one data set
Test_data<-cbind(Test_subject,Test_y,Test_data)


#read train data set from files
file5<-"C:/Users/yukka/Desktop/Coursera-Data Science/Clean data/UCI HAR Dataset/train/X_train.txt"
file6<-"C:/Users/yukka/Desktop/Coursera-Data Science/Clean data/UCI HAR Dataset/train/y_train.txt"
file7<-"C:/Users/yukka/Desktop/Coursera-Data Science/Clean data/UCI HAR Dataset/train/subject_train.txt"
Train_data<-read.table(file= file5,header = FALSE)
Train_y<-read.table(file= file6,header = FALSE)
Train_subject<-read.table(file= file7,header = FALSE)

#name the columns
names(Train_data)<-column_name$V2
names(Train_subject)<-"subject"
names(Train_y)<-"activity"

#combine Train_data,Train_subject,Train_y into one data set
Train_data<-cbind(Train_subject,Train_y,Train_data)

#combine Test_data and Train_data
Data<-rbind(Test_data,Train_data)


#Extracts only the measurements on the mean and standard deviation 
#for each measurement
MeanSD_Data<-Data[,c(1,2,grep("mean|std",colnames(Data),ignore.case = TRUE))]

#Uses descriptive activity names to name the activities in the data set
file8<-"C:/Users/yukka/Desktop/Coursera-Data Science/Clean data/UCI HAR Dataset/activity_labels.txt"
activity_name<-read.table(file= file8,header = FALSE)
MeanSD_Data$activity<-factor(MeanSD_Data$activity,levels = activity_name$V1,
                             labels = activity_name$V2)

#Appropriately labels the data set with descriptive variable names. 
names(MeanSD_Data)<-gsub("Acc", "Accelerometer", names(MeanSD_Data))
names(MeanSD_Data)<-gsub("Gyro", "Gyroscope", names(MeanSD_Data))
names(MeanSD_Data)<-gsub("BodyBody", "Body", names(MeanSD_Data))
names(MeanSD_Data)<-gsub("Mag", "Magnitude", names(MeanSD_Data))
names(MeanSD_Data)<-gsub("^t", "Time", names(MeanSD_Data))
names(MeanSD_Data)<-gsub("^f", "Frequency", names(MeanSD_Data))
names(MeanSD_Data)<-gsub("-mean()", "Mean", names(MeanSD_Data), ignore.case = TRUE)
names(MeanSD_Data)<-gsub("-std()", "STD", names(MeanSD_Data), ignore.case = TRUE)
names(MeanSD_Data)<-gsub("-freq()", "Frequency", names(MeanSD_Data), ignore.case = TRUE)
names(MeanSD_Data)<-gsub("angle", "Angle", names(MeanSD_Data))
names(MeanSD_Data)<-gsub("gravity", "Gravity", names(MeanSD_Data))

#create a new data set with the average of each variable for each activity and each subject
library(dplyr)
Final_Data<-MeanSD_Data%>%
    group_by(subject,activity)%>%
    summarise_all(funs(mean=mean))

write.table(Final_Data, "Final_Data.txt", row.name=FALSE)
