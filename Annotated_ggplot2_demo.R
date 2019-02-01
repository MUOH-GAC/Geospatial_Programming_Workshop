#' Justin's Live Coding Notes: Ggplot2 Demonstration
#'
#' Thanks to Dr. Jessica McCarty and Keelin Haynes for setting-up the data used
#' in this demonstration. I recommend you work through those sections first so
#' that the datasets used herein are already in your global environment.
#'

# Packages and Setup ####
install.packages("rgdal")
install.packages("raster")
install.packages("gdalUtils")
install.packages('dplyr')
install.packages("ggplot2")
install.packages("sf")

library(rgdal)
library(raster)
library(gdalUtils)
library(dplyr)
library(ggplot2)
library(sf)


# Using Data from the Remote Sensing Portion ####
# Credit to Dr. Jessica McCarty for these data

# Green spectra region 0.53 - 0.59 µm
b3 <- raster('LC08_044034_20170614_B3.tif')

# Red spectra region 0.64 - 0.67 µm
b4 <- raster('LC08_044034_20170614_B4.tif')

# Near Infrared (NIR) spectra region 0.85 - 0.88 µm
b5 <- raster('LC08_044034_20170614_B5.tif')

L8FCC <- stack(b5, b4, b3)

L8NDVI <- (L8FCC[[1]] - L8FCC[[2]]) / (L8FCC[[1]] + L8FCC[[2]])

# Write a function to add explicit lon/lat
add.coords <- function(pts){
  pts <- mutate(pts, lon = st_coordinates(pts)[,1], lat = st_coordinates(pts)[,2])
  pts
}

# # Random Sampling
# Make a random sample across the L8NDVI
rand_smp <- sampleRandom(L8NDVI, size = 600, sp = TRUE) %>% st_as_sf()

# First, look at the names we have for rand_smp
names(rand_smp)

# Ggplot uses the names for automatic labels, so we should change layer to ndvi
names(rand_smp)[1] <- 'ndvi'

# Make a generic ggplot object with our data, and ndvi as a single variable
rs <- ggplot(rand_smp, aes(ndvi)) + theme_grey()

# Histograms are rough, but we can specify the number of bins
rs + geom_histogram(binwidth = 0.05)

# This looks a bit better, though still a bit rough
rs + geom_freqpoly()

# Here we have a true kernel density plot
rs + geom_density()


# Add explicit coordinate columns to the sf object for use in plotting
rand_smp <- add.coords(rand_smp)

# Generic ggplot object for plotting our randomly sampled points
rand_plt <- ggplot(rand_smp, mapping = aes(lon, lat)) + theme_bw()

# Add a point geometry to the base plot with slight transparency
rand_plt + geom_point(aes(alpha = 0.2))

# Display the count in hexagonal bins
rand_plt + geom_hex(bins = 10)

# Display both hex bins and points
rand_plt +
  geom_hex(bins = 10) +
  geom_point(color = 'red', alpha = 0.3)

# Create filled density contours
rand_plt +
  stat_density2d(aes(fill = ..level..), geom = 'polygon') +
  # Change X and Y axes to zoom out of the plotting area a bit
  xlim(min(rand_smp$lon) - 5000,
       max(rand_smp$lon) + 5000) +
  ylim(min(rand_smp$lat) - 5000,
       max(rand_smp$lat) + 5000)

# Plot the randomly sampled point cloud with the ndvi value sybolized by both size and color
rand_plt + geom_point(aes(color = ndvi, size = ndvi^2), alpha = 0.5) + theme_bw()


# # Regular Sampling (gridded)
# Do a regullary gridded sample of points on the ndvi
reg_smp <- sampleRegular(L8NDVI, size = 5000, sp = TRUE) %>% st_as_sf()

# Add explicit coordinate columns
reg_smp <- add.coords(reg_smp)

# Create a generic ggplot object with axes set to lon/lat
reg_plt <- ggplot(reg_smp, mapping = aes(lon, lat)) + theme_void()

# View the gridded points, colored by their ndvi values
reg_plt + geom_point(aes(color = layer))

# Notice how this intensively sampled histogram looks like the histogram from
# the random sample. This shouldn't be a surprise, and is a great demo of why
# random sampling across fewer points still gives you a representative
# distribution. This lets us confidently draw conclusions without using as many
# observations that may eventually need to be verified, or simply to save on
# computational overhead when processing large areas.
ggplot(reg_smp, aes(layer)) + geom_histogram(binwidth = 0.05)


# Using Data from the Overlaying Spatial Data Portion ####
# Credit to Keelin Haynes for these data

# Read the places shapefile as an sf object
places <- st_read('SE_Asia_PopPlaces.shp')

# Create a generic ggplot with no geom. Axes are lon/lat
places_plt <- ggplot(places, aes(places$LONGITUDE, places$LATITUDE))

# Plot the places in SE asia as points
places_plt + geom_point(color = 'red')

# Create a hex grid of point counts, add the points on top
places_plt + geom_hex(bins = 8) + geom_point(color = 'red')

# Plot density as polygons (filled isolines)
places_plt +
  stat_density2d(aes(fill = ..level..), geom = 'polygon', bins = 20) +
  # Similar adjustments as done previously to zoom out
  xlim(
    min(places$LONGITUDE) - 2,
    max(places$LONGITUDE) + 2
  ) +
  ylim(
    min(places$LATITUDE) - 2,
    max(places$LATITUDE) + 2
  )

# Plot density as a raster
places_plt +
  stat_density2d(aes(fill = ..density..), geom = 'raster', contour = FALSE) +
  xlim(
    min(places$LONGITUDE) - 2,
    max(places$LONGITUDE) + 2
  ) +
  ylim(
    min(places$LATITUDE) - 2,
    max(places$LATITUDE) + 2
  )

# Read the area of interest polys as an sf object
aoi <- st_read('AOI.shp')

# This is an example of how you might combine point and polygon geometries in a
# single plot. We start with the AOI, then add the points on top.
ggplot(aoi) +
  geom_sf(fill = 'red') +
  geom_point(places,
             mapping = aes(places$LONGITUDE, places$LATITUDE))
