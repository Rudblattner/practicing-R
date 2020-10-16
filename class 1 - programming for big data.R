setwd("C:/Users/rudbl/Downloads/Material de estudo")
getwd()


.Library
#read data from file
diamondData <- read.csv(file="Mispriced-Diamonds.csv")

#Install ggplot
#install.packages("ggplot2")

#Load ggplot
library(ggplot2)
#USe ggplot to draw the graph
ggplot(data=diamondData[diamondData$carat<2.5,], 
       aes(x=carat, y=price, colour=clarity))+
       geom_point(alpha=0.1) + 
       geom_smooth()


# Load ggplot
library(ggplot2)
# Use ggplot to draw the graph
ggplot(data=diamondData[diamondData$carat<1.5,], 
       aes(x=carat, y=price, colour=clarity))+
       geom_point(alpha=0.01) +
       geom_smooth()


