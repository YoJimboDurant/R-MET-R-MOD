#mets2GoogleEarth 
# reads the Stage1 AERMET input for upper, onsite and surface location
# and exports them to Google Earth


mets2GoogleEarth <- function(startYear, stopYear){
  require(plyr)
  years <- seq(startYear, stopYear, by=1)
  sdExist <- sapply(as.character(years), FUN=file.exists )
  if(!all(sdExist)) stop(paste("\nSubdirectory missing for:", years[!sdExist], sep=" "))
  
  l_ply(years, aermet2KML)
  
}

aermet2KML <- function(year, file.choose=FALSE){
  require(stringr)
  require(maptools)
  require(rgdal)
  
  if(!file.choose) inpFile <- paste("./", year,"/S1.inp", sep="")
  
  if(file.choose) inpFile <-file.choose()
  
  impFile <- readLines(inpFile)
  locIDS <- grep("\\bUPPERAIR\\b|\\bSURFACE\\b|\\bONSITE", impFile, value=TRUE)
  locLines <- grep("\\bLOCATION\\b", impFile, value=TRUE)
  locLines <- str_join(locIDS, locLines)

  locDf <- read.table(textConnection(locLines), header=FALSE, fill=TRUE,
                      stringsAsFactors=FALSE, col.names=c("Path","Keyword","Id","Lattitude", "Longitude", "Conversion", "Elevation"))
  
  locDf$Lattitude <- gsub("N", "", locDf$Lattitude)
  if(any(grepl("S", locDf$Lattitude))){
    indx <- grepl("S", locDf$Lattitude)
    locDf$Lattitude[indx] <- gsub("S", "", locDf$Lattitude[indx])
    locDf$Lattitude[indx] <- paste("-", locDf$Lattitude[indx])
  } 
  
  locDf$Longitude <- gsub("E", "", locDf$Longitude)
  if(any(grepl("W", locDf$Longitude))){
    indx <- grepl("W", locDf$Longitude)
    locDf$Longitude[indx] <- gsub("W", "", locDf$Longitude[indx])
    locDf$Longitude[indx] <- paste("-",locDf$Longitude[indx], sep="")
  } 
  
  locDf$Lattitude <- as.numeric(locDf$Lattitude)
  locDf$Longitude <- as.numeric(locDf$Longitude)
  
  
  coordinates(locDf) <- c("Longitude", "Lattitude")
  
  proj4string(locDf)<-CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")
  if(!file.choose) outFile <- paste("./", year,"/metStations.kml", sep="")
  if(file.choose) outFile <- "metLocations.kml"
  writeOGR(locDf, dsn=outFile, layer= "cycle_wgs84", driver="KML", dataset_options=c("NameField=name"),
           overwrite_layer=TRUE)
  
  return(NULL)
}