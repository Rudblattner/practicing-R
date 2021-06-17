#####Libraries#######

library(tidyverse)
library(dplyr)
library(xml2)
library(utf8)
library(rvest)
library(data.table)
library(tibble)
library(RSelenium)
library(stringr)
library(data.table)
library(tm)


####Scraping ----####

#Using Selenium library as Rvest cannot scrape dynamic java websites


#Establishing Selenium server connection
rD = rsDriver(browser="chrome", port=1912L, chromever = "90.0.4430.24")
remDr = rD[["client"]]

#Scraping from RTE website was not possible due to their limitation on going back pages
#Resorted to googling RTE Covid related news and using the navigation function
#Even google search for the whole period to be studied was limited to 33 pages, created queries for period to maximize results
#created a function to navigate through the pages and collect our links
scrape_raw_results = function(page_url, results_list, results_len){
  results_page = paste0(page_url)
  remDr$navigate(results_page)
  count = 1
  #for loop to go through the pages
  for (page_number in seq(from = 1, to = results_len, by = 1)) {
    #looking for the elements on the page
    url_list = remDr$findElements(using = "tag name", value="a")
    #the function get the elements and unlist them, so we can see them as vectors
    url = unlist(lapply(url_list, function(x) {x$getElementAttribute("href")}))
    #pasting current page being scraped to be able to follow up the process
    results_list = c(results_list, url)
    #pasting the scraped url result so it is possible to check if the scraping is being sucessful
    print(paste("url: ", url))
  if(count == results_len){
    break
    }
    count = count + 1
    #identifying the element to click for next page
    next_page <- remDr$findElement(using = 'id', "pnnext")
    #highlight element so we can see we are correctly navigating
    next_page$highlightElement()
    # select the href that links to the next page
    navigate_to = next_page$getElementAttribute("href")
    #these elements are navigating to the next page on the google website by pressing the next page button
    remDr$navigate(navigate_to[[1]])
    #allowing time to avoid being blocked by google bot detection
    Sys.sleep(30)
    print(paste("Page: ", page_number)) 
    print(paste("Count: ", count))
    print(paste("resultscount: ", length(results_list)))
  }
  return(results_list)
}

# Mar 2020 - May 2020
results_mar_may2020 = c() #creating vector to store the google results
page_url_mar_may2020 = paste0("https://www.google.com/search?q=site%3A+https%3A%2F%2Fwww.rte.ie+covid-19&biw=1536&bih=758&sxsrf=ALeKk02jUFQWAOe3L_V50b7r3Jlx3DZ_aQ%3A1621367594331&source=lnt&tbs=sbd%3A1%2Ccdr%3A1%2Ccd_min%3A3%2F1%2F2020%2Ccd_max%3A5%2F31%2F2020&tbm=nws") 
remDr$navigate(page_url_mar_may2020) #googled link is used to direct Selenium controlled browser to the first page of the search
#assign results to the created vector
results_mar_may2020 = scrape_raw_results(page_url_mar_may2020, results_mar_may2020, 26)

#the elements repeat themselves on the code for the other periods
#Jun 2020 - Aug 2020
results_jun_aug2020 = c()
page_url_jun_aug2020 = paste0("https://www.google.com/search?q=site%3A+https%3A%2F%2Fwww.rte.ie+covid-19&biw=1536&bih=758&sxsrf=ALeKk00kF4LBPlIU1AqMxvtqNjARu6hUNg%3A1621367674187&source=lnt&tbs=sbd%3A1%2Ccdr%3A1%2Ccd_min%3A6%2F1%2F2020%2Ccd_max%3A8%2F31%2F2020&tbm=nws")
remDr$navigate(page_url_jun_aug2020)
results_jun_aug2020 = scrape_raw_results(page_url_jun_aug2020, results_jun_aug2020, 27)


#Set2020 - Nov2020
results_sep_nov2020 = c()
page_url_sep_nov2020 = paste0("https://www.google.com/search?q=site%3A+https%3A%2F%2Fwww.rte.ie+covid-19&biw=1536&bih=758&source=lnt&tbs=sbd%3A1%2Ccdr%3A1%2Ccd_min%3A9%2F1%2F2020%2Ccd_max%3A11%2F30%2F2020&tbm=nws")
remDr$navigate(page_url_sep_nov2020)
results_sep_nov2020 = scrape_raw_results(page_url_sep_nov2020, results_sep_nov2020, 27)


