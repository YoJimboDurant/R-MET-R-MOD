# write AERMETinp is a set of 3 functions to create the 3 stages
# of aermet input files for AERMET.


writeS1 <- function(year, stationData, tzCor=6){
  inpFile <- paste("./", year, "/S1.INP", sep="")

  #job
  cat("JOB\n", file=inpFile)
  cat("**\n", file=inpFile, append=TRUE)
  cat("  REPORT     S1.RPT\n", file=inpFile, append=TRUE)
  cat("  MESSAGES   S1.MSG\n", file=inpFile, append=TRUE)

# upperair
  myfiles <- dir(paste("./", year, sep=""))
  fslFile <- grep("[.]FSL", myfiles, value=TRUE)
  if(length(fslFile) !=1) stop(paste("\nMISSING or DUPLICATE FSL file in year", year))

  xdates <- paste(year,"/01/01 TO ", year,"/12/31", sep="")
  ua.WBAN <- stationData$ua.WBAN[stationData$year==year]
  ua.lat <- stationData$ua.lat[stationData$year==year]
  ua.long <- stationData$ua.long[stationData$year==year]

  cat("UPPERAIR\n", file=inpFile, append=TRUE)
  cat(paste("**          Upper air data for WBAN:",
            ua.WBAN ,"FSL format\n"),
      file=inpFile, append=TRUE)


  cat(paste("  DATA      ",fslFile,"  FSL\n", sep=""), file=inpFile, append=TRUE)
  cat("  EXTRACT   UAEXOUT.DAT\n", file=inpFile, append=TRUE)
  cat(paste("  XDATES    ",xdates,"\n", sep=""), file=inpFile, append=TRUE)
  cat(paste("  LOCATION  ", ua.WBAN,"  ",ua.lat," ", ua.long," ",tzCor, "\n", sep=""),file=inpFile, append=TRUE)
  cat("  QAOUT     UAQAOUT.DAT\n", file=inpFile, append=TRUE)

  #surface
  ishFile <- grep("[.]ISH", myfiles, value=TRUE)
  if(length(ishFile) != 1) stop(paste("\nMISSING or DUPLICATE ISH file in year", year))


  surf.WBAN <- sprintf("%05d", as.numeric(stationData$surf.wban[stationData$year==year]))
  surf.lat <- stationData$surf.lat[stationData$year==year]
  surf.long <- stationData$surf.long[stationData$year==year]
  surf.elev <- stationData$surf.elev[stationData$year==year]

  cat("SURFACE\n", file=inpFile, append=TRUE)
  cat(paste("**          Surface air data for WBAN:",
            surf.WBAN ,"ISHD Format\n"),
      file=inpFile, append=TRUE)
  cat(paste("  DATA      ",ishFile,"  ISHD\n", sep=""), file=inpFile, append=TRUE)
  cat("  EXTRACT   SFEXOUT.DAT\n", file=inpFile, append=TRUE)
  cat("  AUDIT     SLVP PRES CLHT TSKC PWTH ASKY HZVS DPTP RHUM\n", file=inpFile, append=TRUE)
  cat("  RANGE TMPD -300  <=  450  999\n", file=inpFile, append=TRUE)
  cat(paste("  XDATES    ",xdates,"\n", sep=""), file=inpFile, append=TRUE)
  cat(paste("  LOCATION  ", surf.WBAN,"  ",surf.lat," ", surf.long," ",tzCor, "  ", surf.elev, "\n", sep=""),file=inpFile, append=TRUE)
  cat("  QAOUT     SFQAOUT.DAT\n", file=inpFile, append=TRUE)

}

writeS2 <- function(year, minFile=TRUE, onSite=FALSE){
  inpFile <- paste("./", year, "/S2.INP", sep="")
  #job
  cat("JOB\n", file=inpFile)
  cat("**\n", file=inpFile, append=TRUE)
  cat("  REPORT     S2.RPT\n", file=inpFile, append=TRUE)
  cat("  MESSAGES   S2.MSG\n", file=inpFile, append=TRUE)
  
  
  cat("UPPERAIR\n", file=inpFile, append=TRUE)  
  cat("  QAOUT      UAQAOUT.DAT\n", file=inpFile, append=TRUE)  
  
  cat("SURFACE\n", file=inpFile, append=TRUE)  
  cat("  QAOUT      SFQAOUT.DAT\n", file=inpFile, append=TRUE)  
  
  if(minFile){
    xfiles <- dir(paste("./", year,"/", sep=""))
    minFile <- grep("AM_1min_[[:digit:]]+_[[:digit:]]+", xfiles, value=TRUE)
  
  if(length(minFile) !=1) stop("Error identifying aerminute file output")
  
  cat(paste("  ASOS1MIN   ", minFile, "\n", sep=""), file=inpFile, append=TRUE)
  
  if(onSite){
    cat("ONSITE\n", file=inpFile, append=TRUE)  
    cat("  QAOUT      onsite.DAT\n", file=inpFile, append=TRUE)  
    
    
  }
  }

  # merge
  xdates <- paste(year,"/01/01 TO ", year,"/12/31", sep="")
  
  cat("MERGE\n", file=inpFile, append=TRUE)
  cat("  OUTPUT     AMS2_ISHD.MRG\n", file=inpFile, append=TRUE)
  cat(paste("  XDATES    ",xdates,"\n", sep=""), file=inpFile, append=TRUE)
  
  return(NULL)
  }
  
