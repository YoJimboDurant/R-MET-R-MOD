# sumAermin reads the summary files from aerminute and produces diagnostic plots
# using the package openair' summary plot

sumAermin <- function(startYear, stopYear, makePDF=FALSE, outfile="sumAermin.pdf", sumFilePattern="_summ_.*\\.dat"){
  require(openair)
  
  years <- seq(startYear, stopYear, by=1)
  sdExist <- sapply(as.character(years), FUN=file.exists )
  if(!all(sdExist)) stop(paste(years[!sdExist], "year directory does not exist \n"))
  
  if(makePDF) pdf(outfile, height=11)
  for (i in 1:length(years)){
    sumFile <- dir(paste("./",years[i], sep=""))
    sumFile <- grep(sumFilePattern, sumFile, value=TRUE)
    sumData <- read.csv(file=paste("./",years[i],"/", sumFile, sep=""), header=TRUE)
    names(sumData) <- tolower(names(sumData))
    
    # function to elim 999.00 and 999 as NA
    naFun1 <- function(x){
      x[x==999.00|x == 999] <- NA
      return(x)
    }
    
    sumData[vapply(sumData, is.numeric, TRUE)] <- apply(sumData[vapply(sumData, 
            is.numeric, TRUE)], MARGIN=2, FUN=naFun1)
    sumData$date <- ymd(sumData$date) + (60* sumData$hr) - 60
    sumData$hr <- NULL
    summaryPlot(sumData, na.len = 24, main=paste(sumFile, years[i]))
  }
    
  if(makePDF) dev.off()
  
}