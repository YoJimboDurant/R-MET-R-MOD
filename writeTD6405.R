# the following pulls 1-minute ASOS data from NCDC and either writes to subdirectory

setInternet2(use = NA) 
setInternet2(use = FALSE) 
setInternet2(use = NA) 

  writeTD6405=function(station_ID, start, stop){
    years <- seq(start, stop, by=1)
    sdExist <- sapply(as.character(years), FUN=file.exists )
    sapply(as.character(years[!sdExist]), FUN=dir.create, showWarnings=FALSE)
    
    for(i in 1:length(years))
    {
      for (j in 1:12)
      {
        TDfile <- paste("ftp://ftp.ncdc.noaa.gov/pub/data/asos-onemin/6405-",year[i],"/64050",station_ID,year[i],sprintf("%02d", j),".dat", sep="")
        destFile <- paste(".\\", as.character(year[i]),"\\","64050",station_ID,year[i], sprintf("%02d", j), sep="")
        download.file(TDfile, destFile)
      }
    }
    
    return(NULL)
  }

}
