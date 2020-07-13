
# https://quanteda.io/
# https://quanteda.io/articles/quickstart.html

pacman::p_load(readtext)
devtools::install_github("quanteda/quanteda.corpora")
devtools::install_github("kbenoit/quanteda.dictionaries")

library("quanteda")
library("readtext")
library("here")


# read JSON ---------------------------------------------------------------



# read multiple text files ------------------------------------------------

corpus_txtmultiple <- readtext("/Users/gdarcy1/Documents/GitHub/WORKING PROJECTS/Corpus/data/UMA_Fraser_Radio_Talks/*.txt", cache = FALSE)
summary(corpus(corpus_txtmultiple), 10)

data(corpus_txtmultiple, package = "quanteda.textmodels")
summary(corpus_txtmultiple)

kwic(corpus_txtmultiple, pattern = "friend")




# read CSV ----------------------------------------------------------------

corpus_csv <- readtext(here::here("data", "frequent_trigrams.csv"), text_field = "term")
summary(corpus(corpus_csv), 5)

kwic(corpus_csv, pattern = "covid")




data(data_corpus_irishbudget2010, package = "quanteda.textmodels")
summary(data_corpus_irishbudget2010)



