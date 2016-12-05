#! /usr/bin/Rscript --vanilla
args <- commandArgs(trailingOnly = TRUE)

today=Sys.Date()
todayDate=strptime(today,"%F")


if(is.na(args[2])){
  print(paste("Robustness KPI Calculation for:", today))
} else {
  print(paste("Robustness KPI Calculation for micro service:", args[2],"for:", today))
}

bom = read.csv(args[1], header=F)
#rob=subset(bom, bom$V2=="Robustness")
rob=bom
if(!is.na(args[2])){
  # calc robustness kpi for one given micro service
  rob=subset(rob, rob$V8==args[2])
}

rob$V3=strptime(rob$V1,"%F %T")
robToday=subset(rob,rob$V1 > todayDate)

kpiToday = 0
color="grey"

robTestCountToday = dim(robToday)[1]
if(robTestCountToday > 0){
  kpiToday = round(mean(robToday$V3),2)
  if(kpiToday > 2.5){
    color="green"
  } else if(kpiToday > 1.5){
    color = "yellow"
  } else {
    color = "red"
  }
}
print(paste("Robustness KPI:", kpiToday))
print(paste("Robustness KPI Color: ", color))
print(paste("Total count of robustness checks: ",robTestCountToday))

#if(kpiToday < 1.5){
  #quit("no",1)
#}
