# load packages
library(XML)
library(dplyr)
library(tidyr)
library(ggplot2)
library(rvest)
library(httr)
theme_set(theme_bw())


# rvest test

url="http://www.foxsports.com/soccer/stats?competition=1&season=20150&category=STANDARD"
foxPage <- GET(url, add_headers('user-agent' = 'r'))
#foxPage <- read_html("http://www.foxsports.com/soccer/stats?competition=1&season=20150&category=STANDARD")


# class: wisbb_standardTable
players <- character(10)
for(i in 1:10){
    players[i] <- foxPage %>%
        read_html() %>%
        html_node(xpath= paste('//*[@id="wisfoxbox"]/section[2]/div[1]/table/tbody/tr[', i, ']/td[1]/div/a/span[1]', sep='')) %>%
        html_text()
}

players

head(foxPage)


//*[@id="wisfoxbox"]/section[2]/div[1]/table/tbody/tr[i]/td[1]/div/a/span[1]
//*[@id="wisfoxbox"]/section[2]/div[1]/table/tbody/tr[2]/td[1]/div/a/span[1]














# this code scrapes the table for standard stats (11 pages)
for (i in 1:11) {
    urlPage <- paste("http://www.foxsports.com/soccer/stats?competition=1&season=20150&category=STANDARD&pos=0&team=0&isOpp=0&splitType=0&sort=3&sortOrder=0&page=", i, sep='')
    pagehtml <- htmlParse(urlPage, isURL = TRUE, encoding = 'UTF -8')
    fox <- pagehtml
    fox.table <- readHTMLTable(fox, header=T, which=1,stringsAsFactors=F)
    if (i==1) {
        standard.test <- fox.table
    }
    else {
        standard.test <- rbind(standard.test, fox.table)
    }
}




# data frames:
View(control.df)

substr("1\r\n\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t", 1, 13)
#2\r\n\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t
#2\r\n\t\t\t\t\t\r\n\t\t\t\t\t\t\t\t\t


substr("abcdef", 2, 4)
