## The following section of this script will provide a list of Kegg Ids, which were original Refseq Ids
## that were taken from a Blast output file and converted into Kegg Ids through the use of the KEGGREST Package

library("KEGGREST")

## Import output file given by Blast 
blastoutputfile <- read.table("C:/Users/isabe/Downloads/Loki1-k1u.tsv")


##create a list that will contain future KEGG values converted from Refseq
listofkeggids <- list()
## iterate over each Id from the second column of the blast output file in order to get the Kegg Ids of these and add them to 
## the list
for (i in blastoutputfile$V2) {
  tst <- unlist(strsplit(i,"[.]"))
  completeid <- paste("ncbi-proteinid:",tst[[1]], sep = "")
  listofkeggids <- c(listofkeggids, keggConv("genes", completeid))
  
  
}

############## ###################################### ################
############## KEGGREST PACKAGE FUNCTIONALITY EXAMPLES ###############
############### ###################################### ###############
#Once you have a list of specific KEGG identifiers, use keggGet() to get more information about them. Assign it to object
testid <- keggGet("pon:100137177")

#Behind the scenes, KEGGREST downloaded and parsed a KEGG flat file, which you can now explore:
names(testid[[1]])


## Which of these is used to construct the pathway maps for the metabolites?
testid[[1]]$BRITE
testid[[1]]$PATHWAY
testid[[1]]$ORTHOLOGY


## Example of keggConv function
head(keggConv("uniprot", "pon:100137177"))

## Gives you information about id on other databases ex. NCBI-GeneID

testid[[1]]$DBLINKS

## What is the difference?

testid[[1]]$PATHWAY
head(keggLink("pathway", "pon:100137177")) ## Less information

### Convertir de Uniprot a Kegg y buscar el pathway
keggConv("genes","up:A0A010PZJ8")
## Uses output of preivous function to gives us KO
keggLink("ko", "cfj:CFIO01_09356")


### REFSEQ A KO
keggConv("genes","ncbi-proteinid:XP_721512")
keggLink("ko", "cal:CAALFM_C103220CA")


keggConv("genes","CP017623")
CP017623
