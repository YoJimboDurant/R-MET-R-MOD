
# read td3505 function
library(ggplot2)
library(openair)
library(circular)
library(Hmisc)


#Relative Humidity
relativeHumidity=function(temp, dewpoint){
DBK = temp + 273.15
DPK = dewpoint + 273.15

TTDB = (1.0/273.15) - (1.0/DBK)
TTDP = (1.0/273.15) - (1.0/DPK)

VPSAT = 6.11 * exp(5418.0 * TTDB)
VPACT = 6.11 * exp(5418.0 * TTDP)

RH = 100. * (VPACT/VPSAT)
return(RH)
}




##################################################################################################
#now lets try and use the GF1 code to calculate a cloud cover, starting with total cloud cover
convertGF1=function(test1){
GF1_CT<-as.numeric(substr(test1$GF1, start=4, stop=5))
 cloud_cover_total<-NULL
for (i in 1:length(GF1_CT)){
if( is.na(GF1_CT[i]) ) cloud_cover_total[i]<-99
else if (GF1_CT[i]<=1) cloud_cover_total[i]<-GF1_CT[i]/10
else if (GF1_CT[i]<=5) cloud_cover_total[i]<-GF1_CT[i]+1
else if (GF1_CT[i]<=8) cloud_cover_total[i]<-GF1_CT[i]+2
else if (GF1_CT[i]==10) cloud_cover_total[i]<-10
else cloud_cover_total[i]<-NA

}
GF1_CO<-as.numeric(substr(test1$GF1, start=6, stop=7))
cloud_cover_op<-NULL
for (i in 1:length(GF1_CO)){
if( is.na(GF1_CO[i]) ) cloud_cover_op[i]<-99
else if (GF1_CO[i]<=1) cloud_cover_op[i]<-GF1_CO[i]/10
else if (GF1_CO[i]<=5) cloud_cover_op[i]<-GF1_CO[i]+1
else if (GF1_CO[i]<=8) cloud_cover_op[i]<-GF1_CO[i]+2
else if (GF1_CO[i]==10) cloud_cover_op[i]<-10
else cloud_cover_op[i]<-NA
}

test1$gf1cct<-cloud_cover_total
test1$gf1cco<-cloud_cover_op

test1$gf1qa<-as.numeric(substr(test1$GF1, start=8, stop=8))


is.na(test1$gf1cct)<-test1$gf1cct==99
is.na(test1$gf1cco)<-test1$gf1cct==99





return(test1)
}









