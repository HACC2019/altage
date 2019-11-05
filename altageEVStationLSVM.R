#Support Vector Machine (SVM) to Check if Actual Session Amount is Statistically Siginificantly Different than Theoretical or not################################################################################################
library(caret)
library(lubridate)
library(kernlab)
library(mlbench)

edata <- read.csv('/Users/akbazuka/Desktop/HACC\ 2019\ Electic/Data_HACC.csv', header=T)

#head(edata)
#summary(edata)
#str(edata)

##Pre-Processing of Data###########
#Start.Time Formatted to add columns MonthOfYear, DayOfWeek, and HoursOfDay
edata$Start.Time <- mdy_hms(edata$Start.Time) #Format Start.Time Column
MonthOfYear <- as.numeric(factor(month(edata$Start.Time)))
DayOfWeek <- as.numeric(factor(factor(wday(edata$Start.Time))))
HourOfDay <- as.numeric(factor(hour(edata$Start.Time)))

#Categorize Featurn of Charge Station Name
edata$Charge.Station.Name <- ifelse(edata$Charge.Station.Name == "A", 0, 1)

#Categorize Feature of Session Inititated By
edata$Session.Initiated.By <- ifelse(edata$Session.Initiated.By == "MOBILE", 0,
                                     ifelse(edata$Session.Initiated.By == "DEVICE", 1,
                                            2))

#Categorize Feature of Start Time -> Time Of Day Start Charging
TimeOfDay <- as.numeric(ifelse(HourOfDay <= 7 | HourOfDay >= 21, 0,
                               ifelse(HourOfDay >= 8 & HourOfDay <= 15, 1,
                                      ifelse(HourOfDay >= 16 & HourOfDay <= 20, 2, 
                                             -1))))

#Convert Duration column to num in minutes
edata$Duration <- as.numeric(hms(edata$Duration)) #requires lubridate library; converts duration to seconds
edata$Duration <- (edata$Duration/60) #Divide by 60 to convert seconds to minutes
#summary(remove_outliers(edata$Duration)) #Calculates summary of vector without outliers

#Convert session amount column to numerical data
edata$Session.Amount <- as.numeric(gsub("\\$", "", edata$Session.Amount))
#summary(remove_outliers(edata$Session.Amount)) #Calculates summary of vector without outliers

#Categorize Feature of Start Port Type
edata$Port.Type <- ifelse(edata$Port.Type == "CHADEMO", 0, 1)

#Categorize Feature of Start Time -> Time Of Day Start Charging
edata$Payment.Mode <- ifelse(edata$Payment.Mode == "CREDITCARD", 0, 1)

#Make continuous variables classifiable (Use mean numbers gotten from summaries to detemine if high or low)

#Energy <- ifelse(edata$Energy.kWh. <= 13.00, 0, 1) #Decision Variable becomes whether Energy is HighEnergyer than 13.00 kWh or not
#DurationMin <- ifelse(edata$Duration <= 21.927, "< 22 Min", "> 22 min")

#Theoretical Amount is price point at time of day multiplied by Energy 
theoreticalAmount <- ifelse(TimeOfDay == 0, 0.54,
                            ifelse(TimeOfDay == 1, 0.49,
                                   0.57))

thAmount <- format(round((edata[,"Energy.kWh."] * theoreticalAmount),2))

Amount <- ifelse(edata$Session.Amount == format(round((edata[,"Energy.kWh."] * theoreticalAmount),2),nsmall=2), 1, 0)

#Data After Manual Pre-Processing
#Charge Station Name: Categorical; 0=A, 1=B
#Session Intitiated By: Categorical; 0=Mobile, 1=Device, 2=Web
#TimeOfDay: Categorical; 0=Off-Peak, 1=Mid-Day, 2=On-Peak
#Duration (minutes): Continuous; -938.02 to 320.62
#Energy(kWh): Continuous; 0 to 84.65
#Session Amount ($): Continuous; 0 to 9.99
#Port Type: Categorical; 0=Chademo, 1=DCCOMBOTYP1
#Payment Mode: Categorical; 0=Credit Card, 1=RFID
#MonthOfYear: Categorical; 1=January...12=December
#DayOfWeek: Categorical; 1=Monday...7=Sunday
#
#Amount: Categorical Decicison Variable; 0=Amount spent is incorrect, 1=Amount spent is correct according to price points per kWh at given TimeOfDay

#Add pre-processed grouped colums together
edata <- data.frame(edata, TimeOfDay, DayOfWeek, MonthOfYear, Amount, thAmount)

#Remove unnecessary columns from dataset before implementing Decision Tree
edata <- edata[-c(3,4,8)]

#Standardize Decision Variable by converting to Factor for Categorical 
edata[["Amount"]] = factor(edata[["Amount"]])

# #Rank Features By Importance
# set.seed(10)
# # prepare training scheme
# control <- trainControl(method="repeatedcv", number=10, repeats=3)
# # train the model
# model <- train(Amount~., data=edata, method="lvq", preProcess="scale", trControl=control)
# # estimate variable importance
# importance <- varImp(model, scale=FALSE)
# # summarize importance
# print(importance)
# # plot importance
# plot(importance)

#Slice Data into Train and Test

set.seed(1000) #Replicates results because makes same splits
intrain <- createDataPartition(y= edata$Amount, p= 0.6, list= FALSE) #y determines target variable, p determines split, in this case- 70%:30%
training <- edata[intrain,] #copying data from data fram to training variable
testing <- edata[-intrain,] #""

# #Removes Outliers from Training Dataset
# training$Duration <- remove_outliers(training$Duration)
# training$Energy.kWh. <- remove_outliers(training$Energy.kWh.)
# training$Session.Amount <- remove_outliers(training$Session.Amount)

dim(training); dim(testing) #Shows dimensions of training and testing data

#Pre-Processing
anyNA(edata) #checks if any missing values in dataset
summary(edata) #Summarized details of dataset

#Train SVM Model
trctrl <- trainControl(method= "cv", number = 10) #repeadetedcv = repeated cross-validation; can change method if wanted

#SVM With No Missing Values; Without Outliers Removed From Training Set
svm_Lin <- train(Amount ~., data=training, method= "svmLinear",
                  trControl=trctrl,
                  preProcess = c("center","scale"),
                  tuneLength=4) #preProcess() method preprocesses data

# #SVM With Missing Values; With Outliers Removed From Training Set
# svm_Linear <- train(Amount ~., data=training, method= "svmLinear",
#                     trControl=trctrl,
#                     na.action = na.pass,
#                    tuneLength=10) #preProcess() method preprocesses data

svm_Lin #Shows results of trained SVM model; C shows "held constant at value 1" becuase linear model was implemented

# #Single row of data implementation; can be used to display error later on if classified incorrectly and data can be read through line by line and checked
#   testSingle <- testing[1,] #Extract single (first row in this case) row from testing set
#   test_pred <- predict(svm_Linear, newdata=testSingle)

test_pred <- predict(svm_Lin, newdata=testing) #trained model is first argument and second is variable that holds our test data
#edata <- data.frame(edata, test_pred) 
test_pred #Shows list returned by predict() method

#Accuracy of Model
#For single row of data
# confusionMatrix(test_pred, testSingle$Amount) #Checks if SingleData column was classified correctly
confusionMatrix(test_pred, testing$Amount)

