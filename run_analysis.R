
data_colnames<-read.table("features.txt")
activity_label<-read.table("activity_labels.txt")
colnames(activity_label)<-c("Activity_id","Activity")
#Read Test Data
test_data<-read.table("./test/X_test.txt")
test_activities<-read.table("./test/y_test.txt")
colnames(test_activities) = "Activity_id"
test_subject<-read.table("./test/subject_test.txt")
colnames(test_subject) = "Subject_id"

#Create subject and activities cols in Test Data
colnames(test_data)<-data_colnames[,2]
test_data<-cbind(test_subject,test_activities,test_data)

#Read Train Data
train_data<-read.table("./train/X_train.txt")
train_activities<-read.table("./train/y_train.txt")
colnames(train_activities) = "Activity_id"
train_subject<-read.table("./train/subject_train.txt")
colnames(train_subject) = "Subject_id"

#Create subject and activities cols in Train Data
colnames(train_data)<-data_colnames[,2]
train_data<-cbind(train_subject,train_activities,train_data)

#Combind Train and Final Data
final_data = rbind(test_data,train_data)

#Subsetting final Data
colNames = colnames(final_data)
interested_cols = (grepl("Activity_",colNames) | grepl("Subject_",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames));
final_data = final_data[interested_cols==T] 

#Create a col of descriptive activity names
#final_data = merge(final_data,activity_label,by="Activity_id",all.x=T)
#final_data = final_data[!colnames(final_data)=="Activity_id"]

#Create descriptive colnames
colNames = colnames(final_data)
for (i in 1:length(colNames)) 
{
  colNames[i] = gsub("\\()","",colNames[i])
};
colnames(final_data) = colNames

# Summarizing the finalDataNoActivityType table to include just the mean of each variable for each activity and each subject
tidyData    = aggregate(final_data[,names(final_data) != c('Activity_id','subject_id')],by=list(Activity_id=final_data$Activity_id,Subject_id = final_data$Subject_id),mean);

# Merging the tidyData with activityType to include descriptive acitvity names
tidyData = tidyData[3:length(tidyData)]
tidyData = merge(tidyData,activity_label,by="Activity_id",all.x=T);
tidyData = tidyData[!names(tidyData)=="Activity_id"]
#Export cleaned data
write.table(tidyData, './CleanData.txt',row.names=TRUE,sep='\t');

