# Project Info

#Date: February 9th, 2021
#GitHub Repository Link: https://github.com/ForgetfulCow/Rentrez
#Username: ForgetfulCow

# The following script will retrieve data from NCBI databases, reformat the data, then 
# write the data to a new .csv file.

# Copy and pasted lines from assignment instructions
# Line 17 concatenates 3 unique NCBI identifiers and stores them in a vector called "ncbi_ids"
# Line 18 loads the "rentrez" package
# Line 19 calls the "enztrez_fetch()" function from the rentrez package. This function 
#   will use the supplied ID character vector to download or "fetch" data from NCBI databases. 
#   the rettype parameter specifies that the data should have FASTA formatting.

ncbi_ids <- c("HQ433692.1","HQ433694.1","HQ433691.1")
library(rentrez)
Bburg<-entrez_fetch(db = "nuccore", id = ncbi_ids, rettype = "fasta")


# Use strsplit() to separate the 3 sequences in the Bburg object. Each element in the 
# Sequences object will contain one sequence. "\n\n" is the splitting criterea. 
Sequences <- strsplit(Bburg, split = "\n\n")

# Convert the Sequences object's class from list to data.frame
# Code copy and pasted from instructions.
Sequences <- unlist(Sequences)
print(Sequences)

# Use regular expressions to separate the sequences from the headers.
# Code copy and pasted from instructions. 
header<-gsub("(^>.*sequence)\\n[ATCG].*","\\1",Sequences)
seq<-gsub("^>.*sequence\\n([ATCG].*)","\\1",Sequences)

# Remove the newline characters.
# using regular expressions. Fully processes data.frame is stored as "Sequences1", rather
# than "Sequences" to assist troubleshooting and prevent data loss.
header1 <- gsub("\\n","",header)
seq1 <- gsub("\\n","",seq)
Sequences1<-data.frame(Name=header1,Sequence=seq1)

# Output the Sequences1 data.frame to a file called Sequences.csv
# Include row.names=FALSE to prevent row index from being written to the file.
write.csv(Sequences1, "Sequences.csv",row.names=FALSE)

