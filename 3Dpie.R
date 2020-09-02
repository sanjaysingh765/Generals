# Draw Pie Chart in R
# Get the library.
#install.packages("plotrix")
library(plotrix)

# Data for Pie chart
rpkm <- read.delim("pie.txt",header=TRUE)

# color for pie chart
#piecol <- c(rainbow(length(rpkm$Number.of.genes)))
col=c("red","orange","yellow","blue","green","violet",  "pink", "cyan", "Coral", "DarkOrchid")

# Give the chart file a name.
png(file = "diet3d.png", family = "Times", units="in", width=6, height=6, res=300, pointsize = 9)
#3D Exploded Pie Chart
pie3D(
  rpkm$Number.of.genes, 
  labels=rpkm$Number.of.genes, 
  explode=0.1, 
  height=0.05 , 
  radius=.9, 
  labelcex = 1.7,  
  start=0.7, 
  #main='Daily Diet Plan', 
  col=col)

 legend(-1,-0.71,legend=rpkm$Category,cex=0.7,yjust=0.2, xjust = -0.1,
         fill = col, bty="n",ncol=3) 
  # Save the file.
  dev.off() 
  
  
  #file format
  
Category	Number of genes	Color
Transcription_O	24	#ed2f52
Transport_O	13	#efc023
Catalytic 	31	#008080
Phosphorylation	5	#8FBC8B
Cell Wall 	7	#AFEEEE
Defense	16	#CD853F
Secondary metabolites	4	#A0522D
Unknown	26	#9ACD32
Miscellaneous	28	#D8BFD8
Uncharacterized	10	#E6E6FA
