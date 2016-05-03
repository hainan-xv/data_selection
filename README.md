ID          BLEU            Description                                             (Number of Words)
=====================================================================================================
1           24.42           train on europarl (~2 million pairs), good baseline     ~111 million
2           10.38           use model1 to decode site-crawl                         N/A
3           20.90           random 1000000                                          ~29 million
4           20.51           random 1000000                                          ~29 million
5           20.45           random 1000000                                          ~29 million
6           18.77           GMM on PoS, top 1000000                                 ~7 million
7           46.47           train on europarl, decode europarl (oracle)

Translate all site-crawl FR to EN, compare the translation with the EN sentences:
=====================================================================================================
8           24.19           use 2's output, unigram similarity, sort and pick       ~24 million
                            most similar ones

9           24.36           like 8, but use 10 Gauss to model similarity scores,    ~22 million
                            and pick most likely ones from site-crawl
10          25.77           merge 1 and 9                                           ~133 million

11          24.51           like 9, but add PoS features                            ~60 million
12          25.29           merge 1 and 11                  This is Weird           ~171 million

Bag of Words "translation": use the lex.f2e to generate a distribution on words,
and compute a quantity similar to cross-entropy:
=====================================================================================================
13          24.48           bow, GMM                                                ~32 million
14          24.67           bow with PoS features, GMM                              ~57 million
15          25.24           merge 1 and 14                                          ~167 million

All GMMs are trained on a 50,000 randomly sampled subset of EuroParl features

Random sampling:
=====================================================================================================
16          19.36           500,000                                                 ~15 million
17          19.51           500,000                                                 ~15 million
18          21.43           2,000,000                                               ~59 million
19          21.87           2,000,000                                               ~59 million
20          21.76           3,000,000                                               ~88 million
21          21.79           3,000,000                                               ~88 million
22          23.11           5,000,000                                               ~150 million
23          23.14           5,000,000                                               ~150 million
24          24.01           10,000,000                                              ~293 million
25          24.21           10,000,000                                              ~293 million

Added the following:
1. Non-word agreements (numbers, webpages)
2. 2-way translation scores
3. Pick the top 10 PoS tags for each language
Better Feature Engineering:
=====================================================================================================
26          24.86           1,000,000                                               ~53 million
27          25.43           merge 1 and 26                                          ~163 million

Same Num-words Comparisons:
=====================================================================================================
28          24.56           top 500000 from 26                                      ~30 million
29          24.04           top 450000 from 14                                      ~29 million
30          24.28           top 1220000 from 9                                      ~30 million

TODO-list
=====================================================================================================
in the BoW approach, get the most likely translation instead of soft decisions
figure out a better way to train GMMs
