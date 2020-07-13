




```{r libraries, results = 'hide', warning = FALSE, message = FALSE}

# install.packages("httr")

# libraries needed
library(tidyverse)
library(httr)
library(jsonlite)

set.seed(8675309) # makes sure random numbers are reproducible
```


```{r MV data}

mv_base_url = "https://collections.museumvictoria.com.au/api/search?"

mv_df <-httr::GET(url = mv_base_url, query = list(q = "food+war")) %>% 
        content(as = "text", encoding = "UTF-8") %>% 
        jsonlite::fromJSON(flatten = TRUE) %>% 
        data.frame()

# check number of columns
ncol(mv_df)

posts<-fromJSON("posts.json")
posts<-as.data.frame(posts)


```



```{r TROVE data}

library(XML)

trove_base_url = "http://api.trove.nla.gov.au/v2/result?key="
api_key = "TROVE_KEY"
zone = "&zone="
query = "&q="
type = "&encoding=json"

zone_name="newspaper"
question="army"

url_query = paste0(trove_base_url, api_key, zone, zone_name, query, question,type)

json_file = jsonlite::fromJSON(url_query)

df = as.data.frame(json_file$response$zone$records$article)



# This package is required for Accessing APIS (HTTP or HTTPS URLS from Web)
library(httr)
#This package exposes some additional functions to convert json/text to data frame
library(rlist)
#This package exposes some additional functions to convert json/text to data frame
library(jsonlite)
#This library is used to manipulate data
library(dplyr)


# using httr

resp <- GET(url_query)

# Shows raw data which is not structured and readable
jsonRespText<-content(resp, as="text") 
jsonRespText



mydf <- fromJSON(jsonRespText)      # Convert JSON to data frame using jsonlite package
mydf

# > View(mydf[["response"]][["zone"]][["records"]][["article"]][[1]])




trove_base_url = "https:// api.trove.nla.gov.au/v2/result?"

trove_df <-httr::GET(url = trove_base_url, query = list(key="3fa0o2759s1qasoi", zone="book", q = "society", l-format="Thesis")) %>% 
        content(as = "text", encoding = "UTF-8") %>% 
        jsonlite::fromJSON(flatten = TRUE) %>% 
        data.frame()

posts<-fromJSON("posts.json")
posts<-as.data.frame(posts)


```





