install.packages("RJSONIO")


getGeoCode <- function(gcStr)  {
  library("RJSONIO") #Load Library
  gcStr <- gsub(' ','%20',gcStr) #Encode URL Parameters
  #Open Connection
  connectStr <- paste('http://maps.google.com/maps/api/geocode/json?sensor=false&address=',gcStr, sep="") 
  con <- url(connectStr)
  data.json <- fromJSON(paste(readLines(con), collapse=""))
  close(con)
  #Flatten the received JSON
  data.json <- unlist(data.json)
  if(data.json["status"]=="OK")   
  {
    lat <- data.json["results.geometry.location.lat"]
    lng <- data.json["results.geometry.location.lng"]
    gcodes <- c(lat, lng)
    names(gcodes) <- c("Lat", "Lng")
    return(gcodes)
  }
}

geoCodes <- getGeoCode("Helmand irrigation Canal")
geoCodes <- getGeoCode("Hauz Khas, Delhi")

getGeoCode("Hauz Khas, Delhi")
getGeoCode("Dwarka Sector 20, Delhi")
getGeoCode("Dwarka Sector 21, Delhi")
getGeoCode("Dwarka Sector 13, Delhi")
getGeoCode("Preet Vihar, Delhi")
getGeoCode("Laxmi Nagar, Delhi")
getGeoCode("Siri Fort, Delhi")
getGeoCode("Niti Bagh, Delhi")

getGeoCode("400601, Mumbai")
