# writeFSL.R reads upper air data from NOAA website using RCurl and 
# writes to year directory


writeFSL <- function(WMO, startYear, stopYear){
  require(RCurl)
# Internet options for Windows

if (R.version$os !="linux-gnu"){
  setInternet2(use = NA) 
  setInternet2(use = FALSE) 
  setInternet2(use = NA) 
}

  # check is directories exist and if not, create them
  years <- seq(startYear, stopYear, by=1)
  sdExist <- sapply(as.character(years), FUN=file.exists )
  sapply(as.character(years[!sdExist]), FUN=dir.create, showWarnings=FALSE)





# this is how to do it:

for (i in 1:length(years)){
    qForm <- postForm("http://www.esrl.noaa.gov/raobs/intl/GetRaobs.cgi",
                  shour = "All Times",
                  ltype = "All Levels",
                  wunits ="Knots",
                  bdate = paste(years[i], "010100", sep=""),
                  edate = paste(years[i], "123123", sep=""),
                  access ="WMO Station Identifier",
                  view="NO",
                  osort="Station Series Sort",
                  StationIDs = WMO, 
                  oformat = "FSL format (ASCII text)",
                  SUBMIT = "Continue Data Access")

    tempFile <- paste("http://www.esrl.noaa.gov/raobs/", str_extract_all(qForm, "temp..*tmp"), sep="")

    download.file(tempFile, paste("./", years[i],"/", WMO, startYear, stopYear,".fsl", sep=""))
  }
  
  return(NULL)
}
