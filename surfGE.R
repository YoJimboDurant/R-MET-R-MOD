
sd1 <- surfData[c("longitude", "lattitude", "category")]
names(sd1)[names(sd1) %in% c("longitude", "lattitude")] <-c("x","y")
r3 <- raster(nrow=300, ncol=300, xmn=min(sd1$x), xmx=max(sd1$x), ymn=min(sd1$y), ymx=max(sd1$y), crs="+proj=longlat +ellps=WGS84 +datum=WGS84")
sd1$category <- as.numeric(factor(sd1$category))
cells <- cellFromXY(r3,sd1[,1:2])
r3[cells] <- sd1[,3]

KML(r3, "r3.kmz", overwrite=TRUE)
plot(r3)
