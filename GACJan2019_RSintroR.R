# Exploration of Landsat 8 and basic remote sensing properties in R
#
# Main author and editor: Dr. Jessica McCarty (McCarty-Kern)
# jmccarty@miamioh.edu, Department of Geography, Miami University
#
# Contributions from Justin Fain, Ms. Robbyn Abbott, Keelin Haynes 
# Department of Geography, Miami University
#
# Tutorial and some data is based on  https://rspatial.org/rs/2-exploration.html
# and previous Miami University lectures and labs
# 
# Acknowledgments to: GFC for the Innovation Lab for Collaborative Research on Sustainable Intensification 
# License: CC BY-SA 4.0 --- Source code on github 
# © Copyright 2016-2019, Robert J. Hijmans
#
# Built using R version 3.5.1 "Feather Spray"
#
# 23 January 2019
#
#
install.packages("rgdal")
install.packages("raster")
install.packages("gdalUtils")

library(rgdal)
library(raster)
library(gdalUtils)

#First way to ingest RS data of the Central Valley of California, USA
#Create a directory for the data
localDir<- 'R_RS'
if(!file.exists(localDir)) {dir.create(localDir)}
#Download the data
url <-"https://biogeo.ucdavis.edu/data/rspatial/rsdata.zip"
file <- paste(localDir,basename(url),sep='/')
#unzip the data
if (!file.exists(file)) {
  download.file(url, file)
  unzip(file,exdir=localDir)
}
#show the unzipped files
list.files(localDir)

dataDir<- 'R_RS/rs'
list.files(dataDir)

# Let's check our working directory
getwd()

# Might need to set it and check the files are in there
setwd ('C:/Workspace/RFiles/R_RS/rs')
list.files()

# Now we can read in our data directly form this unzipped directory

# All data with LC08 prefix is 30 m Landsat 8 OLI data
# More information here: https://www.usgs.gov/land-resources/nli/landsat


# Blue spectra region 0.450 - 0.51 µm
b2 <- raster('LC08_044034_20170614_B2.tif')

# Green spectra region 0.53 - 0.59 µm
b3 <- raster('LC08_044034_20170614_B3.tif')

# Red spectra region 0.64 - 0.67 µm
b4 <- raster('LC08_044034_20170614_B4.tif')

# Near Infrared (NIR) spectra region 0.85 - 0.88 µm
b5 <- raster('LC08_044034_20170614_B5.tif')


# So... YOU MUST KNOW YOUR RS DATA BEFORE USING IT IN R
# Let's explore! First, print a variable to check

b2

# You can also look at image information and band stats individually

#Find out the coordinate reference system (crs) of the RS image 
crs(b2)

#Number of cells or pixels total in the image 
ncell(b2)

#Dimensions of data (rows, columns) 
dim(b2)

# spatial resolution of the data
res(b2)

# number of bands or layers in the image
nlayers(b2)

# Do the bands have the same extent, number of rows and columns, projection, resolution, and origin 
compareRaster(b2,b3)

# And you can compare all bands at once
compareRaster(b2,b3,b4,b5)

# Let's stack our bands using RasterStack (an object with multiple layers) 
# from the existing RasterLayer (single band) objects.

# First, a true color image using the red, green, and blue bands - in that order
L8RGB <- stack(b4, b3, b2)

# Second, a false color composite using NIR, red, and green bands - in that order
L8FCC <- stack(b5, b4, b3)

#Let's check properties real quick
L8RGB
L8FCC

# Let's plot a comparison of our bands
par(mfrow = c(2,2),mar=c(1,1,1,1))
plot(b2, main = "Blue", col = gray(0:100 / 100))
plot(b3, main = "Green", col = gray(0:100 / 100))
plot(b4, main = "Red", col = gray(0:100 / 100))
plot(b5, main = "NIR", col = gray(0:100 / 100))

# Let's plot our stacked image
plot(L8RGB)

#What happened here? 

dev.off()

# What is dev.off()? what does it do?

# Now let's actually plot our stacked image

plotRGB(L8RGB, axes = TRUE, stretch = "lin", main = "Landsat True Color Composite")