#Dec 2020 - Mar 2021
results_dec_mar2021 = c()
page_url_dec_mar2021 = paste0("https://www.google.com/search?q=site%3A+https%3A%2F%2Fwww.rte.ie+covid-19&biw=1536&bih=758&source=lnt&tbs=sbd%3A1%2Ccdr%3A1%2Ccd_min%3A12%2F1%2F2020%2Ccd_max%3A3%2F31%2F2021&tbm=nws")
remDr$navigate(page_url_dec_mar2021)
results_dec_mar2021 = scrape_raw_results(page_url_dec_mar2021, results_dec_mar2021, 27)


#Apr 2021 - May 2021
results_apr_may2021 = c()
page_url_apr_may2021 = paste0("https://www.google.com/search?q=site%3A+https%3A%2F%2Fwww.rte.ie+covid-19&biw=1536&bih=758&sxsrf=ALeKk01Awh9mu8D8bp5QKsdL06ef8QkXKg%3A1621367797181&source=lnt&tbs=sbd%3A1%2Ccdr%3A1%2Ccd_min%3A4%2F1%2F2021%2Ccd_max%3A5%2F18%2F2021&tbm=nws")
remDr$navigate(page_url_apr_may2021)
results_apr_may2021 = scrape_raw_results(page_url_apr_may2021, results_apr_may2021, 27)


#save raw data periods to separate csv files
write.csv2(results_mar_may2020, "results_mar_may2020.csv")
write.csv2(results_jun_aug2020, "results_jun_aug2020.csv")
write.csv2(results_sep_nov2020, "results_sep_nov2020.csv")
write.csv2(results_dec_mar2021, "results_dec_mar2021.csv")
write.csv2(results_apr_may2021, "results_apr_may2021.csv")

#close connection and clean up
remDr$close()
rm(rD)
gc()

###Cleansing up ---

#the scraping process returned several pages from google itself, which were not what we were looking for.
#As all pages are from RTE, we are removing all pages with "google" and 'void', which leaves only the RTE articles behind

results_mar_may2020 = read.csv("results_mar_may2020.csv", header = TRUE, sep = ";")
results_mar_may2020 = results_mar_may2020$x
results_jun_aug2020 = read.csv("results_jun_aug2020.csv", header = TRUE, sep = ";")
results_jun_aug2020 = results_jun_aug2020$x
results_sep_nov2020 = read.csv("results_sep_nov2020.csv", header = TRUE, sep = ";")
results_sep_nov2020 = results_sep_nov2020$x
results_dec_mar2021 = read.csv("results_dec_mar2021.csv", header = TRUE, sep = ";")
results_dec_mar2021 = results_dec_mar2021$x
results_apr_may2021 = read.csv("results_apr_may2021.csv", header = TRUE, sep = ";")
results_apr_may2021 = results_apr_may2021$x

# create a function to clean raw data of unneeded information
clean_urls = function(results_raw){
  df = as.data.frame(results_raw)
  df2 = as.data.frame(df[!grepl("google", df$results_raw),])
  colnames(df2) = "url"
  df3 = as.data.frame(df2[!grepl("void", df2$url),])
  colnames(df3) = "url"
  return(df3)
}

# apply function to the raw data
cleaned_results_mar_may2020 = clean_urls(results_mar_may2020)
cleaned_results_jun_aug2020 = clean_urls(results_jun_aug2020)
cleaned_results_sep_nov2020 = clean_urls(results_sep_nov2020)
cleaned_results_dec_mar2021 = clean_urls(results_dec_mar2021)
cleaned_results_apr_may2021 = clean_urls(results_apr_may2021)

# save the file as back up for cleaned periods
write.csv2(cleaned_results_mar_may2020, "cleaned_results_mar_may2020.csv")
write.csv2(cleaned_results_jun_aug2020, "cleaned_results_jun_aug2020.csv")
write.csv2(cleaned_results_sep_nov2020, "cleaned_results_sep_nov2020.csv")
write.csv2(cleaned_results_dec_mar2021, "cleaned_results_dec_mar2021.csv")
write.csv2(cleaned_results_apr_may2021, "cleaned_results_apr_may2021.csv")

####Scraping pt 2 ---- 

#With the first scraped part, we have extracted the urls for the articles.
#They will be used with rvest to scrape the articles, dates and headlines ina for loop

#These functions will store the info scraped from the urls
scrape_articles = function(url){
  articles = read_html(url) %>%
    html_nodes(".article-body") %>%#scraping the article
    html_text()
  return(articles)
}

scrape_dates = function(url){
  date = read_html(url) %>% 
    html_nodes(".modified-date") %>% #scraping the date
    html_text()
  return(date)
}

