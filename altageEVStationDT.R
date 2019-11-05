#Aniruddh Kedlaya
#Last Uodate: 24/10/19
#Decision Tree: 
# Pre-process data to separate continuous variables into 2 or more classifiable values and store in vectors.
# (When processing continuous variables, function to remove outliers was used to retrieve statistical 
# information without outliers so that later on, it can be determined when test data is input, whether 
# the accuracy results show that there is an anomaly in the system, or not; this part has not yet been
# implemented.)
# Then add new vectors to data frame and lose corresponding original ones.
# Implement decision tree by use of package-'Tree' and then by 'Rpart' (prettier plot).

require(tree)
require(lubridate)
require(rpart)
require(rpart.plot)
library(rattle)

remove_outliers <- function(x, na.rm = TRUE, ...) {
  qnt <- quantile(x, probs=c(.25, .75), na.rm = na.rm, ...)
  H <- 1.5 * IQR(x, na.rm = na.rm)
  y <- x
  y[x < (qnt[1] - H)] <- NA
  y[x > (qnt[2] + H)] <- NA
  y
}

edata <- read.csv('/Users/akbazuka/Desktop/HACC\ 2019\ Electic/Data_HACC.csv', header=T)

#Start.Time Formatted to add columns MonthOfYear, DayOfWeek, and HoursOfDay
edata$Start.Time <- mdy_hms(edata$Start.Time) #Format Start.Time Column
MonthOfYear <- factor(month(edata$Start.Time))
DayOfWeek <- factor(wday(edata$Start.Time))
HourOfDay <- factor(hour(edata$Start.Time))
HourOfDay <- as.numeric(HourOfDay) #convert factor to numeric

head(edata$Session.Initiated.By)
#hist(edata$Energy.kWh.)

#Convert Duration column to num in minutes
edata$Duration <- as.numeric(hms(edata$Duration)) #requires lubridate library; converts duration to seconds
edata$Duration <- (edata$Duration/60) #Divide by 60 to convert seconds to minutes
summary(remove_outliers(edata$Duration)) #Calculates summary of vector without outliers

#Convert session amount column to numerical data
edata$Session.Amount <- as.numeric(gsub("\\$", "", edata$Session.Amount))
summary(remove_outliers(edata$Session.Amount)) #Calculates summary of vector without outliers

#Make continuous variables classifiable (Use mean numbers gotten from summaries to detemine if high or low)
Energy <- ifelse(edata$Energy.kWh. <= 13.00, "Energy Less than 13kWh", "Energy More than 13kWh") #Decision Variable becomes whether Energy is HighEnergyer than 13.00 kWh or not
#Payment <- ifelse(edata$Payment.Mode == "CREDITCARD", 1, 2)

DurationMin <- ifelse(edata$Duration <= 21.927, "< 22 Min", "> 22 min")

Amount <- ifelse(edata$Session.Amount == format(round((edata[,"Energy.kWh."] * theoreticalAmount),2),nsmall=2), 1, 0)
edata[["Amount"]] = factor(edata[["Amount"]])

#Nested ifelse statements to group HoursOfDay into the three price determining groups, used by Hawaiian Electric
TimeOfDay <- ifelse(HourOfDay <= 7 | HourOfDay >= 21, "Off-Peak",
                    ifelse(HourOfDay >= 8 & HourOfDay <= 15, "Mid-Day",
                           ifelse(HourOfDay >= 16 & HourOfDay <= 20, "On-Peak",
                                  "NA")))

#Add pre-processed grouped colums together
edata <- data.frame(edata, Energy, DurationMin, Amount, MonthOfYear, DayOfWeek, TimeOfDay)

#Remove unnecessary columns from dataset before implementing Decision Tree
edata <- edata[-c(2,3,4,5,7,8,9,10)]

str(edata)

#Implement Decision Tree
tree.edata = tree(Amount~.-Energy.kWh., data=edata) #Can switch out <Energy> as first argument for different variable to change dependent variable
summary(tree.edata)
#Plot tree
plot(tree.edata)
text(tree.edata, all=TRUE, cex=.7, pretty=0)

tree.edata #Detailed Summary of tree

#Implement Decision Tree with rpart package without Energy.kWh column
fit <- rpart(Amount~.-Energy.kWh., data=edata) #Can switch out <Energy> for different variable to change dependent variable
#Plot
rpart.plot(fit, extra = "auto")
fancyRpartPlot(fit)
summary(fit)

