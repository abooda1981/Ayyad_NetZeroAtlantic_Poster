##We will need packages for various things--make sure you have the right packages downloaded and installed
library(marmap)
#Bathymetry package checking NOAA data
library(RColorBrewer)
#Colours and plots 
#Script for doing basic bathymetry plots for Atlantic Canada



##This section has colour palettes--get this out of the way now because
# We will need them to be defined for later 
blues <- c("lightsteelblue4", "lightsteelblue3",
           "lightsteelblue2", "lightsteelblue1")
greys <- c(grey(0.6), grey(0.93), grey(0.99))


#Get the bathymetry for the region we're interested in
atlanticCanada_bath <- getNOAA.bathy(lon1 = -53, lon2 = -67,
                        lat1 = 61, lat2 = 42, resolution = 4)

#Transform it into a dataframe because "atlanticCanada" is a 
# bathy object which is not easy to use
atlanticCanada_DF = fortify.bathy(atlanticCanada_bath)

#Sample the depth of the region through the DF
# The DF has components x, y and z for long, lat and depth
#We will need only the first two columns to do transects
sampled_atlantic_points = atlanticCanada_DF[sample(nrow(atlanticCanada_DF), 100),]



#Get a transect and plot it 
#Define the points which go out to 50 km offshore 
points_NL_1 = c(-55.7819788469112, 52.432659513990004)
points_NL_2 = c(-55.12035184208865, 52.419598202396166)
atCan_trsc = get.transect(atlanticCanada_bath, points_NL_1[1], points_NL_1[2], points_NL_2[1], points_NL_2[2], distance = TRUE)

points_NL_3 = c(-63.199389, 58.263834)
points_NL_4 = c(-62.003147, 58.208927)
atCan_trsc_2 = get.transect(atlanticCanada_bath, points_NL_3[1], points_NL_3[2], points_NL_4[1], points_NL_4[2], distance = TRUE)

#Scale it: 
plot(atlanticCanada_bath, lwd = c(0.3, 1), lty = c(1, 1),
     deep = c(-5000, 0), shallow = c(-50, 0), step = c(500, 0),
     col = c("blue", "green"), drawlabels = c(TRUE, TRUE))
scaleBathy(atlanticCanada_bath, deg = 1, x = "bottomleft", inset = 5)

#Determine which sites will be left out because of bad sampling 
fons_bathy = get.depth(atlanticCanada_bath, far_offshore_eastern_nova_scotia_sites[,1:2], locator = FALSE)
nons_bathy = get.depth(atlanticCanada_bath, near_offshore_eastern_nova_scotia_sites[,1:2], locator = FALSE)
fonl_bathy = get.depth(atlanticCanada_bath, far_offshore_northern_sites[,1:2], locator = FALSE)
nonl_bathy = get.depth(atlanticCanada_bath, near_offshore_northern_sites[,1:2], locator = FALSE)
fonb_bathy = get.depth(atlanticCanada_bath, far_offshore_new_brunswick[,1:2], locator = FALSE)
nonb_bathy = get.depth(atlanticCanada_bath, near_offshore_new_brunswick[,1:2], locator = FALSE)

#These are the filtered sites we will be working with
list_of_first_bathymetry_sites <- list(fons_bathy, nons_bathy, fonl_bathy, nonl_bathy, fonb_bathy, nonb_bathy)
names(list_of_first_bathymetry_sites) = c("fons_bathy", "nons_bathy", "fonl_bathy", "nonl_bathy", "fonb_bathy", "nonb_bathy")
list_of_filtered_bathymetry = list_of_first_bathymetry_sites

for(i in 1:6)
{
  list_of_filtered_bathymetry[[i]] = first_filter_function(list_of_filtered_bathymetry[[i]])
}

