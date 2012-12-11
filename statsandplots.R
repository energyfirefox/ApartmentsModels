### statistcs and graphs

##### read datafrom .csv

result <- read.csv("estate.csv")

flobj <- result
#### correlation test
cor(result)

library(ggplot2)
library(ggmap)

names(flobj)
flobj <- flobj[flobj$Ціна >= 18000 & flobj$Кімнат < 6, ]
flobj <- flobj[complete.cases(flobj), ]
summary(flobj)

odnk <- flobj[flobj$Кімнат == 1, ]
dwok <- flobj[flobj$Кімнат == 2, ]
tryk <- flobj[flobj$Кімнат == 3, ]

x <- summary(odnk)
odnstats <- data.frame(Ціна = x[ ,8], Площа = x[ , 12])

y <- summary(dwok)
dwokstats <- data.frame(Ціна = y[ ,8], Площа = y[ , 12])

z <- summary(tryk)
trykstats <- data.frame(Ціна = z[ ,8], Площа = z[ , 12])
table(tryk$Ціна)

price <- data.frame(Однокімнатні = x[ ,8], Двокімнатні = y[ ,8], Трикімнатні = z[ ,8] )
area <- data.frame(Однокімнатні = x[ ,12], Двокімнатні = y[ ,12], Трикімнатні = z[ ,12])

p <- ggplot(flobj, aes(factor(Кімнат), Загальна.площа)) +
      geom_boxplot(colour = "steelblue") +
      xlab("Кімнат") + ylab("Загальна площа (кв.м.)")
      
p 

p <- ggplot(flobj, aes(factor(Кімнат), Ціна/1000)) +
  geom_boxplot(colour = "steelblue") +
  xlab("Кімнат") + ylab("Ціна, тис. у.о.")

p

p <- ggplot(flobj, aes(Загальна.площа, Ціна/1000)) +
  geom_point() + geom_smooth(se = F, colour = "red") +
  xlab("Загальна площа") + ylab("Ціна, тис. у.о.")
p

p <- ggplot(flobj, aes(Кухня, Ціна/1000)) +
  geom_point() + geom_smooth(se = F, colour = "red") +
  xlab("Площа кухні") + ylab("Ціна, тис. у.о.")
p

p <- ggplot(flobj, aes(Поверх, Ціна/1000)) +
  geom_point() + geom_smooth(se = F, colour = "red") +
  xlab("Поверх") + ylab("Ціна, тис. у.о.")
p

p <- ggplot(flobj, aes(Кількість.поверхів, Ціна/1000)) +
  geom_point() + geom_smooth(se = F, colour = "red") +
  xlab("Кількість поверхів") + ylab("Ціна, тис. у.о.")
p


p <- ggplot(result, aes(km, Ціна/1000)) +
  geom_point() +
  geom_smooth() +
  xlab("Відстань, км") + ylab("Ціна, тис. у.о.") 

p


gbreaks <- c(0, 50000, 75000, 100000, 150000, 200000, 300000, 500000)
g <- cut(dbase$Ціна, breaks = gbreaks)
levels(g)
dbase <- transform(dbase, g = g)

mapLv <- get_map(location = 'Ukraine, Lviv', zoom = 13)
ggmap(mapLv) +
  geom_point(data = dbase, aes(Lon, Lat), colour = "red", size = dbase$Ціна/30000, alpha = 1/3) 





