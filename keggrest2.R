## The following section of this script will provide a list of Kegg Ids, which were original Refseq Ids
## that were taken from a Blast output file and converted into Kegg Ids through the use of the KEGGREST Package
library(dplyr)
library("KEGGREST")

## Import output file given by Blast 
blastoutputfile <- read.table("C:/Users/isabe/Downloads/Loki1-k1u.tsv")


## Modifies BLAST output files id so that they can be used in the keggConv function
tstlist <- unlist(strsplit(as.character(blastoutputfile$V2),"[.]"))

tstlist = tstlist[tstlist!= "1"]
tstlist = tstlist[tstlist!= "2"]
tstlist = tstlist[tstlist!= "3"]

## Appends "ncbi-proteinid:" in front of each id"
tstlist2 <- as.data.frame(paste("ncbi-proteinid:", tstlist, sep = ""))

## Removes duplicate values, keeping only one of these
tstlist3 <- unique(tstlist2)



##create a list that will contain future KEGG values converted from Uniprot or Refseq
tstlist5 <- list()
tstlist6 <- list()

## There are two ways so use keggConv function, iterating over dataframe (presumed to be slower) or directly applying
## the function to the list


## This way will let you see the progress of the function
for (i in unlist(tstlist3)) {
  
 tstlist5 <- c(tstlist5, keggConv("genes", i, querySize = 100))
}

## This way is more direct, possibly faster but you will not know how fast it is executing
tstlist6 <- keggConv("genes", unlist(tstlist3), querySize = 100)


## We then take the resulting kegg ids from the previous function and convert them into KO ids with the Kegglink function 
for (i in unlist(tstlist5)) {

  listofkoids <- c(listofkoids, keggLink("ko", tstlist5[[i]]))
  
  
}
