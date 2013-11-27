# set up AERSURFACE and Run


# getSurf.R gets surface file either letting
# user choose from list or pulling down specified file

getSurf <- function(stateFile="choose"){

  require(stringr)
  require(R.utils)
  if(!file.exists("aersurface")) dir.create("aersurface")
  
  httpSite <- "http://edcftp.cr.usgs.gov/pub/data/landcover/states/"

  
  if(stateFile=="choose"){
    
    con=url(httpSite)
    indexData <- readLines(con)
    close(con)
    indexData <- str_match(indexData, "href=.*nlcd.*?bin.gz")
    indexData <- indexData[!is.na(indexData)]
    indexData <- substring(indexData, 7)
    print(indexData)
    i <- scan(n=1)
    
    httpFile <- paste(httpSite, indexData[i], sep="")
    
    download.file(httpFile, paste("./aersurface/", indexData[i], sep=""))
    gunzip( paste("./aersurface/", indexData[i], sep=""), 
            destname=paste("./aersurface/", gsub("[.]gz$", "",
                      indexData[i]), sep=""), overwrite=TRUE)
    
    
  } else {
    httpFile <- paste(httpSite, stateFile, sep="")
    download.file(httpFile, paste("./aersurface/", stateFile, sep=""))
    if(grepl("[.]gz$", stateFile)) {
      gunzip( paste("./aersurface/", stateFile, sep=""), 
        destname=paste("./aersurface/", gsub("[.]gz$", "", stateFile), sep=""),
              overwrite=TRUE)
    }
    return(destname)
  }
}
  
  readLocSurf = function(year){
    ishFile <- grep("[.]ish$", dir(path=paste(year, "/", sep="")), value=TRUE)
    TD3505<-read.fwf(file=paste("./", year, "/", ishFile, sep=""), widths=c(4,6,5,4,2,2,2,2,1,6,7,5,5,5,4,3,1,1,4,1,5,1,1,1,6,1,1,1,5,1,5,1,5,1), n=1)
    td_names<-c(
      "total_variable_characters",
      "USAF_master_station",
      "NCDC_WBAN_identifier",
      "year",
      "month",
      "day",
      "UTC_hour",
      "UTC_minute",
      "data_source_flag",
      "lattitude",
      "longitude",
      "report_type",
      "elevation_relative_msl",
      "call_letter_id",
      "QA_process",
      "wd",
      "wind_direction_quality_code",
      "wind_observation_type_code",
      "ws",
      "wind_speed_quality_code",
      "ceiling_height_dimension",
      "ceiling_height_quality_code",
      "ceiling_determination_code",
      "CAVOK",
      "visibility",
      "visibility_distance_quality_code",
      "visibility_quality_code",
      "visibility_variability_code",
      "air_temperature",
      "air_temperature_quality_code",
      "dewpoint",
      "dewpoint_quality_code",
      "sea_level_pressure",
      "sea_level_pressure_quality_code")
    
    names(TD3505)<-td_names
    
    lat <- TD3505$lattitude/1000
    long <- TD3505$longitude/1000
    msl <- TD3505$elevation_relative_msl
    return(c(year=year, surf.WMO = TD3505$USAF_master_station, surf.wban = TD3505$NCDC_WBAN_identifier, surf.lat=lat,surf.long=long, surf.elev=msl))
  }
  
  
  readLocUA <- function(year){
    fslFile <- grep("[.]fsl$", dir(path=paste(year, "/", sep="")), value=TRUE)
    urDat <- read.table(paste("./",year, "/", fslFile, sep=""),skip=1, nrow=1)
    if(urDat$V1 !=1) stop(paste("Check format of Upper airfile", year,"\n"))
    WBAN <- urDat$V2
    WMO <- urDat$V3
    if(grepl("N", urDat$V4))lat <- gsub("N", "", urDat$V4)
        
    if(grepl("S", urDat$V4))lat <- gsub("N", "-", urDat$V4)
  
    
    if(grepl("W", urDat$V5)) long <- gsub("W", "", urDat$V5)
    if(grepl("E", urDat$V5)) long <- gsub("E", "", urDat$V5)
    elev <- urDat$V6
    c(year= year, ua.WMO=WMO, ua.WBAN=WBAN, ua.lat=lat,ua.long=long, ua.elev=elev)
  }
  
