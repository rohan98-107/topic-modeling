# topic-modeling
Stat 486 Final Project 

Final Project Report - Topic Modeling on Twitter Dataset
Rohan Rele, Raj Patel, Kevin Yang 


Motivations

Text Mining is an increasing popular field due to the demand to replicate and possibly out-do humans’ reading comprehension skills. One aspect of text analysis that is particularly difficult for even the most sophisticated software is analyzing short text messages. This project attempt to classify and discern overall trends from a mass of short messages; namely, the topic modeling of  tweets from the social media website Twitter. 

Preliminary Analysis 

Our first method of analysis was to obtain simple summary statistics of the full tweet dataset. Being that our tweets, sized at 1.2 million individual messages, were a result of concatenating multiple other datasets, we wanted to be sure that there were no biases or non deterministic data points in our set before moving on to the cleaning phase. The results were as follows: 

$total_words
[1] 27090096

$total_tweets
[1] 1241330

$longest_tweet
[1] 44585

$avg_tweet_length
[1] 21.82344

The $longest_tweet variable may look strange to anyone familiar with the site. Twitter enforces a 150 character limit on its messages. However, likely because of emojis (emoticons), hyperlinks and images, the ASCII values of certain tweets may be much greater than 150. This is likely the cause of this figure. Another important figure to understand before we moved on to cleaning and creating our Corpus is the initial distribution of our data. In other words, how much of each topic exists in our original dataset. In order for us to determine whether or topic model is working correctly, it is important to note this. 
 

As one can see, the distribution is fairly skewed. This is actually better. This way, we will be even more certain that our topic model is not simply using probability values but rather building upon itself using conditional probability via posterior distribution. 

Creating/Cleaning the Corpus 

The Corpus is a very important concept in the sphere of text mining. Corpus literally translates to “dictionary” or “vocabulary”. The reason this is useful is it enables us to use a “bag of words” model where, later on, when we run high-intensity computations on our dataset, we can access each word from our vocabulary rather than parsing tweets to find the relevant terms. The corpus automatically makes the distinction between singular/plural words and treats them as a single vocabulary word. 

Once the corpus is created, we then had to clean the corpus using the tm (Text Mining) package. This also proved very effective as tm comes with very easy-to-use functionality to remove numbers, non-ASCII character (emoticons, hyperlinks), non-english words, URLs, stop-words (words like “and”, “the”...etc.) and punctuation. Later, we are able to view the corpus with a word cloud. 

LDA- Latent Dirichlet Allocation 

Now we had enough understanding of the initial dataset to perform the actual topic analysis. Step 1 is the most difficult and most important step. 

(i) Step 1: Creating the DTM and TDM

DTM stands for Document Term Matrix and TDM, its transpose, is the Term Document Matrix. Without these data structures it becomes much more difficult to perform text analysis of any kind. The DTM maps every document (tweet) as a row and every column as a word where every cell is populated by a ‘0’ or ‘1’. This gives us a boolean representation of what words appear in every tweet. 

 


The issue with these representations is that they are extremely memory-intensive. This is where the “curse of dimensionality” plays a very aggressive role in the model. 10 tweets each with 100 distinct words yields a DTM with size 10x1000. This is a relatively large matrix for such a small amount of text data. In our case, we had 1.2 million samples and although there are less than 100 distinct words per tweet, memory/runtime constraints forced us to reduce the sample size to ~ 50%. Anything greater would cause a fatal exception even on a powerful desktop computer. 

The results of our model reflect a smaller portion of our initial data. However, as we will see in a moment, the results are just as accurate as they would be even if we increased our sample size to include the full extent of our tweets dataset. 



Aside: What is LDA and how does it work? 

In order to understand why this is true. We must gain a preliminary understanding of what the model is attempting to do and introduce some of the core mathematical/technical concepts central to glean our results effectively. Specifically, LDA is the method of choice for topic modeling and topic discovery. After preprocessing, the LDA method involves two significant proportions with one main assumption.

The LDA method assumes that all other topic assignments besides the current one are correct. With this, the following proportions are calculated:
1)	Proportion of words in document t currently assigned to topic a
a)	p(topic a | document t)

2)	Proportion of assignments to topic t over all documents that come from given word
a)	p(word x | topic a)

 


(ii) Step 2: Visualizing Word/Document Associations 

Topic Modeling at a high level is simply understanding the relationship between each word/tweet and then probabilistically computing how likely each tweet is to be of a certain topic based on its words. One important feature to consider is word associations. The model will use machine learning to determine the relationship between tweets and words but what about the words themselves? 

Here are some visualizations that we created to understand the relationship between words in our corpus and DTM/TDM: 

Word Cloud 

 
Unigram Frequency plot

 

Association matrix 

$wine
  fruit flavors acidity tannins    ripe    rich 
   0.35    0.34    0.33    0.30    0.27    0.25 


Comparison Cloud 

 



(iii) Step 3: Gibbs Sampling and Modeling 

The main caveat of LDA is that it requires a fixed “k” number of topics to be inputted to the model before training and that the nature of the topics cannot be predetermined. In our case, we chose k=5. Since we used 5 different datasets, it was the natural choice. 



