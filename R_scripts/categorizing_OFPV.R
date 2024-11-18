#Plot the two types of AC yield 

arbitrary_selected_data = openxlsx::read.xlsx("/home/abed/Documents/data_for_pvlib_atlantic_canada_offshore/site_ 1 .xlsx")
plot(arbitrary_selected_data$AC_yield~{1:8760}, col = "red", type = "b")
points(arbitrary_selected_data$AC_yield_B~{1:8760}, col = "green", type ="b")



df_summarizing_capfacs_solar = data.frame(matrix(0, nrow = length(list_of_meteorological_data), ncol = 7))
colnames(df_summarizing_capfacs_solar) = c("LON", "LAT", "With_tilt_greater", "No_tilt_greater", "no_difference", "AC_yield", "AC_yield_B")

for(i in 1:nrow(df_summarizing_capfacs_solar))
{
  full_extent_filename = paste0("/home/abed/Documents/data_for_pvlib_atlantic_canada_offshore/", list_of_basic_data_files[i])
  read_in_data = openxlsx::read.xlsx(full_extent_filename)
  df_summarizing_capfacs_solar[i,1] = unique(read_in_data$LON)
  df_summarizing_capfacs_solar[i, 2] = unique(read_in_data$LAT)
  df_summarizing_capfacs_solar[i,3] = sum(read_in_data$AC_yield > read_in_data$AC_yield_B, na.rm = TRUE)
  df_summarizing_capfacs_solar[i,4] = sum(read_in_data$AC_yield < read_in_data$AC_yield_B, na.rm = TRUE)
  df_summarizing_capfacs_solar[i,5] = sum(read_in_data$AC_yield == read_in_data$AC_yield_B, na.rm = TRUE)
  df_summarizing_capfacs_solar[i, 6] = sum(read_in_data$AC_yield, na.rm = TRUE)*0.001
  df_summarizing_capfacs_solar[i, 7] = sum(read_in_data$AC_yield_B, na.rm = TRUE)*0.001
}

quick_check_pv_capfac_diff = df_summarizing_capfacs_solar$No_tilt_greater/df_summarizing_capfacs_solar$With_tilt_greater
lm_latitude_tilt_no_improve = lm(quick_check_pv_capfac_diff~df_summarizing_capfacs_solar$LAT)