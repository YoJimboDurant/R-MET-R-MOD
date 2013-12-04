# readS1qaRpt reads Stage 1 report from AERMET and summarizes variables
# that were QA'd. Called by stage1Rpt.R. 

readS1qaRpt <- function(rFile){
  require(lubridate)
  rLines <- readLines(rFile)
  
  qaStart <- grep("SURFACE DATA", rLines) +3
  qaStop <- grep("NOTE: Test values", rLines) -2
  
  qaData <- read.fwf(textConnection(rLines[qaStart:qaStop]), c(-7,4,-1,7,-1,8, -1, 8, -1, 8,
                                                     -1,8,-1,8, -1,8,-1,8))
  qaData$V7 <- gsub(",", "", qaData$V7)
  qaData$V8 <- gsub(",", "", qaData$V8)
  names(qaData) <- c("Parameter", "totalObs", "Missing", "violateLB", "violateUB", "Accepted", "missingFlag",
                     "lowerBound", "upperBound")
  
  # get date for data
  theDate <- grep("The Extract Dates Are:    Starting:", rLines, value=TRUE)[1]
  theDate <- gsub("          The Extract Dates Are:    Starting:  ", "", theDate)
  theDate <- dmy(theDate)
  
  qaData$date <- theDate
  return(qaData)
}
