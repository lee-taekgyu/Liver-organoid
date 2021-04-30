library(ggplot2)
setwd("/home/pickyu2/Bioinformatics/Methylation/Liver_organoid/Mean_group/")

PD4_Tendency <- read.table("PD4_Minus_group.xls", sep = '\t', header = F)
PD4_TE_value <- strsplit(PD4_Tendency$V8, ';')
PD4_TL_value <- strsplit(PD4_Tendency$V9, ';')

PD4_TE_value <- unlist(PD4_TE_value)
PD4_TL_value <- unlist(PD4_TL_value)


PD4_TE_value <- as.double(PD4_TE_value)
PD4_TL_value <- as.double(PD4_TL_value)


PD4_TE_value <- na.omit(PD4_TE_value)
PD4_TL_value <- na.omit(PD4_TL_value)

PD4_data <- cbind(PD4_TE_value, PD4_TL_value)
PD4_data <- as.data.frame(PD4_data)

label <- c('T-E',  'T-L')
png(filename = 'PD4_Minus_group.png', width=500, height=300, unit='px', bg='white' )
ggplot(data=PD4_data) + 
  ggtitle("Methylation Tendency \n PD4") + 
  theme_classic() + 
  scale_color_discrete(labels=c('T-E','T-L')) + 
  theme(plot.title = element_text(hjust=0.5), panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + 
  xlab("Substitution") + 
  theme(legend.title = element_blank(), legend.position = c(0.1, 0.85)) + 
  theme(legend.key = element_rect(fill = 'white')) + 
  geom_density(mapping=aes(x=PD4_TE_value, colour = 'PD4_TE_value')) +
  geom_density(mapping=aes(x=PD4_TL_value, colour = 'PD4_TL_value')) 

dev.off() 

