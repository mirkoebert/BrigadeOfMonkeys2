#! /usr/bin/Rscript --vanilla
args <- commandArgs(trailingOnly = TRUE)
print("Conformance Rule: Response error ratio.")
#print(args)
expected = 0.12
state=0

source("src/main/R/util.R")
x = reverseServerName(args[2])
url=paste0(args[1],"render/?from=-",args[3],"minutes&until=-1minutes&target=divideSeries(sumSeries(statsite.counts.servers.",x,".Varnish.response.{4,5}*),sumSeries(statsite.counts.servers.",x,".Varnish.response.{1,2,3,4,5}*))&format=csv")
print(url)

agent = read.csv(url, header=FALSE)
iacm = max(agent$V3, na.rm=T)
if(is.infinite(iacm)){
  warning("No Values.", call. = F)
  print(agent)
} else {
  if(iacm > expected){
    warning(paste("Error ratio is to high. Expect < ",expected,", Is",iacm), call. = F)
    state=1
  } else {
    print("Test passed succesfully.")
    state=3
  }
}
logResult("OffWaitOn", "Response error ratio", args[2], iacm, expected, state, "Robustness")

