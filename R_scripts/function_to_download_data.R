##Function to download a year's worth of data for each site 
years_download_offshore_sites <- function(longitude, latitude)
{
  
  
  starting_date = "2014-12-31"
  ending_date = "2015-12-31"
  
    parameters_list = c("ALLSKY_SRF_ALB", "CLRSKY_KT", "CLRSKY_SRF_ALB",
                        "ALLSKY_SFC_SW_DWN", "ALLSKY_SFC_SW_DNI", "SZA", "CLRSKY_SFC_SW_DIFF",
                        "ALLSKY_SFC_SW_DIFF", "TS", "T2M", "WS10M", "WS2M")
    
    
    nasa_data_full_year = nasapower::get_power(community = "re", pars = 
                                                   parameters_list, lonlat = c(longitude, latitude), temporal_api = "HOURLY", dates =c(starting_date, ending_date))
  
  print("")
  print("Keep going")
  Sys.sleep(10)
  return(data.frame(nasa_data_full_year))
  
}

generate_list_of_meteorological_data <- function(DF_input)
{
  list_of_meteorological_data = list()
  for(i in 1:nrow(DF_input))
  {
    list_of_meteorological_data[[i]] = years_download_offshore_sites(DF_input$lon[i], DF_input$lat[i])
    print("Another site")
  }
  
  return(list_of_meteorological_data)
}