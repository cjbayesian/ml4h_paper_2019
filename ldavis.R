## This script is based on the example in ldavis:
## https://ldavis.cpsievert.me/reviews/reviews.html

library(tm)
library(LDAvis)
library(lda)

load("data/ML4H2018.rdata")
# load("data/NeurIPS2018.rdata")

stop_words <- stopwords("SMART")

# pre-processing:
papers <- gsub("'", "", papers)  # remove apostrophes
papers <- gsub("[[:digit:]]", " ", papers)  # replace numbers with space
papers <- gsub("[[:punct:]]", " ", papers)  # replace punctuation with space
papers <- gsub("[[:cntrl:]]", " ", papers)  # replace control characters with space
papers <- gsub("^[[:space:]]+", "", papers) # remove whitespace at beginning of documents
papers <- gsub("[[:space:]]+$", "", papers) # remove whitespace at end of documents
papers <- tolower(papers)  # force to lowercase

# tokenize on space and output as a list:
doc.list <- strsplit(papers, "[[:space:]]+")

# compute the table of terms:
term.table <- table(unlist(doc.list))
term.table <- sort(term.table, decreasing = TRUE)

# remove terms that are stop words or occur fewer than 5 times:
del <- names(term.table) %in% stop_words | term.table < 5
term.table <- term.table[!del]
vocab <- names(term.table)

# now put the documents into the format required by the lda package:
get.terms <- function(x) {
  index <- match(x, vocab)
  index <- index[!is.na(index)]
  rbind(as.integer(index - 1), as.integer(rep(1, length(index))))
}
documents <- lapply(doc.list, get.terms)

# Compute some statistics related to the data set:
D <- length(documents)  # number of documents
W <- length(vocab)  # number of terms in the vocab
doc.length <- sapply(documents, function(x) sum(x[2, ]))  # number of tokens per document
N <- sum(doc.length)  # total number of tokens in the data
term.frequency <- as.integer(term.table)  # frequencies of terms in the corpus

# MCMC and model tuning parameters:
K <- 20
G <- 500
alpha <- 0.02
eta <- 0.02


n_documents <- length(documents)
# ~90:10 train test split for perprlexity analysis
train <- documents[1:150]
test <- documents[151:length(documents)]

# Fit the model:
K_s <- c(4,8,12,16,20,24,28,32)
ll_all = c()
set.seed(357)
for (K in K_s){
  t1 <- Sys.time()
  fit <- lda.collapsed.gibbs.sampler(documents = train, K = K, vocab = vocab, 
                                     num.iterations = G, alpha = alpha, 
                                     eta = eta, initial = NULL, burnin = 0,
                                     compute.log.likelihood = TRUE)
  t2 <- Sys.time()
  t2 - t1  # about 10 minutes on laptop
  
  theta <- t(apply(fit$document_sums + alpha, 2, function(x) x/sum(x)))
  phi <- t(apply(t(fit$topics) + eta, 2, function(x) x/sum(x)))
  ll <- 0
  for(document in test){
    for (topic_i in 1:K) {
      p_topic = (sum(theta[,topic_i])/n_train_documents)
      ll_word = sum(log(unname(phi[topic_i,document[1,]])))
      ll = ll + ll_word + log(p_topic)
    }
  }
  ll_all = c(ll_all, ll)
  print(ll_all)
}

## Minimum perplexity at ~12 topics
plot(K_s,ll_all/K_s, type = "b")


## Train on whole corpus with larger K=20 topics
G <- 5000
t1 <- Sys.time()
fit <- lda.collapsed.gibbs.sampler(documents = documents, K = 20, vocab = vocab, 
                                   num.iterations = G, alpha = alpha, 
                                   eta = eta, initial = NULL, burnin = 0,
                                   compute.log.likelihood = TRUE)
t2 <- Sys.time()
t2 - t1  # about 10 minutes on laptop

ml4h_papers_lda <- list(phi = phi,
                     theta = theta,
                     doc.length = doc.length,
                     vocab = vocab,
                     term.frequency = term.frequency)

# create the JSON object to feed the visualization:
json <- createJSON(phi = ml4h_papers_lda$phi, 
                   theta = ml4h_papers_lda$theta, 
                   doc.length = ml4h_papers_lda$doc.length, 
                   vocab = ml4h_papers_lda$vocab, 
                   term.frequency = ml4h_papers_lda$term.frequency)


serVis(json, out.dir = 'ldavis', open.browser = FALSE)
# A simple way to locally serve up the vis is to run:
# `python -m SimpleHTTPServer 8000`
# from the `ldavis` path then open `localhost:8000` in your browser.