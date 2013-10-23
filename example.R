
# load 5 years of data into R

gwinnett <- readTD3505_noaa(747808,63803, 2006,2010)

# windRose
windRose(gwinnett)

# make calms less than 1
gwinnett <- make_calms_less1(gwinnett)
windRose(gwinnett)

# fetch 5 years of surface files
 writeTD3505(747808,63803, 2006,2010)

