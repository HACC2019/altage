#Congestion Checking################################################################################################
library(lubridate)

edata <- read.csv('/Users/akbazuka/Desktop/HACC\ 2019\ Electic/Data_HACC.csv', header=T)

##Pre-Processing of Data###########
#Start.Time Formatted to add columns MonthOfYear, DayOfWeek, and HoursOfDay
  edata$Start.Time <- mdy_hms(edata$Start.Time) #Format Start.Time Column
  edata$End.Time <- mdy_hms(edata$End.Time)
  
  MonthOfYear <- as.numeric(factor(month(edata$Start.Time)))
  DayOfWeek <- as.numeric(factor(factor(wday(edata$Start.Time))))
  HourOfDay <- as.numeric(factor(hour(edata$Start.Time)))
  
  #Categorize Feature of Start Time -> Time Of Day Start Charging: 0=Off-Peak, 1=Mid-Day, 2=On-Peak
  edata$TimeOfDay <- as.numeric(ifelse(HourOfDay <= 7 | HourOfDay >= 21, 0,
                                 ifelse(HourOfDay >= 8 & HourOfDay <= 15, 1,
                                        ifelse(HourOfDay >= 16 & HourOfDay <= 20, 2, 
                                               -1))))

#Calculate and store duration between charge cycles (start time of next cycle - end time of this cycle)
  fromSessionID <- c()
  toSessionID <- c()
  timeToNextCharge <- c()
  timeOfDayBetweenCC <- c()
  betweenCC <- data.frame()
  
  for (i in 1:nrow(edata)){
      timeToNextCharge <- c(timeToNextCharge, difftime(edata[i+1,3], edata[i,4], tz="HST", units = "mins"))
      timeOfDayBetweenCC <- c(timeOfDayBetweenCC, edata$TimeOfDay[i+1])
      fromSessionID <- c(fromSessionID, edata$Session.Id[i])
      toSessionID <- c(toSessionID, edata$Session.Id[i+1])
  }
  
#Store Duration Between Charge Cycles in DataFrame
  betweenCC <- data.frame(edata$Charge.Station.Name,fromSessionID, toSessionID, format(round(timeToNextCharge,2),nsmall=2), timeOfDayBetweenCC)
  colnames(betweenCC) <- c("Station","fromSessionID","toSessionID","timeToNextCC(min)","timeOfDayBCC")
  
  congested <- c()
  
  timeToNextCharge = c(as.numeric(timeToNextCharge))
  
  if(timeToNextCharge[3] <= 7){
    congestedCount = congestedCount + 1
  }
  
  congestedCount = 0
  
#Loop to determine when there is congestion
  for (i in 1:(nrow(betweenCC)-1)){
    congestedCount <- ifelse((timeToNextCharge[i]) <= 7, congestedCount + 1, 0) #7 for 7 min; Allow user to change time as well as no. of vehicles in backlog to determine congestion on front end side
    
    if (congestedCount >= 3){ #3 for 3 or more cars consecutively waiting
      congested <- c(congested, "Yes")
    } else{
      congested <- c(congested, "No")
    }
    #For last row that has value of NA
    if (i==(nrow(betweenCC)-1)){
      congested <- c(congested, "No")
    }
  }
  #Store congestion vector in betweenCC (between charge cycles) data frame
  betweenCC <- data.frame(betweenCC,congested)

#Number of instance of congestion
  length(which(betweenCC$congested == "Yes" & betweenCC$timeOfDayBCC == 0)) #Where congestion occurred during Off-Peak Hours
  length(which(betweenCC$congested == "Yes" & betweenCC$timeOfDayBCC == 1)) #Where congestion occurred during Mid-Day Hours
  length(which(betweenCC$congested == "Yes" & betweenCC$timeOfDayBCC == 2)) #Where congestion occurred during On-Peak Hours
  #length(which(betweenCC$congested=="No")) #No. of Instances where congestion did not occur
  
  betweenCCA <- betweenCC[betweenCC$Station=="A",]
  
  betweenCCB <- betweenCC[betweenCC$Station=="B",]