readTD3505_noaa=function(station_ID,WBAN=99999,start,stop){

i=0
TD3505_return<-NULL
year=start

while(year<=stop)
{
year=start+i



#read a file into data frame from TD3505 data (required fields)



TD3505<-read.fwf(file=gzcon(url(paste("ftp://ftp.ncdc.noaa.gov/pub/data/noaa/",year,"/",station_ID,"-",WBAN,"-",year,".gz", sep="")))
, widths=c(4,6,5,4,2,2,2,2,1,6,7,5,5,5,4,3,1,1,4,1,5,1,1,1,6,1,1,1,5,1,5,1,5,1))

close(gzcon(url(paste("ftp://ftp.ncdc.noaa.gov/pub/data/noaa/",year,"/",station_ID,"-",WBAN,"-",year,".gz", sep=""))))

td_names<-c(
"total_variable_characters",
"USAF_master_station",
"NCDC_WBAN_identifier",
"year",
"month",
"day",
"UTC_hour",
"UTC_minute",
"data_source_flag",
"lattitude",
"longitude",
"report_type",
"elevation_relative_msl",
"call_letter_id",
"QA_process",
"wd",
"wind_direction_quality_code",
"wind_observation_type_code",
"ws",
"wind_speed_quality_code",
"ceiling_height_dimension",
"ceiling_height_quality_code",
"ceiling_determination_code",
"CAVOK",
"visibility",
"visibility_distance_quality_code",
"visibility_quality_code",
"visibility_variability_code",
"air_temperature",
"air_temperature_quality_code",
"dewpoint",
"dewpoint_quality_code",
"sea_level_pressure",
"sea_level_pressure_quality_code")

names(TD3505)<-td_names

#now to futz with the variable codes....

#first read into the lines of data

var_TD3505<-readLines(con=gzcon(url(paste("ftp://ftp.ncdc.noaa.gov/pub/data/noaa/",year,"/",station_ID,"-",WBAN,"-",year,".gz", sep=""))))
close(gzcon(url(paste("ftp://ftp.ncdc.noaa.gov/pub/data/noaa/",year,"/",station_ID,"-",WBAN,"-",year,".gz", sep=""))))

# now we need to trim the lines

var_TD3505<-substr(var_TD3505, start=106, stop=1000L)

#now scan lines for AA101 presence and location


#make a list of what we are looking for

code_list<-c("AA101","AG1","GA1","GA2","GA3","GA4","GA5","GA6","GD1","GD2","GD3","GD4","GD5","GD6","GF1","MA1","MW1","MW2")
code_length_head<-c(5,rep(3,17))
code_length<-c(6,4,2,2,2,2,2,2,1,1,1,1,1,1,5,12,3,3)
code_length<-code_length+code_length_head


wx_index<-sapply(code_list, FUN=regexpr, text=var_TD3505)
wx_index<-data.frame(wx_index)

#replace -1 with NA
wx_index[wx_index==-1]<-NA

wx_index_start<-wx_index+code_length_head
wx_index_stop<-wx_index_start+code_length-1

# now we can do this or something like it
TD3505$AA101<-(substr(var_TD3505, start=wx_index$AA101, wx_index$AA101+code_length[1]-1))
TD3505$AG1<-(substr(var_TD3505, start=wx_index$AG1, stop=wx_index$AG1+code_length[2]-1))
TD3505$GA1<-(substr(var_TD3505, start=wx_index$GA1, stop=wx_index$GA1+code_length[3]-1))
TD3505$GA2<-(substr(var_TD3505, start=wx_index$GA2, stop=wx_index$GA2+code_length[4]-1))
TD3505$GA3<-(substr(var_TD3505, start=wx_index$GA3, stop=wx_index$GA3+code_length[5]-1))
TD3505$GA4<-(substr(var_TD3505, start=wx_index$GA4, stop=wx_index$GA4+code_length[6]-1))
TD3505$GA5<-(substr(var_TD3505, start=wx_index$GA5, stop=wx_index$GA5+code_length[7]-1))
TD3505$GA6<-(substr(var_TD3505, start=wx_index$GA6, stop=wx_index$GA6+code_length[8]-1))


TD3505$GD1<-(substr(var_TD3505, start=wx_index$GD1, stop=wx_index$GA1+code_length[9]-1))
TD3505$GD2<-(substr(var_TD3505, start=wx_index$GD2, stop=wx_index$GA2+code_length[10]-1))
TD3505$GD3<-(substr(var_TD3505, start=wx_index$GD3, stop=wx_index$GA3+code_length[11]-1))
TD3505$GD4<-(substr(var_TD3505, start=wx_index$GD4, stop=wx_index$GA4+code_length[12]-1))
TD3505$GD5<-(substr(var_TD3505, start=wx_index$GD5, stop=wx_index$GA5+code_length[13]-1))
TD3505$GD6<-(substr(var_TD3505, start=wx_index$GD6, stop=wx_index$GA6+code_length[14]-1))

TD3505$GF1<-substr(var_TD3505, start=wx_index$GF1, stop=wx_index$GF1+code_length[15]-1)

TD3505$MA1<-(substr(var_TD3505, start=wx_index$MA1, stop=wx_index$MA1+code_length[16]-1))

TD3505$MW1<-(substr(var_TD3505, start=wx_index$MW1, stop=wx_index$MW1+code_length[17]-1))

TD3505$MW2<-(substr(var_TD3505, start=wx_index$MW2, stop=wx_index$MW2+code_length[18]-1))




#next step is to put a date field to the records:

dates<-ISOdate(TD3505$year,TD3505$month,TD3505$day, TD3505$UTC_hour, TD3505$UTC_minute, tz="UTC")
TD3505$date<-dates

is.na(TD3505$wd) <- TD3505$wd == 999
is.na(TD3505$ws) <- TD3505$ws == 9999
is.na(TD3505$air_temperature)<-TD3505$air_temperature == 9999

TD3505$ws<-TD3505$ws/10
TD3505$temp<-TD3505$air_temperature/10
is.na(TD3505$ceiling_height_dimension)<-TD3505$ceiling_height_dimension==99999
is.na(TD3505$temp)<-TD3505$temp==999.9
is.na(TD3505$dewpoint)<-TD3505$dewpoint==9999
TD3505$dewpoint<-TD3505$dewpoint/10

TD3505$relative_humidity<-relativeHumidity(TD3505$temp, TD3505$dewpoint)

TD3505_return<-rbind(TD3505_return,TD3505)


i=i+1


}

TD3505_return<-convertGF1(TD3505_return)
return(TD3505_return)

}

# Make a function to help get and write the files (since ISSO in its wisdom does not provide a file zip that works
# with gzip)


writeTD3505=function(station_ID, WBAN=99999, start, stop){
years <- seq(start, stop, by=1)
for(i in 1:length(years))
{
    year=years[i]
    fileout<-readLines(con=gzcon(url(paste("ftp://ftp.ncdc.noaa.gov/pub/data/noaa/",year,"/",station_ID,"-",WBAN,"-",year,".gz", sep=""))))
    write(fileout, file=paste("S",station_ID,"_",year))
}

return(NULL)
}

make_calms_less1 <- function(td3505, calm_speed=1) {

td3505$ws_old <- td3505$ws
td3505$wd_old <- td3505$wd


td3505$wd[td3505$ws<calm_speed]<- 0
td3505$ws[td3505$ws<calm_speed] <-0

return(td3505)


}


