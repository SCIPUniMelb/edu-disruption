# 
# https://www.tidytextmining.com/ngrams.html

library(tidyverse)
library(tidytext)
library(here)

covid_trigrams <- tibble(read_csv(here::here("Data", "frequent_trigrams.csv")))

covid_trigrams 

# split into columns to filter out stop-words

trigrams_separated <- covid_trigrams %>%
  tidyr::separate(term, c("word1", "word2", "word3"), sep = " ")

trigrams_separated

trigrams_filtered <- trigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word) %>%
  filter(!word3 %in% stop_words$word)

# new trigram counts
trigrams_counts <- trigrams_filtered %>% 
  count(word1, word2, word3, sort = TRUE)

trigrams_counts

# “separate/filter/count/unite” let us find the most common bigrams not containing stop-words

trigrams_separated %>%
  filter(word1 == "death") %>%
  count(word1, word2, word3, sort = TRUE)


AFINN <- get_sentiments("afinn")

AFINN


not_words <- trigrams_separated %>%
  filter(word2 == "covid") %>%
  inner_join(AFINN, by = c(word1 = "word")) %>%
  count(word1, value, sort = TRUE)

not_words

library(ggplot2)

not_words %>%
  mutate(contribution = n * value) %>%
  arrange(desc(abs(contribution))) %>%
  head(20) %>%
  mutate(word1 = reorder(word1, contribution)) %>%
  ggplot(aes(word1, n * value, fill = n * value > 0)) +
  geom_col(show.legend = FALSE) +
  xlab("Words preceded by \"COVID\"") +
  ylab("Sentiment value * number of occurrences") +
  coord_flip()






