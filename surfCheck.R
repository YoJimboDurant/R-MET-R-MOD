## Uses surfReader to read surface files then plot
## using openair windrose then scatterplots and boxplots
## 


library(Hmisc)
library(openair)

## This reads a table into a aermet surface file called surface_file_1, skipping the first line

surfCheck <- function(startYear, stopYear, outfile="surfaceFile.pdf", file.choose=FALSE){
  source("surfaceReader.R")
  library(plyr)
  
  if(file.choose){
    sFile<-file.choose()
    surface_file_1 <- surfaceReader(sFile)
  }else{
    years <- seq(startYear, stopYear, by=1)
    sdExist <- sapply(as.character(years), FUN=file.exists )
    if(!all(sdExist)) stop(paste("\nSubdirectory missing for:", years[!sdExist], sep=" "))
    sFile <- paste("./", years, "/AM_",years,".SFC", sep="")
    surface_file_1 <- ldply(sFile, surfaceReader)
  }

  



## figure out minimum and maximum dates
daterange=c(as.POSIXlt(min(surface_file_1$date)),as.POSIXlt(max(surface_file_1$date)))

## Then there is a set of small functions which implement elementary
## functionality:

surface_plot_fct=function(parameter,x_dates,factor,ylab,title){
  
  plot(x_dates,parameter,xaxt="n",ylab=ylab, xlab="Date", pch=".", col="gray")   #don't plot the x axis
  
  dates<-axis.POSIXct(1, at=seq(daterange[1], daterange[2], by="month"), format="%m-%Y") #label the x axis by months
  
  
  #lines(lowess(mean,consumed,f=3/10))   #this does not work if there are missing data
  #so, the following function fixes it
  lowess.na <- function(x, y = NULL, f = 2/3,...) {  #do lowess with missing data
    
    x1 <- subset(x,(!is.na(x)) &(!is.na(y)))
    y1 <- subset(y, (!is.na(x)) &(!is.na(y)))
    lowess.na <- lowess(x1,y1,f, ...)
  }
  
  lines(lowess.na(x_dates,parameter,f=factor/10))   #this does work if there are missing data
  
  title(main=title)
}

if(!file.exists("./output")) dir.create("./output")
pdf(file="./output/surfaceFile.pdf")
windRose(surface_file_1)
surface_plot_fct(surface_file_1$ws,surface_file_1$date, ylab="Wind Speed (m/s)", title="Surface File Wind Speed", factor=1)
surface_plot_fct(surface_file_1$wd,surface_file_1$date, ylab="Wind Direction", title="Wind Direction", factor=1)
surface_plot_fct(surface_file_1$sensible_heat_flux,surface_file_1$date,factor=1, ylab = expression(paste("Sensible Heat Flux ( ", W/m^2, ")", sep = "")), title="Sensible Heat Flux")
boxplot(surface_file_1$sensible_heat_flux~surface_file_1$month, ylab=expression(paste("Sensible Heat Flux (", W/m^2, ")", sep = "")), xlab="Month", main="Sensible Heat Flux by Month")
boxplot(surface_file_1$sensible_heat_flux~surface_file_1$hour, ylab=expression(paste("Sensible Heat Flux (", W/m^2, ")", sep = "")), xlab="Hour", main="Sensible Heat Flux by Hour")
surface_plot_fct(surface_file_1$surface_friction_velocity, surface_file_1$date, factor=1, ylab = expression(paste("Surface Friction Velocity ( ", m/s, ")", sep = "")), title="Surface Friction Velocity")
surface_plot_fct(surface_file_1$convective_velocity_scale, surface_file_1$date, factor=1, ylab = expression(paste("Convective Velocity Scale ( ", m/s, ")", sep = "")), title="Convective Velocity Scale")
surface_plot_fct(surface_file_1$verticle_potential_temperature, surface_file_1$date, factor=1, ylab = "Vertical Potential Temperature",title="Vertical Potential Temperature Gradient above PBL")
surface_plot_fct(surface_file_1$height_conv_pbl, surface_file_1$date, factor=1, ylab="Height CBL (m)", title="Height of Convective Boundary Layer")
surface_plot_fct(surface_file_1$height_mech_sbl, surface_file_1$date, factor=1, ylab="Height SBL (m)", title="Height of Stable Boundary Layer")
surface_plot_fct(surface_file_1$monin_obukhov_length, surface_file_1$date, factor=1, ylab="Monin-Obukhov Length (m)", title="Monin-Obukhov Length")
boxplot(surface_file_1$monin_obukhov_length~surface_file_1$month, ylab="Monin-Obukhovlenght(m)", xlab="Month",main="Monin-Obukhov Length by Month")
boxplot(surface_file_1$monin_obukhov_length~surface_file_1$hour, ylab="Monin-Obukhovlenght(m)", xlab="Hour",main="Monin-Obukhov Length by Hour")
surface_plot_fct(surface_file_1$temperature, surface_file_1$date, factor=1, ylab="Temperature (K)", title="Temperature")
boxplot(surface_file_1$temperature~surface_file_1$month, ylab="Temperature (K)", xlab="Month", main="Temperature by Month")
boxplot(surface_file_1$temperature~surface_file_1$hour, ylab="Temperature (K)", xlab="Hour", main="Temperature by Hour")
surface_plot_fct(surface_file_1$relative_humidity, surface_file_1$date, factor=1, ylab="Relative Humidity (%)", title="Relative Humidity")
surface_plot_fct(surface_file_1$surface_pressure, surface_file_1$date, factor=1, ylab="Surface Pressure (mb)", title="Surface Pressure")
surface_plot_fct(surface_file_1$cloud_cover, surface_file_1$date, factor=1, ylab="Cloud Cover (tenths)", title="Cloud Cover")
surface_plot_fct(surface_file_1$albedo, surface_file_1$date, factor=1, ylab="Albedo", title="Albedo")
boxplot(surface_file_1$albedo~surface_file_1$month, ylab="Albedo", xlab="Month", main="Albedo by Month")
boxplot(surface_file_1$albedo~surface_file_1$hour, ylab="Albedo", xlab="Hour", main="Albedo by Hour")

dev.off()

return(NULL)
}




