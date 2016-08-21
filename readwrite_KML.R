# ===========================================================================================
# Read and Write KML in R
# ===========================================================================================
library(maptools)
library(rgdal)
library(sp)

# Reading KML
# ---------------------
ffg <- "/PDATA/Cellgrid/R_Exercise/Users/Serene/hecto/Delhi_Slum"
tkml <- getKMLcoordinates(kmlfile=paste0(ffg, "/NSL_Wards_KML.kml"), ignoreAltitude=T)
class(tkml)
xx <- readOGR(paste0(ffg, "/NSL_Wards_KML.kml"), "NSL_Wards_KML")
class(xx)


# Export to : 
# ==========================================================================
path <- "P:/Parth/GIS stuff/Overlay (Interaction)/gcs to indicus_geo/shapefiles/output"
# path <- "/PDATA/Parth/GIS stuff/Overlay (Interaction)/gcs to indicus_geo/shapefiles/output"
del <- readOGR(path, "wCellID4gcs7")
dim(del)                                # 1513   45

## In order for the points to be displayed in the correct place they need to be re-projected to WGS84 geographical coordinates.
p4s <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")
del84 <- spTransform(del, CRS= p4s)

## Using the OGR KML driver we can then export the data to KML. dsn should equal the name of the exported file and the dataset_options argument allows us to specify the labels displayed by each of the points.
writeOGR(del84, dsn="del84.kml", layer= "del84", driver="KML", dataset_options=c("NameField=name"))
writeOGR(del, path, dsn="del.kml", layer="del", driver="KML")


# ================================
# Ref
# ================================
## In order for the points to be displayed in the correct place they need to be re-projected to WGS84 geographical coordinates.
p4s <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")
cycle_wgs84<- spTransform(cycle, CRS= p4s)

## Using the OGR KML driver we can then export the data to KML. dsn should equal the name of the exported file and the dataset_options argument allows us to specify the labels displayed by each of the points.
writeOGR(cycle_wgs84, dsn="london_cycle_docks.kml", layer= "cycle_wgs84", driver="KML", dataset_options=c("NameField=name"))