scrape_headlines = function(url){
  headline = read_html(url) %>% 
    html_nodes(".headline") %>% #scraping the headline
    html_text()
  return(headline)
}

###First period - extracting the articles + additional info
articles = c()
dates = c()
urls = c()
headlines = c()
for (url in cleaned_results_mar_may2020$url) { #loop will go through all urls and scrape their contents
  article = scrape_articles(url)
  date = scrape_dates(url)
  headline = scrape_headlines(url)
  #print(paste("url: ", url))#checking if it is looping properly by the urls
  articles = c(articles, article)
  dates = c(dates,date)
  urls = c(urls, url)
  headlines = c(headlines, headline)
}

articles_01 = data.frame(articles)
date_01 = data.frame(dates)
url_01 = data.frame(urls)
headline_01 = data.frame(headlines)
size = length(articles)

#The scraped data must be consolidated in dataframes. For that we adjusted the df's sizes to all match the same one for their periods
#Then to facilitate reproducibility, csv files were created with the consolidated dfs.
####Consolidating the df's 
article_01 = articles_01
date_01 = date_01$dates[1:size]
url_01 = url_01$urls[1:size]
headline_01 = headline_01$headlines[1:size]
period_01 = data.frame(articles_01$articles, date_01, headline_01, url_01)
write.csv2(period_01, "period_01.csv")

###Second period - extracting the articles + additional info
articles = c()
dates = c()
urls = c()
headlines = c()
for (url in cleaned_results_jun_aug2020$url) { #loop will go through all urls and scrape their contents
  article = scrape_articles(url)
  date = scrape_dates(url)
  headline = scrape_headlines(url)
  articles = c(articles, article)
  dates = c(dates,date)
  urls = c(urls, url)
  headlines = c(headlines, headline)
}

articles_02 = data.frame(articles)
date_02 = data.frame(dates)
url_02 = data.frame(urls)
headline_02 = data.frame(headlines)
size = length(articles)

article_02 = articles_02
date_02 = date_02$dates[1:size]
url_02 = url_02$urls[1:size]
headline_02 = headline_02$headlines[1:size]
period_02 = data.frame(articles_02$articles, date_02, headline_02, url_02)
write.csv2(period_02, "period_02.csv")

###Third period - extracting the articles + additional info
articles = c()
dates = c()
urls = c()
headlines = c()
for (url in cleaned_results_sep_nov2020$url) { #loop will go through all urls and scrape their contents
  article = scrape_articles(url)
  date = scrape_dates(url)
  headline = scrape_headlines(url)
  articles = c(articles, article)
  dates = c(dates,date)
  urls = c(urls, url)
  headlines = c(headlines, headline)
}

articles_03 = data.frame(articles)
date_03 = data.frame(dates)
url_03 = data.frame(urls)
headline_03 = data.frame(headlines)
size = length(articles)

article_03 = articles_03
date_03 = date_03$dates[1:size]
url_03 = url_03$urls[1:size]
headline_03 = headline_03$headlines[1:size]
period_03 = data.frame(articles_03$articles, date_03, headline_03, url_03)
write.csv2(period_03, "period_03.csv")

###Fourth period - extracting the articles + additional info
articles = c()
dates = c()
urls = c()
headlines = c()
for (url in cleaned_results_dec_mar2021$url) { #loop will go through all urls and scrape their contents
  article = scrape_articles(url)
  date = scrape_dates(url)
  headline = scrape_headlines(url)
  articles = c(articles, article)
  dates = c(dates,date)
  urls = c(urls, url)
  headlines = c(headlines, headline)
}

articles_04 = data.frame(articles)
date_04 = data.frame(dates)
url_04 = data.frame(urls)
headline_04 = data.frame(headlines)
size = length(articles)

article_04 = articles_04
date_04 = date_04$dates[1:size]
url_04 = url_04$urls[1:size]
headline_04 = headline_04$headlines[1:size]
period_04 = data.frame(articles_04$articles, date_04, headline_04, url_04)
write.csv2(period_04, "period_04.csv")

###Fifth period - extracting the articles + additional info
articles = c()
dates = c()
urls = c()
headlines = c()
for (url in cleaned_results_apr_may2021$url) { #loop will go through all urls and scrape their contents
  article = scrape_articles(url)
  date = scrape_dates(url)
  headline = scrape_headlines(url)
  articles = c(articles, article)
  dates = c(dates,date)
  urls = c(urls, url)
  headlines = c(headlines, headline)
}
articles_05 = data.frame(articles)
date_05 = data.frame(dates)
url_05 = data.frame(urls)
headline_05 = data.frame(headlines)
size = length(articles)

