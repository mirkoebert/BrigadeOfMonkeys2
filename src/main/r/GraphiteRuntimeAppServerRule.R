#! /usr/bin/Rscript --vanilla
args <- commandArgs(trailingOnly = TRUE)
#args[1]="http://graphite."
#args[2]="app-dev-2"
#args[3]="20"
#args[4]="san"

expected = 200 #ms
state=0 #gray
iacm = -1
source("src/main/R/util.R")

print("Conformance Rule: Response time App Server.")
#print(args)


x = reverseServerName(args[2])
url=paste0(args[1],"render/?from=-",args[3],"minutes&until=now&target=divideSeries(scaleToSeconds(nonNegativeDerivative(servers.",x,".localhost_9000.global_request_processor.http-nio-8444.processingTime),1),scaleToSeconds(nonNegativeDerivative(servers.",x,".localhost_9000.global_request_processor.http-nio-8444.requestCount),1)))&format=csv")
print(url)

tryCatch(
  {
    agent = read.csv(url, header=FALSE)
    iacm = max(agent$V3, na.rm=T)
    if(iacm > expected){
      print(paste(testfailedstring,"runtime mean is to high. Expect < ",expected,", Is",iacm))
      state=1 #red
    } else {
      print("Test passed succesfully.")
      state=3 #green
    }},
  warning = function(war) {
    print(paste("BoM_Execution_WARNING:  ",war))
    # TODO: log error to bom event log
  },
  error = function(err) {
    print(paste("BoM_Execution_ERROR:  ",err))
  }
)

logResult("OffWaitOn", "Response time", args[2], iacm, expected, state, "Robustness", args[4])

