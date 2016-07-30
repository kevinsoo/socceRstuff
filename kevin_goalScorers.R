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
load("AllData_PremLeague1516.Rda")

# calculate team-level statistics
df.teams <- df.PL %>% group_by(Club) %>% 
    summarise(nPlayers=n(),
              TeamGoals=sum(Goals),
              aveGoals=mean(Goals),
              TeamAssists=sum(Assists), 
              aveAssists=mean(Assists),
              TeamShots=sum(Shots),
              aveShots=mean(Shots),
              TeamShotsOnGoal=sum(ShotsOnGoal),
              aveShotsOnGoal=mean(ShotsOnGoal),
              TeamTouches=sum(Touches),
              aveTouches=mean(Touches),
              TeamPasses=sum(Passes),
              avePasses=mean(Passes)) %>%
    mutate(PassingRate=TeamPasses/TeamTouches)

# merge team with individual level stats
df.PL <- merge(df.PL, df.teams, by="Club")

# calculate individual-level ratios and mark the top few players
df.PL <- df.PL %>% mutate(ShotAccuracy=ShotsOnGoal/Shots, 
                          ScoringAccuracy=Goals/ShotsOnGoal,
                          ScoringRate=Goals/MP,
                          Selfishness=Passes/Touches,
                          Passingness=Selfishness/PassingRate)
scorers <- df.PL %>% filter(Goals>0, GP>5)
scorers$ID <- ifelse(scorers$Goals>15, scorers$Name, NA) 

# plot selfishness against scoring rate for goalscorers
ggplot(scorers, aes(x=Passingness, y=ScoringRate, color=Goals)) + 
    geom_point() +
    geom_label_repel(aes(label=ID)) +
    stat_smooth(method="lm", color="red", size=0.5) +
    xlab("Passing rate relative to team (1 = team average)") +
    ylab("Goals per minute of play") +
    ggtitle("Do more 'selfish' players score more goals?")

