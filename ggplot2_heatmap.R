library("reshape2")
library(ggplot2)
library(plyr)
library(scales)

#upload data
df1 <- read.csv("expression.csv", header=T)
df1


# Use of rescale
tableau.m <- ddply(df1, .(Time), transform, rescale = rescale(expression))
# Order data for titles
tableau.m$Gene <- factor(tableau.m$Gene, levels = rev(unique(tableau.m$Gene)), ordered=TRUE)




#make plot
png("Expression.png", units="in", family="Times",  width=2.5, height=2, res=300, pointsize = 2) #pointsize is font size| increase image size to see the key
ggplot(tableau.m , aes(Time, Gene,fill = rescale)) + 
  geom_tile(colour = "black",show.legend = T) + 
  geom_text(aes(label=significance), size = 4) +
  scale_fill_gradientn(colours = c("steelblue", "red"),breaks=c(0, 1), labels=c("High","Low"))+
  labs(x = "",y = "") +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    panel.background = element_blank(),
    plot.background = element_blank(),
    legend.title=element_blank(),
    axis.text=element_text(size=6, color = "black",family="Times"),
    axis.title=element_text(size=6,face="bold", color = "black"),
    plot.title = element_text(color="black", size=6, face="bold",hjust = 0.4,margin=margin(b = 5, unit = "pt")),
    axis.text.x = element_text(angle = 360, hjust = 1, vjust = 1.01,color = "black" ),
    plot.margin=unit(c(8,2,2,2),"mm"),
    axis.title.y = element_text(margin = margin(t = 0, r = 0, b = 0, l = 0)),
    axis.title.x = element_text(margin = margin(t = 0, r = 0, b = 0, l = 0)))+
   theme(  legend.text=element_text(size=4),
          #legend.justification=c(2.5,1),
          legend.key = element_rect(size = 6),
          legend.key.size = unit(2.5, 'lines'),
          legend.position=c(0.5, 1.12),
          legend.direction = "horizontal",
          legend.title=element_blank())
    
  dev.off() 
  
  
  
  
  
  
  
  
  
  
  
  
  
  




