#! /usr/bin/Rscript --vanilla
args <- commandArgs(trailingOnly = TRUE)
#print("Monkey Helper: Get minutes from diff dates.")

d1 = as.numeric(args[1])
d2 = as.numeric(args[2])

diff = abs(d2 - d1)
min = round(diff/60)
cat(min)