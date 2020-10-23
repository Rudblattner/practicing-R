list.files()
getwd()
setwd("C:/Users/rudbl/Downloads/Material de estudo")
list.files(all.files=TRUE)
library(readxl)
tempData = read_excel("BodyTemp,xlsx")
library(readxl)
tempData
readxl_example()
.Library
tempData = read_excel("C:/Users/rudbl/Downloads/Material de estudo/BodyTemp.xlsx",1)
num = as.integer(readline(prompt = "Enter a number: "))
print(num)
##To be run in a different window, with SOURCE instead of RUN##
name = readline(prompt="Enter Name: ")
age = readline(prompt = "Enter Age: ")
age = as.integer(age)

print(paste("Hi, ", name, "next year you will be ", age+1, " years old."))

###To be run in a different window, with SOURCE instead of RUN##
weight = as.numeric(readline(prompt = "What is your weight (kilos): "))
height = as.numeric(readline(prompt = "What is your height (metres): "))
bmi = weight/(height*height)

print(paste("Your weight is ", weight, "kg, ",
            "Your height is ", height, "m, ",
            "and your BMI is ", bmi))

###Save output data###

v = c(11,12,13,14,15)
w = c(1,2,3,4)
data = v + w
data
write.csv(v, file = "test.csv", row.names = FALSE)

##Read file from internet##
adData2 = read.csv("http://faculty.marshall.usc.edu/gareth-james/ISL/Advertising.csv")
adData2

##Calculating and Saving Advertising###

totalSpend = adData2$TV + adData2$radio + adData2$newspaper
totalSpend
write.csv(totalSpend, file="Spend.csv", row.names=FALSE)


##Read Data from HTML tables###

.Library
library(XML)
library(RCurl)
url = getURL("https://www.w3schools.com/html/html_tables.asp")
tables = readHTMLTable(url)
tables
tables = readHTMLTable(url, which=3)


##On-line Baseball Data###

library(XML)
library(RCurl)
url = getURL("https://www.baseball-reference.com/teams/SFG/2017.shtml")
tables = readHTMLTable(url)
tables

##In-Built Data Sets in R###

data()
library(datasets)
data(mtcars)
data(iris)
iris
iris$Sepal.Length
iris$Sepal.Width
iris$Petal.Length
iris$Petal.Width
iris$Species

setosaIris = subset(iris, Species == "setosa")
setosaIris
versicolorIris = subset(iris, Species == "versicolor")
versicolorIris
virginicaIris = subset(iris, Species == "virginica")
virginicaIris

BigSepalWidth = subset(iris, Sepal.Width >= 3)
BigSepalWidth


###Plotting###

library(ggplot2)
plot(iris$Petal.Length, iris$Petal.Width, pch=21, bg=c("red","green3","blue")[iris$Species],
main="Edgar Anderson's Iris Data")
pairs(iris[1:4], main = "Edgar Anderson's Iris Data", pch=25, bg = c("red", "green3", "blue")[iris$Species])



###Exercise 1###

#Create an Excel file using data of your choice
#Save as both CSV and XLSX format
#Load both files into R 
#Display contents of both files

library("xlsx")

exercise1.C4 = c(1,2,3,4)
write.csv(exercise1.C4, file = "exercise1.C4.csv", row.names = FALSE)
createworkbook (exercise1.C4, file = "exercise1.C4.xlsx", row.names = FALSE)

ex1.csv = read.csv("exercise1.C4.csv")
ex1.xlsx = read_excel("exercise1.C4.xlsx")




#Read and display data from the following URL:
#  http://faculty.marshall.usc.edu/gareth-james/ISL/Income1.csv
#Create a new variable "Percent"
#This is the percentage of Family Income spent on Education
#Formula: (Education/Income)*100
#Display the variable "Percent"
#Calculate mean percentage of income spent on education



