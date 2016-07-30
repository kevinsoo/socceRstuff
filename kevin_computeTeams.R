##########################################################
# This computes team-level data from the player-level data
# Author: Kevin Soo
##########################################################

# load packages
library(dplyr)

# load player-level data
load("players_PremLeague1516.Rda")

# calculate team-level statistics
df.teams <- df.players %>% group_by(Club) %>% 
    summarise(nPlayers=n(),
              TeamGoals=sum(Goals),
              TeamAssists=sum(Assists), 
              TeamShotsOnGoal=sum(ShotsOnGoal),
              TeamShots=sum(Shots),
              TeamYC=sum(YC),
              TeamRC=sum(RC),
              TeamTouches=sum(Touches),
              TeamPasses=sum(Passes), 
              TeamInterceptions=sum(Interceptions),
              TeamBlocks=sum(Blocks),
              TeamGoalmouthBlocks=sum(GoalmouthBlocks),
              TeamTackles=sum(Tackles),
              TeamOffside=sum(Offside),
              TeamCrosses=sum(Crosses),
              TeamCornerKicks=sum(CornerKicks)) 

# save data
save(df.teams, file="teams_PremLeague1516.Rda")