# Final Project

library(tm)
library(ggplot2)
library(corpus)
library(dplyr)
library(wordcloud)
library(topicmodels)
library(tidytext)
library(stringi)

datapath<-"//Users/rohanrele//Documents//Rutgers//Junior//Stat486//FinalProjectWorkingDir//ProjectData"
#reading in data
t1<-read.csv(file = paste(datapath,"//FIFA.csv",sep=""),header = FALSE)
t1names<-c(1,7)
t1<-t1[-1,t1names]
t1$tag<-1
colnames(t1)<-c("id","text","tag")
t2<-read.csv(file = paste(datapath,"//tweets_startup.csv",sep=""),header = FALSE)
t2names<-c(1,3)
t2<-t2[-1,t2names]
t2$tag<-2
colnames(t2)<-c("id","text","tag")
t2<-t2[rep(1:nrow(t2),times = 10),]
t3<-read.csv(file = paste(datapath,"//stockerbot-export.csv",sep=""),header = FALSE)
t3names<-c(1,2)
t3<-t3[-1,t3names]
t3$tag<-3
colnames(t3)<-c("id","text","tag")
t3<-t3[rep(1:nrow(t3),times = 10),]
t4<-read.csv(file = paste(datapath,"//tweets.csv",sep=""),header = FALSE)
t4names<-c(9,2)
t4<-t4[-1,t4names]
t4$tag<-4
colnames(t4)<-c("id","text","tag")
t4<-t4[rep(1:nrow(t4),times = 10),]
t5<-read.csv(file = paste(datapath,"//winemag-data_first150k.csv",sep=""),header = FALSE)
t5names<-c(1,3)
t5<-t5[-1,t5names]
t5$tag<-5
colnames(t5)<-c("id","text","tag")
tweets<-rbind(t1,t2,t3,t4,t5)
rm(t1names,t2names,t3names,t4names,t5names)
rm(t1,t2,t3,t4,t5)

#preliminary analysis 

word_count<-stri_count_words(tweets[[2]])
tweet_count<-length(tweets[[2]])
max_tweet_length<-max(word_count)
avg_tweet_length<-mean(word_count)
dataset_summary<-list(total_words=sum(word_count),total_tweets=tweet_count,
                      longest_tweet=max_tweet_length,avg_tweet_length=avg_tweet_length)

#clean the corpus 

indices<-sample(1:nrow(tweets),100000)
test<-tweets[indices,]
rm(indices)
test$text <- sapply(test$text,function(row) iconv(row, "latin1", "ASCII", sub=""))
corpus<-Corpus(VectorSource(test$text))
corpus = tm_map(corpus, content_transformer(tolower))
corpus = tm_map(corpus, removeNumbers)
corpus = tm_map(corpus, removePunctuation)
stops<-c(stopwords("english"),"will", "amp")
corpus = tm_map(corpus, removeWords, stops)
corpus = tm_map(corpus, stripWhitespace)
rm(stops)


# Making the document term matrix (for visualizations)
dtm<-DocumentTermMatrix(corpus)
dtm<-removeSparseTerms(dtm,0.99)
ui = unique(dtm$i)
empty.rows <- dtm[-ui, ]$dimnames[1][[1]]
corpus <- corpus[-as.numeric(empty.rows)]
dtm.final <- dtm[ui, ]
rm(ui,empty.rows)
dtm.final<-as.matrix(dtm.final)
v<-sort(rowSums(dtm.final),decreasing=TRUE)
d<-data.frame(word = names(v),freq=v)

# Making the term document matrix (For lda)
tdmtemp<-TermDocumentMatrix(corpus)
tdm<-removeSparseTerms(tdmtemp,0.99)
tdm<-as.matrix(tdm)
u<-sort(rowSums(tdm),decreasing=TRUE)
t<-data.frame(word=names(u),freq=u)

#Visualizations 
hist(test$tag,xlab="Tag",main="Topic Distribution")

set.seed(1234)
wordcloud(words = t$word, freq = t$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.25, 
          colors=brewer.pal(80, "Dark2"))

ggplot(head(t,15), aes(reorder(word,freq), freq)) +
  geom_bar(stat = "identity") + coord_flip() +
  xlab("Unigrams") + ylab("Frequency") +
  ggtitle("Most frequent unigrams")

temp<-tdm[,sample(1:ncol(tdm),4)]
colnames(temp)<-c("wine","football","tech","movie")
comparison.cloud(temp,max.words = 40)
rm(temp)

findAssocs(tdmtemp,"movie",0.25)


#LDA Modeling 

ldaOut<-LDA(dtm.final,k=5,method="Gibbs",control=list(seed=1234))
lda.topics<-as.matrix(topics(ldaOut))
lda.terms<-as.matrix(terms(ldaOut))
topicProbabilities <- as.data.frame(ldaOut@gamma)
