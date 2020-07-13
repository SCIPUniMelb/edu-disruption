library(tidyverse)
library(rtweet)

# Authenticate access to the Twitter API ----------------------------------
source("keys.R")


## store authentication information
token <- create_token(
  app = "un-tweets-2019",
  consumer_key = api_key,
  consumer_secret = api_secret_key,
  access_token = access_token,
  access_secret = access_token_secret
)

# Find the 500 most recent tweets by
## Jennifer Gonzalez (https://twitter.com/cultofpedagogy )
## Steven Kolber (https://twitter.com/steven_kolber )

edu_chatter <- get_timelines(
  user = c("cultofpedagogy", "steven_kolber", "EduTweetOz"),
  n = 3000
)

# Visualise their tweet frequency by week
edu_chatter %>%
  group_by(screen_name) %>%
  ts_plot(by = "week")





