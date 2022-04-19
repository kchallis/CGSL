NUMBER_TO_COMPARE <- 10000
NUMBER_TO_REPLACE_NA <- 10001

# This reads in all my files
cstenten17 = read.csv('C:/Users/kate/OneDrive/Desktop/Czech general service list/v4_arf/v4_ARF_ranks/cstenten17.rank.csv', encoding="UTF-8", stringsAsFactors = FALSE)[1:NUMBER_TO_COMPARE,]
#head(cstenten17)
ORALv1 = read.csv('C:/Users/kate/OneDrive/Desktop/Czech general service list/v4_arf/v4_ARF_ranks/ORALv1.rank.csv', encoding="UTF-8", stringsAsFactors = FALSE)[1:NUMBER_TO_COMPARE,]
#head(ORALv1)
koditex = read.csv('C:/Users/kate/OneDrive/Desktop/Czech general service list/v4_arf/v4_ARF_ranks/koditex.rank.csv', encoding="UTF-8", stringsAsFactors = FALSE)[1:NUMBER_TO_COMPARE,]
#head(koditex)
ORTOFONv2 = read.csv('C:/Users/kate/OneDrive/Desktop/Czech general service list/v4_arf/v4_ARF_ranks/ORTOFONv2.rank.csv', encoding="UTF-8", stringsAsFactors = FALSE)[1:NUMBER_TO_COMPARE,]
#head(ORTOFONv2)
syn2020 = read.csv('C:/Users/kate/OneDrive/Desktop/Czech general service list/v4_arf/v4_ARF_ranks/SYN2020.rank.csv', encoding="UTF-8", stringsAsFactors = FALSE)[1:NUMBER_TO_COMPARE,]
#head(syn2020)

#This compares ranks

