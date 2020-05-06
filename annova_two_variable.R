
####################################################################################################
#
#
#
#           SCript perform two way annova test ( Var and treatment are two variable)
#
#Gene  value  time  var treatment
#Nitab4.5_0003540g0010.1  71.12 2HU_1   L8   Control
#Nitab4.5_0003540g0010.1  47.90 2HU_2   L8   Control
#Nitab4.5_0003540g0010.1 126.00 2HT_1   L8 Treatment
#Nitab4.5_0003540g0010.1 153.00 2HT_2   L8 Treatment
#Nitab4.5_0003540g0010.1  25.00 2HU_1 TN90   Control
#Nitab4.5_0003540g0010.1  20.00 2HU_2 TN90   Control
#Nitab4.5_0003540g0010.1 120.00 2HT_1 TN90 Treatment
#Nitab4.5_0003540g0010.1 123.00 2HT_2 TN90 Treatment
#
######################################################################################################

#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)< 1) {
  stop("At least one argument must be supplied (input file).\n USES : Rscript data_file y_axis_limit y_axis_break image_width image_height plot_title significance_letter_position", call.=FALSE)
} else if (length(args)==1) {
  # default output file
  args[2] = "out.png"
}

#load required libraries
library(ggplot2)
library(extrafont)
#font_import() # only one time required when first time use the library extrafont
#y
fonts() 
loadfonts()
library(lsmeans)
library(multcompView)
library(multcomp)


#load data
#rpkm <- read.delim("2h",header=T,  check.names = FALSE)
rpkm <- read.delim(args[1],header=T, check.names = FALSE)
rpkm
   
library(Rmisc) 
# get data summary
tgc <- summarySE(rpkm, measurevar="value", groupvars=c( "var","treatment"))
tgc


#Define model 
model = lm(value ~ var + treatment + var : treatment, data = rpkm)

#Group separations by lsmeans in table format
#Here we’ll create an object of the lsmeans output called marginal.  
#Then we’ll pass this object to the cld function to create a compact letter display.

marginal = lsmeans(model,
                   pairwise ~ var : treatment,
                   adjust="tukey") ### Tukey-adjusted comparisons

marginal$contrasts


sig.test <- cld(marginal[[1]],
    alpha=0.05,
    Letters=letters,      ### Use lower-case letters for .group
    adjust="tukey")       ### Tukey-adjusted comparisons 
sig.test

###  Remove spaces in .group 

sig.test$.group=gsub(" ", "", sig.test$.group)

tgc$sd

graph <- ggplot(sig.test, aes(x=var, y=lsmean, fill=treatment,label = .group))+
       geom_bar(colour="black",stat="identity",position=position_dodge(width = .9),size=.1,width=.5) + 
   geom_errorbar(aes(ymin = lsmean + tgc$sd, ymax = lsmean - tgc$sd),position = position_dodge(width=0.9), colour="black", width=0.32)+
 geom_text( aes( y=lsmean + tgc$sd + as.numeric(args[7])), color   = "black",
             position=position_dodge(width=0.9), size=4)+ 
   theme(plot.margin=unit(c(3,0.2,0.2,0.4),"mm"))+
   theme(legend.position=c(0.4, .9),legend.key.size = unit(4, 'lines'),legend.title=element_blank())+
   theme(axis.text=element_text(size=8),axis.title=element_text(size=8,face="plain"))+
   theme(legend.text = element_text(colour="black", size = 8, face = "plain", family = "Times"))+
   theme(axis.text.x = element_text(colour="black", size = 8, face = "plain", family = "Times",angle = 360, hjust = 0.6,vjust = 1))+
   theme(axis.text.y = element_text(colour="black", size = 8, face = "plain", family = "Times",angle = 360, vjust = 1))+
   theme(axis.title.y = element_text(colour="black", size = 8, face = "bold", family = "Times"))+
   theme(plot.title = element_text(color="black", size=8, face="bold",hjust = 0.5,margin=margin(b = 5, unit = "pt")))+
   theme(axis.title.x = element_text(colour="black", size = 8, face = "bold", family = "Times"))+
   theme(legend.position="top",legend.direction = "horizontal", legend.key.size = unit(4, 'lines'),legend.title=element_blank())+
   theme(panel.background = element_blank(),
         panel.grid.minor = element_blank(),
         #axis.ticks  = element_blank(),
         axis.line.y   = element_line(colour="black"),
         axis.line.x = element_line(colour="black"))+
   theme(axis.line.x = element_line(color="black", size = 0.3,colour = "black"),
         axis.line.y = element_line(color="black", size = .3,colour = "black"))+
   # Add some space around the edges  
   theme(plot.margin = unit(c(0.1,0.1,0.1,0.1), "cm"))+
   theme(
     panel.grid.major = element_blank(),
     panel.grid.minor = element_blank(),
     panel.background = element_blank())+
   theme(axis.text.x = element_text(angle = 360, hjust = 0.5, color = "black"))+
   #scale_fill_brewer(palette = "Set2")+
   #theme_bw() +
   theme(axis.line = element_line(colour = "black"),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         panel.border = element_blank(),
         panel.background = element_blank())+
   theme(axis.text=element_text(size=4, color = "black"),axis.title=element_text(size=4,face="bold", color = "black"))+
   theme(axis.text.x = element_text(angle = 360, hjust = 0.5, vjust = 0.5,color = "black",face="bold")) +
   labs(y="Expression (FPKM)",x="") +
   theme(axis.line = element_line(size = 0.2, color = "black"),axis.ticks = element_line(colour = "black", size = 0.2))+
   scale_fill_manual(values=c('#999999','#E69F00'),labels=c("Control", "Treatment"),guide=FALSE)+
   scale_y_continuous(expand=c(0,0), limits = c(0, as.numeric(args[2])),breaks = seq(0, as.numeric(args[2]), by = as.numeric(args[3])))+
   ggtitle(args[6])

ggsave(graph , file=paste0(args[1], ".png"), units="in", family="Times New Roman", width=as.numeric(args[4]), height=as.numeric(args[5]),  dpi = 600, pointsize = 2)
  
