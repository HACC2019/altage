library(lubridate)

pdata <- read.csv('/Users/akbazuka/Desktop/HACC\ 2019\ Electic/Power\ Data\ 1.csv', header=T)

ChargeCycle <- c()
countCycle = 0

for (i in 1:(nrow(pdata))){
  
  if (i==1 && pdata$Power..kW.[i] >= 1.00) countCycle = countCycle + 1
  else if ((pdata$Power..kW.[i-1] < 1.00) && (pdata$Power..kW.[i] >= 1.00)){ #&& (i < (nrow(pdata)-1))){
    countCycle = countCycle + 1
  }
  
  if (pdata$Power..kW.[i] >= 1.00){
    ChargeCycle <- c(ChargeCycle, countCycle)
  }
  else {
    ChargeCycle <- c(ChargeCycle, 0)
  }
}

#countCycle

#ChargeCycle

#pdata <- data.frame(pdata, ChargeCycle) #Shows all data after determining when there are charge cycles

pdataClean <- pdata[pdata$ChargeCycle != 0,] #Only shows data of charge cycles (excludes charge station data when not in use)

maxPower <- c()
      
for (i in 1:countCycle){
  #Separates each charge cycle into a a sub dataframe
  pSubset <- pdataClean[pdataClean$ChargeCycle == i,]
  #Calculates the peak power in the given charge cycle
  maxPower <- c(maxPower, max(pSubset$Power..kW.))
}

peakPower = max(maxPower)

maxPower #Can see the peak power of each charge cycle

peakPower #Displays the Minimum amount of Power they need to have based on the peak power within the data

mean(maxPower, trim = 0.1, na.rm = FALSE) #Calculate the average amount of peak power from peak power in every charge cycle (trims 10% of data from either side to remove outliers)
