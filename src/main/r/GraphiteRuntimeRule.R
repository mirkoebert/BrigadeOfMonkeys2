#! /usr/bin/Rscript --vanilla
args <- commandArgs(trailingOnly = TRUE)
print("Conformance Rule: Response time TTFB.")
print(args)

source("src/main/r/util.R")


x = reverseServerName(args[2])

url=paste0(args[1],"render/?from=-",args[3],"minutes&until=now&target=statsite.timers.servers.",x,".Varnish.response.ttfb.median&format=csv")
print(url)

agent = read.csv(url, header=FALSE)
iacm = max(agent$V3, na.rm=T)
expected = 0.120 # sec
state=0 #grey
if(iacm > expected){
  warning(paste("Error: runtime ttfb median is to high. Expect (sec) < ",expected,", Is",iacm), call. = F)
  state=1 #red
} else {
  print("Test passed succesfully.")
  state=3 #green
}

logResult("OffWaitOn", "Response time ttfb", args[2], iacm, expected, state, "Robustness")
