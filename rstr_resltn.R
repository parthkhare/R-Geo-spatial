# ===========================================================================================
# CODE: Change Raster Resolution
# ===========================================================================================

rm(list =ls())
# ===========================================================================================
library(maptools)
library(raster)
library(rgeos)
library(foreign)
require(rgdal)
require(sp)
# ===========================================================================================


# Data Import
# ===========================================================================================
pth.rv <- "G:/ADE_GRID/Experimentation&Testing/HectoGrid/R&D/NDBI SAVI/Test_SpatialIndices_July2015"
pth2 <- "G:/ADE_GRID/Experimentation&Testing/HectoGrid/R&D/NDBI SAVI/Raw files 30m"

# SAVI: IMport Data at 100m
# ------------
savi100 <- readGDAL(paste0(pth2,"/DelhiNCR_SAVI_R.tif")) # , as.is=TRUE
dim(savi100)                            # 3,66,947 3
table(is.na(savi100$band1))             # 1,95,336
proj4string(savi100)
sv100 <- raster(savi100)
class(sv100)

# SAVI: IMport Data at 30m
# ------------
savi30 <- readGDAL(paste0(pth2,"/DelhiNCR_SAVI.tif")) # , as.is=TRUE
dim(savi30)                            # 4,57,560 1
table(is.na(savi30$band1))             # 2,175,472
proj4string(savi30)
sv30 <- raster(savi30)
class(sv30)

# Cell Size: dimensions of cell size are inequal therefore
# ------------
str(savi30)                      # [311X278]
str(sv30)
str(savi100)
# ===========================================================================================


# Raster Projection Tests
# ===========================================================================================
sv30@data
pr1 <- projectRaster(sv30, crs=projection(sv30), res=30)
class(pr1)
str(pr1)

pr1s <- SpatialGridDataFrame(pr1)

pr1p <- rasterToPoints(pr1, spatial = T)
svp30 <- spTransform(svp30,CRS("+proj=longlat +datum=WGS84"))
dim(svp30)
plot(svp30)


# Extent Dummy 
# ------------------
pr3 <- projectExtent(sv30, projection(sv30))
class(pr3)
pr3@data

# Adjust the cell size 
# ------------------
res(pr3) <- 30

# now project
# ------------------
pr3 <- projectRaster(sv30, pr3)

# ===========================================================================================


# Resolution Changing 30m to 100m
# ===========================================================================================
# Factor to be multiplied to change Number [= final resolution/current resolution] 
# -----------------------------
resampleFactor <- 3.33333 #  [here from 30 to 100m hence [100/30]

# Record the number of Rows and Columns of the original data
# ------------------------------
inCols <- ncol(sv30)
inRows <- nrow(sv30)

# Create a empty Raster layer for 100m
# ------------------------------
resampledRaster <- raster(ncol=ceiling(inCols / resampleFactor), 
                          nrow=ceiling(inRows / resampleFactor))
extent(resampledRaster) <- extent(sv30)

# The resample method will write the resampled raster image to a NEW disk file
# ------------------------------
system.time(resampledRaster <- resample(sv30, resampledRaster, method='bilinear'))
# writeRaster(resampledRaster, file.path(Indices_Out, paste0(Metro_Name, "_", Index_name,"_R")),format="GTiff",overwrite=TRUE)
# ===========================================================================================



# Export and Checks
# ===========================================================================================
# Colors Palletes
# -----------------------
# cols <- rev(terrain.colors(10))
# cols <- colorRampPalette(c("red", "white", "blue"))(255)

# Convert rasters to Points and Plot T1: 30m to 100m
# ---------------------
# Arc GIS 100m resolution
svp100 <- rasterToPoints(sv100, spatial = T)
svp100 <- spTransform(svp100,CRS("+proj=longlat +datum=WGS84"))
dim(svp100)

# Original 30m resolution
svp30 <- rasterToPoints(sv30, spatial = T)
svp30 <- spTransform(svp30,CRS("+proj=longlat +datum=WGS84"))
dim(svp30)

# Resampled 100m from 30m in R
rRp <- rasterToPoints(resampledRaster, spatial = T)
rRp <- spTransform(rRp,CRS("+proj=longlat +datum=WGS84"))
dim(rRp)

# Export to Check
# ---------------------
op <- "G:/ADE_GRID/Experimentation&Testing/HectoGrid/R&D/NDBI SAVI/Raw files 30m/Vector files"
writeOGR(rRp, op, "rRstr30-100",driver="ESRI Shapefile", overwrite = T)
writeOGR(svp100, op, "Arc100",driver="ESRI Shapefile", overwrite = T)
writeOGR(svp30, op, "base30",driver="ESRI Shapefile", overwrite = T)
# ===========================================================================================



