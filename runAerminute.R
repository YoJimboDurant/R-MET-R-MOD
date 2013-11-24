# runs aerminute

runAerminute = function(startYear, stopYear, filePrefix="AM"){
  years <- seq(startYear, stopYear, by=1)
  for(i in 1:length(years)){
    aerminute <- paste(getwd(),"/aerminute_v11325/aerminute_11325.exe", sep="")
    setwd(paste("./", years[i],sep=""))
	if (R.version$os !="linux-gnu"){
    		shell(aerminute, input=paste(filePrefix, years[i],".inp", sep=""))
	}else{
		if(R.version$os =="linux-gnu")
		system(aerminute, input=paste(filePrefix, years[i],".inp", sep=""))
	}

    setwd("..")
  }
  
  
}
