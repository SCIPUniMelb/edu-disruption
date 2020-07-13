
## install packages
install.packages(c("tidyverse","tidytext","rtweet"), dep = TRUE)

library(tidyverse) 
library(tidytext)
library(rtweet)


# include API keys --------------------------------------------------------
source("keys.R")

## search for tweets
tweets <- search_tweets(q = "#COVID",
                        n = 18000,
                        include_rts = FALSE,
                        `-filter` = "replies",
                        lang = "en")

tweets %>%
  sample_n(5) %>%
  select(created_at, screen_name, text, favorite_count, retweet_count)

write_as_csv(tweets, "COVID-tweets-June2.csv")


## Exploring tweets 
## Timeline of tweets
ts_plot(tweets, "hours") +
  labs(x = NULL, y = NULL,
       title = "Frequency of tweets with #COVID hashtag",
       subtitle = paste0(format(min(tweets$created_at), "%d %B %Y"), " to ", format(max(tweets$created_at),"%d %B %Y")),
       caption = "Data collected from Twitter's REST API via rtweet") +
  theme_minimal()

## Top tweeting location
tweets %>%
  filter(!is.na(place_full_name)) %>%
  count(place_full_name, sort = TRUE) %>%
  top_n(5)

## Most retweeted tweet
tweets %>%
  arrange(-retweet_count) %>%
  slice(1) %>%
  select(created_at, screen_name, text, retweet_count)

## Most liked tweet
tweets %>%
  arrange(-favorite_count) %>%
  top_n(5, favorite_count) %>%
  select(created_at, screen_name, text, favorite_count)

## Top tweeters
tweets %>%
  count(screen_name, sort = TRUE) %>%
  top_n(10) %>%
  mutate(screen_name = paste0("@", screen_name))

## Top emoji

# install.packages("devtools")
devtools::install_github("hadley/emo")

library(emo)
tweets %>%
  mutate(emoji = ji_extract_all(text)) %>%
  unnest(cols = c(emoji)) %>%
  count(emoji, sort = TRUE) %>%
  top_n(10)

## Top hashtags
tweets %>%
  unnest_tokens(hashtag, text, "tweets", to_lower = FALSE) %>%
  filter(str_detect(hashtag, "^#"),
         hashtag != "#ClimateEmergency") %>%
  count(hashtag, sort = TRUE) %>%
  top_n(10)

## Top mentions
tweets %>%
  unnest_tokens(mentions, text, "tweets", to_lower = FALSE) %>%
  filter(str_detect(mentions, "^@")) %>%  
  count(mentions, sort = TRUE) %>%
  top_n(10)

## Top words
words <- tweets %>%
  mutate(text = str_remove_all(text, "&amp;|&lt;|&gt;"),
         text = str_remove_all(text, "\\s?(f|ht)(tp)(s?)(://)([^\\.]*)[\\.|/](\\S*)"),
         text = str_remove_all(text, "[^\x01-\x7F]")) %>%
  unnest_tokens(word, text, token = "tweets") %>%
  filter(!word %in% stop_words$word,
         !word %in% str_remove_all(stop_words$word, "'"),
         str_detect(word, "[a-z]"),
         !str_detect(word, "^#"),         
         !str_detect(word, "@\\S+")) %>%
  count(word, sort = TRUE)

# Then we use the wordcloud package to create a visualisation of the word frequencies.

library(wordcloud)
words %>%
  with(wordcloud(word, n, random.order = FALSE, max.words = 50, colors = "#F29545"))


