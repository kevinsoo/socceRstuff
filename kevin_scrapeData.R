# load packages
library(XML)
library(dplyr)
library(tidyr)
library(stringr)

# this code scrapes the table for standard and control stats (11 pages each)
for (i in 1:11) {
    standard <- paste("http://www.foxsports.com/soccer/stats?competition=1&season=20150&category=STANDARD&pos=0&team=0&isOpp=0&splitType=0&sort=3&sortOrder=0&page=", i, sep="")
    standard.table <- readHTMLTable(standard, header=T, which=1, stringsAsFactors=F)
    control <- paste("http://www.foxsports.com/soccer/stats?competition=1&season=20150&category=CONTROL&pos=0&team=0&isOpp=0&splitType=0&sort=4&sortOrder=0&page=", i, sep="")
    control.table <- readHTMLTable(control, header=T, which=1, stringsAsFactors=F)
    if (i==1) {
        df.standard <- standard.table
        df.control <- control.table
    }
    else {
        df.standard <- rbind(df.standard, standard.table)
        df.control <- rbind(df.control, control.table)
    }
}

#### combine and clean data
# remove empty columns
df.standard <- na.omit(df.standard)
df.control <- na.omit(df.control)

# rename columns
colnames(df.standard) <- c("Standard", "GP", "GS", "MP", "Goals", "Assists", "ShotsOnGoal", "Shots", "YC", "RC")
colnames(df.control) <- c("Control", "GP", "GS", "MP", "Touches", "Passes", "Interceptions", "Blocks", "GoalmouthBlocks", "Tackles", "Offside", "Crosses", "CornerKicks")

# get clubs from string
df.standard$Club <- str_sub(df.standard$Standard, str_length(df.standard$Standard)-2, str_length(df.standard$Standard))
df.standard$Club <- ifelse(str_detect(df.standard$Club, " ")==TRUE, NA, df.standard$Club)
df.control$Club <- str_sub(df.control$Control, str_length(df.control$Control)-2, str_length(df.control$Control))
df.control$Club <- ifelse(str_detect(df.control$Club, " ")==TRUE, NA, df.control$Club)

# get names from string
standard <- gsub("[0-9]|\t|\n", "", df.standard$Standard) # get numbers and whitespace out
standard <- gsub("\r", " ", standard) # include a space between mentions of name
df.standard$LastName <- NA
df.standard$FirstName <- NA

control <- gsub("[0-9]|\t|\n", "", df.control$Control) # get numbers and whitespace out
control <- gsub("\r", " ", control) # include a space between mentions of name
df.control$LastName <- NA
df.control$FirstName <- NA

# clean names for standard df
for(i in 1:nrow(df.standard)) {
    # for first few rows, remove additional whitespace
    if (i<=50) {
        standard[i] <- str_replace(standard[i], "  ", "")
    }
    
    # for players with last, first name
    if (str_detect(standard[i], ",")==TRUE) {
        # get last name (before first comma)
        df.standard$LastName[i] <- str_sub(standard[i], 1, str_locate(standard[i], ',')[2]-1)
        
        # get first name (after first comma) of those with two-part last names (e.g. De Bruyne)
        if (nrow(str_locate_all(standard[i], ' ')[[1]])>=7) {
            df.standard$FirstName[i] <- str_sub(standard[i], 
                                    str_locate(standard[i], ',')[2]+2,
                                    str_locate_all(standard[i], ' ')[[1]][3]-1
            )
        }
        # get first name (after first coma) of those with one-part last names
        else if (nrow(str_locate_all(standard[i], ' ')[[1]])==5) {
            df.standard$FirstName[i] <- str_sub(standard[i], 
                                    str_locate(standard[i], ',')[2]+2,
                                    str_locate_all(standard[i], ' ')[[1]][2]-1
            )
        }
        # get first name (after first coma) of those with two part first names
        else if (nrow(str_locate_all(standard[i], ' ')[[1]])==6) {
            df.standard$FirstName[i] <- str_sub(standard[i], 
                                    str_locate(standard[i], ',')[2]+2,
                                    str_locate_all(standard[i], ' ')[[1]][3]-1
            )
        }
        # for those with no club
        else if (nrow(str_locate_all(standard[i], ' ')[[1]])==3) {
            df.standard$FirstName[i] <- str_sub(standard[i], 
                                    str_locate(standard[i], ',')[2]+2,
                                    str_locate_all(standard[i], ' ')[[1]][2]-1
            )
        }
        else {
            df.standard$FirstName[i] <- NA
        }
    }
    # for single-name players, get last name (before first space)
    else if (str_detect(standard[i], ",")==FALSE) {
        df.standard$LastName[i] <- str_sub(standard[i], 1, str_locate(standard[i], ' ')[2]-1)
    }
}

