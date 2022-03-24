## rerefaction
##This is trial version and I endedup making accumualation curve

test.txt: text file containing taxonomic ids per row.

Following values can be manually set prior to running the code

#fraction of sample
samp_frac <- c(1,0.95,0.9,0.85,0.8,0.75,0.7,0.65,0.6,0.55,0.5,0.45,0.4,0.35,0.3,0.25,0.2,0.15,0.1,0.05,0.01)

#Total simulation
simulation <- 1:10

#Minimum occurance in a sample to claim a species. Here it is constant for all samples
threshold <- c(0,2,10,20, 30, 40,60,70, 80, 90, 100,150, 200)

