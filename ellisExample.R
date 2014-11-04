# this demonstrates the workings of the 4 functions to get TD6405 AERMINUTE DATA, TD3505 hour data, and create input files, then run AERMINUTE
source("installAERMET.R") # checks and installs AERMET AERMINUTE and AERSURFACE
source("writeTD6405.R")
source("writeTD3505.R")
source("writeAMInpfile.R")
source("runAerminute.R")
source("writeFSL.R")

source("writeAERMETinp.R")
source("aerSurf.R")
source("QAaerSurf.R")

source("compAermin.R")
source("stage1Rpt.R")
source("surfCheck.R")

writeTD6405("KDFW", 2006,2010)
writeTD3505(722590,"03927", 2006, 2010) 
writeAMInpfile(ifg="n", start=2006, stop=2010)
runAerminute(2006,2010)
compAermin(2006,2010, makePDF = TRUE)

writeFSL(72249, 2006, 2010)

#
aerSurf.R(2006,2010) # use 42 (North Texas)
QAaersurf.R() # run map of input

# Do not run until aerSurf.R
writeAermetInp(2006,2010) 

runAermetS1(2006,2010, S1Name="S1")
runAermetS1(2006,2010, S1Name="S2")
runAermetS1(2006,2010, S1Name="S3")

stage1Rpt(2006,2010)
surfCheck(2006,2010)
