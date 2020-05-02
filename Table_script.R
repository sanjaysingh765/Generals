# This script will draw table in R
#input file format is given in the last of file


library(gridExtra)
library(grid)
library(extrafont)
#font_import() # only one time required when first time use the library extrafont
#y
fonts() 
loadfonts()
library(cowplot)

png("axil_up.png",units="in", family="Times New Roman",  width=7, height=12, res=300, pointsize = 4) #pointsize is font size| increase image size to see the key)

apical <- read.csv("input.txt", header=T)
myt <- ttheme_default(
         # Use hjust and x to left justify the text
         # Alternate the row fill colours
                 core = list(fg_params=list(fontsize=9, fontface="bold",hjust = 0.5),
                             bg_params=list(fill=c("grey95", "grey90"))),

         # Change column header to white text and red background
                 colhead = list(fg_params=list(col="white"),
                                bg_params=list(fill="black"))
 )



grid.newpage()
apical1 <- apical[, c(1,2,3,5,6)]
grid.draw(tableGrob(format(apical1, big.mark=","), 
theme=myt, 
rows=NULL,))
dev.off()

#FORMAT
#Gene,Hormone,Function,regulation,log2 fold change,FDR corrected p-value,
#Gene1,ABA,Metabolism,Downregulated,-1.647,2.28182296602758E-06
#Gene11,ABA,Metabolism,Downregulated,-1.272,8.75628657203343E-05
#Gene21,ABA,Metabolism,Downregulated,-1.015,0.0027270564
#Gene31,ABA,Metabolism,Downregulated,-1.087,0.0043516287



