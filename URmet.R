# URMET 2nd Gig
#
#
#
# Attempt to improve performace of URMET
#
#
#
# Author: Jim Durant (hzd3@cdc.gov)
#
#


# first read the lines into a df
lines<-read.table(file=file.choose(), fill=TRUE)

datelines<- lines[lines$V1==254,]

# now this is INTERESTING... the rownames contain the row number that the
# new record starts at. Therefore, if I take the rownames and add 4 I can get the start and end
# of the profile....


startlines<-as.numeric(rownames(datelines))
endlines<-c(startlines,  dim(lines)[1])
endlines<-endlines[-1]

datelines$length<-(endlines-startlines-4)

repfunction=function(x){
  times<-x[8]
  x<-data.frame(x)
  apply(x, MARGIN=2, FUN=rep, times)
}

dateline<-apply(datelines, MARGIN=1, FUN=repfunction) 

dateline<-matrix(unlist(dateline), byrow=TRUE, ncol=8)

#add one extra line

dateline<-rbind(dateline, dateline[dim(dateline)[1],])

dateline<-data.frame(dateline)


pressurelines<-lines[lines$V1!=254 &lines$V1!=1 &lines$V1!=2 &lines$V1!=3,]


upperair<-cbind(dateline, pressurelines)

upperair$date<-strptime(paste(upperair$X5, upperair$X4, upperair$X3, upperair$X2), format="%Y %b %d %H")

names(upperair)<-c("X1", "Hour", "Day", "Month", "Year", "X6","X7", "X8", "LINTYP", "press", "alt", "temp", "dewpt", "dir", "wspd", "date")


upperair$press<-as.numeric(as.character(upperair$press))

upperair$alt<-as.numeric(as.character(upperair$alt))


upperair$temp<-as.numeric(as.character(upperair$temp))

upperair$dewpt<-as.numeric(as.character(upperair$dewpt))

is.na(upperair$press) <- upperair$press == 99999
is.na(upperair$temp) <- upperair$temp == 99999
is.na(upperair$dewpt) <- upperair$dewpt == 99999
is.na(upperair$dir) <- upperair$dir == 99999
is.na(upperair$wspd) <- upperair$wspd == 99999
is.na(upperair$alt) <- upperair$alt == 99999

# now to get into format for plotskew

upperair$press<-upperair$press/10
upperair$temp<-upperair$temp/10
upperair$dewpt<-upperair$dewpt/10

upperair$date<-as.POSIXct(upperair$date)


library(ggplot2)

ggplot(upperair, aes(x=press, y=temp, group=as.factor(date)))+geom_smooth(alpha=1/10)+coord_flip()+scale_x_reverse()


g<-ggplot(upperair[!is.na(upperair$temp),], aes(x=press, y=temp, group=as.factor(date)))+geom_line()+coord_flip()+scale_x_reverse() +facet_wrap(~Hour, nrow=2)
g

library(openair)
newupper<-cutData(upperair, type="season")

#morning soundings by season
g<-ggplot(newupper[!is.na(newupper$temp)& as.numeric(as.character(newupper$Hour))==0,], aes(x=press, y=temp, group=as.factor(date)))+geom_line(alpha=1/10)+coord_flip()+scale_x_reverse() +facet_wrap(~season, nrow=2)
g
