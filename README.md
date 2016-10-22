# socceRstuff
<b>Collecting, cleaning and visualizing soccer data</b>

I've collected and cleaned the Premier League 2015-2016 standard and control statistics. The file `kevin_scrapeData.R` does this, producing a data frame combining the original two tables of player data. I also computed team-level data.

I recommend just starting with the complete .Rda files. To load data:
```R
load("players_PremLeague1516.Rda")
load("teams_PremLeague1516.Rda")
```

I'm on the lookout for more soccer-related data sets, particularly time series data.