aerSurf.R <- function(startYear,stopYear, stateFile="choose", state="TX", stateRegion="N", 
                      radius="1.0",
                      sector="Y",
                      nsector=12,
                      temporal="S",
                      snow="N",
                      airport="Y",
                      arid="N",
                      moisture="A",  
                      pathexecutable="aersurface_exe"){
  require(plyr)
  # browser()
  # first get lattitude and longitude of surface station
  years <- seq(startYear, stopYear, by=1)
  sdExist <- sapply(as.character(years), FUN=file.exists )
  if(!all(sdExist)) stop(paste("\nSubdirectory missing for:", years[!sdExist], sep=" "))
  
  surfStation <- ldply(years, readLocSurf)
  urStation <- ldply(years, readLocUA)
  
  stationData <- merge(surfStation, urStation)

  # get binary data for landuse
  destfile <- getSurf(stateFile)
  destfile <- destfile[1]
  
  
  
 writeSurfInp <- function(year, destfile=destfile, state=state,
                          stateRegion=stateRegion, 
                          stationData=stationData,
                          radius=radius,
                          sector=sector,
                          nsector=nsector,
                          temporal=temporal,
                          snow=snow,
                          airport=airport,
                          arid=arid,
                          moisture=moisture){  
    outfile <-  paste("\"./", year, "/aersurface.out\"", sep="")
    inpfile <-  paste("./", year, "/aersurface.surfinp", sep="")
    cat(paste("\"", destfile, "\"", "\n", sep=""), file=inpfile)
    cat(paste(state, "\n", sep=""), file= inpfile, append=TRUE)
    cat(paste(stateRegion, "\n", sep=""), file=inpfile, append=TRUE)
    cat(paste(outfile, "\n", sep=""), file=inpfile, append=TRUE)
    cat(paste("LATLON", "\n"), file=inpfile, append=TRUE)
    cat(paste(stationData$surf.lat[stationData$year==year], "\n", sep=""), file=inpfile, append=TRUE)
    cat(paste(stationData$surf.long[stationData$year==year], "\n", sep=""), file=inpfile, append=TRUE)
    cat("NAD83\n", file=inpfile, append=TRUE)
    cat(paste(radius,"\n", sep=""), file=inpfile, append=TRUE)
    cat(paste(sector,"\n", sep=""), file=inpfile, append=TRUE)
    if(sector =="Y") cat(paste(nsector,"\n", sep=""), file=inpfile, append=TRUE)
    cat(paste(temporal,"\n", sep=""), file=inpfile, append=TRUE)
    cat(paste(snow,"\n", sep=""), file=inpfile, append=TRUE)
    cat(paste(airport,"\n", sep=""), file=inpfile, append=TRUE)
    cat(paste(arid,"\n", sep=""), file=inpfile, append=TRUE)
    cat(paste(moisture,"\n", sep=""), file=inpfile, append=TRUE)

  return(NULL)
  }

  # create input file

  l_ply(years, writeSurfInp, destfile=destfile, 
        state=state, 
        stateRegion=stateRegion,
        stationData=stationData,
        radius=radius,
        sector=sector,
        nsector=nsector,
        temporal=temporal,
        snow=snow,
        airport=airport,
        arid=arid,
        moisture=moisture)

  
  for(i in 1:length(years)){
    aersurface <- paste(getwd(), "/aersurface_exe/aersurface", sep="")
    inpfile <- paste("\"",years[i],"/aersurface.surfinp\"", sep="")
    if (R.version$os !="linux-gnu"){
      shell(paste(aersurface, "<", inpfile, sep="" ))
    }else{
      if(R.version$os =="linux-gnu")
        system(aersurface, input=paste(filePrefix, years[i],".inp", sep=""))
    }
}

  
  
  
  
  
}