article_05 = articles_05
date_05 = date_05$dates[1:size]
url_05 = url_05$urls[1:size]
headline_05 = headline_05$headlines[1:size]
period_05 = data.frame(articles_05$articles, date_05, headline_05, url_05)
write.csv2(period_05, "period_05.csv")

####Cleaning part 2 ----
###Grouping the df's --- 
#The dataframes were then grouped by month, so the analysis could follow up on a month by month basis

period_01 = read.csv2(file = "period_01.csv")
period_02 = read.csv2(file = "period_02.csv")
period_03 = read.csv2(file = "period_03.csv")
period_04 = read.csv2(file = "period_04.csv")
period_05 = read.csv2(file = "period_05.csv")


#function to group by month
Mar_2020 = period_01[period_01$date_01 %like% "Mar",]
Apr_2020 = period_01[period_01$date_01 %like% "Apr",]
May_2020 = period_01[period_01$date_01 %like% "May",]
Jun_2020 = period_02[period_02$date_02 %like% "Jun",]
Jul_2020 = period_02[period_02$date_02 %like% "Jul",]
Aug_2020 = period_02[period_02$date_02 %like% "Aug",]
Sep_2020 = period_03[period_03$date_03 %like% "Sep",]
Oct_2020 = period_03[period_03$date_03 %like% "Oct",]
Nov_2020 = period_03[period_03$date_03 %like% "Nov",]
Dec_2020 = period_04[period_04$date_04 %like% "Dec",]
Jan_2021 = period_04[period_04$date_04 %like% "Jan",]
Feb_2021 = period_04[period_04$date_04 %like% "Feb",]
Mar_2021 = period_04[period_04$date_04 %like% "Mar",]
Apr_2021 = period_05[period_05$date_05 %like% "Apr",]
May_2021 = period_05[period_05$date_05 %like% "May",]


####Creating a Corpus
#The corpus was individually created for each of the months of the analysis, on this file we have the corpus that was created 
#with the full period for the queries created


#Put documents in a list
doc.list <- list(Mar_2020,Apr_2020,May_2020,Jun_2020,Jul_2020,Aug_2020,Sep_2020,Oct_2020,Nov_2020,Dec_2020,Jan_2021,Feb_2021,Mar_2021,Apr_2021,May_2021)

N.docs <- length(doc.list)

names(doc.list) <- paste0("doc", c(1:N.docs))

#Creating a corpus 
my.docs <- VectorSource(c(doc.list))
my.docs$Names <- c(names(doc.list))

my.corpus <- Corpus(my.docs)

#Standardize the documents
getTransformations()

#remove punctuation
my.corpus = tm_map(my.corpus, removePunctuation)

#Transform to lower case
my.corpus = tm_map(my.corpus, content_transformer(tolower))

#strip digits
my.corpus =  tm_map(my.corpus, removeNumbers)

#remove stopwords from standard stopword list
my.corpus = tm_map(my.corpus, removeWords, c(stopwords("English"),
                                             "said","now", "will","come", "other", "let","left", "along", "also", "without", "came",
                                             "back", "even", "like", "last", "still", "did", "upon", "way", "yet", "can", "did", "seem",
                                             "may", "made", "know", "say", "saw", "went", "must", "think", "well", "thing", "thought",
                                             "turn", "look", "stood", "though", "see", "turn ", "seemed", "set", "need", "use", "the",
                                             "new", "nupdat", "say", "get", "take", "depart", "first", "one", "day", "two",
                                             "say ", "nupdat ", " nupdat", " say", "causal", "spoken", "kati", "duplead", "signific",
                                             "mani","nthe", "sinc", "allow", "use", "three", "told", "second", "ask", "move", "told",
                                             ))
#Strip whitespace
my.corpus = tm_map(my.corpus, stripWhitespace)

#Reduce the words to their radicals
my.corpus = tm_map(my.corpus, stemDocument)

