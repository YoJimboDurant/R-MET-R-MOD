# compAermin reads the comparison files from aerminute and produces diagnostic plots
# using the package openair' model comparison functions

compAermin <- function(startYear, stopYear, makePDF=FALSE, outfile="compAermin.pdf", sumFilePattern="_comp_.*\\.dat"){
  require(openair)
  require(lubridate)
  
  years <- seq(startYear, stopYear, by=1)
  sdExist <- sapply(as.character(years), FUN=file.exists )
  if(!all(sdExist)) stop(paste(years[!sdExist], "year directory does not exist \n"))
  
  if(makePDF) pdf(outfile, height=11)
  for (i in 1:length(years)){
    compFile <- dir(paste("./",years[i], sep=""))
    compFile <- grep(sumFilePattern, compFile, value=TRUE)
    compData <- read.csv(file=paste("./",years[i],"/", compFile, sep=""), header=TRUE)
    names(compData) <- tolower(names(compData))
    names(compData)[names(compData)== "date.yyyymmdd."] <- "date"
    # function to elim 999.00 and 999 as NA
    naFun1 <- function(x){
      x[x==999.0|x == -999.0 |x==999.9] <- NA
      return(x)
    }
    
    compData[vapply(compData, is.numeric, TRUE)] <- apply(compData[vapply(compData, 
                                                                       is.numeric, TRUE)], MARGIN=2, FUN=naFun1)
 
    compData$date <- ymd(compData$date) + (60* compData$hour) - 60
    compData$hr <- NULL
    
    TaylorDiagram(compData, obs="obs..dir", mod="x1.min.dir10", main=paste("Wind Direction", compFile, years[i]))
    TaylorDiagram(compData, obs="obs..speed", mod="x1.min.speed_1", main=paste("Wind Speed", compFile, years[i]))
  }
  
  if(makePDF) dev.off()
  
}