# load packages
library(XML)
library(dplyr)
library(tidyr)
library(ggplot2)
theme_set(theme_bw())

# this code scrapes the table for control stats for 

fox <- "http://www.foxsports.com/soccer/stats?competition=1&season=20150&category=CONTROL&pos=0&team=0&isOpp=0&splitType=0&sort=4&sortOrder=0&page=1"
fox.table = readHTMLTable(fox, header=T, which=1,stringsAsFactors=F)
