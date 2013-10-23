
                                        #startend  01 2000 12 2000
                                        #ifwgroup  n

mydir <- setwd("C:\\Temp\\NPNE")
inpname <- "NP"
subdir <-2000:2012
i <- 13
ifg="y"

setwd(as.character(subdir[i]))
myfile <- paste(inpname, as.character(subdir[i]), ".inp", sep="")

cat(paste("startend  01",
	as.character(subdir[i]), "12", as.character(subdir[i])), file=myfile)
cat(paste("\nifwgroup", ifg), file=myfile, append=TRUE)
ids <- grep(".dat", myfiles)
mminutefiles <- myfiles[ids]

cat("\n\nDATAFILE STARTING\n", file=myfile, append=TRUE)
write(mminutefiles, file=myfile, append=TRUE)
cat("DATAFILE FINISHED\n",file=myfile, append=TRUE)

ids <- grep(".ish", myfiles)
ishfile <- myfiles[ids]

cat("\nSURFDATA STARTING\n", file=myfile, append=TRUE)
write(ishfile, file=myfile, append=TRUE)
cat("SURFDATA FINISHED\n", file=myfile, append=TRUE)

cat("\nOUTFILES STARTING\n", file=myfile, append=TRUE)
cat(paste("hourfile", paste(inpname, "1min", as.character(subdir[i]),
	"11059.dat", sep="_")), file=myfile, append=TRUE)
cat(paste("\nsummfile", paste(inpname, "1min", as.character(subdir[i]),
	"summ","11059.dat", sep="_")), file=myfile, append=TRUE)

cat(paste("\ncompfile", paste(inpname, "1min", as.character(subdir[i]),
	"summ","11059.dat", sep="_")), file=myfile, append=TRUE)

cat("\nOUTFILES FINISHED", file=myfile, append=TRUE)





