##I have copied the main part of this to the "Main Workhorse" but you can also access it here.
##This is where the offshore sites are determined: by moving either north/south or east/west
##To see how the movement is done, 
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


for(i in 1:length(list_of_meteorological_data))
{
  filenamenow = paste("site_", i, ".xlsx")
  path_to_file = [PUT YOUR PATH HERE WITHIN QUOTATION MARKS]
  full_file_path = paste0(path_to_file, filenamenow)
  df_of_data_now = list_of_meteorological_data[[i]][1:8760,]
  openxlsx::write.xlsx(df_of_data_now, file = full_file_path, overwrite = TRUE)
}
