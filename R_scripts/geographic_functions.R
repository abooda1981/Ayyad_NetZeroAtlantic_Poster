##Functions to move along geographically. 
#Borrowed from the earlier paper 


move_offshore_longitudinal <- function(point1, required_distance, direction_to_move)
{
  latitude_in_radians = point1[2]*pi/180
  cos_of_latitude = cos(latitude_in_radians)
  distance_when_moving_1_degree_longitude = 111*cos_of_latitude
  longitudinal_degree_requirement = required_distance/distance_when_moving_1_degree_longitude
  #point2 = point1
  #point2[1] = point2[1] + 1
  point3 = point1
  if(direction_to_move == "west")
  {
    point3[1] = point1[1] - longitudinal_degree_requirement
  }
  
  else if(direction_to_move == "east")
  {
    point3[1] = point1[1] + longitudinal_degree_requirement
  }
  
  print(0.001*distHaversine(point1, point3))
  return(point3)
}
  
  
#Notice that we only need one function for the latitude moves 
move_north_south <- function(point1, required_distance, direction_to_move)
{
  point3 = point1
  distance_adjustment = required_distance/111
  if(direction_to_move == "north")
  {
    #When you have a north facing port, then you go offshore by moving north, adding latitude
    point3[2] = point1[2] + distance_adjustment
  }
  
  else if(direction_to_move == "south")
  {
    #And vice versa
    point3[2] = point1[2] - distance_adjustment
  }
  print(0.001*distHaversine(point1, point3))
  return(point3)
}


#
