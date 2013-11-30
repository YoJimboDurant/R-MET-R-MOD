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


writeAermetInp <- function(startYear, stopYear, tzCor=6,...){
  source("aerSurf.R")
  require(plyr)
  require(gdata)
  years <- seq(startYear, stopYear, by=1)
  sdExist <- sapply(as.character(years), FUN=file.exists )
  if(!all(sdExist)) stop(paste("\nSubdirectory missing for:", years[!sdExist], sep=" "))

  surfStation <- ldply(years, readLocSurf)
  urStation <- ldply(years, readLocUA)

  stationData <- merge(surfStation, urStation)

  l_ply(years, writeS1, stationData=stationData, tzCor=tzCor)

}


# writeAermetInp(2006,2010)

runAermetS1 <- function(startYear, stopYear){

  require(plyr)
  years <- seq(startYear, stopYear, by=1)
  sdExist <- sapply(as.character(years), FUN=file.exists )
  if(!all(sdExist)) stop(paste("\nSubdirectory missing for:", years[!sdExist], sep=" "))

  l_ply(years, function(year, src="./aermet_exe/aermet"){
      outfile <- paste("./",year,"/","aermet", sep="")
      if(!file.exists(outfile)) file.copy(src, outfile)
  }, .progress="text")

  l_ply(years, function(year, S1Name="S1.INP"){
      infile <- paste("./",year,"/",S1Name, sep="")
      outfile <- paste("./",year,"/","AERMET.INP", sep="")
      file.copy(infile, outfile)
  }, .progress="text")

    l_ply(years, function(year){
      setwd(as.character(year))
      system("aermet")
      setwd("..")
       }, .progress="text")


  return(NULL)
}