#Substitute the words that are broken from Stem docs
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "peopl", replacement = "people")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "nupdat", replacement = "update")
my.orpus = tm_map(my.corpus,content_transformer(gsub), pattern = "measur", replacement = "measure")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "hospit", replacement = "hospital")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "countri", replacement = "country")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "emerg", replacement = "emergency")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "rté", replacement = "rte")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "pandem", replacement = "pandemic")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "servic", replacement = "service")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "vaccin", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "govern", replacement = "government")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "ministri", replacement = "ministry")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "includ", replacement = "include")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "absenc", replacement = "absence")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "countri ", replacement = "country")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "increas", replacement = "increase")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "minist", replacement = "ministry")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "vaccin ", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = " vaccin ", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "pfizerbiontech", replacement = "pfizer")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "pfizervaccinee", replacement = "pfizer")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = " pfizerbiontechvaccinee", replacement = "pfizer")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "astrazenecavaccinee", replacement = "astrazeneca")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = " covidvaccine", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = " dosevaccinee", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "mrnavaccinee", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "supplyvaccinee", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "fullyvaccine", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "johnsonvaccinee", replacement = "johnson")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "viruscovidireland", replacement = "covid")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "rolloutvaccinee", replacement = "rollout")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "virusvaccinee", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "dosesvaccinee", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "massvaccine", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "millionvaccinee", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "peopleevaccine", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "receivevaccinee", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "vaccin", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "vaccinee", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "vaccineenh", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "vaccineesnth", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "oxfordastrazeneca", replacement = "astrazeneca")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "vaccineatednmr", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "coronavirusrel", replacement = "coronavirus")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "inocul", replacement = "inoculate")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "receiv", replacement = "receive")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "medicin", replacement = "medicine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "contagi", replacement = "contagion")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "decreas", replacement = "decrease")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "mandatori", replacement = "mandatory")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "decemb", replacement = "december")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "patientsnth", replacement = "patient")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "receiv", replacement = "receive")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "promis", replacement = "promise")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "rolloutn", replacement = "rollout")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "receivee", replacement = "receive")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "inoculat", replacement = "inoculate")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "administry", replacement = "administration")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "vaccin        ", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "immunis       ", replacement = "immunisation")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "paulreiddublin", replacement = "paulreid")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "dosenin", replacement = "dose")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "dosenearli", replacement = "dose")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "suppli", replacement = "supply")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "deliveri", replacement = "delivery")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "januari", replacement = "january")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "receivee", replacement = "receive")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "advisori", replacement = "advisory")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "biontech", replacement = "pzifer")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "dosesn", replacement = "dose")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "centrenit", replacement = "centre")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "approv", replacement = "approve")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "doseer", replacement = "dose")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "advisori", replacement = "advisor")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "leftov", replacement = "leftover")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "vaccineenth", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "oldnther", replacement = "old")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "deliveri", replacement = "delivery")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "februari", replacement = "february")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "casesnspeak", replacement = "cases")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "vaccineenth", replacement = "vaccine")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "immunis", replacement = "immunisation")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "covidrel", replacement = "covid")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "casesnspeak", replacement = "cases")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "mandatori", replacement = "mandatory")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "dosenth", replacement = "dose")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "rteplay", replacement = "rte")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "diseas", replacement = "disease")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "provid", replacement = "provide")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "nurs", replacement = "nurse")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "famili", replacement = "family")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "respons", replacement = "response")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "advic", replacement = "advice")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "compani", replacement = "company")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "programm", replacement = "program")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "continu", replacement = "continue")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "countri", replacement = "country")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "manag", replacement = "manage")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "announc", replacement = "announce")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "activ", replacement = "active")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "issu", replacement = "issue")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "pleas", replacement = "please")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "requir", replacement = "require")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "centr", replacement = "centre")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "addit", replacement = "additional")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "possibl", replacement = "possible")
my.corpus = tm_map(my.corpus,content_transformer(gsub), pattern = "posit", replacement = "positive")





#Create document-term Matrix
my.corups.dtm = DocumentTermMatrix(my.corpus)

#Exploratory Data Analysis
#collapse matrix by summing over columns - this gets total counts (over all docs) for each term
freq = colSums(as.matrix(my.corups.dtm))

length(freq)

ord = order(freq, decreasing = TRUE)


#remove very frequent and very rare words
my.corpus.dtmr = DocumentTermMatrix(my.corpus, control = list(wordLengths = c(3,25)))
#we don't use the bounds here since the vector is a single document

freqr = colSums(as.matrix(my.corpus.dtmr))

#length should be the total of terms
length(freqr)

#create sort order (asc)
ordr = order(freqr, decreasing=TRUE)


#list most frequent terms, Lower bound specified as second argument
list.freq.term = findFreqTerms(my.corpus.dtmr,lowfreq = 20)

#create the histogram to show the ranked info

df = data.frame(term=names(freqr), occurrences = freqr)


hist = df %>%
  subset(freqr>1250)%>%
  ggplot(.,aes(x=reorder(term, -occurrences), y=occurrences))
