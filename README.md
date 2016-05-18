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
^3          20.90           1,000,000                                               ~29 million
^4          20.51           1,000,000                                               ~29 million
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
(Better Feature Engineering):
=====================================================================================================
26          24.86           1,000,000                                               ~53 million
27          25.43           merge 1 and 26                                          ~163 million

Same Num-words Comparisons:
=====================================================================================================
28          24.56           top 500000 from 26                                      ~30 million
29          24.04           top 450000 from 14                                      ~29 million
30          24.28           top 1220000 from 9                                      ~30 million

Plot method 26 with more data points:
=====================================================================================================
31          22.51           top 100,000                                             ~7 million
32          23.29           top 200,000                                             ~13 million
28          24.56           top 500,000                                             ~30 million
36          24.92           top 800,000                                             ~45 million
26          24.86           top 1,000,000                                           ~53 million
33          24.74           top 2,000,000                                           ~90 million
35          24.65           top 3,000,000                                           ~127 million
34          24.07           top 5,000,000                                           ~186 million

Pick top BLEU scores:
=====================================================================================================
37          12.92           top 100,000                                             ~0.8 million
38          14.87           top 200,000                                             ~1.7 million
39          15.99           top 500,000                                             ~4 million
40          19.47           top 1,000,000                                           ~10 million
41          23.29           top 2,000,000                                           ~25 million
42          24.22           top 3,000,000                                           ~42 million
43          24.61           top 5,000,000                                           ~89 million
# we can see that shorter sentences tend to have higher BLEU scores. So now we add length features:

GMM with 2 lengths and BLEU
=====================================================================================================
44          12.52           top 100,000                                             ~1.2 million
45          18.41           top 200,000                                             ~3 million
46          21.76           top 500,000                                             ~11 million
47          22.98           top 1,000,000                                           ~24 million
48          23.10           top 2,000,000                                           ~48 million
49          23.16           top 3,000,000                                           ~70 million
50          23.78           top 5,000,000                                           ~114 million

Variation on Method 26
=====================================================================================================
51          22.56           top 100,000                                             ~7 million
52          23.60           top 200,000                                             ~13 million
53          24.45           top 500,000                                             ~30 million
54          25.04           top 800,000                                             ~46 million
55          24.86           top 1,000,000                                           ~55 million
56          24.84           top 2,000,000                                           ~90 million
57          24.47           top 3,000,000                                           ~124 million
58          24.11           top 5,000,000                                           ~182 million

TODO-list:
=====================================================================================================
in the BoW approach, get the most likely translation instead of soft decisions
figure out a better way to train GMMs
alignment features
manually examine the sentences more
get the "good" sample from europarl to train GMMs
news commentary data

unigram similarity of MT results

Running right now:
=====================================================================================================
