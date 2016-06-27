reverseServerName = function(serverName){
  x = unlist(strsplit(serverName,"\\."))
  x = rev(x)
  x=paste(x, collapse = '.')
  return(x)
}

logResult = function(pattern, rule, server, value, expected, state, type, targetMicroService){
    tsp = as.character(Sys.time())
    x=data.frame(state,type, tsp,pattern, rule, server, value, expected, targetMicroService)
    write.table(x,file="bom_v2.log",append=TRUE, sep = ",",  row.names=F, col.names=F)
}

testfailedstring="Test failed:"
