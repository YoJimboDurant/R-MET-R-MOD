
#combine report file for stage 1 and maybe do something graphical?

stage1Rpt <- function(startYear, stopYear, outfile="S1summ.pdf"){
  
  require(reshape2)
  require(ggplot2)
  require(openair)
  years <- seq(startYear, stopYear, by=1)
  sdExist <- sapply(as.character(years), FUN=file.exists )
  if(!all(sdExist)) stop(paste("\nSubdirectory missing for:", years[!sdExist], sep=" "))
  rFile <- paste("./", years, "/S1",".RPT", sep="")
  
  S1QArpt <- ldply(rFile, readS1qaRpt)
  S1QArpt <- cutData(S1QArpt, type="year")
  S1QArpt$availData <- S1QArpt$totalObs - S1QArpt$Missing - S1QArpt$violateLB - S1QArpt$violateUB
  S1QArpt <- melt(S1QArpt[c("year", "Parameter", "availData", "Missing", 
                            "violateLB", "violateUB")], id.vars=c("year", "Parameter"))
  
  ggplot(S1QArpt, aes(x=year, y=value, fill=variable)) + geom_bar(stat="identity")+facet_wrap(~Parameter)
}

  
  
