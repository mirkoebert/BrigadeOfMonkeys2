#! /usr/bin/Rscript --vanilla
args <- commandArgs(trailingOnly = TRUE)
print("Conformance Rule: Response error ratio.")
#print(args)
expected = 0.1
state=0
iacm = -1

source("src/main/R/util.R")
x = reverseServerName(args[2])
url=paste0(args[1],"render/?from=-",args[3],"minutes&until=now&target=divideSeries(scaleToSeconds(nonNegativeDerivative(servers.",x,".localhost_9000.global_request_processor.http-nio-8444.errorCount),1),scaleToSeconds(nonNegativeDerivative(servers.",x,".localhost_9000.global_request_processor.http-nio-8444.requestCount),1))&format=csv")
print(url)

tryCatch(
  {
    agent = read.csv(url, header=FALSE)
    iacm = max(agent$V3, na.rm=T)
    if(is.infinite(iacm)){
      warning("No Values.", call. = F)
      print(agent)
    } else {
      if(iacm > expected){
        print(paste(testfailedstring,"Error ratio is to high. Expect <",expected,", Is",round(iacm,2)))
        state=1
      } else {
        print("Test passed succesfully.")
        state=3
      }
    }
  },
  warning = function(war) {
    print(paste("BoM_Execution_WARNING:  ",war))
    # TODO: log error to bom event log
  },
  error = function(err) {
    print(paste("BoM_Execution_ERROR:  ",err))
  }
)


logResult("OffWaitOn", "Response error ratio", args[2], iacm, expected, state, "Robustness", args[4])