# clean names for control df
for(i in 1:nrow(df.control)) {
    # for first few rows, remove additional whitespace
    if (i<=50) {
        control[i] <- str_replace(control[i], "  ", "")
    }
    
    # for players with last, first name
    if (str_detect(control[i], ",")==TRUE) {
        # get last name (before first comma)
        df.control$LastName[i] <- str_sub(control[i], 1, str_locate(control[i], ',')[2]-1)
        
        # get first name (after first comma) of those with two-part last names (e.g. De Bruyne)
        if (nrow(str_locate_all(control[i], ' ')[[1]])>=7) {
            df.control$FirstName[i] <- str_sub(control[i], 
                                                str_locate(control[i], ',')[2]+2,
                                                str_locate_all(control[i], ' ')[[1]][3]-1
            )
        }
        # get first name (after first coma) of those with one-part last names
        else if (nrow(str_locate_all(control[i], ' ')[[1]])==5) {
            df.control$FirstName[i] <- str_sub(control[i], 
                                                str_locate(control[i], ',')[2]+2,
                                                str_locate_all(control[i], ' ')[[1]][2]-1
            )
        }
        # get first name (after first coma) of those with two part first names
        else if (nrow(str_locate_all(control[i], ' ')[[1]])==6) {
            df.control$FirstName[i] <- str_sub(control[i], 
                                                str_locate(control[i], ',')[2]+2,
                                                str_locate_all(control[i], ' ')[[1]][3]-1
            )
        }
        # for those with no club
        else if (nrow(str_locate_all(control[i], ' ')[[1]])==3) {
            df.control$FirstName[i] <- str_sub(control[i], 
                                                str_locate(control[i], ',')[2]+2,
                                                str_locate_all(control[i], ' ')[[1]][2]-1
            )
        }
        else {
            df.control$FirstName[i] <- NA
        }
    }
    # for single-name players, get last name (before first space)
    else if (str_detect(control[i], ",")==FALSE) {
        df.control$LastName[i] <- str_sub(control[i], 1, str_locate(control[i], ' ')[2]-1)
    }
}

# concatenate names
df.standard$Name <- paste(substr(df.standard$FirstName, 1, 1), ". ", df.standard$LastName, sep="")
df.standard$Name <- gsub("NA. ","", df.standard$Name)
df.control$Name <- paste(substr(df.control$FirstName, 1, 1), ". ", df.control$LastName, sep="")
df.control$Name <- gsub("NA. ","", df.control$Name)

# arrange data frames and merge
df.standard <- df.standard %>% select(LastName, FirstName, Name, Club, GP:RC) %>% arrange(Name)
df.control <- df.control %>% select(LastName, FirstName, Name, Club, GP:CornerKicks) %>% arrange(Name)
df.PL <- merge(df.standard, df.control, c("Name","LastName", "FirstName", "Club", "GP", "GS", "MP"))

# set data types
df.PL$Club <- as.factor(df.PL$Club)
df.PL$GP <- as.numeric(df.PL$GP)
df.PL$GS <- as.numeric(df.PL$GS)
df.PL$MP <- as.numeric(df.PL$MP)
df.PL$Goals <- as.numeric(df.PL$Goals)
df.PL$Assists <- as.numeric(df.PL$Assists)
df.PL$ShotsOnGoal <- as.numeric(df.PL$ShotsOnGoal)
df.PL$Shots <- as.numeric(df.PL$Shots)
df.PL$YC <- as.numeric(df.PL$YC)
df.PL$RC <- as.numeric(df.PL$RC)
df.PL$Touches <- as.numeric(df.PL$Touches)
df.PL$Passes <- as.numeric(df.PL$Passes)
df.PL$Interceptions <- as.numeric(df.PL$Interceptions)
df.PL$Blocks <- as.numeric(df.PL$Blocks)
df.PL$GoalmouthBlocks <- as.numeric(df.PL$GoalmouthBlocks)
df.PL$Tackles <- as.numeric(df.PL$Tackles)
df.PL$Offside <- as.numeric(df.PL$Offside)
df.PL$Crosses <- as.numeric(df.PL$Crosses)
df.PL$CornerKicks <- as.numeric(df.PL$CornerKicks)

# save data frames
save(df.standard, file="StandardStats_PremLeague1516.Rda")
save(df.control, file="ControlStats_PremLeague1516.Rda")
df.players <- df.PL # rename df
save(df.players, file="players_PremLeague1516.Rda")
