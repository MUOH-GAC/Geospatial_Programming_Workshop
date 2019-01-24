#' GEOSPATIAL R WORKSHOP
#'
#'

# PACKAGES AND SETUP ####

# # Install packages where needed
if(!require(ggplot2)){
  install.packages('ggplot2')
}
if(!require(rgdal)){
  install.packages('rgdal')
}
if(!require(gdalUtils)){
  install.packages('gdalUtils')
}
if(!require(raster)){
  install.packages('raster')
}
if(!require(rgeos)){
  install.packages('rgeos')
}
if(!require(sf)){
  install.packages('sf')
}
if(!require(spdep)){
  install.packages('spdep')
}
if(!require(ggmap)){
  install.packages('ggmap')
}
if(!require(dplyr)){
  install.packages('dplyr')
}

# # Mount packages to the R session
# raster
require(raster)
# ggplot2
require(ggplot2)
# rgdal
require(rgdal)
# gdalUtils
require(gdalUtils)
# sf
require(sf)
# spdep
require(spdep)
# ggmap
require(ggmap)
# dplyr
require(dplyr)

# # Set Working Directory
#' The function **setwd** changes the R session's current working directory.
#' This is equivalent to the cd/chdir commands that you may be familiar with.
#' We can double check that **setwd** changed our directory to the place we
#' intended with the command **getwd**, which simply returns the file path of
#' the current directory.

# setwd() # This should be the path to the data file (must be in quotes)

#' At this point it is a good idea to use the **list.files** function to make
#' sure that the things we need are in the directory we just moved to.



# Reading Tabular Data ####
#' We should have a shapefile of 0-level administrative boundaries as well as a
#' csv of information about countries.
#' We will deal with the shapefile later on.



#' Now we can use the **head** and **tail** functions to check the loaded data



# FUNCTIONS ####
# # Definitions
#' Defining functions in R is very similar to variable assignment. Here we will
#' make our first function to raise 10 to any arbitrary exponent.



# # Closures: Functions really do write themselves
#' We can also write a *closure* which is a function for creating functions.
#' Think of these as function templates. Below is a *closure* which further
#' generalizes our exponential functions. This allows us to use the same
#' template to quickly make functions for similar tasks such as finding the
#' nth root of a number.



# VECTORS & DATA FRAMES ####
# # Vectors
# # Vectors are the most basic groupings of information in R.
#' **typeof** tells you the data type stored in the vector.
#' **class** tells you what mode the vector is (logical, numeric, character).
#' **length** does exactly what you would expect and returns the numeric
#' length of your vector.



#' Vectors can not be of mixed type, so they are silently converted to the same
#' type. This is explained in the details of the **c** function's help
#' documenation: The output type is determined from the highest type of the
#' components in the hierarchy NULL < raw < logical < integer < double < complex
#'  < character < list < expression


# # Data Frames
# Now that we have two vectors, we can mash them into a data frame.


#' Check out the structure and dimensions with **str** and **dim**.



#' We see that there are 1704 rows (observations), each with
#' 6 columns (variables). This is a 5-year development index data set for a
#' bunch of countries. The **names** function gives us the variable (column)
#' names which should match the csv header row. The **summary** function gives
#' us a bunch of information very quickly, but it isn't particularly useful at
#' this point since there are multiple countries with 5 entries each.


# SEQUENCES & INDEXING ####
# # Sequences
# There are multiple ways to make sequences, but some are better for certain cases



# # Indexing
#' You can use square brackets to subset data frames. This follows the pattern
#' *data[row, col]*. Leaving either of the indices blank will select all of
#' that row or column.



# You can also subset by sequences



# ... or by name

#' Use **nrow** and **seq** to create a new data frame containing every 100th
#' row of the dvlp df, starting at row 100.



#' All of this is helpful to know, but numeric indices aren't really all
#' that useful in practice. We will look at a few other ways to subset things
#' using conditional expressions



# INTRODUCING DPLYR ####

#' Dplyr is a powerful data manipulation package. It is also incredibly fast
#' since most of the functions are really just convenience wrappers for
#' underlying C functions.

#' If you just want to move a column to the front of a data frame, you can use
#' some of *dplyr*'s super handy tools. Let's move the continents column to the
#' front using **select** and **everything**.



#' Dplyr's **select** and **filter** functions allow you to subset data intuitively.



# # More filtering and selecting using the pipe!
#' This is the pipe: **%>%**
#' It passes the left-hand side as the first argument to the function on the
#' right-hand side. This lets you chain a bunch of operations together without
#' nesting your functions. It is far more readable but can sometimes
#' be a pain to debug.

#' Let's look at how it can be used to make our code more human-readable.


#' Nested functions make it unclear what is our data, and what are variable
#' names. They must be read from the inside-out.



#' The pipe streamlines this process, allowing you to read from top to bottom
#' through the workflow.



# # Negative indices
#' We can also use **select** to drop variables from the table. If we only
#' select entries from India, having the country variable becomes redundant.
#' We could do something like this instead:



# # Mutate
#' Rather than dropping variables, we can use **mutate** to add new columns.
#' This calculates new values row-by-row.



# # Group By
#' We can also use the **group_by** function to gather similar observations into
#' distinct bundles that we can then perform operations on.



# GGPLOT2 ####

#' The plotting library *ggplot2* allows you to build visualizations in an
#' intuitive layer-by layer fashion. To represent this process, *ggplot2* uses a
#' '+' to add new layers. This symbol also acts somewhat like the pipe,
#' insomuch as it passes the first argument to **ggplot** to subsequent layers.




#' Because *ggplot2* is an additive process, we can define a basemap and store
#' it to a variable for use later.



#' Now we can combine all of these techniques to create some very impressive plots.



# SF (simple features) ####
#' The simple features library is a fast and easy way to store geometries.
#' Under the hood, it is very similar to the way Post handles spatial data.



#' *Sf* also plays nicely with *ggplot2*.





# Acknowledgements ####

#' Adapted in part from 'Data Visualization in R' Workshop by K. Arthur Endsley
#'   - http://karthur.org/
#'   - https://github.com/arthur-e
#'
#'
#'
#' Advanced R by Hadley Wickham.
#'   - Available at http://adv-r.had.co.nz/ or in print
