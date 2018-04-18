# source("https://bioconductor.org/biocLite.R")
# biocLite("Biostrings")
# install.packages("readr")
# install.packages("rentrez")
library(readr)
library(rentrez)

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
