# Project Info

#Date: February 9th, 2021
#GitHub Repository Link: https://github.com/ForgetfulCow/Rentrez
#Username: ForgetfulCow

# The following script will download the SARS-CoV-2 reference genome from Genbank.
# Uses the accession ID: "NC_045512.2"

# Load packages
library(annotate)
library(genbankr)

# The S protein = important for infection & virulence. 
# S protein starts at bp position 21,563 and ends at position 25,384. 
# Thus, the S protein gene will be 3,821 base pairs long.

# Download the sequence for the S protein
SarsCov2ID<-GBAccession("NC_045512.2")
SarsCov2 <- readGenBank(SarsCov2ID)

# Use regular expressions in R to isolate the S protein from the genome 
# you downloaded.
SarsCov2Seq <- as.character(SarsCov2@sequence)
print(SarsCov2Seq)

# Verify that the S protein's location is the same as the one provided by prof.
SarsCov2@genes

# ATG = START codon; [ACTG]{3} = codon; +? = 1 or more, match as few times as possible
# TAA|TAG|TGA = the three possible STOP codons. 
# \\L\\1 = replace with the lowercase version of the matching character.
# Problem: The ORFs don't correspond to the actual genes
#     Changing `+?` to manipulate 'greediness' and 'laziness' doesn't seem to work.
ORFs_L <- gsub("(ATG([ATGC]{3})+?(TAA|TAG|TGA)+?)","\\L\\1",
               SarsCov2Seq, perl = T)

# All groups of uppercase letters are replaced with a space.
# Only open reading frames are left. 
NoNonORFS <- gsub("[ATGC]+"," ",
                  ORFs_L, perl = T)

S_exon<- gsub("(\\s([atcg]{3821})\\s)", "\\1", NoNonORFS) 
# I think the above code would work if the ORFs actually corresponded to the gene locations.

# Simple way to extract S protein's sequence. 
# 1) get coords of sequence from sequence@genes. 
# 2) use substr to extract sequence that belongs to these coordinants. 
S_exon <- substr(SarsCov2Seq, start = 21563, stop = 25383)
print(S_exon)

# Do stuff on BLAST website

# Would you say this gene is highly conserved or evolving rapidly? Why? 
# My opinion and explanation below.

# This gene seems highly conserved.
# From the description you can see that each sequence had its maximum score 
# and we don't expect to find any sequences that have that score by chance. 
# This suggests that the sequences are related to the query sequence.
# This is supported by the graphics summary which shows that every 
# sequence has an alignment score of >200 along the query sequence. 
# When you look at the alignment tab, you can see that every sequence 
# had 100% identity with the query sequence. 
