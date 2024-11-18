##Script to plot the availabilities of the combined solar + wind 
NL_combined_data = openxlsx::read.xlsx("/home/abed/GenX.jl-main/example_systems/working_multistage_combined/inputs/availability_data_offshore/NL_5.xlsx")

NL_combined_data_winter = NL_combined_data[1:1000,]
NL_combined_data_summer = NL_combined_data[4400:5399,]

plot(NL_combined_data_winter$Wind_availability~{1:1000}, 
     type = "l", col = "blue", ylab = "", xlab = "")

lines(NL_combined_data_winter$OFPV_availability, col = "red", type = "l")
lines(NL_combined_data_winter$combined_availability, col = "purple", type = "l")
legend(0, 0.5, legend = c("Wind power", "PV power", "Combined"), col = c("blue", "red", "purple"), lty = 1)
title(main = "Winter time performance \n of VRE systems (site in NL)", xlab = "Selected hours", ylab = "Availability/capacity factor")


cell_temps_con = openxlsx::read.xlsx("/home/abed/Documents/data_for_pvlib_atlantic_canada_offshore/quick_plot_cell_temperatures/conventional_cell_T.xlsx")
cell_temps_wat = openxlsx::read.xlsx("/home/abed/Documents/data_for_pvlib_atlantic_canada_offshore/quick_plot_cell_temperatures/site_ 4.xlsx")

plot(cell_temps_con[,2]~{1:8760}, col = "red", type = "b", ylab = "", xlab = "")
lines(cell_temps_wat$T_cell_zero, col = "blue", type = "b")
title(main = "Temperature performance of \n two models", ylab = "Operating cell temperature (°C)", xlab = "Hour in year")
legend(1, 60, legend = c("Water cooled", "Conventional"), col = c("blue", "red"), lty = 1)