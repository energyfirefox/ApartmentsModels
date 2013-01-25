# Haversine formula example in R
# Author Anastasiia Kornilova

haversine.distance <- function(origin, destination){
  lat1 <- origin[1]
  lon1 <- origin[2]
  
  lat2 <- destination[1]
  lon2 <- destination[2]
  destination <- c(lat2, lon2)
  radius <- 6371 # km
   
  dlat <- (lat2-lat1)*pi/180
  dlon <- (lon2 -lon1)*pi/180
  a <- sin(dlat/2)*sin(dlat/2) + cos(lat1*pi/180)*cos(lat2*pi/180)*sin(dlon/2)*sin(dlon/2)
  c <- 2 * atan2(sqrt(a), sqrt(1-a))
  d <- radius * c
  return(d)
}

p1 <- c(49.84025, 23.99940)
p2 <- c(49.84251, 24.03205)
haversine(p1, p2)
