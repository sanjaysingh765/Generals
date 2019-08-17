#modified from https://www.biostars.org/p/269082/

## Install required libraries
#source("https://bioconductor.org/biocLite.R")
#biocLite("affy","ArrayExpress")

library(ArrayExpress)
library(aff)

# To read all CEL files in the working directory and normlize them:
Data <- ReadAffy()
eset <- rma(Data)
norm.data <- exprs(eset)
head(norm.data)

# In order to convert the probeset IDs to Arabidopsis gene identifiers, 
#In order to avoid ambiguous probeset associations (i.e. probesets that have multiple matches to genes), we only used probes that match only one gene in the Arabidopsis genome.
URL <- "https://www.arabidopsis.org/download_files/Microarrays/Affymetrix/affy_ATH1_array_elements-2010-12-20.txt"
download.file(URL, destfile = "affy_ATH1_array_elements-2010-12-20.txt", method="curl")
affy_names <- read.delim("affy_ATH1_array_elements-2010-12-20.txt",header=T)

# Select the columns that contain the probeset ID and corresponding AGI number. 
#Please note that the positions used to index the matrix depend on the input format of the array elements file. 
#You can change these numbers to index the corresponding columns if you are using a different format:
probe_agi <- as.matrix(affy_names[,c(1,5)])

# To associate the probeset with the corresponding AGI locus:
normalized.names <-merge(probe_agi,norm.data,by.x=1,by.y=0)[,-1]

# To remove probesets that do not match the Arabidopsis genome:
normalized.arabidopsis <- normalized.names[grep("AT",normalized.names[,1]),]


# To remove ambiguous probes:
normalized.arabidopsis.unambiguous <- normalized.arabidopsis[grep(pattern=";",normalized.arabidopsis[,1], invert=T),]

# In some cases, multiple probes match the same gene, due to updates in the annotation of the genome. To remove duplicated genes in the matrix:
normalized.agi.final <- normalized.arabidopsis[!duplicated(normalized.arabidopsis[,1]),]

# To assign the AGI number as row name:
rownames(normalized.agi.final) <- normalized.agi.final[,1]
normalized.agi.final <- normalized.agi.final[,-1]

#The resulting gene expression dataset contains unique row identifies (i.e. AGI locus), and different expression values obtained from different experiments on each column
# To export this data matrix from R to a tab-delimited file use the following command. The file will be written to the folder that you set up as your working directory in R using the setwd() command in line 1 above:
write.table (normalized.arabidopsis ,"Gene_expression.txt", sep="\t",col.names=NA,quote=F)
