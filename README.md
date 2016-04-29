ID          BLEU            Description
===============================================================================
1           24.42           train on europarl (~2 million pairs), good baseline
2           10.38           use model1 to decode site-crawl
3           20.90           random 1000000
4           20.51           random 1000000
5           20.45           random 1000000
6           18.77           GMM on PoS
7           46.47           train on europarl, decode europarl (oracle)

Translate all site-crawl FR to EN, compare the translation with the EN sentences
===============================================================================
8           24.19           use 2's output, unigram similarity, sort and pick
                            most similar ones

9           24.36           like 8, but use 10 Gauss to model similarity scores,
                            and pick most likely ones from site-crawl
10          25.77           merge 1 and 9

11          24.51           like 9, but add PoS features
12          25.29           merge 1 and 11                  This is Weird

Bag of Words "translation": use the lex.f2e to generate a distribution on words,
and compute a quantity similar to cross-entropy 
===============================================================================
13          24.48           bow, GMM
14          24.67           bow with PoS features, GMM
15          25.24           merge 1 and 14

All GMMs are trained on a 50,000 randomly sampled subset of EuroParl features

Random sampling:
===============================================================================
16          19.36           500,000
17                          500,000
18          21.43           2,000,000
19          21.87           2,000,000
20                          3,000,000
21          21.79           3,000,000
22          23.11           5,000,000
23          23.14           5,000,000
24                          10,000,000
25                          10,000,000

Better Feature Engineering:
1. Non-word agreements (numbers, webpages)
2. 2-way translation scores
3. Pick the top 10 PoS tags for each language
===============================================================================
26                          1,000,000
27                          merge 1 and 26


TODO-list
===============================================================================
in the BoW approach, get the most likely translation instead of soft decisions
get most frequent PoS tags instead of all of them
figure out a better way to train GMMs
translation model could be used 2-ways
