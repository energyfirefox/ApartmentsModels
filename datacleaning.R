library(ggmap)

obj1 <- read.table("~/Projects/realestate/data/page1.csv", header = T, dec = ",", stringsAsFactors = F, sep = ",", na.strings = "NA")
obj2 <- read.table("~/Projects/realestate/data/page2.csv", header = T, dec = ",", stringsAsFactors = F, sep = ",", na.strings = "NA")
obj3 <- read.table("~/Projects/realestate/data/page3.csv", header = T, dec = ",", stringsAsFactors = F, sep = ",", na.strings = "NA")
obj4 <- read.table("~/Projects/realestate/data/page4.csv", header = T, dec = ",", stringsAsFactors = F, sep = ",", na.strings = "NA")
obj5 <- read.table("~/Projects/realestate/data/page5.csv", header = T, dec = ",", stringsAsFactors = F, sep = ",", na.strings = "NA")
obj6 <- read.table("~/Projects/realestate/data/page6.csv", header = T, dec = ",", stringsAsFactors = F, sep = ",", na.strings = "NA")
obj7  <- read.table("~/Projects/realestate/data/page7.csv", header = T, dec = ",", stringsAsFactors = F, sep = ",", na.strings = "NA")
obj8 <- read.table("~/Projects/realestate/data/page8.csv", header = T, dec = ",", stringsAsFactors = F, sep = ",", na.strings = "NA")
obj9 <- read.table("~/Projects/realestate/data/page9.csv", header = T, dec = ",", stringsAsFactors = F, sep = ",", na.strings = "NA")
obj10 <- read.table("~/Projects/realestate/data/page11.csv", header = T, dec = ",", stringsAsFactors = F, sep = ",", na.strings = "NA")

colnames(obj4) <- colnames(obj1)
colnames(obj5) <- colnames(obj1)
colnames(obj6) <- colnames(obj1)
colnames(obj7) <- colnames(obj1)
colnames(obj8) <- colnames(obj1)
colnames(obj9) <- colnames(obj1)
colnames(obj10) <- colnames(obj1)




flobj <- rbind(obj1, obj2, obj3, obj4, obj5, obj6, obj7, obj8, obj9, obj10)

flobj <- flobj[flobj$Ціна >= 18000 & flobj$Кімнат < 6, ]
flobj <- flobj[complete.cases(flobj), ]

names(flobj)



dbase <- flobj[ ,c( "Місто", "Вулиця" , "Ціна", "Загальна.площа",
                    "Кімнат", "Поверх", "Кількість.поверхів", 
                    "Житлова.площа", "Кухня")] 




dbase <- dbase[complete.cases(dbase), ]
dbase <- dbase[dbase$Вулиця != "", ]
dbase$Вулиця[dbase$Вулиця == "Дж.Вашингтона"] <- "Джорджа Вашингтона"



dbase <- transform(dbase, Адреса = paste(dbase$Місто, dbase$Вулиця, sep = ", "))
class(dbase$Адреса)
dbase$Адреса <- as.character(dbase$Адреса)

#### add distances to data
adress <- unique(dbase$Адреса)

gcodes <- geocode(adress, output = "latlon")
!!! ##### cbind gcodes + address and write to .csv  
adcodes <- data.frame(adress = adress, lon = gcodes$lon, lat = gcodes$lat )  
write.csv(adcodes, "adgcodes.csv", row.names  = F)

ugcodes <- unique(gcodes)
gcenter <- as.numeric(geocode("Львів, площа Ринок", output = "latlon"))


wh <- as.numeric(ugcodes[1, ])
dist <- mapdist(wh, gcenter, output = "simple", language = "uk-UA")
gcod <- as.data.frame(dist)

for (i in 32:length(ugcodes$lon)){
  wh <- as.numeric(ugcodes[i, ])
  dist <- mapdist(wh, gcenter, output = "simple")
  gcod <- rbind(gcod, dist)
}
#
ugcodes[32, ]##gcod - відстані від площі ринок до gcodes, ugcodes - unique від adresss


gcodesdist <- cbind(gcod, ugcodes)
write.csv(gcodesdist, "gcodedist.csv", row.names  = F)

### total data frame with addresses, geocodes and distances to square Rynok in Lviv
unistreetdist <- merge(gcodesdist, adcodes, by = c("lon", "lat"), all = T)


### select only dist in km, address and geocode
ugeodistances <- unistreetdist[ , c("lon", "lat", "km", "adress")]
ugeodistances$adress <- as.character(ugeodistances$adress)

##########
result <- merge(dbase, ugeodistances, by.x = "Адреса", by.y = "adress")
result <- unique(result)

names(result)
result <- result[ , c("Ціна", "Кімнат", "Поверх" ,"Кількість.поверхів", "Загальна.площа" ,  "Житлова.площа",
                      "Кухня" , "km")]

table(result$km)
result <- result[result$km < 15, ]
result <- result[result$Ціна > 10000, ]
write.csv(result, "estate.csv", row.names = F)


