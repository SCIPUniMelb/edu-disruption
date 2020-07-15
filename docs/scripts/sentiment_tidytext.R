
# Sentiment analysis using tidytext
# https://www.edgarsdatalab.com/2017/09/04/sentiment-analysis-using-tidytext/

library(tidyverse)
library(tidytext)
library(here)

tweets_rl <- tibble(read_csv(here::here("Data", "tweets-remotelearning.csv")))
tweets_rl

tweet_words <- tweets_rl %>%
  select(status_id, screen_name, text, created_at) %>%
  unnest_tokens(word, text)

tweet_words

stop_words 

my_stop_words <- tibble(
  word = c(
    "https",
    "t.co",
    "rt",
    "amp",
    "rstats",
    "gt"
  ),
  lexicon = "twitter"
)

all_stop_words <- stop_words %>%
  bind_rows(my_stop_words)

suppressWarnings({
  no_numbers <- tweet_words %>%
    filter(is.na(as.numeric(word)))
})

no_stop_words <- no_numbers %>%
  anti_join(all_stop_words, by = "word")

tibble(
  total_words = nrow(tweet_words),
  after_cleanup = nrow(no_stop_words)
)

top_words <- no_stop_words %>%
  group_by(word) %>%
  tally %>%
  arrange(desc(n)) %>%
  head(10)

top_words


#  match words against different lexicons (vocabularies) ------------------

# NRC lexicon 
nrc_words <- no_stop_words %>%
  inner_join(get_sentiments("nrc"), by = "word")

nrc_words 

nrc_words %>%
  group_by(sentiment) %>%
  tally %>%
  arrange(desc(n))

nrc_words %>%
  group_by(status_id) %>%
  tally %>%
  ungroup %>%
  count %>%
  pull


# bing lexicon 
bing_words <- no_stop_words %>%
  inner_join(get_sentiments("bing"), by = "word")

bing_words 

bing_words %>%
  group_by(sentiment) %>%
  tally %>%
  arrange(desc(n))

bing_words %>%
  group_by(status_id) %>%
  tally %>%
  ungroup %>%
  count %>%
  pull


# viz ---------------------------------------------------------------------

library(ggjoy)

# with nrc lexicon
ggplot(nrc_words) +
  geom_joy(aes(
    x = created_at,
    y = sentiment, 
    fill = sentiment),
    rel_min_height = 0.01,
    alpha = 0.7,
    scale = 3) +
  theme_joy() +
  labs(title = "#remotelearning sentiment analysis",
       subtitle = "tidytext / get_sentiments() / NRC lexicon",
       x = "Date of tweet",
       y = "Sentiment") + 
  scale_fill_discrete(guide=FALSE)

ggsave(here("remotelearning_nrc_lexicon.png"),
       dpi = 300,  width = 11, height = 8)

# with bing lexicon
ggplot(bing_words) +
  geom_joy(aes(
    x = created_at,
    y = sentiment, 
    fill = sentiment),
    rel_min_height = 0.01,
    alpha = 0.7,
    scale = 3) +
  theme_joy() +
  labs(title = "#remotelearning sentiment analysis",
       subtitle = "tidytext / get_sentiments() / bing lexicon",
       x = "Date of tweet",
       y = "Sentiment") + 
  scale_fill_discrete(guide=FALSE)

ggsave(here("remotelearning_bing_lexicon.png"),
       dpi = 300,  width = 11, height = 8)

# -------------------------------------------------------------------------

library(RColorBrewer)
library(wordcloud)

set.seed(10)

positive_words_nrc <- nrc_words %>%
  filter(sentiment == "positive") %>%
  group_by(word) %>%
  tally

positive_words_nrc %>%
  with(wordcloud(word, n, max.words = 50, colors =  c("#56B4E9", "#E69F00")))


positive_words_bing <- bing_words %>%
  filter(sentiment == "positive") %>%
  group_by(word) %>%
  tally

positive_words_bing %>%
  with(wordcloud(word, n, max.words = 50, colors =  c("#56B4E9", "#E69F00")))

negative_words_bing <- bing_words %>%
  filter(sentiment == "negative") %>%
  group_by(word) %>%
  tally

negative_words_bing %>%
  with(wordcloud(word, n, max.words = 50, colors =  c("#56B4E9", "#E69F00")))



# Because a tweet is short, it made sense to find out what words surround joyful words. The next wordcloud will 
# use tweets with at least one word consider joyful. The joyful words are removed, as well as the top 10 orverall 
# words to get a better picture of the surrounding words unique with this sentiment.

other_words <- nrc_words %>%
  filter(sentiment == "joy") %>%
  group_by(status_id) %>%
  tally %>% 
  ungroup() %>%
  inner_join(no_stop_words, by = "status_id")  %>%
  anti_join(joy_words, by = "word") %>%
  anti_join(top_words, by = "word") %>%
  group_by(word) %>%
  count 

other_words %>%
  with(wordcloud(word, n, max.words = 30, colors =  c( "#56B4E9", "#E69F00")))









