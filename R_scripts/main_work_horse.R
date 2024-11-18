#You probably want to start here
##In this script, we download, crop and project the relevant part of the Atlantic Canada map. We also build databases of 
##Have a look also at the script which creates the offshore sites; it should be included in the same folder. 
library(rnaturalearth)
library(rnaturalearthdata)
library(sf)
library(dplyr)
library(ggplot2)
library(nasapower)
library(geosphere)
##You will need to set the working directory properly for these to work
source("geographic_functions.R") 
source("functions_to_download_data.R")


# Define projected CRS--we will re-project Atlantic Canada using this more appropriate code later
crs = 3395

# Create cropping sf polygon based on your coordinates, project to crs
bbox <- st_as_sfc(st_bbox(c(xmin = -70,
                            ymin = 41,
                            xmax = -50,
                            ymax = 61))) %>%
  st_as_sf(crs = 4326) %>%
  st_transform(crs)

# Load Canada
canada_dl <- ne_countries(scale = 110, country = "Canada")

# Return the boundaries of Canada, projected the correct way
canada_b <- ne_countries(scale = 110) %>%
  st_transform(crs) %>%
  st_boundary()

# Return line vertices--we are only interested in a set of points along the coast
##
coast_atlantic_canada <- ne_countries(scale = 110) %>%
  st_transform(crs) %>%
  filter(sovereignt != "Canada") %>%  ##We don't want to worry about the US
  st_boundary() %>%
  summarise(geometry = st_union(geometry)) %>%
  st_difference(canada_b, .) %>%
  st_transform(st_crs(canada_dl)) %>%
  st_crop(xmin = -70, xmax = -50 , ymin = 41, ymax = 61) %>%
  st_cast("POINT") %>%
  select()


# Return coordinates only
coast_coords <- st_coordinates(coast_atlantic_canada)


##Ploat it just to make sure it's correct
ggplot() +
  geom_sf(data = canada_dl) +
  geom_sf(data = coast_atlantic_canada, size = 0.5) + scale_colour_manual(name = "", values = "firebrick") +
  coord_sf(xlim = c(-70, -50),
           ylim = c(41, 61),
           expand = FALSE)


#We will need a data frame to contain all the coordinates we could possibly want
total_coordinates = st_coordinates(coast_atlantic_canada)
total_coordinates_DF = as.data.frame(total_coordinates)

#This is an extremely convoluted way to build the set of sites which we will use to extract meteorological data from 
#The first part of this involved going through and deciding where to cut the sites on/off
#The first groups of sites belowe are coastal
northern_section = total_coordinates[which(total_coordinates[1,] >= 51.9),]
northern_section_b = northern_section[which(northern_section$X >= -61.8),]

new_brunswick_sites = total_coordinates_DF[which(total_coordinates_DF$X > -65 & total_coordinates_DF$Y < 45),]
new_brunswick_sites_b = new_brunswick_sites[1:5,]

eastern_nova_scotia_sites = total_coordinates_DF[which(total_coordinates_DF$Y <= 51.9 & total_coordinates_DF$X > -55),]


#We will now create "very close" offshore sites
very_close_nl_sites = northern_section_b
very_close_nb_sites = new_brunswick_sites_b
very_close_ns_sites = eastern_nova_scotia_sites
#Now we fix them
for(i in 1:nrow(very_close_nl_sites))
{
  very_close_nl_sites[i,] = move_offshore_longitudinal(point1 = very_close_nl_sites[i,], 19, "east")
}

for(i in 1:nrow(very_close_nb_sites))
{
  very_close_nb_sites[i,] = move_north_south(point1 = very_close_nb_sites[i,], 19, direction_to_move = "south")
}


##Nova Scotia is a shit show 
subset_ns_VI = eastern_nova_scotia_sites[which(eastern_nova_scotia_sites$X > -54 & eastern_nova_scotia_sites$Y > 47),]
subset_ns_V = eastern_nova_scotia_sites[which(eastern_nova_scotia_sites$X > -55 & eastern_nova_scotia_sites$Y > 45 & eastern_nova_scotia_sites$Y < 48),]
subset_ns_VII = eastern_nova_scotia_sites[which(eastern_nova_scotia_sites$X > -60 & eastern_nova_scotia_sites$Y > 48),]


very_close_ns_sites_A = subset_ns_V
for(i in 1:nrow(subset_ns_V))
{
  very_close_ns_sites_A[i,] = move_north_south(point1 = very_close_ns_sites_A[i,], 19, direction_to_move = "south")
}


very_close_ns_sites_B = subset_ns_VI
for(i in 1:nrow(very_close_ns_sites_B))
{
  very_close_ns_sites_B[i,] = move_offshore_longitudinal(point1 = very_close_ns_sites_B[i,], 19, direction_to_move = "east")
}

very_close_ns_sites_C = subset_ns_VII
for(i in 1:nrow(very_close_ns_sites_C))
{
  very_close_ns_sites_C[i,] = move_offshore_longitudinal(point1 = very_close_ns_sites_C[i,], 19, direction_to_move = "east")
}

overall_very_close_sites = rbind(very_close_nb_sites, very_close_nl_sites, very_close_ns_sites_A, very_close_ns_sites_B, very_close_ns_sites_C)
#Do away with repeats, however they got here
overall_very_close_sites = dplyr::distinct(overall_very_close_sites)
#Remeber these are the offshore sites!!
overall_very_close_offshore_sites = overall_very_close_sites

#Time to find out the bathymetry--this can be left just as it is 
overall_very_close_offshore_sites$depth = get.depth(atlanticCanada_bath, x = overall_very_close_offshore_sites$X, y = overall_very_close_offshore_sites$Y, locator = FALSE)$depth
#Remove the sites which are not offshore 
overall_very_close_offshore_sites = overall_very_close_offshore_sites[which(overall_very_close_offshore_sites$depth < 0),]

#Divide it into shallow and deep 
#Could be done at a later time 
#Let's get the meteorological data
#Need to change the column names to make them work with the function
colnames(overall_very_close_offshore_sites) = c("lon", "lat", "depth")
#We only want the sites with a decent wind power potential 

overall_viable_and_close_sites = overall_very_close_offshore_sites[which(overall_very_close_offshore_sites$capfactor_wind >= 0.40),]
list_of_meteorological_data = generate_list_of_meteorological_data(overall_viable_and_close_sites)


##Go to the script for summarizing wind power to see what we do with this
#Note that we deleted the meteorological data couple of times

#We also need to export the data to Excel so that it can be read in by Python/PVLIB 

#This will give you an error unless you put in a correct relative path 
# for(i in 1:length(list_of_meteorological_data))
# {
#   filenamenow = paste("site_", i, ".xlsx")
#   path_to_file = [PUT YOUR PATH HERE WITHIN QUOTATION MARKS]
#   full_file_path = paste0(path_to_file, filenamenow)
#   df_of_data_now = list_of_meteorological_data[[i]][1:8760,]
#   openxlsx::write.xlsx(df_of_data_now, file = full_file_path, overwrite = TRUE)
# }
