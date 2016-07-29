# load packages
library(XML)
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
theme_set(theme_bw())

# this code scrapes the table for standard and control stats (11 pages each)
for (i in 1:11) {
    standard <- paste("http://www.foxsports.com/soccer/stats?competition=1&season=20150&category=STANDARD&pos=0&team=0&isOpp=0&splitType=0&sort=3&sortOrder=0&page=", i, sep="")
    standard.table <- readHTMLTable(fox, header=T, which=1, stringsAsFactors=F)
    control <- paste("http://www.foxsports.com/soccer/stats?competition=1&season=20150&category=CONTROL&pos=0&team=0&isOpp=0&splitType=0&sort=4&sortOrder=0&page=", i, sep="")
    control.table <- readHTMLTable(fox, header=T, which=1, stringsAsFactors=F)
    if (i==1) {
        df.standard <- standard.table
        df.control <- control.table
    }
    else {
        df.standard <- rbind(df.standard, standard.table)
        df.control <- rbind(df.control, fox.table)
    }
}

#### combine and clean data
# rename columns
colnames(df.standard) <- c("Standard", "GP", "GS", "MP", "Goals", "Assists", "ShotsOnGoal", "Shots", "YC", "RC")
colnames(df.control) <- c("Control", "GP", "GS", "MP", "Touches", "Passes", "Interceptions", "Blocks", "GoalmouthBlocks", "Tackles", "Offside", "Crosses", "CornerKicks")

# remove empty columns
df.standard <- na.omit(df.standard)
df.control <- na.omit(df.control)

# get clubs from string
df.standard$Club <- str_sub(df.standard$Standard, str_length(df.standard$Standard)-2, str_length(df.standard$Standard))
df.control$Club <- str_sub(df.control$Control, str_length(df.control$Control)-2, str_length(df.control$Control))
df.standard$Club <- ifelse(str_detect(df.standard$Club, " ")==TRUE, NA, df.standard$Club)
df.control$Club <- ifelse(str_detect(df.control$Club, " ")==TRUE, NA, df.control$Club)

# get names from string
df.standard$Name <- str_replace_all(df.standard$Standard, "\n" , " ")
df.standard$Name <- str_replace_all(df.standard$Name, "\r" , "")
df.standard$Name <- str_replace_all(df.standard$Name, "\t" , "")
df.control$Name <- str_replace_all(df.control$Control, "\n" , " ")
df.control$Name <- str_replace_all(df.control$Name, "\r" , "")
df.control$Name <- str_replace_all(df.control$Name, "\t" , "")

for (i in 1:nrow(df.standard)) {
    df.standard$Name[i] <- str_sub(df.standard$Name[i], 
                                   str_locate_all(df.standard$Name[i], ", ")[[1]][1,2] + 1, 
                                   str_locate_all(df.standard$Name[i], ", ")[[1]][2,1] - 1)
    df.control$Name[i] <- str_sub(df.control$Name[i],
                                   str_locate_all(df.control$Name[i], ", ")[[1]][1,2] + 1, 
                                   str_locate_all(df.control$Name[i], ", ")[[1]][2,1] - 1)
}

# collect data frames
df.standard <- df.standard %>% select(Name, Club, GP:RC)

# save data frames
save(df.standard, file="StandardStats_PremLeague1516.Rda")
save(df.control, file="ControlStats_PremLeague1516.Rda")

