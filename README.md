## rerefaction.R

      ***(This is trial version and I endedup making accumualation curve)***

      test.txt: text file containing taxonomic ids per row.

      Following values can be manually set prior to running the code

      #fraction of sample
      samp_frac <- c(1,0.95,0.9,0.85,0.8,0.75,0.7,0.65,0.6,0.55,0.5,0.45,0.4,0.35,0.3,0.25,0.2,0.15,0.1,0.05,0.01)

      #Total simulation
      simulation <- 1:10

      #Minimum occurance in a sample to claim a species. Here it is constant for all samples
      threshold <- c(0,2,10,20, 30, 40,60,70, 80, 90, 100,150, 200)

## rarefaction_parallel.R: This script takes taxonomic ids, and generates table containing unique taxonomic ids present in different sampling effort.
 Things to consider: 
 Good part: It offer to run everything in parallel. 
 Sampling: Continuously discarding particular percentage of sample from the left out sample -> conut unique species (taxonomic ids) left
 Simulation: Option to iterate to generate average value
 Threshold: Minimum count to claim it as species, or minimise FALSE positive. Higher value may disrupt the TRUE positive at final sampling effort
 Subset: Subset for customised taxonomy ranks eg., for class, order, family: subset(my_data, select = -c(taxid, kingdom, phylum, genus, species))
  
  Extract output from kraken2 containing taxonomic ids (3rd column) 
  eg., test.txt:
  523845
  0
  0
  0
  1869304
  0
  0
  0
  1977087
  2026742

  #Convert to final_data.txt using taxonkit: 
  taxonkit lineage test.txt 2>/dev/null | taxonkit reformat -t -a | csvtk -H -t cut -f 1,4 | awk '{if (!$2) {print $1 "\t" ";;;;;;"} else {print $1 "\t" $2}}' | csvtk -H  sep -f 2 -s ';' -R   -t | awk 'BEGIN { FS = OFS = "\t" } { for(i=1; i<=NF; i++) if($i ~ /^ *$/) $i = 0 }; 1' | csvtk add-header -n taxid,kingdom,phylum,class,order,family,genus,species  -t  1>test_final_data.txt
  
  Preprocess: convert taxonomic ids to extract taxonomic ids for different taxonomic levels
  #test_final_data.txt
  taxid   kingdom phylum  class   order   family  genus   species
  523845  2157    28890   183939  2182    2183    155862  2186
  0       0       0       0       0       0       0       0
  0       0       0       0       0       0       0       0
  0       0       0       0       0       0       0       0
  1869304 2       1224    28221   213118  0       0       1869304
  0       0       0       0       0       0       0       0
  0       0       0       0       0       0       0       0
  0       0       0       0       0       0       0       0
  1977087 2       1224    0       0       0       0       1977087
  2026742 2       142182  0       0       0       0       2026742
  
  
 
 #Run: This script takes sequences, and offer to run everything in parallel.
  
  Rscript rarefaction_parallel.R >result.txt





