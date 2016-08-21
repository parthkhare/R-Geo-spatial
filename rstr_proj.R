require( raster )

#  Projection info
# ------------------
proj1 <- CRS("+proj=laea +lon_0=20 +lat_0=5 +ellps=sphere +unit=km +to_meter=1e3")
proj2 <-  CRS("+proj=longlat +datum=WGS84 +ellps=WGS84")

# Raster Data
# ==========================================================================================
# create a new (not projected) RasterLayer with cellnumbers as values
# ------------------
r <- raster(xmn=-110, xmx=-90, ymn=40, ymx=60, ncols=40, nrows=40)
r <- setValues(r, 1:ncell(r))
class(r)
projection(r)
# proj.4 projection description
# ------------------
newproj <- "+proj=lcc +lat_1=48 +lat_2=33 +lon_0=-100 +ellps=WGS84"
# ==========================================================================================

# Method 1: Simple
# ==========================================================================================
#simplest approach
# ------------------
pr1 <- projectRaster(r, crs=newproj)
# alternatively also set the resolution
# ------------------
pr2 <- projectRaster(r, crs=newproj, res=20000)
# inverse projection, back to the properties of 'r'
# ------------------
inv <- projectRaster(pr2, r)
# ==========================================================================================

# Method 2: Dummy Empty Raster
# ==========================================================================================
# to have more control, provide an existing Raster object, here we create one
# using projectExtent (no values are transferred)
# ------------------
pr3 <- projectExtent(r, newproj)
# Adjust the cell size 
# ------------------
res(pr3) <- 200000
# now project
# ------------------
pr3 <- projectRaster(r, pr3)
# ==========================================================================================


## Not run:
# using a higher resolution
res(pr1) <- 10000
pr <- projectRaster(r, pr1, method='bilinear')
inv <- projectRaster(pr, r, method='bilinear')
dif <- r - inv
# small difference
plot(dif)
## End(Not run)
  
