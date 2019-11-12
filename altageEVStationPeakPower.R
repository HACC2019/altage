library(lubridate)

pdata <- read.csv('/Users/akbazuka/Desktop/HACC\ 2019\ Electic/Power\ Data\ 1.csv', header=T)

#pdata$Start.Date.and.Time <- mdy_hms(edata$Start.Date.and.Time)

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

#ChargeCycle
#pdata <- data.frame(pdata, ChargeCycle)

