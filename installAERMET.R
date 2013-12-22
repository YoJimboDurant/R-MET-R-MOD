
# installAERMET.R

#check and see if AERMET, AERSURFACE, and AERMINUTE is present and
# download AERMET, AERSURFACE, and AERMINUTE if it is not.


# Internet options for Windows

if (R.version$os !="linux-gnu"){
  setInternet2(use = NA) 
  setInternet2(use = FALSE) 
  setInternet2(use = NA) 
}

programTree <- list(
  aermetEx = "./aermet_exe/aermet.exe",
  aerminEx = "./aerminute_v11325/aerminute_11325.exe",
  aerSurfaceEx= "./aersurface_exe/aersurface.exe")



# check to see if the programTree does not exist:
aermetExists <- sapply(programTree, file.exists)

if(!all(aermetExists)){
print("The following Aermet executable files are missing:")
print(programTree[!aermetExists])

}

if(!aermetExists[1]){
  print("downloading aermet")
  download("http://www.epa.gov/ttn/scram/7thconf/aermod/aermet_exe.zip", "aermet_exe.zip", mode = "wb")
  unzip("aermet_exe.zip", exdir="./aermet_exe")
  
}


if(!aermetExists[2]){
  print("downloading aermet")
  download("http://www.epa.gov/ttn/scram/7thconf/aermod/aerminute_v11325.zip", "aerminute_v11325.zip", mode = "wb")
  unzip("aerminute_v11325.zip", exdir="./aerminute_v11325")
  
}


if(!aermetExists[3]){
  print("downloading aersurface")
  download("http://www.epa.gov/ttn/scram/7thconf/aermod/aersurface_exe.zip", "aersurface_exe.zip", mode = "wb")
  unzip("aersurface_exe.zip", exdir="./aersurface_exe")
  
}