compare_ranks(cstenten17, ORALv1, NU`MBER_TO_COMPARE)
compare_ranks(cstenten17, koditex, NUMBER_TO_COMPARE)
compare_ranks(cstenten17, ORTOFONv2, NUMBER_TO_COMPARE)
compare_ranks(cstenten17, syn2020, NUMBER_TO_COMPARE)
compare_ranks(ORTOFONv2, syn2020, NUMBER_TO_COMPARE)
compare_ranks(ORTOFONv2, koditex, NUMBER_TO_COMPARE)
compare_ranks(ORTOFONv2, ORALv1, NUMBER_TO_COMPARE)
compare_ranks(ORALv1, koditex, NUMBER_TO_COMPARE)
compare_ranks(ORALv1, syn2020, NUMBER_TO_COMPARE)
compare_ranks(koditex, syn2020, NUMBER_TO_COMPARE)


#This gives me POS summaries of the corpora
summarize_pos(koditex, NUMBER_TO_COMPARE)
summarize_pos(ORALv1, NUMBER_TO_COMPARE)
summarize_pos(ORTOFONv2, NUMBER_TO_COMPARE)
summarize_pos(syn2020, NUMBER_TO_COMPARE)
summarize_pos(cstenten17, NUMBER_TO_COMPARE)


#########################

CGSL <- replace_NAs(intersect_all_lempos(), NUMBER_TO_REPLACE_NA)
#View(CGSL)
CGSL <- add_summary_cols(CGSL, 6)

#This is how to rerank the list
CGSL <- rerank(CGSL)

#View(CGSL)
nrow(CGSL)

#This is how you can put the list in a new order
CGSL = CGSL[order(CGSL$final_rank),]

####################################

#Get intersection of spoken corpora and written corpora separately

spoken_CGSL <- intersect_spoken_lempos()
spoken_CGSL <- add_summary_cols(spoken_CGSL, 3)
spoken_CGSL <- rerank(spoken_CGSL)
spoken_CGSL <- spoken_CGSL[order(spoken_CGSL$final_rank),] #would it be better to rank things the same way?
#View(spoken_CGSL)
nrow(spoken_CGSL)

written_CGSL <- intersect_written_lempos()
written_CGSL <- add_summary_cols(written_CGSL, 4)
written_CGSL <- rerank(written_CGSL)
written_CGSL <- written_CGSL[order(written_CGSL$final_rank),]
#View(written_CGSL)
nrow(written_CGSL)

###################################
#Here I am getting my lists ranked

spoken_CGSL <- rerank(spoken_CGSL)
written_CGSL <- rerank(written_CGSL)
CGSL <- rerank(CGSL)
nrow(CGSL)
nrow(spoken_CGSL)
nrow(written_CGSL)
head(written_CGSL)

###################

#Here I am getting the union of the intersection of all the lists, plus
# the intersection of the spoken and written corpora
CGSL_ARF <- union_CGSL_spok_writ(CGSL, spoken_CGSL, written_CGSL)
#View(CGSL_ARF)
nrow(CGSL_ARF)

CGSL_ARF <- replace_NAs(CGSL_ARF, NUMBER_TO_REPLACE_NA)
nrow(CGSL_ARF)
#View(CGSL_ARF)

CGSL_ARF <- add_summary_cols(CGSL_ARF, 4)
CGSL_ARF <- rerank(CGSL_ARF)


nrow(CGSL_ARF)

#View(CGSL_ARF)

#This is a work-around solution for avoiding some of the formatting problems with R and Czech diacritics
#see https://stackoverflow.com/questions/32035119/how-to-solve-clipboard-buffer-is-full-and-output-lost-error-in-r-running-in-wi
#see also https://stackoverflow.com/questions/32035119/how-to-solve-clipboard-buffer-is-full-and-output-lost-error-in-r-running-in-wi#:~:text=There%20is%20a%2032Kb%20limit,%22)%20to%20give%20128Kb.%22&text=Note%20that%20the%20number%20of,can%20increase%20it%20even%20more.

#Here I'm writing the raw table
write.table(CGSL_ARF, "clipboard-16384", sep="\t", row.names = FALSE, col.names=FALSE)


#Here I'm getting the words to be the correct diacritics
words <- toString(CGSL_ARF$X.U.FEFF.lempos)
# this is not an elegant solution, but if you do "head" here, then you can 
# copy and paste this as a string, save it as a .txt file (remove the " "'s
# around the whole thing), and then import the data into excel, transposing the
# data and making sure to split on the ,'s 
# This is a little bit silly.
head(words)

#write.table(spoken_CGSL, "clipboard-16384", sep="\t", row.names = FALSE, col.names=FALSE)
#words <- toString(spoken_CGSL$X.U.FEFF.lempos)
#head(words)

#write.table(written_CGSL, "clipboard-16384", sep="\t", row.names = FALSE, col.names=FALSE)
#words <- toString(written_CGSL$X.U.FEFF.lempos)
#head(words)

##############
## getting the words labeled for written and spoken registers only

written_lemposes <- setdiff(CGSL_ARF$X.U.FEFF.lempos, spoken_CGSL$X.U.FEFF.lempos)
spoken_lemposes <- setdiff(CGSL_ARF$X.U.FEFF.lempos, written_CGSL$X.U.FEFF.lempos)

#using the lempos name as the index
rownames(CGSL_ARF) <- CGSL_ARF$X.U.FEFF.lempos
CGSL_ARF$modality <- ""
CGSL_ARF[written_lemposes, "modality"] <- "written"
CGSL_ARF[spoken_lemposes, "modality"] <- "spoken"
write.csv(CGSL_ARF, file="C:/Users/kate/OneDrive/Desktop/Czech general service list/v5_CGSL/CGSL_ARF_lemposes_labeled_bad_diacritics_10k_10kplus1kpenalty_minfirst.csv", row.names = FALSE)


################

##This is where I'm comparing the overlap of a Czech vocab list to
## what I have in the CGSL_ARF
## The correlation won't work until I add some kind of actual
## tARFn value (median perhaps?), and it will need to be pearson, not
## spearman.

T1 = read.csv('C:/Users/kate/OneDrive/Desktop/Czech general service list/textbooks/T1.csv', encoding="UTF-8", stringsAsFactors = FALSE)
colnames(T1)<-c("lempos", "unit")
head(T1)

T2 = read.csv('C:/Users/kate/OneDrive/Desktop/Czech general service list/textbooks/T2.csv', encoding="UTF-8", stringsAsFactors = FALSE)
colnames(T2)<-c("lempos", "unit")
head(T2)

T3 = read.csv('C:/Users/kate/OneDrive/Desktop/Czech general service list/textbooks/T3.csv', encoding="UTF-8", stringsAsFactors = FALSE)
colnames(T3)<-c("lempos", "unit")
head(T3)

T4 = read.csv('C:/Users/kate/OneDrive/Desktop/Czech general service list/textbooks/T4.csv', encoding="UTF-8", stringsAsFactors = FALSE)
colnames(T4)<-c("lempos", "unit")
head(T4)


CGSL_ARF_10k = read.csv('C:/Users/kate/OneDrive/Desktop/Czech general service list/v5_CGSL/final_CGSL.csv', encoding="UTF-8", stringsAsFactors = FALSE)
head(CGSL_ARF_10k)
colnames(CGSL_ARF_10k)<-c("lempos", "final_rank.CGSL", "final_rank.written_CGSL", "mean", "max", "min", "median", "product", "final_rank", "modality")
head(CGSL_ARF_10k)

CGSL_ARF_3k <- CGSL_ARF_10k[1:3000,]

overlappingTs <- merge(T1, T2, by="lempos")
overlappingTs <- merge(overlappingTs, T3, by="lempos")
overlappingTs <- merge(overlappingTs, T4, by="lempos")
head(overlappingTs)


T1_CGSL <- merge(T1, CGSL_ARF_10k, by="lempos")
T1_CGSL_3k <- merge(T1, CGSL_ARF_3k, by="lempos")

nrow(T1_CGSL)
head(T1_CGSL)

nrow(T1_CGSL_3k)
head(T1_CGSL_3k)

nrow(T1)

pct_overlap_T1 <- nrow(T1_CGSL)/nrow(T1)
pct_overlap_T1

pct_overlap_T1_3k <- nrow(T1_CGSL_3k)/nrow(T1)
pct_overlap_T1_3k

cor_T1_CGSL <- cor.test(T1_CGSL$unit, T1_CGSL$final_rank, method="pearson")
cor_T1_CGSL

cor_T1_CGSL_3k <- cor.test(T1_CGSL_3k$unit, T1_CGSL_3k$final_rank, method="pearson")
cor_T1_CGSL_3k



#T2
T2_CGSL <- merge(T2, CGSL_ARF_10k, by="lempos")
T2_CGSL_3k <- merge(T2, CGSL_ARF_3k, by="lempos")

nrow(T2_CGSL)
head(T2_CGSL)

nrow(T2_CGSL_3k)
head(T2_CGSL_3k)

nrow(T2)

pct_overlap_T2 <- nrow(T2_CGSL)/nrow(T2)
pct_overlap_T2

pct_overlap_T2_3k <- nrow(T2_CGSL_3k)/nrow(T2)
pct_overlap_T2_3k

cor_T2_CGSL <- cor.test(T2_CGSL$unit, T2_CGSL$final_rank, method="pearson")
cor_T2_CGSL

cor_T2_CGSL_3k <- cor.test(T2_CGSL_3k$unit, T2_CGSL_3k$final_rank, method="pearson")
cor_T2_CGSL_3k

#T3
T3_CGSL <- merge(T3, CGSL_ARF_10k, by="lempos")
T3_CGSL_3k <- merge(T3, CGSL_ARF_3k, by="lempos")

nrow(T3_CGSL)
head(T3_CGSL)

nrow(T3_CGSL_3k)
head(T3_CGSL_3k)

nrow(T3)

pct_overlap_T3 <- nrow(T3_CGSL)/nrow(T3)
pct_overlap_T3

pct_overlap_T3_3k <- nrow(T3_CGSL_3k)/nrow(T3)
pct_overlap_T3_3k

cor_T3_CGSL <- cor.test(T3_CGSL$unit, T3_CGSL$final_rank, method="pearson")
cor_T3_CGSL

cor_T3_CGSL_3k <- cor.test(T3_CGSL_3k$unit, T3_CGSL_3k$final_rank, method="pearson")
cor_T3_CGSL_3k

#T4
T4_CGSL <- merge(T4, CGSL_ARF_10k, by="lempos")
T4_CGSL_3k <- merge(T4, CGSL_ARF_3k, by="lempos")

nrow(T4_CGSL)
head(T4_CGSL)

nrow(T4_CGSL_3k)
head(T4_CGSL_3k)

nrow(T4)

pct_overlap_T4 <- nrow(T4_CGSL)/nrow(T4)
pct_overlap_T4

pct_overlap_T4_3k <- nrow(T4_CGSL_3k)/nrow(T4)
pct_overlap_T4_3k

cor_T4_CGSL <- cor.test(T4_CGSL$unit, T4_CGSL$final_rank, method="pearson")
cor_T4_CGSL

cor_T4_CGSL_3k <- cor.test(T4_CGSL_3k$unit, T4_CGSL_3k$final_rank, method="pearson")
cor_T4_CGSL_3k





#which(table(T1$lempos)>1)
#which(table(CGSL_ARF_10k$lempos)>1)





##############################

#here we are merging all the overlapping words into a single list
merge1 = merge(cstenten17.rank.ARF, ORALv1.rank.ARF, by="X.U.FEFF.word", suffixes=c(".cstenten17", ".ORALv1"))
colnames(koditex.rank.ARF)=c("X.U.FEFF.word", 'rank.koditex')
merge2 = merge(merge1, koditex.rank.ARF, by="X.U.FEFF.word")
colnames(ORTOFONv2.rank.ARF)=c("X.U.FEFF.word", 'rank.ORTOFONv2')
merge3 = merge(merge2, ORTOFONv2.rank.ARF, by="X.U.FEFF.word")
colnames(syn2020.rank.ARF)=c("X.U.FEFF.word", 'rank.syn2020')
merge4 = merge(merge3, syn2020.rank.ARF, by="X.U.FEFF.word")
lemposes_intersection_ARF = merge4
summary(lemposes_intersection_ARF)
#View(lemposes_intersection_RF)

#here we are taking the average rank to find out a rough idea of what the list looks like
lemposes_intersection_ARF$mean = apply(lemposes_intersection_RF[, 2:6], 1, mean)
lemposes_intersection_ARF = lemposes_intersection_RF[order(lemposes_intersection_RF$mean),]
lemposes_intersection_ARF$max = apply(lemposes_intersection_RF[, 2:6], 1, max)
lemposes_intersection_ARF$min = apply(lemposes_intersection_RF[, 2:6], 1, min)
lemposes_intersection_ARF$median = apply(lemposes_intersection_RF[, 2:6], 1, median)
lemposes_intersection_ARF$product = apply(lemposes_intersection_RF[, 2:6], 1, prod)
#View(lemposes_intersection_RF)
summary(lemposes_intersection_ARF)
hist(lemposes_intersection_ARF$max)
hist(lemposes_intersection_ARF$median)
hist(log10(lemposes_intersection_ARF$product))
hist(lemposes_intersection_ARF$mean)

#here we are making a union of all the sets
merge1 = merge(cstenten17.rank.ARF, ORALv1.rank.ARF, by="X.U.FEFF.word", suffixes=c(".cstenten17", ".ORALv1"), all=TRUE)
colnames(koditex.rank.ARF)=c("X.U.FEFF.word", 'rank.koditex')
merge2 = merge(merge1, koditex.rank.ARF, by="X.U.FEFF.word", all=TRUE)
colnames(ORTOFONv2.rank)=c("X.U.FEFF.word", 'rank.ORTOFONv2')
merge3 = merge(merge2, ORTOFONv2.rank.ARF, by="X.U.FEFF.word", all=TRUE)
colnames(syn2020.rank)=c("X.U.FEFF.word", 'rank.syn2020')
merge4 = merge(merge3, syn2020.rank.ARF, by="X.U.FEFF.word", all=TRUE)
lemposes_union_ARF = merge4
#View(lemposes_union_ARF)
summary(lemposes_union_ARF)


#viewing the union histogram data
#need to figure out the correct way to deal with NA's
lemposes_union_ARF$mean = apply(lemposes_union_ARF[, 2:6], 1, mean)
lemposes_union_ARF = lemposes_union_ARF[order(lemposes_union_ARF$mean),]
lemposes_union_ARF$max = apply(lemposes_union_ARF[, 2:6], 1, max)
lemposes_union_ARF$min = apply(lemposes_union_ARF[, 2:6], 1, min)
lemposes_union_ARF$median = apply(lemposes_union_ARF[, 2:6], 1, median)
lemposes_union_ARF$product = apply(lemposes_union_ARF[, 2:6], 1, prod)
#View(lemposes_union_ARF)
summary(lemposes_union_ARF)
hist(lemposes_union_ARF$max)
hist(lemposes_union_ARF$median)
hist(log10(lemposes_union_ARF$product))
hist(lemposes_union_ARF$mean)


#checking for unique lemposes
all_lemposes_ARF = c(cstenten17.rank.ARF$X.U.FEFF.word, ORALv1.rank.ARF$X.U.FEFF.word, koditex.rank.ARF$X.U.FEFF.word, ORTOFONv2.rank.RF$X.U.FEFF.word, syn2020.rank.RF$X.U.FEFF.word)
unique_lemposes_ARF = which(table(all_lemposes_ARF)==1)
length(unique_lemposes_ARF)

#replacing NAs with value of 10k
lemposes_union_ARF_missingvalues_10k = lemposes_union_ARF
lemposes_union_ARF_missingvalues_10k[is.na(lemposes_union_ARF_missingvalues_10k)] <- 10000
lemposes_union_ARF_missingvalues_10k

#viewing the union histogram data dealing with NAs with adding 10k as value
#need to figure out the correct way to deal with NA's
lemposes_union_ARF_missingvalues_10k$mean = apply(lemposes_union_ARF_missingvalues_10k[, 2:6], 1, mean)
lemposes_union_ARF_missingvalues_10k = lemposes_union_ARF_missingvalues_10k[order(lemposes_union_RF_missingvalues_10k$mean),]
lemposes_union_ARF_missingvalues_10k$max = apply(lemposes_union_ARF_missingvalues_10k[, 2:6], 1, max)
lemposes_union_ARF_missingvalues_10k$median = apply(lemposes_union_ARF_missingvalues_10k[, 2:6], 1, median)
lemposes_union_ARF_missingvalues_10k$product = apply(lemposes_union_ARF_missingvalues_10k[, 2:6], 1, prod)
#View(lemposes_union_RF_missingvalues_10k)
summary(lemposes_union_ARF_missingvalues_10k)
hist(lemposes_union_ARF_missingvalues_10k$max)
hist(log10(lemposes_union_ARF_missingvalues_10k$max))
hist(log10(lemposes_union_ARF_missingvalues_10k$median))
hist(lemposes_union_ARF_missingvalues_10k$median)
hist(log10(lemposes_union_ARF_missingvalues_10k$product))
hist(lemposes_union_ARF_missingvalues_10k$product)
hist(lemposes_union_ARF_missingvalues_10k$mean)
#View(lemposes_union_RF_missingvalues_10k)

#filtering out intersection
#The idea is to filter the intersection and all the words that are greater than 1000
#in rank, creating a list that is not the CGSL of raw frequencies
#Then we will filter these not words from the union list to get the cgsl_RF!
library(dplyr)
not_cgsl_ARF <- lemposes_union_ARF_missingvalues_10k
#View(not_cgsl_RF)

not_cgsl_ARF <- not_cgsl_ARF %>%
  filter(!(X.U.FEFF.word %in% lemposes_intersection_ARF$X.U.FEFF.word))
not_cgsl_ARF <- not_cgsl_ARF[order(not_cgsl_ARF$mean),]
#View(not_cgsl_RF)

not_cgsl_ARF <- filter(not_cgsl_ARF, not_cgsl_ARF$rank.cstenten17 > 1000)
not_cgsl_ARF <- filter(not_cgsl_ARF, not_cgsl_ARF$rank.koditex > 1000)
not_cgsl_ARF <- filter(not_cgsl_ARF, not_cgsl_ARF$rank.ORALv1 > 1000)
not_cgsl_ARF <- filter(not_cgsl_ARF, not_cgsl_ARF$rank.ORTOFONv2 > 1000)
not_cgsl_ARF <- filter(not_cgsl_ARF, not_cgsl_ARF$rank.syn2020 > 1000)
#View(not_cgsl_ARF)

cgsl_ARF <- lemposes_union_ARF_missingvalues_10k %>%
  filter(!(X.U.FEFF.word %in% not_cgsl_ARF$X.U.FEFF.word))
#View(cgsl_ARF)
nrow(cgsl_ARF)

#checking the CGSL_ARF
hist(cgsl_ARF$mean)
hist(cgsl_ARF$max)
hist(cgsl_ARF$min)
hist(cgsl_ARF$product)
plot(cgsl_ARF$max, cgsl_ARF$min)
plot(log10(cgsl_ARF$min))

#talking with Danny about this
subset(cgsl_ARF, X.U.FEFF.word == "ne_T")
summary(cgsl_ARF)
cgsl_ARF = cgsl_ARF[order(cgsl_ARF$median),]
