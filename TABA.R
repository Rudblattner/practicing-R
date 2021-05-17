#####Libraries#######

library(tidyverse)
library(dplyr)
library(xml2)
library(utf8)
library(rvest)
library(data.table)
library(tibble)
library(RSelenium)


#Establishing Selenium server connection
rD = rsDriver(browser="chrome", port=1248L, chromever = "90.0.4430.24")
remDr = rD[["client"]]

###Selenium scraping for dynamic websites
remDr$navigate("https://www.thejournal.ie/covid19-facts/news/page/1") #navigate to url to be scraped
remDr$getStatus() #checking status

RTE_covid = read_html(remDr$getPageSource()[[1]])#setting main page url
RTE_covid

covid_data = data.frame() #creating an empty df to hold the data

for (page_number in seq(from = 1, to = 2, by = 1)) { #for loop iterating through all the pages
  remDr$navigate(paste0(".title",page_number))
  RTE_covid = read_html(remDr$getPageSource()[[1]])
  Sys.sleep(10)
  
  headline = RTE_covid %>% html_nodes(".title") %>% html_text() #extracting the headlines
  #url = RTE_covid %>% html_nodes("a") %>% html_attr("href")

  covid_data = rbind(covid_data, data.frame(headline)) #biding the extracted info into a df
  
  print(paste("Page: ", page_number)) #pasting current page being scraped to be able to follow up the process
  
}


covid = as.data.frame(unique(covid_data))

write.csv(covid, "covid_data.csv")



for (i in length(covid$url)) {
    covid$text = read_html(covid$url[i]) %>%
                          html_nodes(".lancio-text p , .lancio-standfirst") %>%
                          html_text() 
    
    print(paste("i: ", i))
}


test = read_html("https://www.independent.ie/search/?q=covid&order=relevance&contextPublication=false&start=0")
  
test =test %>%
  headline = RTE_covid %>% html_nodes("span") %>% html_text() #extracting the headlines
  url = RTE_covid %>% html_nodes("span") %>% html_attr("href")

test = as.data.frame(test)

write.table(test, file = "test.txt", sep = "")


Nov_03_2020 = read_html("https://www.rte.ie/news/coronavirus/2020/1103/1175591-covid-19-ireland/")

Nov_03_2020 = Nov_03_2020 %>%
  html_nodes(".article-body") %>%
  html_text() 

Nov_03_2020 = as.data.frame(Nov_03_2020)

write.table(Nov_03_2020, file = "Nov_03_2020.txt", sep = "")



