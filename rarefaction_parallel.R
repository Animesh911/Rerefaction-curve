start.time <- Sys.time()

setwd("/storage/aku048/paper1/metagenomics-illbgi-master/taxonomy_git/rarefaction_curve_discard_without_replacement_paper1/")

my_data <- data.matrix(read.csv("test1.txt", header=T, sep="\t", stringsAsFactors=F, quote = "", check.names=F, comment.char=""))

library(scales)
library(reshape2)
library(doParallel)
detectCores()

registerDoParallel(6)


raref <- function(x){
    taxonid <- as.matrix(x)
    discard_length <- discard *nrow(taxonid)
  
    sample_value <- round(seq(nrow(taxonid), 0, -discard_length))
    discard_times <- 1/discard   
     
    foreach(sim = 1: simulation, .combine = 'rbind') %dopar% {
      taxonid <- as.matrix(x)
      
      foreach(i = sample_value) %dopar% {                                                       #repeat discarding till no value remains to sample
      taxonid <- taxonid[sample(nrow(taxonid), i , replace=FALSE), ,drop=FALSE]   #smaller sample after discard_length
          
      # calculate frequency of species
      counts <- data.frame(unclass(rle(sort(taxonid))))	      #sort all sampled taxonids and 'rle' counts the vlaues (taxonids) and length (freq), remove default rle class and save as df
      rownames(counts) <- counts$values
         
      # observed number of species
      for(j in threshold) {
        species_identified <- counts[which(counts[,1] >= j), , drop=FALSE]        #>= criteria for species presence > threshold, drop = FALSE to prevent df converting into vector
        
        if ("0" %in% rownames(species_identified)){				              	        #check if only 1 values are there; 
          classified_taxa <- nrow(species_identified) -1                          # sim = 1 in simulation iteration
          }else{							                                                    #if not check put the classified as the frequency
            classified_taxa <- nrow(species_identified)
            }
          return(classified_taxa) 
        }  
      }
   }
}
   

#sample discard during subsampling
discard <- 0.01
#Total simulation
simulation <- 10
#Minimum occurance in a sample to claim a species
threshold <- 10
    
###########taxid   kingdom phylum  class   order   family  genus   species

###########
#data <- subset(my_data, select = -c(taxid, kingdom, genus, species) )
data <- subset(my_data) #, select = family )
      
    
output <- foreach(i = 1:ncol(data), .multicombine=TRUE) %dopar%  {                                                          # for-loop over columns
   raref(as.matrix(data[,i]))
  }


output

end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken
