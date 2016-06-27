#! /usr/bin/Rscript --vanilla
args <- commandArgs(trailingOnly = TRUE)
print("Conformance Rule: CPU idle.")
#print(args)
expected1 = 50
state1=3
iacm = -1
source("src/main/r/util.R")
x = reverseServerName(args[2])
url=paste0(args[1],"render/?from=-",args[4],"minutes&until=now&target=scaleToSeconds(nonNegativeDerivative(servers.",x,".system.cpu.idle,0),1)&format=csv")
print(url)

tryCatch(
  {
    agent = read.csv(url, header=FALSE)
    agent = na.omit(agent)
    iac = agent$V3/as.numeric(args[3])
    iacm = max(iac)

    if( iacm< expected1 ){
      print(paste(testfailedstring,"CPU idle time is to low. Expected > 50, Is",round(iacm)))
      state1=1
    } else {
      print("Test passed succesfully.")
    }
  },
  warning = function(war) {
    print(paste("BoM_Execution_WARNING:  ",war))
    # TODO: log error to bom event log
  },
  error = function(err) {
    print(paste("BoM_Execution_ERROR:  ",err))
  })
logResult("OffWaitOn", "CPU idle", args[2], iacm, expected1, state1, "Robustness", args[5])

