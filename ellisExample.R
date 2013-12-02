# this demonstrates the workings of the 4 functions to get TD6405 AERMINUTE DATA, TD3505 hour data, and create input files, then run AERMINUTE

# this demonstrates the workings of the 4 functions to get TD6405 AERMINUTE DATA, TD3505 hour data, and create input files, then run AERMINUTE

source("writeTD6405.R")
source("writeTD3505.R")
source("writeAMInpfile.R")
source("runAerminute.R")
source("writeFSL.R")

source("writeAERMETinp.R")
source("aerSurf.R")

writeTD6405("KDFW", 2006,2010)
writeTD3505(722590,"03927", 2006, 2010) 
writeAMInpfile(ifg="n", start=2006, stop=2010)
runAerminute(2006,2010)

writeFSL(72249, 2006, 2010)
aerSurf.R(2006,2010)
writeAermetInp(2006,2010)
