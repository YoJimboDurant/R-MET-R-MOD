#QAaerSurf. A function to QA and visualize output of AERSURFACE program
# still in development

require(stringr)
library(sp)  
library(raster)  
library(rgdal)  
library(rgeos)  
library(spdep)  
library(reshape2)
library(RgoogleMaps)


# read albedo_bowen_domain

albDom <- readLines("albedo_bowen_domain.txt")

x <- grep("xllcorner", albDom,  value=TRUE)
y <- grep("yllcorner", albDom,  value=TRUE)

x <- as.numeric(str_extract(x, "[-]?[[:digit:]]+[.][[:digit:]]"))
y <- as.numeric(str_extract(y, "[-]?[[:digit:]]+[.][[:digit:]]"))

llcorner <- project(cbind(x,y), "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs", inv=TRUE)

#
lons <- seq(x, x+(334*30), by=30)
lats <- seq(y, y-(334*30), by=-30)
longs <- outer(lons, rep(1, length(lons)))
latts <- outer(rep(1, length(lats)), lats)

surfData <- grep("[[:digit:]]{2}[[:blank:]]", albDom, value=TRUE)
sData <- read.table(textConnection(surfData)) 
surfData <- melt(sData)
surfData$x <- as.vector(latts)+15 # 15m added to get to center of box
surfData$y <- as.vector(longs)+15 # 15m added to get to center of box

latlong <- project(cbind(surfData$x,surfData$y), "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs", inv=TRUE)

surfData$lattitude <- latlong[,2]
surfData$longitude <- latlong[,1]

bb <- qbbox(lat = surfData[,"lattitude"], lon = surfData[,"longitude"])

MyMap <- GetMap.bbox(bb$lonR, bb$latR, destfile = "./aersurface/landuse.png", GRAYSCALE = TRUE)
