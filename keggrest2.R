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
# for (i in unlist(tstlist3)) {
#   
#  tstlist5 <- c(tstlist5, keggConv("genes", i, querySize = 100))
# }




## This way is more direct, possibly faster but you will not know how fast it is executing #################

## Lets test with a small sub-sample to see how fast
##tstlist4 <- as.data.frame(as.character(tstlist3[1:100,]))
##tstlist6 <- keggConv("genes", unlist(tstlist4), querySize = 100)

tstlist6 <- keggConv("genes", unlist(tstlist3), querySize = 100)


## We then take the resulting kegg ids from the previous function (depending on which method you used it will either be
## tstlist5 or tstlist6 *** make sure to update the script accordingly
## and convert them into KO ids with the Kegglink function 
listofkoids <- list()

## Here we use tstlist6
for (i in unlist(tstlist6)) {

  listofkoids <- c(listofkoids, keggLink("ko", i[[1]]))
  
}
