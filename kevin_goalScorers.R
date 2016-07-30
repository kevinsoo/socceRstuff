###################################
# Plot stuff related to goalscoring
# Author: Kevin Soo
###################################

# load packages
library(dplyr)
library(ggplot2)
library(ggrepel)
library(ggthemes)
library(ggsci)
library(gganimate)
library(gapminder)
theme_set(theme_bw())

# load data
load("players_PremLeague1516.Rda")
load("teams_PremLeague1516.Rda")

# merge data
df.all <- merge(df.players, df.teams, by="Club")

# calculate individual-level ratios and mark the top few players
df.all <- df.all %>% mutate(ShotAccuracy=ShotsOnGoal/Shots, 
                          ScoringAccuracy=Goals/ShotsOnGoal,
                          ScoringRate=Goals/MP,
                          Selfishness=Passes/Touches)
scorers <- df.all %>% filter(Goals>0, GP>5)
scorers$ID <- ifelse(scorers$Goals>15, scorers$Name, NA) 

# plot selfishness against scoring rate for goalscorers
ggplot(scorers, aes(x=Selfishness/(TeamPasses/TeamTouches), y=ScoringRate, color=Goals)) + 
    geom_point() +
    geom_label_repel(aes(label=ID)) +
    stat_smooth(method="lm", color="red", size=0.5) +
    xlab("Passing rate relative to team (1 = team average)") +
    ylab("Goals per minute of play") +
    ggtitle("Do more 'selfish' players score more goals?")

