# This is to certify that the R code below is writtent by Avish Jadwani for the 
#Coursera Getting and Cleaning data MOOC.
#Getting working directory location 
getwd()
#"C:/Users/Monika/Documents"

#setting working directory to a preffered location
setwd("C:/Users/Monika/Desktop/week4")
#Checking the working directory location now
getwd()
#[1] "C:/Users/Monika/Desktop/week4"
#I have downloaded the file provided and unzipped it in the week4 folder
#I will now read the files 
#Beginning with reading the test files
#For my convenience I will name the file TestX for the file X_test.txt
TestX<-read.table("./UCI HAR Dataset/test/X_test.txt")
#For my convenience I will name the file TestY for the file Y_test.txt
TestY<-read.table("./UCI HAR Dataset/test/Y_test.txt")
#For my convenience I will name the file TestSubject for the file subject_test.txt
TestSubject<-read.table("./UCI HAR Dataset/test/subject_test.txt")
#Reading Train file
#For my convenience I will name the file TrainX for the file X_train.txt
TrainX<-read.table("./UCI HAR Dataset/train/X_train.txt")
#For my convenience I will name the file TrainY for the file Y_train.txt
TrainY<-read.table("./UCI HAR Dataset/train/Y_train.txt")
#For my convenience I will name the file TrainSubject for the file subject_train.txt
TrainSubject<-read.table("./UCI HAR Dataset/train/subject_train.txt")
## Reading features and activity
#For my convenience I will name the file fea for the file features.txt
fea<-read.table("UCI HAR Dataset/features.txt")
#For my convenience I will name the file act for the file activity_labels.txt
act<-read.table("UCI HAR Dataset/activity_labels.txt")

#Task 1 of the assignment Merging the training and the test sets to 
#create one data set
#Geting help from the R Documentation
?rbind
#Merging X-X and Y-Y data of train and test data 
# giving Xmerge file name to X data merge 
Xmerge<-rbind(TestX,TrainX)
#checking 
Xmerge
#Got 561 columns with 1 row of data 
# giving Ymerge file name to Y data merge
Ymerge<-rbind(TestY,TrainY)
#Checking
Ymerge
#Got 1000 rows of data here, 1 column
# giving Subjectmerge file name to subject data merge
Subjectmerge<-rbind(TestSubject, TrainSubject)
#Checking
Subjectmerge
#again 1000 rows here
#Task 2 Extracts only the measurements on the mean and standard deviation for each measurement
#Taking help from R Documentation to 
?grep
#Finding record with mean and std in it  for all the features 
#naming task2 for the file that contains vector of only those records that have mean or std in it 
task2<-grep("mean\\(\\)|std\\(\\)",fea[,2])
#Checking 
task2
# [1]   1   2   3   4   5   6  41  42  43  44  45  46  81  82  83  84  85  86 121 122
#[21] 123 124 125 126 161 162 163 164 165 166 201 202 214 215 227 228 240 241 253 254
#[41] 266 267 268 269 270 271 345 346 347 348 349 350 424 425 426 427 428 429 503 504
#[61] 516 517 529 530 542 543
#total of 66 records

#Extracting those records from the Xmerge file
Extract<-Xmerge[,task2]
#Checking
Extract
#Got succesfull results
# Task 3 Uses descriptive activity names to name the activities in the data set
#Ymerge had 1000 rows and act file has details of activity along with a unique code
#such as 1 for walking
#Now I will replace  ymerge column number codes with appropriate activity
Ymerge[,1]<-act[Ymerge[,1],2] 
#checking
Ymerge
#Ymerge file now shows activities like walking ,walking_downstairs etc instead of numbers
## replacing numeric values with lookup value from activity.txt; won't reorder Y set
 
#Task 4 Appropriately labels the data set with descriptive variable names
#Now I will replace those V1, V2 column names with fBodyGyro... names
#reading fBodyGyro... names in names file
names<-fea[task2,2]
#Replacing  V1,V2 column names with names in names file above
names(Extract)<-names
#Checking
Extract
#The column names are changed
#naming the serial number as S no.
names(Subjectmerge)<-"Sno"
#naming the activity columnt as Activity
names(Ymerge)<-"Activity"
#Checking
head(Y)
#Binding files to create a final file
FinalData<-cbind(Subjectmerge, Ymerge, Extract)
#Checking , Reading only 5 columns just for testing 
head(FinalData[,c(1:5)])

#Task 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
#Loading data.table package 
install.packages("data.table")
library("data.table")
#Converting to data.table because we can perform average and other operations easily with this
Data<-data.table(FinalData)
# This is required as we have to find average of values and group by it 
CleanTidyData <- Data[, lapply(.SD, mean), by = 'Sno,Activity']

# it finds the average of all columns, except Sno & Activity and group by Sno & Activity
#Saving file in working directory
write.table(CleanTidyData, file = "CleanTidyData.txt", row.names = FALSE)

#Reading  10 rows and 5 columns in clean data
head(CleanTidyData[order(Sno),c(1:5)],10)
