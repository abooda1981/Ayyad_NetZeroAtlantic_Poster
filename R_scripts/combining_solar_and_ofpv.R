##Create a single vector from the combined wind and solar availabilities--we cannot have more than 100% = 500 MW at one time

list_of_combined_data = list.files("/home/abed/GenX.jl-main/example_systems/working_multistage_combined/inputs/availability_data_offshore/")

setwd("/home/abed/GenX.jl-main/example_systems/working_multistage_combined/inputs/availability_data_offshore/")
for(i in 1:length(list_of_combined_data))
{
  combined_data = openxlsx::read.xlsx(list_of_combined_data[i])
  combined_data$combined_availability = 0
  combined_data$OFPV_availability[is.na(combined_data$OFPV_availability)] <- 0
  for(j in 1:nrow(combined_data))
  {
    combined_data$combined_availability[j] = min(1, combined_data$Wind_availability[j] + combined_data$OFPV_availability[j])
  }
  
  openxlsx::write.xlsx(combined_data, file = list_of_combined_data[i], overwrite = TRUE)
}