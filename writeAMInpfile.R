# create aerminute input files

writeAMInpfile <- function(inpname="AM", ifg="y", start, stop)
{
  require(stringr)
  years <- seq(start, stop, by=1)
  sdExist <- sapply(as.character(years), FUN=file.exists )
  if(!all(sdExist)) stop(paste("\nSubdirectory missing for:", years[!sdExist], sep=" "))
  
  for (i in 1:length(years)){
  myfile <- paste(inpname, as.character(years[i]), ".inp", sep="")
  myfile <- paste(".\\",years[i],"\\", myfile, sep="")

  myfiles <- dir(paste(".\\", as.character(years[i]), sep=""))
  ids <- grep("^[[:digit:]]+[[:upper:]]{4}[[:digit:]]+[.]dat",myfiles,value = FALSE)
  
  
  if(length(ids) ==0) stop("No .dat files in directory")
  
  months <- str_sub(myfiles[ids], start=14, end=16)
  
  minMonth <- sprintf("%02d", min(as.integer(months)))
  maxMonth <- sprintf("%02d", max(as.integer(months)))
  
  mminutefiles <- myfiles[ids]
  
  
  cat(paste("startend  ", minMonth,
            as.character(years[i]), maxMonth, as.character(years[i])), file=myfile)
  cat(paste("\nifwgroup", ifg), file=myfile, append=TRUE)
  cat("\n\nDATAFILE STARTING\n", file=myfile, append=TRUE)
  write(mminutefiles, file=myfile, append=TRUE)
  cat("DATAFILE FINISHED\n",file=myfile, append=TRUE)
  
  ids <- grep(".ish", myfiles)
  ishfile <- myfiles[ids]
  
  cat("\nSURFDATA STARTING\n", file=myfile, append=TRUE)
  write(ishfile, file=myfile, append=TRUE)
  cat("SURFDATA FINISHED\n", file=myfile, append=TRUE)
  
  cat("\nOUTFILES STARTING\n", file=myfile, append=TRUE)
  cat(paste("hourfile", paste(inpname, "1min", as.character(years[i]),
                              "11059.dat", sep="_")), file=myfile, append=TRUE)
  cat(paste("\nsummfile", paste(inpname, "1min", as.character(years[i]),
                                "summ","11059.dat", sep="_")), file=myfile, append=TRUE)
  
  cat(paste("\ncompfile", paste(inpname, "1min", as.character(years[i]),
                                "summ","11059.dat", sep="_")), file=myfile, append=TRUE)
  
  cat("\nOUTFILES FINISHED", file=myfile, append=TRUE)
  
  
  }
}
