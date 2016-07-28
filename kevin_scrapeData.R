# load packages
library(XML)
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
theme_set(theme_bw())

# this code scrapes the table for standard stats (11 pages)
for (i in 1:11) {
    fox <- paste("http://www.foxsports.com/soccer/stats?competition=1&season=20150&category=STANDARD&pos=0&team=0&isOpp=0&splitType=0&sort=3&sortOrder=0&page=", i, sep="")
    fox.table <- readHTMLTable(fox, header=T, which=1,stringsAsFactors=F)
    if (i==1) {
        standard.df <- fox.table
    }
    else {
        standard.df <- rbind(standard.df, fox.table)
    }
}

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

#### combine and clean data
# rename columns
colnames(standard.df) <- c("Standard", "GP", "GS", "MP", "Goals", "Assists", "ShotsOnGoal", "Shots", "YC", "RC")
colnames(control.df) <- c("Control", "GP", "GS", "MP", "Touches", "Passes", "Interceptions", "Blocks", "GoalmouthBlocks", "Tackles", "Offside", "Crosses", "CornerKicks")

standard.df$Name <- str_replace_all(standard.df$Standard, "\n" , " ")
standard.df$Name <- str_replace_all(standard.df$Name, "\r" , "")
standard.df$Name <- str_replace_all(standard.df$Name, "\t" , "")

# save data frames
save(standard.df, file="StandardStats_PremLeague1516.Rda")
save(control.df, file="ControlStats_PremLeague1516.Rda")