hist = hist + geom_bar(stat="identity")
hist = hist+theme(axis.text.x = element_text(angle=45,hjust=1))
hist


###Word cloud ----

#limit words by specifying their min frequency
wordcloud(names(freqr), freqr, min.freq = 500, colors=brewer.pal(6,"Dark2"))



####Query 1 - Word association

associations <- findAssocs(my.corpus.dtmr, "vaccine", .8) #shows the associated words to the selected word on a 0.8 correlation level
associations

toi <- "vaccine" # term of interest
corlimit <- 0.9 #  lower correlation bound limit.
vaccin.cor <- data.frame(corr = findAssocs(my.corpus.dtmr, toi, corlimit)[[1]],
                         terms = names(findAssocs(my.corpus.dtmr, toi, corlimit)[[1]]))

vaccin.cor$terms <- factor(vaccin.cor$terms ,levels = vaccin.cor$terms)

ggplot(vaccin.cor, aes( y = terms  ) ) +
  geom_point(aes(x = corr), data = vaccin.cor) +
  xlab(paste0("Correlation with the term ", "\"", toi, "\""))


###Query 2 - Returning the frequent terms on specific documents

results.df <- data.frame(doc=names(doc.list), score=t(doc.scores))

results.df <- results.df[order(results.df$score, decreasing=TRUE), ]

print(results.df, row.names = FALSE, right=FALSE, digits = 2)



###Sentiment Analysis

#converting corpus into vector

#Syuzhet classification, classification range from -1 to +1
syuzhet = get_sentiment(corp, method="syuzhet")
head(syuzhet)
summary(syuzhet)

#bing clasdsification, classification ranges from -1 to +1

bing = get_sentiment(corp, method="bing")
head(bing)
summary(bing)

#afinn classification, classification ranges from -5 to +5
afinn = get_sentiment(corp, method="afinn")
head(afinn)
summary(afinn)


rbind(
  sign(head(syuzhet)),
  sign(head(bing)),
  sign(head(afinn))
)

#creating the emotion classification per month

sent_mar_2020 = get_nrc_sentiment(Mar_2020$articles_01.test)
sent_apr_2020 = get_nrc_sentiment(Apr_2020$articles_01.test)
sent_may_2020 = get_nrc_sentiment(May_2020$articles_01.test)
sent_jun_2020 = get_nrc_sentiment(Jun_2020$articles_02.test)
sent_jul_2020 = get_nrc_sentiment(Jul_2020$articles_02.test)
sent_aug_2020 = get_nrc_sentiment(Aug_2020$articles_02.test)
sent_sep_2020 = get_nrc_sentiment(Sep_2020$articles_05.test)
sent_oct_2020 = get_nrc_sentiment(Oct_2020$articles_05.test)
sent_nov_2020 = get_nrc_sentiment(Nov_2020$articles_05.test)
sent_dec_2020 = get_nrc_sentiment(Dec_2020$articles_03.test)
sent_jan_2021 = get_nrc_sentiment(Jan_2021$articles_03.test)
sent_feb_2021 = get_nrc_sentiment(Feb_2021$articles_03.test)
sent_mar_2021 = get_nrc_sentiment(Mar_2021$articles_03.test)
sent_apr_2021 = get_nrc_sentiment(Apr_2021$articles_04.test)
sent_may_2021 = get_nrc_sentiment(May_2021$articles_04.test)


tsmar_2020 = data.frame(t(sent_mar_2020))
dfmar2020 = data.frame(rowSums(tsmar_2020[2:73]))
names(dfmar2020)[1] <- "count"
dfmar2020 <- cbind("sentiment" = rownames(dfmar2020), dfmar2020)
rownames(dfmar2020) <- NULL
dfmar2020_2<-dfmar2020[1:8,]
quickplot(sentiment, data=dfmar2020_2, weight=count, geom="bar", fill=sentiment, ylab="count")+ggtitle("Survey sentiments - Mar 2020")

tsapr_2020 = data.frame(t(sent_apr_2020))
dfapr2020 = data.frame(rowSums(tsapr_2020[2:96]))
names(dfapr2020)[1] <- "count"
dfapr2020 <- cbind("sentiment" = rownames(dfapr2020), dfapr2020)
rownames(dfapr2020) <- NULL
dfapr2020_2<-dfapr2020[1:8,]
quickplot(sentiment, data=dfapr2020_2, weight=count, geom="bar", fill=sentiment, ylab="count")+ggtitle("Survey sentiments - Apr 2020")

