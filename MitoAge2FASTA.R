# source("https://bioconductor.org/biocLite.R")
# biocLite("Biostrings")
# biocLite("ShortRead")
# install.packages("readr")
# install.packages("rentrez")
# install.packages("seqinr")
library(readr)
library(rentrez)
library(data.table)
library(ShortRead)
library("seqinr")

### downloaded the mitoAge data and used this script to get the actual sequences of each mtDNA
setwd("D:/MitoAge/mitoage_build1_full_database")

total_mtDNA_base_composition <- suppressMessages(read_csv("total_mtDNA_base_composition.csv"))
mainDir <- getwd()
subDir <- "output"
dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
number_of_records <- nrow(total_mtDNA_base_composition)
for (NC in 1:number_of_records) {
    if (total_mtDNA_base_composition$Class[NC] == "Mammalia") {
        ref_ID <- total_mtDNA_base_composition$Ref[NC]
	print(ref_ID) # show some progress
        fasta <- entrez_fetch(db="nuccore", id=ref_ID, rettype="fasta")
        filename <- paste(subDir, "/", ref_ID,".fasta", sep="")
        write(fasta, file = filename)
    }
}

seqcombined <- readFasta(subDir, "fasta$") # Reading all fasta files into one object
writeFasta(seqcombined, "merged_fasta.fasta")

seqs = read.fasta(file="merged_fasta.fasta")
write.fasta(seqs, names(seqs), nbchar=65536, file.out="merged_fasta_one_line_fasta.fasta") # One FASTA per line

fastaFile <- readDNAStringSet("merged_fasta_one_line_fasta.fasta")
Ref = names(fastaFile)
FASTA = paste(fastaFile)

dat <- fread("total_mtDNA_base_composition.csv", select = c("Ref","Common name","Maximum longevity (yrs)"))

df <- as.data.frame(data.frame(Ref, FASTA))
new_df <- merge(dat, df, by = c("Ref")) # Merging two dataframes

fwrite(new_df, file = "MitoAge_NCRef_CommonName_Lifespan_FASTA.csv")
