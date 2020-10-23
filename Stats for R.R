##Statistics with R###

library(ggplot2)
.Library
getwd()
StatR = read.csv("Advertising.csv")
summary(StatR)
shapiro.test(StatR$TV)
shapiro.test(StatR$radio)
shapiro.test(StatR$newspaper)
shapiro.test(StatR$sales)

###Creating images with R###
hist(StatR$TV)
png(file="C:/Users/rudbl/Downloads/Material de estudo/histTV.jpeg", width = 700, height = 700)
hist(StatR$TV)
dev.off() ###Command used to inform R that the commands are done and it can create the image###

boxplot(StatR$X)


###Variation, STD Variation
var(StatR$TV)
sd(StatR$TV)
###Calculating confidence intervals in R##
t.test(StatR$TV) #Since there's no native way of calculating confidence intervals in R, 
##we use the T test and take the interval it returns for that
t.test(StatR$TV, conf.level = 0.9)##conf.level parameter allow us to force a value for the confidence interval. Std=0.95

media = mean(StatR$TV)
hist(StatR$TV)
abline(v=media, col="blue", lwd=2)
abline(v=137.0102, col="red", lwd=4)
abline(v=159.0139, col="green3", lwd=4)

##Hypothesis testing

x1 =runif(30, 37.9, 38.8)
x1
x2 = runif(30, 36, 38.2)
x2

t.test(x1, x2)
wilcox.test(x1, x2)

#Correlation
cor(StatR$TV, StatR$radio)
cor(StatR$TV, StatR$sales)
cor(StatR$radio, StatR$sales)
cor(StatR$newspaper, StatR$sales)
cor(StatR$TV, StatR$newspaper)


cor(StatR$TV, StatR$radio, method = "pearson") #the cor std is pearson
cor(StatR$TV, StatR$radio, method = "spearman") #but you can use spearman as well when you dont have a normal dist.
cor(StatR$TV, StatR$sales, method = "spearman")
cor(StatR$radio, StatR$sales, method = "spearman")
cor(StatR$newspaper, StatR$sales, method = "spearman")
cor(StatR$TV, StatR$newspaper, method = "spearman")


a = c(37, 420, 117)
b = c(29, 8,3)
cor(a,b)


##Linear regression

##First check if the data is spread in a way that can be used (points need to be minimally close to the mean)

ggplot(data = StatR, mapping = aes(x=TV, y=sales)) + 
geom_point()

lm(formula = StatR$TV ~ StatR$sales)  ##The model is lm(formula = y ~ x) which means y depends of x##

##Based on the result we come up with the following function:
f(y) = -33.45 + 12.87*x ##with X being the number we are trying to predict
##The firsy number (Intercept) becomes the constant and the second number (coefficient) is the number we will multiply x for


