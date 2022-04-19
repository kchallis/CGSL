# CGSL
Czech General Service List

In the spirit of open access and replicabilility promoted by Bodo Winter in his _Statistics for Linguists: An Introduction Using R_ (2019), this repo contains the scripts I used to build the Czech General Service List. They are redundant, ugly, and inefficient. But they work, so please be kind. I'm still learning.

The underlying datasets are not mine to share so I have not included them. If you ask the original corpus creators for access, or ask me to ask them to give you access, they will most likely give it to you. Censorship is not looked on kindly in the Czech lands, and copyright law does not work the same there, either.

The most annoying thing about using Czech data in R is that there is some kind of weird issue having to do with Windows regional language settings which causes certain diacritics (e.g. ř) to get messed up. Sometimes this occurs in the internal R display, but it can also mess up text that is written to a .csv or .tsv. My non-elegant solution is documented in these scripts in the comments and involves extending the copy-paste limit, printing a dataframe column (the one with those pesky diacritics), and copy-pasting it manually. 
