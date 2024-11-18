##Just to make sure, let's do some plotting the solar capacity factors 

list_of_pv_data_files = list.files("/home/abed/Documents/data_for_pvlib_atlantic_canada_offshore/")

# NS_locations = very_close_ns_sites
# NB_locations = very_close_nb_sites

setwd("/home/abed/Documents/data_for_pvlib_atlantic_canada_offshore/")

throw_away_df = data.frame(matrix(0, nrow = length(list_of_pv_data_files), ncol = 3))
colnames(throw_away_df) = c("LON", "LAT", "CAPFAC_PV")
for(i in 1:length(list_of_pv_data_files))
{
  openedfile = openxlsx::read.xlsx(list_of_pv_data_files[i])
  throw_away_df$LON[i] = unique(openedfile$LON)
  throw_away_df$LAT[i] = unique(openedfile$LAT)
  throw_away_df$CAPFAC_PV[i] = 0.9*sum(openedfile$mpp_DC, na.rm = TRUE)/(8760*220)
}

throw_away_df$pasted = paste(throw_away_df$LON, throw_away_df$LAT)


overall_viable_and_close_sites$capfactor_pv = 0 

for(i in 1:nrow(overall_viable_and_close_sites))
{
  pasted_coors = paste(overall_viable_and_close_sites$lon[i], overall_viable_and_close_sites$lat[i])
  extracted_df = throw_away_df[which(throw_away_df$pasted == pasted_coors),]
  print(extracted_df)
  overall_viable_and_close_sites$capfactor_pv[i] = extracted_df$CAPFAC_PV
}


##What if we took two sets: the sites with good wind, and the sites with good wind + good PV?
viable_sites_wind_and_pv = overall_viable_and_close_sites[which(overall_viable_and_close_sites$capfactor_pv >= 0.1),]

#Find which files to open for which coordinates
setwd("/home/abed/Documents/data_for_pvlib_atlantic_canada_offshore/")
df_holding_coords_files = data.frame(matrix(0, nrow = length(list_of_pv_data_files), ncol = 3))
colnames(df_holding_coords_files) = c("filename", "lon", "lat")
for(i in 1:length(list_of_pv_data_files))
{
  df_holding_coords_files$filename[i] = list_of_pv_data_files[i]
  openedfile = openxlsx::read.xlsx(list_of_pv_data_files[i])
  df_holding_coords_files$lon[i] = unique(openedfile$LON)
  df_holding_coords_files$lat[i] = unique(openedfile$LAT)
}

list_holding_availability = list()
for(i in 1:nrow(viable_sites_wind_and_pv))
{
  
}