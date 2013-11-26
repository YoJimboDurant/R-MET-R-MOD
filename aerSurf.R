# set up AERSURFACE and Run


getSurf.R <- function(stateFile){
    if(!file.exists(aersurface)) dir.create("aersurface")
    httpSite <- "http://edcftp.cr.usgs.gov/pub/data/landcover/states/"
    indexData <- getURI(httpSite)
    
    cleanFun <- function(htmlString) {
      return(gsub("<.*?>", "", htmlString))
    }
    
    indexData <- cleanFun(indexData)
aerSurf.R <- function(startYear,stopYear, stateFile, airport=TRUE, 
                      arid=FALSE, moisture="A", ){
  
  
  
  
}