writeS3 <- function(year, anHeight=10){
  inpFile <- paste("./", year, "/S3.INP", sep="")
  #job
  cat("JOB\n", file=inpFile)
  cat("**\n", file=inpFile, append=TRUE)
  cat("  REPORT   S3.RPT\n", file=inpFile, append=TRUE)
  cat("  MESSAGES S3.MSG\n", file=inpFile, append=TRUE)

  # metprep
  xdates <- paste(year,"/01/01 TO ", year,"/12/31", sep="")
  
  cat("METPREP\n", file=inpFile, append=TRUE)
  cat(paste("  XDATES   ",xdates,"\n", sep=""), file=inpFile, append=TRUE)
  cat("  DATA     AMS2_ISHD.MRG\n",file=inpFile, append=TRUE)
  cat("  METHOD   REFLEVEL SUBNWS\n",file=inpFile, append=TRUE)
  cat("  METHOD   WIND_DIR  RANDOM\n",file=inpFile, append=TRUE)
  cat(paste("  NWS_HGT  WIND      ", anHeight, "\n", sep=""),file=inpFile, append=TRUE)
  cat(paste("  OUTPUT   AM_", year,".SFC\n", sep=""), file=inpFile, append=TRUE)
  cat(paste("  PROFILE  AM_", year,".PFL\n\n\n", sep=""), file=inpFile, append=TRUE)

  xfiles <- dir(paste("./", year,"/", sep=""))
  
  surfFile <- grep("aersurface.out", xfiles, value=TRUE)
  
  if(length(surfFile)!=1) stop (paste("Missing Surface Characteristics", year))
  
  surfsUp <- readLines(paste("./", year, "/", surfFile, sep=""))
  write(surfsUp, file=inpFile, append=TRUE)
  
  return(NULL)
}


writeAermetInp <- function(startYear, stopYear, tzCor=6, minFile=TRUE, onSite=FALSE, anHeight=10, ...){
  source("aerSurf.R")
  require(plyr)
  require(gdata)
  years <- seq(startYear, stopYear, by=1)
  sdExist <- sapply(as.character(years), FUN=file.exists )
  if(!all(sdExist)) stop(paste("\nSubdirectory missing for:", years[!sdExist], sep=" "))

  surfStation <- ldply(years, readLocSurf)
  urStation <- ldply(years, readLocUA)

  stationData <- merge(surfStation, urStation)

  #stage 1 input files written here:
  
  l_ply(years, writeS1, stationData=stationData, tzCor=tzCor)
  
  #stage 2 input files written here:
  l_ply(years, writeS2, minFile, onSite)
  
  #stage 3 input files written here:
  l_ply(years, writeS3, anHeight=anHeight)
  
}


# writeAermetInp(2006,2010)

runAermetS1 <- function(startYear, stopYear, S1Name="S1"){
# S1Name is stage of AERMET process. There are 3 stages which
# I designate S1 (Stage 1) S2 (Stage 2) and S3 (Stage 3)
  
  require(plyr)
  years <- seq(startYear, stopYear, by=1)
  sdExist <- sapply(as.character(years), FUN=file.exists )
  if(!all(sdExist)) stop(paste("\nSubdirectory missing for:", years[!sdExist], sep=" "))


  stageName <- paste(S1Name, ".INP", sep="")
  l_ply(years, function(year, S1Name=stageName){
      infile <- paste("./",year,"/",S1Name, sep="")
      outfile <- paste("./",year,"/","AERMET.INP", sep="")
      if(!file.exists(infile)) stop(paste("Missing", S1Name, "Input File"))
      file.copy(infile, outfile, overwrite=TRUE)
  }, .progress="text")

    l_ply(years, function(year){
      setwd(as.character(year))
      
      if (R.version$os !="linux-gnu"){
        
        src="../aermet_exe/aermet.exe"
        outfile <- "aermet.exe"
        if(!file.exists(outfile)) file.copy(src, outfile)
        shell("aermet.exe")
      }
      
      if (R.version$os =="linux-gnu"){
          src="../aermet_exe/aermet"
          outfile <- paste("./",year,"/","aermet", sep="")
          if(!file.exists(outfile)) file.copy(src, outfile)
          system("aermet")
      }
      setwd("..")

       }, .progress="text")


  return(NULL)
}