#Let's plot true color and false color side-by-side
par(mfrow = c(1,2),mar=c(2,5,2,2))
plotRGB(L8RGB, r=1, g=2, b=3, axes=TRUE, stretch="lin", main="Landsat True Color Composite")
plotRGB(L8FCC, r=1, g=2, b=3, axes=TRUE, stretch="lin", main="Landsat False Color Composite")

# Let's review documentation https://www.rdocumentation.org/packages/DescTools/versions/0.99.19/topics/Mar

# What happens when we change to mar=c(3,3,3,3) in line 135?

help("plotRGB")

# Comparing to lines 135 - 137, what has been changed below?
par(mfrow = c(1,2),mar=c(2,5,2,2))
plotRGB(L8RGB, r=1, g=2, b=3, scale = 255, axes=TRUE, stretch="hist", main="Landsat True Color Composite")
plotRGB(L8FCC, r=1, g=2, b=3, scale = 255, axes=TRUE, stretch="hist", main="Landsat False Color Composite")

# Let's compare spectral relationship of the bands
par(mfrow = c(1,1),mar=c(1,1,1,1))
pairs(L8FCC[[2:1]], main = "Red versus NIR")

# Now let's calculate the NDVI - Normalized Difference Vegetation Index 
# NDVI is a quantitative index of greenness ranging from -1  to 1,
# where -1 represents minimal or no greenness and 1 represents maximum greenness.
L8NDVI <- (L8FCC[[1]] - L8FCC[[2]]) / (L8FCC[[1]] + L8FCC[[2]])

# Plot the NDVI image using default color ramp
plot(L8NDVI,
     main = "NDVI of Landsat 8 image, Central Valley, CA",
     axes = FALSE, box = FALSE)

# Change the color of the color ramp to a built-in blue palette
plot(L8NDVI,
     main = "NDVI of Landsat 8 image, Central Valley, CA",
     axes = FALSE, box = FALSE, col=blues9)

# Never use the Rainbow color ramp. Here's why!
plot(L8NDVI,
     main = "NDVI of Landsat 8 image, Central Valley, CA",
     axes = FALSE, box = FALSE, col=rainbow(10))

# Plotting the NDVI using heat map colors
plot(L8NDVI,
     main = "NDVI of Landsat 8 image, Central Valley, CA",
     axes = FALSE, box = FALSE, col=heat.colors(12))

# And then reversing those colors to visualize NDVI
plot(L8NDVI,
     main = "NDVI of Landsat 8 image, Central Valley, CA",
     axes = FALSE, box = FALSE, col=rev(heat.colors(12)))

## Settling on terrain colors but using reverse function
plot(L8NDVI,
     main = "NDVI of Landsat 8 image, Central Valley, CA",
     axes = FALSE, box = FALSE, col=rev(terrain.colors(10)))

# view distribution of NDVI values using named colors
# more about named colors here https://www.stat.auckland.ac.nz/~ihaka/downloads/R-colours-a4.pdf 
par(mfrow = c(1,1),mar=c(5,5,5,5))
hist(L8NDVI,
     main = "NDVI: Distribution of pixels in Landsat 8",
     col = "forestgreen",
     xlab = "NDVI Index Value",
     xlim= c(-1,1),
     xaxs = "i",
     yaxs = "i")
# BONUS - When you leave the workshop
# Maybe you need to use USDA high res NAIP imagery

# But firrst you have to download and convert to a geotiff format
# for GIS
# Here is a direct download example with no login required

# Let's download NAIP imagery directly from https://datagateway.nrcs.usda.gov/GDGHome_DirectDownLoad.aspx
# You must know the FIPS code of the county you are seeking.
# For instance, Butler County is 017.
# Direct link to Butler Co NAIP is https://nrcs.app.box.com/v/naip/file/272297510197

#All NAIP imagery comes initially as Mr. SID files and we need to convert to geotiff

# Convert the download of Butler County NAIP to geotiff, note the new file name is rnaip
rnaip <- gdal_translate(src_dataset = "C:/Workspace/RFiles/NAIP/ortho_1-1_1n_s_oh017_2017_1.sid", dst_dataset = "Butler2017NAIP.tif", output_Raster = TRUE)