tsmay_2020 = data.frame(t(sent_may_2020))
dfmay2020 = data.frame(rowSums(tsmay_2020[2:77]))
names(dfmay2020)[1] <- "count"
dfmay2020 <- cbind("sentiment" = rownames(dfmay2020), dfmay2020)
rownames(dfmay2020) <- NULL
dfmay2020_2<-dfmay2020[1:8,]
quickplot(sentiment, data=dfmay2020_2, weight=count, geom="bar", fill=sentiment, ylab="count")+ggtitle("Survey sentiments - May 2020")

tsjun_2020 = data.frame(t(sent_jun_2020))
dfjun2020 = data.frame(rowSums(tsjun_2020[2:96]))
names(dfjun2020)[1] <- "count"
dfjun2020 <- cbind("sentiment" = rownames(dfjun2020), dfjun2020)
rownames(dfjun2020) <- NULL
dfjun2020_2<-dfjun2020[1:8,]
quickplot(sentiment, data=dfjun2020_2, weight=count, geom="bar", fill=sentiment, ylab="count")+ggtitle("Survey sentiments - Jun 2020")

tsjul_2020 = data.frame(t(sent_jul_2020))
dfjul2020 = data.frame(rowSums(tsjul_2020[2:90]))
names(dfjul2020)[1] <- "count"
dfjul2020 <- cbind("sentiment" = rownames(dfjul2020), dfjul2020)
rownames(dfjul2020) <- NULL
dfjul2020_2<-dfjul2020[1:8,]
quickplot(sentiment, data=dfjul2020_2, weight=count, geom="bar", fill=sentiment, ylab="count")+ggtitle("Survey sentiments - Jul 2020")

tsaug_2020 = data.frame(t(sent_aug_2020))
dfaug2020 = data.frame(rowSums(tsaug_2020[2:78]))
names(dfaug2020)[1] <- "count"
dfaug2020 <- cbind("sentiment" = rownames(dfaug2020), dfaug2020)
rownames(dfaug2020) <- NULL
dfaug2020_2<-dfaug2020[1:8,]
quickplot(sentiment, data=dfaug2020_2, weight=count, geom="bar", fill=sentiment, ylab="count")+ggtitle("Survey sentiments - Aug 2020")

tssep_2020 = data.frame(t(sent_sep_2020))
dfsep2020 = data.frame(rowSums(tssep_2020[2:78]))
names(dfsep2020)[1] <- "count"
dfsep2020 <- cbind("sentiment" = rownames(dfsep2020), dfsep2020)
rownames(dfsep2020) <- NULL
dfsep2020_2<-dfsep2020[1:8,]
quickplot(sentiment, data=dfsep2020_2, weight=count, geom="bar", fill=sentiment, ylab="count")+ggtitle("Survey sentiments - Sep 2020")

tsoct_2020 = data.frame(t(sent_oct_2020))
dfoct2020 = data.frame(rowSums(tsoct_2020[2:120]))
names(dfoct2020)[1] <- "count"
dfoct2020 <- cbind("sentiment" = rownames(dfoct2020), dfoct2020)
rownames(dfoct2020) <- NULL
dfoct2020_2<-dfoct2020[1:8,]
quickplot(sentiment, data=dfoct2020_2, weight=count, geom="bar", fill=sentiment, ylab="count")+ggtitle("Survey sentiments - Oct 2020")

tsnov_2020 = data.frame(t(sent_nov_2020))
dfnov2020 = data.frame(rowSums(tsnov_2020[2:67]))
names(dfnov2020)[1] <- "count"
dfnov2020 <- cbind("sentiment" = rownames(dfnov2020), dfnov2020)
rownames(dfnov2020) <- NULL
dfnov2020_2<-dfnov2020[1:8,]
quickplot(sentiment, data=dfnov2020_2, weight=count, geom="bar", fill=sentiment, ylab="count")+ggtitle("Survey sentiments - Nov 2020")

tsdec_2020 = data.frame(t(sent_dec_2020))
dfdec2020 = data.frame(rowSums(tsdec_2020[2:37]))
names(dfdec2020)[1] <- "count"
dfdec2020 <- cbind("sentiment" = rownames(dfdec2020), dfdec2020)
rownames(dfdec2020) <- NULL
dfdec2020_2<-dfdec2020[1:8,]
quickplot(sentiment, data=dfdec2020_2, weight=count, geom="bar", fill=sentiment, ylab="count")+ggtitle("Survey sentiments - Dec 2020")

