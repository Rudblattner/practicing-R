library(ggplot2)

##Setting Working directory
setwd("C:/Users/rudbl/Downloads/Material de estudo/databases")

##Uploading dataset from CSV file
cc = read.csv("CreditCard.csv")

##Question 1

x = 98
y = 2



##Setting Working directory
setwd("C:/Users/rudbl/Downloads/Material de estudo/databases")

##Uploading dataset from CSV file
cc = read.csv("CreditCard.csv")

#Question 2

##a.	Import the chosen dataset into R Studio and assign it to a variable
#- then add a code to insert an additional column containing either "Male" or "Female". 
#The number of "Males" in the column should be equal to X (calculated in Question 1).


male = rep('male', times = 98)
#Creating male entries
female  = rep ('female', times =2 )
#Creating female entries
nond = rep('nond', times =1219)
#Creating non-defined entries to match the size of the data frame
cc$newc = c(male, female, nond)
#Created a new column using the 3 vectors created


##b.	Create a new subset of the dataset for only Males and save it as a new file named "Males_X.csv" in your working directory, where the "X" in the filename should be the numeric value of X.

#Creating subset
malesub = cc$newc[cc$newc=="male"]
#Creating the file from the subset
write.csv(malesub, 'Males_98.csv')

##Question 3

#Use R to draw the following diagrams with titles and x/y axis labels (3 x 5 marks each):
  
#a.	Represent any two numerical columns of the dataset using scatter plot and provide the output in your doc/pdf file.

#Creating scatter plot
plot(x = cc$age, y = cc$active, #defining the variables being used
     main="Active cards x age", #inserting title
     ylab="Active cards", #inserting label for y axis
     xlab="Age", #inserting label for x axis
     pch=2, #modifying the symbol
     col="blue") #modifying the color


#b.	Represent any two numerical columns of the dataset using histogram plot and provide the output in your doc/pdf file.
#creating the histogram
hist(x = cc$age, #defining the variables
     main="Age", #inserting the title
     xlab="Age", #inserting the x axis label
     col="blue") #modifying the color


#c.	Represent any two numerical columns of the dataset using box plot and provide the output in your doc/pdf file.

#creating the boxplot
boxplot(x = cc$income, #defining the variables
        ylab = "frequency", #inserting the label of the y axis
        main="Income",#inserting the title
        col="green") #modifying the color


##4.	In this Question you need to perform the following operations on the (Y+1)th numerical column (the value of Y is given by Question 1)  of the chosen dataset (4x 13  marks):
  
#a.	Find the average of the column. Print out the sentence "An average of Z was established." where Z is the column average rounded to 3 decimals.

c3 = colMeans(cc[3],dims=1) #defining the average of the column
c3avg = round(c3, 3) #rounding it up to 3
c3avgc = as.character(c3avg) #turning them into characters

print(paste('An average of',c3avgc,'was established.')) #creating the print while concatenating the results

#output
#reports 
#0.4564064 

#b.	Assign the contents of the column to a new vector. Iterate over each value of the vector and find whether each value is greater than X and, if so, replace that value with Y. 

#Creating the new vector
cb = cc[4]

#Created a loop to go through all 1319 values, using the counter to iterate between the numbers

for (val in length(cb)) {#defining the values to loop through
  if (val > x) { #conditions to be met
    val = y #change to be made
  }
}

#As per the code, it will look into all values on the vector, compare the values with X and change them if the number is larger than x.



#c.	Assign the contents of the column to a new vector. Find the maximum value of the vector and modify it to 0 without using its numerical index. Then find the 2nd maximum value of the remaining values. Print it and provide the output in your doc/pdf file.

cbmax = max(cb) #creating a vector to identify the max

for (val in length(cb)) {#defining the values to loop through
  if (val == cbmax) {#conditions to be met
    val = 0 #replacing the value
  }
}


#d.	Write a block of code to find the minimum of the column programmatically (i.e., without using the min() function).

for (val in length(cb)) #defining the values to loop through
  if (val == cbmax) {#conditions to be met

