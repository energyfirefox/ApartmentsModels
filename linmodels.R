### testing diff models

result <- read.csv("estate.csv")
par(mex = 0.5)
pairs(result, gap = 0, cex.label = 0.9)

model <- lm(Ціна ~ ., data = result)
summary(model)
anova(model)

model1 <- lm(Ціна ~ Загальна.площа + km + Кімнат + Поверх + Кількість.поверхів, data = result)
summary(model1)
anova(model1)

model2 <- lm(Ціна ~ Загальна.площа + km , data = result)
summary(model2)
anova(model2)

model3 <- lm(Ціна ~ Загальна.площа  + km + Кількість.поверхів, data = result)
summary(model3)

gcenter <- as.numeric(geocode("Львів, площа Ринок", output = "latlon"))

loc <- as.numeric(geocode("Львів, вулиця Хорватська", output = "latlon"))
ldist <- mapdist(gcenter, loc)
ldist$km
area = 59
kpov = 4




testset <- data.frame(Загальна.площа = area, km = ldist$km, Кількість.поверхів = kpov)

pricep <- predict(model3, testset)

predicted.price <- predict(model3, result)
actual.price <- result$Ціна

p <- ggplot(result, aes(actual.price/1000, predicted.price/1000)) +
  geom_point() + geom_smooth(se = F, colour = "red", method = "lm") +
  xlab("Реальна ціна, тис. у.о.") + ylab("Прогнозована ціна, тис. у.о.")
p

summary(lm(predicted.price ~ actual.price))
pricep



loc <- as.numeric(geocode("Львів, вулиця Хорватська", output = "latlon"))
ldist <- mapdist(gcenter, loc)
ldist$km
prpred <- 1210.79*59 - 2004.7*1.879 - 862.98*4 + 11835


