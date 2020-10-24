###Stats in R: Intro to modeling 

#-------------------------------------------------------------------------------
#Working question: which of the variables affect the air quality?
#-------------------------------------------------------------------------------

library(ggplot2)
library(Ecdat)
data("Airq")
names(Airq)

###Describing the variables###

## airq: Air quality index (the lower, the better) - This will be the answer variable, in which we will compare our remaining data against
## vala:  worth of the city companies (in millions of USD)
## rain: amount of rain (in inches)
## coas: is it positioned at the coast? (Y or N)
## dens: populational density (in sqrd miles)
## medi: average income per capta (in USD)


#-------------------------------------------------------------------------------
##EDA

summary(Airq)


##Plotting the data for visualization
plot(airq~vala, data=Airq)

ggplot(data=Airq, mapping = aes(y=airq, x=vala)) + 
geom_point()


###Creating an statistical model
## y ~ x 
## y ~ x1 + x2 + x3 ... +xn
##airq ~ vala + coas + rain

#-------------------------------------------------------------------------------

##Putting the model together

m1 = lm(airq ~ vala, data = Airq) # linear model
#Some models might not be linear
summary(m1) #to understand the model significance


##P-value indicate if the variable or model are significant
##If the p-value is  <(0.05) the variable is significant
## If the p-value is higher than 0.05 we cannot see the expected effect


#The "vala" variable didn't influence the air quality in cities ("airq")
# the "coas" variable does influence the air quality 
m2=lm(airq ~ coas, data=Airq)
summary(m2)
##Yes, the coastal position does affect the air quality
##The coastal cities generally have a better air quality
plot(airq ~  coas, data = Airq)

m3 = lm(airq ~ medi, data = Airq)
summary(m3)
plot(airq ~ medi, data = Airq)
##The variable medi does not influence in the air quality

m4 = lm(airq ~ rain, data = Airq)
summary(m4)
##The variable rain does not influence in the air quality

m5 = lm(airq ~ dens, data = Airq)
summary(m5)
##The variable dens does not influence in the air quality

##lines on of non-significant variables are optional in graphs

#lines on graphs

plot(airq ~ medi, data = Airq)
curve(9.936e+01 + 5.638e-04*x, add=TRUE)
# y = a + b*x
# a = intercept (where a touches the y axis)
# b = it's the line inclination

##improving the graph

plot(airq ~ medi, data = Airq, xlab = "Average income per capta", ylab = "Air quality", pch = 5, cex=1.2, 
     col = "blue", cex.lab = 1.3)
curve(9.936e+01 + 5.638e-04*x, add=TRUE, col = "darkblue", lwd=2, lty=3)


plot(airq ~ coas, data = Airq, xlab = "Coastal city", ylab = "Air quality", pch = 5, cex=1.2, 
     col = "pink", cex.lab = 1.3, ylim=c(50,170), main="Air Quality x Coastal city")


plot(airq ~ vala, data =Airq, xlab = "Value of the city companies", ylab = "Air Quality", col = "darkgreen", cex.lab = 1.3, pch = 8)
curve(96.451419 + 0.001969*x, add = TRUE, col = "purple", lwd = 2.5, lty = 8)
#-------------------------------------------------------------------------------
### Multiple variable regression

mRM1 = lm(airq ~ vala + coas, data = Airq)
summary(mRM1)
##There is a relation from value of the city companies and coastal city position in the air quality
#-------------------------------------------------------------------------------
## Multiple regression graph

plot(airq ~ vala, data=Airq, xlab="Value of the companies", ylab = "Air quality", col = "darkblue", cex = 1.2, pch = 16)
curve (1.171e+02 + 1.999e-03 * x, add = TRUE, col = "red", lwd = 2 ) #non-coastal city
curve (1.171e+02 + 1.999e-03 * x + -2.968e+01, lty = 2, add = TRUE, col = "darkgreen", lwd = 2) #coastal city
legend("bottomright", c("non-coastal", "coastal"), pch = 16, lty = c(1,2), bty = "n")

#The air quality is affected  by both the company values and coastal position of the city.
#The higher the company value, worst is the air quality. Also, non-coastal cities have a worst air quality than coastal cities;


mRM2 = lm(airq ~ vala + coas + dens, data = Airq)
summary(mRM2)
#-------------------------------------------------------------------------------
##Model contrast
#Comparing a complete model with a model without the variable to be analyzed

completeModel  = lm(airq ~ vala + coas + dens, data = Airq)
incompletemodel = lm(airq ~ vala + coas, data = Airq)
#Are the models the same?
#If p>0.05, there is no difference between the models
#if there's no difference between the models, keep the simplest one
#if p<0.05, the variable shouldn't be taken out

anova(completeModel, incompletemodel)
#According to the ANOVA test, the variable density is not relevant to our model(p-value >0,05), therefore, it will be excluded

#-------------------------------------------------------------------------------
#Final Graph
plot(airq ~ vala, data=Airq, xlab="Value of the companies", ylab = "Air quality", col = "darkblue", cex = 1.2, pch = 16, cex.lab=1.3)
curve (1.171e+02 + 1.999e-03 * x, add = TRUE, col = "red", lwd = 2 ) #non-coastal city
curve (1.171e+02 + 1.999e-03 * x + -2.968e+01, lty = 2, add = TRUE, col = "darkgreen", lwd = 2) #coastal city
legend("bottomright", c("non-coastal", "coastal"), pch = 16, lty = c(1,2), bty = "n", col=c("red", "darkgreen"))


##Conclusion
#-------------------------------------------------------------------------------
#What affect the air quality in the cities
#Coastal cities present a better air quality and the higher is the cities' company value, worse is the air quality
