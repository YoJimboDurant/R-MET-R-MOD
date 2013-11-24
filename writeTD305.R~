# write TD3505 dowloads TD3505 file and puts it in year directory
writeTD3505=function(station_ID, WBAN=99999, start, stop){
  years <- seq(start, stop, by=1)
  for(i in 1:length(years))
  {
    year=years[i]
    fileout<-readLines(con=gzcon(url(paste("ftp://ftp.ncdc.noaa.gov/pub/data/noaa/",year,"/",station_ID,"-",WBAN,"-",year,".gz", sep=""))))
    write(fileout, file=paste(".\\", years[i],"\\","S",station_ID,"_",year, ".ish", sep=""))
  }
  
  return(NULL)
}
