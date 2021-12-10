#fraction of sample
samp_frac <- c(1,0.95,0.9,0.85,0.8,0.75,0.7,0.65,0.6,0.55,0.5,0.45,0.4,0.35,0.3,0.25,0.2,0.15,0.1,0.05,0.01)
#Total simulation
simulation <- 1:10
#Minimum occurance in a sample to claim a species
threshold <- c(0,2,10,20, 30, 40,60,70, 80, 90, 100,150, 200)

setwd("C:\\Users\\aku048\\OneDrive - UiT Office 365\\Desktop\\paper1\\rarefaction\\test")
data <- data.matrix(read.csv("test.txt", header=T, sep="\t", stringsAsFactors=F, quote = "", check.names=F, comment.char=""))
colnames(data) = "taxonid"

##function can be called as:
raref(data, samp_frac, threshold, 1, replace = FALSE)
raref(data, samp_frac, threshold, 1)


##function for this code

raref <- function(x, samp_frac, threshold, simulation, ...)
{
	## convert data.frame to matrix for faster access
	taxonid <- as.matrix(x)

	final_simulated_threshold_value <- data.frame(matrix(ncol = length(threshold), nrow = length(samp_frac))) # row is samp_frac(i) col is threshold(j)
	colnames(final_simulated_threshold_value) <- threshold
	rownames(final_simulated_threshold_value) <- samp_frac

	## selecting a random subset in taxonid 
	sample_count <- 1
	for (i in samp_frac){
		
	# simulation
	simulated_value <- data.frame(matrix(ncol = length(threshold), nrow = length(simulation))) # row is simulation(sim) col is threshold(j)

	for(sim in simulation){
		
		#sampling as per percentage of total, samp_frac;i
		taxonids <- taxonid[sample(nrow(taxonid), round(i *nrow(taxonid), digits = 0), ...), ]
		
		# calculate frequency of species
		count <- rle(sort(taxonids))	#sort all sampled taxonids and 'rle' counts the vlaues (taxonids) and length (freq)
		counts <- data.frame(taxonids=count$values, freq=count$lengths)
		rownames(counts) <- counts[,1]	#change taxonids as rowname and delete the coulmn
		counts <- counts[-1]
		counts <- as.data.frame(t(counts))

		# observed number of species
		thresh_count <- 1
		for (j in threshold){
			subset <- counts[,which(counts[1,] >= j), drop=FALSE] 		#>= criteria for species presence
			if ("0" %in% colnames(subset)){					#check if only 1 vlaues are there; 
				classified_taxa <- ncol(subset[, -1, drop=FALSE])
				simulated_value[sim,thresh_count] <- classified_taxa
			}else{								#if not check put the classified as the frequency
				simulated_value[sim,thresh_count] <- ncol(subset)
			}
			thresh_count <- thresh_count +1
		}
		closeAllConnections()
	}
	simulated_threshold_value <- colMeans(simulated_value)
	final_simulated_threshold_value[sample_count,] <- simulated_threshold_value
	sample_count <- sample_count + 1
	}	
	
print(final_simulated_threshold_value)
}