Results 

Interpreting the results is quite intuitive. The model returns 3 parameters: (1) is the terms which refer to the names of the topics from 1-k, (2) is the topics dataframe which assigns each tweet a number from 1-k, and (3) is the topic probabilities which is the most important result. This gives a table of probabilities for each tweet. As mentioned earlier, each document is assigned a  distribution of k discrete probabilities and the lda model simply picks the highest one as the “topic” of the document. For a sample size of 100,000, here are the results: 

Topics 

  2   4   5   7   8  14  16  17  18  19  21  22  23  24  25  26  27  28  29  30  31  32  34  35  36  37  40  41  43  44 
  1   1   1   1   1   1   5   4   1   3   4   1   4   1   3   3   1   2   3   4   1   5   1   1   3   1   3   5   3   1 
 45  46  47  48  49  50  51  52  53  54  55  56  57  58  59  60  62  63  66  67  69  70  71  72  73  74  76  77  78  79 
  3   4   1   3   5   2   5   3   4   2   4   4   4   5   2   3   5   3   1   1   5   3   1   5   3   1   2   3   5   5 
 80  81  83  84  87  88  89  90  91  93  94  95  96  97  99 101 102 104 105 107 109 111 112 113 114 115 116 117 119 121 
  5   1   5   3   4   4   5   5   3   1   3   3   2   5   4   2   3   2   2   1   2   2   1   1   4   1   2   2   4   1 
123 124 126 127 128 129 131 132 133 134 
  2   1   2   3   1   5   5   5   3   2 			…(rest omitted for brevity) 


Terms 

Topic 1 "wine"           
Topic 2 "flavors"        
Topic 3 "inc"            
Topic 4 "avengersendgame"
Topic 5 "world" 

Topic Probabilities 

           V1        V2        V3        V4        V5
1   0.2156863 0.1960784 0.1960784 0.1960784 0.1960784
2   0.2156863 0.1960784 0.1960784 0.1960784 0.1960784
3   0.2181818 0.2181818 0.2000000 0.1818182 0.1818182
4   0.2156863 0.1960784 0.1960784 0.1960784 0.1960784
5   0.2280702 0.2280702 0.1929825 0.1754386 0.1754386
6   0.2115385 0.1923077 0.1923077 0.2115385 0.1923077
7   0.1923077 0.1923077 0.1923077 0.1923077 0.2307692
8   0.1785714 0.1785714 0.1964286 0.2678571 0.1785714
9   0.2075472 0.1886792 0.2075472 0.2075472 0.1886792
10  0.1851852 0.1851852 0.2407407 0.1851852 0.2037037
11  0.2000000 0.1818182 0.1818182 0.2181818 0.2181818
12  0.2156863 0.1960784 0.1960784 0.1960784 0.1960784
13  0.1886792 0.1886792 0.2075472 0.2264151 0.1886792
14  0.2115385 0.1923077 0.2115385 0.1923077 0.1923077
15  0.1886792 0.1886792 0.2264151 0.1886792 0.2075472
16  0.1886792 0.1886792 0.2452830 0.1886792 0.1886792
17  0.2678571 0.1785714 0.1785714 0.1785714 0.1964286
18  0.2241379 0.2586207 0.1724138 0.1724138 0.1724138
19  0.1923077 0.1923077 0.2115385 0.1923077 0.2115385

…(rest omitted for brevity) 

Conclusion

We were able to accurately model twitter topics by using LDA and probabilistic distribution. As we can see by our intermediate results, the words “avengersendgame” and “inc” did not show up in some of the visualizations however the model still accurately determined that these were main themes. “inc” most likely refers to the frequent naming of companies from the “startup_tweets” and “avengersendgame” is a very popular movie that is playing in theaters right now. “wine” being a topic is no surprise since the majority of our data came from wine-tour tweets. The “world” topic likely refers to FIFA World Cup. All in all, we were able to conclude that even though LDA is traditionally used for larger text data-sets, it is still a useful tool in understanding message that are thought to only be readable by humans. 


References 

Ganegedara, Thushan. "Intuitive Guide to Latent Dirichlet Allocation." Towards Data Science. 23 Aug. 2018. Towards Data Science. 09 May 2019 <https://towardsdatascience.com/light-on-math-machine-learning-intuitive-guide-to-latent-dirichlet-allocation-437c81220158>.

K. “A Gentle Introduction to Topic Modeling Using R.” Eight to Late, 6 Oct. 2017, eight2late.wordpress.com/2015/09/29/a-gentle-introduction-to-topic-modeling-using-r/.

Resnik, Philip, and Eric Hardisty. “Gibbs Sampling for the Uninitiated.” Http://Users.umiacs.umd.edu, June 2010, users.umiacs.umd.edu/~resnik/pubs/LAMP-TR-153.pdf.

Silge, Julia, and David Robinson. “Text Mining with R.” 6 Topic Modeling, 23 Mar. 2019, www.tidytextmining.com/topicmodeling.html.



