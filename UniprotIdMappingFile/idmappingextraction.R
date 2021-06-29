library("dplyr")
# As a first step, we download the idmapping example file in .txt format and import it into R as a table. We also do this 
# with the file that contains the conversion of UniprotIds to Kegg Ortholog Ids (uniprot-KO.csv)

idmappingexample <- read.table("C:/Users/isabe/Downloads/idmapping.dat.example.txt")
unitoKOtable <- read.table("C:/Users/isabe/Downloads/uniprot-KO.csv (1).sorted", fill = TRUE)

# We then look for matches between the Uniprot Ids in the UniprotToKo file and the Uniprot Ids in the idmapping file
##The match function provides a list of row positions of the second file where values of the first file are found. We assign
##the list of positions to a file called "idmappingfiltered"
# For this function we (ALWAYS) take the first columns of each file respectively, since they both contain the Uniprot Ids we are comparing

idmappingfiltered <- match(unitoKOtable$V1, idmappingexample$V1)

# we then remove NA values from the list of matches. We are left with a list of row indexes of the idmapping file
# where Uniprot Ids of the UniprotToKO file where found.
idmappingfiltered <- idmappingfiltered[!is.na(idmappingfiltered)]

# As a next step, use the function slice which helps us to create a new table which only contains the rows in which matches were found
# The file created will only keep the rows (with all of the columns) of the original idmapping file where matches 
# withing the UnitoKo file were found 
# 
extractedidmapping <- slice(idmappingexample, idmappingfiltered)


# Then, in order to keep the Uniprot Ids that have a Kegg Ortholog id and of other Databases (such as Refseq, EMBL, etc)
# from the original idmapping example file, we match the Uniprot Ids of extractedidmapping with the Uniprot Ids of idmappingexample

#We create an empty list before starting the loop to store our values
listofmatches <- list()
for (x in extractedidmapping$V1){
  listofmatches <- c(listofmatches, which(idmappingexample$V1 == x))
 
}

#we then convert our list into integer values 
integermatches <- as.integer(listofmatches)
# As a next step, use the function slice in order to create a new table which only contains all of the rows in which 
# matches were found
slicedUniversalidtables <- slice(idmappingexample, integermatches)

# We are left with a table that contains all of the uniprot Id sequences with the analogs of other Id sequences from other bases.