tsjan_2021 = data.frame(t(sent_jan_2021))
dfjan2021 = data.frame(rowSums(tsjan_2021[2:80]))
names(dfjan2021)[1] <- "count"
dfjan2021 <- cbind("sentiment" = rownames(dfjan2021), dfjan2021)
rownames(dfjan2021) <- NULL
dfjan2021_2<-dfjan2021[1:8,]
quickplot(sentiment, data=dfjan2021_2, weight=count, geom="bar", fill=sentiment, ylab="count")+ggtitle("Survey sentiments - Jan 2021")

tsfeb_2021 = data.frame(t(sent_feb_2021))
dffeb2021 = data.frame(rowSums(tsfeb_2021[2:58]))
names(dffeb2021)[1] <- "count"
dffeb2021 <- cbind("sentiment" = rownames(dffeb2021), dffeb2021)
rownames(dffeb2021) <- NULL
dffeb2021_2<-dffeb2021[1:8,]
quickplot(sentiment, data=dffeb2021_2, weight=count, geom="bar", fill=sentiment, ylab="count")+ggtitle("Survey sentiments - Feb 2021")

tsmar_2021 = data.frame(t(sent_mar_2021))
dfmar2021 = data.frame(rowSums(tsmar_2021[2:80]))
names(dfmar2021)[1] <- "count"
dfmar2021 <- cbind("sentiment" = rownames(dfmar2021), dfmar2021)
rownames(dfmar2021) <- NULL
dfmar2021_2<-dfmar2021[1:8,]
quickplot(sentiment, data=dfmar2021_2, weight=count, geom="bar", fill=sentiment, ylab="count")+ggtitle("Survey sentiments - Mar 2021")

tsapr_2021 = data.frame(t(sent_apr_2021))
dfapr2021 = data.frame(rowSums(tsapr_2021[2:198]))
names(dfapr2021)[1] <- "count"
dfapr2021 <- cbind("sentiment" = rownames(dfapr2021), dfapr2021)
rownames(dfapr2021) <- NULL
dfapr2021_2<-dfapr2021[1:8,]
quickplot(sentiment, data=dfapr2021_2, weight=count, geom="bar", fill=sentiment, ylab="count")+ggtitle("Survey sentiments - Apr 2021")

tsmay_2021 = data.frame(t(sent_may_2021))
dfmay2021 = data.frame(rowSums(tsmay_2021[2:56]))
names(dfmay2021)[1] <- "count"
dfmay2021 <- cbind("sentiment" = rownames(dfmay2021), dfmay2021)
rownames(dfmay2021) <- NULL
dfmay2021_2<-dfmay2021[1:8,]
quickplot(sentiment, data=dfmay2021_2, weight=count, geom="bar", fill=sentiment, ylab="count")+ggtitle("Survey sentiments - May 2021")

pos_df = c(dfmar2020[10,3],
           dfapr2020[10,2],
           dfmay2020[10,2],
           dfjun2020[10,2],
           dfjul2020[10,2],
           dfaug2020[10,2],
           dfsep2020[10,2],
           dfoct2020[10,2],
           dfnov2020[10,2],
           dfdec2020[10,2],
           dfjan2021[10,2],
           dffeb2021[10,2],
           dfmar2021[10,2],
           dfapr2021[10,2],
           dfmay2021[10,2])

neg_df = c(dfmar2020[9,3],
           dfapr2020[9,2],
           dfmay2020[9,2],
           dfjun2020[9,2],
           dfjul2020[9,2],
           dfaug2020[9,2],
           dfsep2020[9,2],
           dfoct2020[9,2],
           dfnov2020[9,2],
           dfdec2020[9,2],
           dfjan2021[9,2],
           dffeb2021[9,2],
           dfmar2021[9,2],
           dfapr2021[9,2],
           dfmay2021[9,2])

month = c("2020-03", "2020-04", '2020-05', '2020-06', "2020-07", "2020-08", '2020-09', 
          '2020-10', '2020-11', '2020-12', '2021-01', '2021-02', '2021-03', '2021-04', '2021-05')

pos_neg = data.frame(neg_df, pos_df,month)

ggplot()+
  geom_area(data = pos_neg, aes(y=pos_df,x=anytime(month), fill = "blue", alpha = 0.8)) + 
  geom_area(data = pos_neg, aes(y=neg_df,x=anytime(month), fill = "red", alpha = 0.8)) +
  scale_fill_discrete(name = "", labels = c("negative", "positive")) +
  guides(alpha = FALSE) +
  labs(x = "", y = "positive & negative sentiments") +
  ggtitle("Positive and negative emotions extracted on articles from RTE 
          \n from Mar 2020 to May 2021") +
  theme(plot.title = element_text(hjust = 0.5))

