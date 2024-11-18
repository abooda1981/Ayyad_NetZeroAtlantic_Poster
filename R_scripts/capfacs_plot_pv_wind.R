##In this script, we make a plot showing the capacity factors; the dots showing where the sites lie will be coloured according to the capacity factor of the PV plant on that site
#This script assumes you have all of the other objects created.


#canada_dl is an SPDF object which is the downloaded map data of Canada
#We will need it because we will plot on to it. We will also plot only on the coast of Atlantic Canada!
#
ggplot() +
  geom_sf(data = canada_dl) +
  geom_sf(data = coast_atlantic_canada, size = 0.5) +
  coord_sf(xlim = c(-70, -50),
           ylim = c(41, 61),
           expand = FALSE) + geom_point(data = viable_sites_wind_and_pv, aes(x = lon, y = lat, color = capfactor_pv)) + scale_color_continuous(name = "Capacity factor \n OFPV") + 
  ggplot2::ggtitle(label = "Final set of sites: solar PV")

ggplot() +
  geom_sf(data = canada_dl) +
  geom_sf(data = coast_atlantic_canada, size = 0.5) +
  coord_sf(xlim = c(-70, -50),
           ylim = c(41, 61),
           expand = FALSE) + geom_point(data = viable_sites_wind_and_pv, aes(x = lon, y = lat, color = capfactor_wind)) + scale_color_continuous(name = "Capacity factor \n Offshore wind") + 
  ggplot2::ggtitle(label = "Final set of sites: wind power")
