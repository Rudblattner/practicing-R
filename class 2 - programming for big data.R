x<-2
x
y<-3
z<-x+y
print(z)
z<-sqrt(x^2+y^2)
z

x<-10
print(x)
x<-c("Fee", "Fie", "Foe", "Fum")
print(x)


#Data_GOOG <- read.csv(file="GOOG_May18.csv")
#Data_OilGold = read.csv(file="OilGold.csv")

#variables
ls()
#variables with values
ls.str()

rm(my_div)
my_div = c(1,2,3,4)+3.14

#Vector
num_vec = c(1*pi, 2*pi, 3*pi, 4*pi)
char_vec = c("Everyone", "loves", "stats")
log_vec = c(TRUE, TRUE, FALSE, FALSE)

#Combining Vectors
v1 = c(1,2,3)
v2 = c(4,5,6)
v3 = c(v1,v2)

x <- c(50, 46, 54, 55, 55, 52, 53, 51, 47, 49, 51, 55)
y <- c(1267, 1238, 1157, 1192, 1234, 1231, 1267, 1246, 1260, 1237, 1283, 1314)

mean(x)
median(x)
sd(x)
var(x)
cor(x,y)

#Data_GOOG <- read.csv(file="GOOG_May18.csv")
setwd("C:/Users/rudbl/Downloads/Material de estudo")
getwd()
priceData = read.csv(file="OilGold.csv", head=TRUE, sep=",")
priceData


priceData$Oil
priceData$Gold


mean(priceData$Oil)
median(priceData$Gold)
sd(priceData$Oil)
var(priceData$Gold)
cor(priceData$Oil, priceData$Gold)

1:5
seq(from=1, to=5, by=2)
rep(1, times=5)
0:9
10:19
9:0
seq(from=0, to=20)
seq(from=0, to=20, by=2)
seq(from=0, to=20, by=5)
seq(from=0, to=100, length.out = 5)
seq(from=1.0, to=2.0, lenght.out=5)

x = 5
y = 10

x = c(3,4,5)
y = c(3,5,4)

x==y
x!=y
x<y
x>y
x>=y

fib = c(0,1,1,2,3,5,8,13,21,34)
fib
fib[1]
fib[7]
fib[8:10]
fib<10
fib[fib<10]

years <- c(1998, 2002, 2006, 2010, 2014, 2018)
years
names(years) <- c("France", "Brazil", "Italy", "Spain", "Germany", "France")
years
years["Brazil"]
years[c("Italy", "Germany")]
years[names(years) == "France"]


v <- c(11, 12, 13, 14, 15)
w <- c(1, 2, 3, 4, 5)
v + w
v - w
v * w
v / w
v ^ w
mean(v)
sum(w)
sd(v)
log(w)
sin(w)


