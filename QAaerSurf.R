#QAaerSurf. A function to QA and visualize output of AERSURFACE program
# still in development

QAaersurf.R <- function(domainFile="albedo_bowen_domain.txt"){
library(stringr)
library(sp)  
library(raster)  
library(rgdal)  
library(rgeos)  
library(spdep)  
library(reshape2)
library(OpenStreetMap)
library(ggplot2)
library(ggmap)


# read albedo_bowen_domain

albDom <- readLines(domainFile)

x <- grep("xllcorner", albDom,  value=TRUE)
y <- grep("yllcorner", albDom,  value=TRUE)

x <- as.numeric(str_extract(x, "[-]?[[:digit:]]+[.][[:digit:]]"))
y <- as.numeric(str_extract(y, "[-]?[[:digit:]]+[.][[:digit:]]"))

llcorner <- project(cbind(x,y), "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs", inv=TRUE)
#


# lons <- lons[order(lons)]


surfData <- grep("[[:digit:]]{2}[[:blank:]]", albDom, value=TRUE)
sData <- read.table(textConnection(surfData)) 

lons <- seq(x, x+((dim(sData)[1]-1)*30), by=30)
lats <- seq(y, y+((dim(sData)[2]-1)*30), by=30)
lats <- lats[order(-lats)]  # start in upper left corner

latts <- outer(lats, rep(1, length(lats)))
longs <- outer(rep(1, length(lons)), lons)


surfData <- melt(sData)
surfData$x <- as.vector(longs)+15 # 15m added to get to center of box
surfData$y <- as.vector(latts)+15 # 15m added to get to center of box

#latlong <- project(cbind(surfData$x,surfData$y), "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs", inv=TRUE)
# for some reason this seems off a little bit. I looked in the metadata
# and there are some data on projections:

# Horizontal_Coordinate_System_Definition:
#   Planar:
#   Map_Projection:
#   Map_Projection_Name: Albers Conical Equal Area
# Albers_Conical_Equal_Area:
#   Standard_Parallel: 29.5
# Standard_Parallel: 45.5
# Longitude_of_Central_Meridian: -96.0
# Latitude_of_Projection_Origin: 23.0
# False_Easting: 0
# False_Northing: 0
# Planar_Coordinate_Information:
#   Planar_Coordinate_Encoding_Method: row and column
# Coordinate_Representation:
#   Abscissa_Resolution: 30.0
# Ordinate_Resolution: 30.0
# Planar_Distance_Units: meters
# Geodetic_Model:
#   Horizontal_Datum_Name: North American Datum 1983
# Ellipsoid_Name: Geographic Reference System 80
# Semi-major_Axis: 6378137
# Denominator_of_Flattening_Ratio: 298.257

# it seems puzzling to me that llcorner and ulcorner are so close

latlong <- project(cbind(surfData$x,surfData$y), "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83", inv=TRUE)

ulcorner <- c(max(latlong[,2]), min(latlong[,1]))
lrcorner <- c(min(latlong[,2]), max(latlong[,1]))

surfData$lattitude <- latlong[,2]
surfData$longitude <- latlong[,1]

# load landuse table from AERSURFACE manual
landuse <- read.csv("landuse.csv")

surfData <- merge(surfData, landuse)
surfData$category <-factor(surfData$category)
surfData$color <-factor(surfData$color)

g1 <- ggplot(surfData, aes(x=longitude, y=lattitude, colour=category)) +geom_point()
g1+scale_color_manual(values=levels(surfData$color))+theme_bw()

meanlat <- mean(surfData$lattitude)
meanlon <- mean(surfData$longitude)

bmap <- get_map(location=c(lon=meanlon, lat=meanlat), maptype="satellite", zoom=13)

ggmap(bmap)+geom_point(data=surfData, aes(x=longitude, y=lattitude, colour=category, alpha=1/10))

domainFile <- gsub("[.].*", "", domainFile )
#browser()
pdf(file=paste("./aersurface/", domainFile,".pdf", sep=""), width=24, height=24)
print(ggmap(bmap))
print(ggmap(bmap)+geom_point(data=surfData, aes(x=longitude, y=lattitude, colour=category))+scale_color_manual(values=levels(surfData$color))+theme_bw()+ ggtitle("Albedo Bowen Domain"))
dev.off()

return(NULL)
}

