# Script to calculate Ka, Ks, Ka/Ks ratio and divergence time


#initiate libraries
library(seqinr)
library(ape)
library(phangorn)

# read alignemnt
aln=read.alignment('alignment.clustal',format="clustal")

#calculate Ka and Ks
kaks <- kaks(aln)
ks <- kaks$ks
ks
ka <- kaks$ka
ka

#calculate Ka/Ks ratio
ratio <- kaks$ka/kaks$ks
ratio

#set lambda value
lambda <- 6.96*10^-9

#calculate divergence time
divergence <- (ks/(2*lambda))
dt <- divergence/1e6  #convert to million

write.csv(as.matrix(ratio), "ORC+KaKs_ratio.csv")
write.csv(as.matrix(ks), "ORC+Ks.csv")
write.csv(as.matrix(ka), "ORC+Ka.csv")
write.csv(as.matrix(dt), "ORC+divergence_time.csv")



