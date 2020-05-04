##################################################################################################################################################
#
#
#
#        Take input, y-limit and y-break as command
#        Perfrom T-test 
#        plot individual row as barplot with std error 
#   AGI CN  CN  CN CN TT  TT  TT  TT  TT
#   BCCP2          217.2      268.8      268.8      91.6     118.5     128.5     227.5     253.9     253.9
#   ACP1           286.7      317.0      317.0      82.4     118.5     138.5     283.7     291.2     291.2
#   PKP-BETA1     1125.3     1139.3     1139.3     407.3     627.5     620.5    1037.3    1095.0    1095.0
#   WRI1            44.0       39.5       39.5      32.3      41.4      40.4      37.3      45.3      45.3
    #TCP4           181.1      198.2      198.2     836.0    1168.4    1158.4      67.3      97.6      97.6
#
#
###################################################################################################################################################


#http://www.sthda.com/english/articles/24-ggpubr-publication-ready-plots/76-add-p-values-and-significance-levels-to-ggplots/#compare-more-than-two-groups
library("reshape2")
library("ggpubr")
library(Rmisc) 
library(extrafont)
#font_import() # only one time required when first time use the library extrafont
#y
fonts() 
loadfonts()
library(RColorBrewer)

#http://www.sthda.com/english/articles/24-ggpubr-publication-ready-plots/76-add-p-values-and-significance-levels-to-ggplots/#compare-more-than-two-groups
#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)< 1) {
  stop("At least one argument must be supplied (input file).\n USES : Rscript data_file y_axis_limit y_axis_break", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "out.png"
}



source("https://gist.githubusercontent.com/sanjaysingh765/fcfaf58e2de7874a9c646097fe4c5c38/raw/ggplot2_theme2.R")
your_font_size <- 2  #choose font size for significance stars/value



rpkm <- read.csv(args[1],header=T, row.names = 1, check.names = FALSE)
rpkm

for(i in 1:nrow(rpkm)) {

select <- rpkm[c(i),] 
select

title <- row.names(select)
title

#aql <- melt(select, id.vars = c("AGI"))
aql <- melt(as.matrix(select))
aql

#perform pairwise.t.test
ttest_results <- with(aql, pairwise.t.test(value, interaction(Var1, Var2)))
# Get p-values in a dataframe
write.table(ttest_results$p.value, file="output.csv", sep="\t", quote = F,append=TRUE)
#write.table(data.frame(fname=filename[i],mean=mean),file="output.csv",append=TRUE)


# get data summary
tgc <- summarySE(aql, measurevar="value", groupvars=c( "Var2","Var1"))
tgc

library(Rmisc)


# Visualize
PLOT <- ggplot(tgc, aes(x=Var2, y=value, fill=Var2)) + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=value-se, ymax=value+se),
                width=.2,                    # Width of the error bars
                position=position_dodge(.9))+
  scale_fill_brewer(palette="Set1") +
  #scale_y_continuous(expand=c(0,0), limits = c(0, max(aql$value)), breaks = seq(0, max(aql$value), by = 100) ) +
  #scale_y_continuous(expand=c(0,0), limits = c(0, 1200), breaks = seq(0,1200, by = 400) ) +
  scale_y_continuous(expand=c(0,0), limits = c(0, as.numeric(args[2])),breaks = seq(0, as.numeric(args[2]), by = as.numeric(args[3])))+
  ggtitle(title)+
  theme(legend.position="none")+
  labs(y="Intensity",x="")+
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank())  +
  theme(
    axis.text=element_text(size=8, color = "black",family="Arial"),
    axis.title=element_text(size=8,face="bold", color = "black"),
    plot.title = element_text(color="black", size=10, face="bold.italic",hjust = 0.5,margin=margin(b = 5, unit = "pt")))+
  theme(axis.text.x = element_text(angle =45, hjust = 1.0, vjust = 1.0,color = "black" ))+
  theme(axis.line = element_line(size = 0.4, color = "black"),axis.ticks = element_line(colour = "black", size = 0.4))+
  theme(axis.ticks.length = unit(0.04, "cm"))+
  theme(plot.margin=unit(c(0.1,0.1,0.1,0.4),"mm"))+
  theme(axis.title.y = element_text(margin = margin(t = 0, r = 2, b = 0, l = 0)))+
  theme(axis.title.x = element_text(margin = margin(t = 0, r = 0, b = 2, l = 0)))



ggsave(PLOT , file=paste0("PLOT_", title,".png"), units="in", family="Arial",  width=1.2, height=2.5, dpi = 300,  pointsize = 9)



}

