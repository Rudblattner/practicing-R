setwd('C:/Users/rudbl/Downloads/Material de estudo')
Data = read.csv('Avengers database.csv')
install.packages('tidyverse')
install.packages(c("nycflights13", "gapminder", "Lahman"))

ggplot2 :: mpg

library(ggplot2)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data=mpg)
mpg
?mpg


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = hwy, y = cyl))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = class, y = drv))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))


ggplot(data = mpg) + 
  geom_point(mapping = aes (x =displ, y = hwy, size = class ))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))


ggplot(data = mpg)  + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "purple")


mpg
?mpg


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue", size = 2, shape = 8, alpha = 0.2)


?geom_point


ggplot(data = mpg) + 
  geom_point(mapping = aes(x =  displ, y = hwy), shape = 4, stroke = 0.2)


ggplot(data = mpg) + 
  geom_point(mapping = aes(colour = displ<5, x = displ, y = hwy))


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

?facet_wrap

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y=hwy)) + 
  facet_grid(drv ~ cyl)



ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(drv ~ .)


ggplot(data = mpg) + 
  geom_point (mapping = aes(x = displ, y = ))
