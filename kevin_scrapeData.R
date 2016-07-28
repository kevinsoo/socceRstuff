# load packages
library(XML)
library(dplyr)
library(tidyr)
library(ggplot2)
theme_set(theme_bw())

# this code scrapes the table for standard stats (11 pages)
for (i in 1:11) {
    fox <- paste("http://www.foxsports.com/soccer/stats?competition=1&season=20150&category=CONTROL&pos=0&team=0&isOpp=0&splitType=0&sort=4&sortOrder=0&page=", i, sep="")
    fox.table <- readHTMLTable(fox, header=T, which=1,stringsAsFactors=F)
    if (i==1) {
        control.df <- fox.table
    }
    else {
        control.df <- rbind(control.df, fox.table)
    }
}

head(control.df)

# this code scrapes the table for control stats (11 pages)
for (i in 1:11) {
    fox <- paste("http://www.foxsports.com/soccer/stats?competition=1&season=20150&category=CONTROL&pos=0&team=0&isOpp=0&splitType=0&sort=4&sortOrder=0&page=", i, sep="")
    fox.table <- readHTMLTable(fox, header=T, which=1,stringsAsFactors=F)
    if (i==1) {
        control.df <- fox.table
    }
    else {
        control.df <- rbind(control.df, fox.table)
    }
}

head(control.df)
