## RScript to determine keggrest functionality
library("KEGGREST")

#Once you have a list of specific KEGG identifiers, use keggGet() to get more information about them. Assign it to object
testid <- keggGet("pon:100137177")

#Behind the scenes, KEGGREST downloaded and parsed a KEGG flat file, which you can now explore:
names(testid[[1]])


## Which of these is used to construct the pathway maps for the metabolites?
testid[[1]]$BRITE
testid[[1]]$PATHWAY
testid[[1]]$ORTHOLOGY
