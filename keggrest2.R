## The following section of this script will provide a list of Kegg Ortholog Ids, which were original Refseq Ids
## that were taken from a Blast output file and first converted into Kegg Ids through the use of the KEGGREST Package
library(dplyr)
library("KEGGREST")
library(readr)

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
tstlist4 <- as.data.frame(as.character(tstlist3[1:100,]))
tstlist6 <- keggConv("genes", unlist(tstlist4), querySize = 100)

#tstlist6 <- keggConv("genes", unlist(tstlist3), querySize = 100)


## We then take the resulting kegg ids from the previous function (depending on which method you used it will either be
## tstlist5 or tstlist6 *** make sure to update the script accordingly
## and convert them into KO ids with the Kegglink function 
listofkoids <- list()

## Here we use tstlist6
for (i in unlist(tstlist6)) {

  listofkoids <- c(listofkoids, keggLink("ko", i[[1]]))
  
}

############ The following code serves to manipulate both output files taken from the previous KEGGREST ################
 
############ processes in order to organize  the ids involved into a neat table ####################################

## Refseq and KEGG ids file
RS_KEGG <- read_delim("C:/Users/isabe/OneDrive/Documents/OceanicPicoalgaeMetagenomics-Package/Network-Based-Bioinformatics-Research-in-Genomics-/KOList6 FP.csv", ";", 
                      escape_double = FALSE, trim_ws = TRUE)

## Kegg and KO file
KEGG_KO <- read_csv("ListofKoids - C.csv")

## Kegg and their corresponding Refseq and KO ids
RS_KO <- merge(RS_KEGG, KEGG_KO, by.x = "KEGG", by.y = "KEGG" , all.x = T)

## Original BLAST output file assignment
BL_RS <- originaloutputfile

##Here we manipulate the results in order to get a table that re-duplicates the KO ids to get a sense of how many repeat ids there are
BL_KO <- merge(BL_RS, RS_KO, by.x = "tstlist", by.y = "RefSeq", all.x = F)
listofNA  <- is.na(BL_KO$KO)
listofNA <- which(listofNA)
## We will use this later ignore this for now
BL_KOwithoutduplicates <- unique(BL_KOwithoutNA)
## Contains duplicate KO ids! 200k approx
BL_KOwithoutNA <- slice(BL_KO, -listofNA)

###################### This part of the script compares the original blast output file with a new one  ####################
###################### so that we can eliminate previously analyzed refseq id's and this way we  ###############
###################### save more time when we minimize the file of the size  #########

## Assign new blast output file
newblastoutputfile <- read.table("C:/Users/isabe/Downloads/Loki3-u1-clean2.tsv")

## We remove duplicates 
newblastoutputfile <- unique(newblastoutputfile)
originaloutputfile <- unique(as.data.frame(tstlist))

## Verify which entries in the new file are in the original file  
BOP2KOs <- merge(newblastoutputfile, BL_KOwithoutduplicates, by.x = "V1", by.y = "tstlist", all.x = F)
List1and3 <-merge(newblastoutputfile, originaloutputfile, by.x = "V1", by.y = "tstlist", all.y = F)

## Displays entries of newblastoutputfile that are not in originalblastoutputfile
List1and3withNA <- as.data.frame(setdiff(newblastoutputfile$V1, List1and3$V1))

## Search in keggrest!



