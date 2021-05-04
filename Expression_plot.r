expression_person <- read.table("oncogene_list_persponal.csv",header = T)

oncogene1 <- normcount[c("MYC","EGF","TGFA","CTNNB1","MET","NRAS",'HRAS','E2F1','CCND1','YAP1','BIRC2','EIF5A2','EGFR'),]

a <- ggplot(data = expression_person, aes(x = name, y = MET, color= group)) + 
  geom_point(data = expression_person, aes(x = name, y = MET, color= group)) + 
  geom_line(data = expression_person,aes(x = name, y = MET, group = group)) +
  scale_x_discrete(limits=c('M_p1_200422',
                            'M_p2_200422',
                            'M_p3_200422',
                            'M_p2_200129',
                            'M_p8_200129',
                            'M_p3_190701',
                            'M_p5_190701',
                            'M_p11_190701',
                            'M_p3_190923',
                            'M_p7_190923',
                            'P_p1_190425',
                            'P_p4_190425',
                            'P_p7_190425',
                            'P_p12_190425',
                            'P_p3_181015',
                            'P_p6_181015',
                            'P_p8_181015')) +
  theme(plot.title = element_text(hjust=0.5)) + 
  theme(panel.background = element_blank()) +
  theme_classic() + 
  xlab("") + 
  ylab("Normalized count") + 
  theme(axis.text = element_text(angle = 45, hjust = 1, size = 7)) +
  theme(legend.position = "top") + 
  scale_color_discrete(labels = c("MD_200422", "MD_200129","MD_190701","PD_190923","PD_190425","PD_181015")) +
  theme(legend.title=element_blank()) + 
  ggtitle("MET") + 
  theme(plot.title = element_text(hjust = 0.5))  +
  theme(legend.text = element_text(color = "black", size = 5, face = "bold"))

b <- ggplot(data = expression_person, aes(x = name, y = NRAS, color= group)) + BIRC2
  geom_point(data = expression_person, aes(x = name, y = NRAS, color= group)) + 
  geom_line(data = expression_person,aes(x = name, y = NRAS, group = group)) +
  scale_x_discrete(limits=c('M_p1_200422',
                            'M_p2_200422',
                            'M_p3_200422',
                            'M_p2_200129',
                            'M_p8_200129',
                            'M_p3_190701',
                            'M_p5_190701',
                            'M_p11_190701',
                            'M_p3_190923',
                            'M_p7_190923',
                            'P_p1_190425',
                            'P_p4_190425',
                            'P_p7_190425',
                            'P_p12_190425',
                            'P_p3_181015',
                            'P_p6_181015',
                            'P_p8_181015')) +
  theme(plot.title = element_text(hjust=0.5)) + 
  theme(panel.background = element_blank()) +
  theme_classic() + 
  xlab("") + 
  ylab("Normalized count") + 
  theme(axis.text = element_text(angle = 45, hjust = 1, size = 7)) +
  theme(legend.position = "top") + 
  scale_color_discrete(labels = c("MD_200422", "MD_200129","MD_190701","PD_190923","PD_190425","PD_181015")) +
  theme(legend.title=element_blank()) + 
  ggtitle("NRAS") + 
  theme(plot.title = element_text(hjust = 0.5))  +
  theme(legend.text = element_text(color = "black", size = 5, face = "bold"))

c <- ggplot(data = expression_person, aes(x = name, y = HRAS, color= group)) + 
  geom_point(data = expression_person, aes(x = name, y = HRAS, color= group)) + 
  geom_line(data = expression_person,aes(x = name, y = HRAS, group = group)) +
  scale_x_discrete(limits=c('M_p1_200422',
                            'M_p2_200422',
                            'M_p3_200422',
                            'M_p2_200129',
                            'M_p8_200129',
                            'M_p3_190701',
                            'M_p5_190701',
                            'M_p11_190701',
                            'M_p3_190923',
                            'M_p7_190923',
                            'P_p1_190425',
                            'P_p4_190425',
                            'P_p7_190425',
                            'P_p12_190425',
                            'P_p3_181015',
                            'P_p6_181015',
                            'P_p8_181015')) +
  theme(plot.title = element_text(hjust=0.5)) + 
  theme(panel.background = element_blank()) +
  theme_classic() + 
  xlab("") + 
  ylab("Normalized count") + 
  theme(axis.text = element_text(angle = 45, hjust = 1, size = 7)) +
  theme(legend.position = "top") + 
  scale_color_discrete(labels = c("MD_200422", "MD_200129","MD_190701","PD_190923","PD_190425","PD_181015")) +
  theme(legend.title=element_blank()) + 
  ggtitle("HRAS") + 
  theme(plot.title = element_text(hjust = 0.5))  +
  theme(legend.text = element_text(color = "black", size = 5, face = "bold"))

d <- ggplot(data = expression_person, aes(x = name, y = E2F1, color= group)) + 
  geom_point(data = expression_person, aes(x = name, y = E2F1, color= group)) + 
  geom_line(data = expression_person,aes(x = name, y = E2F1, group = group)) +
  scale_x_discrete(limits=c('M_p1_200422',
                            'M_p2_200422',
                            'M_p3_200422',
                            'M_p2_200129',
                            'M_p8_200129',
                            'M_p3_190701',
                            'M_p5_190701',
                            'M_p11_190701',
                            'M_p3_190923',
                            'M_p7_190923',
                            'P_p1_190425',
                            'P_p4_190425',
                            'P_p7_190425',
                            'P_p12_190425',
                            'P_p3_181015',
                            'P_p6_181015',
                            'P_p8_181015')) +
  theme(plot.title = element_text(hjust=0.5)) + 
  theme(panel.background = element_blank()) +
  theme_classic() + 
  xlab("") + 
  ylab("Normalized count") + 
  theme(axis.text = element_text(angle = 45, hjust = 1, size = 7)) +
  theme(legend.position = "top") + 
  scale_color_discrete(labels = c("MD_200422", "MD_200129","MD_190701","PD_190923","PD_190425","PD_181015")) +
  theme(legend.title=element_blank()) + 
  ggtitle("E2F1") + 
  theme(plot.title = element_text(hjust = 0.5))  +
  theme(legend.text = element_text(color = "black", size = 5, face = "bold"))

e <- ggplot(data = expression_person, aes(x = name, y = CCND1, color= group)) + 
  geom_point(data = expression_person, aes(x = name, y = CCND1, color= group)) + 
  geom_line(data = expression_person,aes(x = name, y = CCND1, group = group)) +
  scale_x_discrete(limits=c('M_p1_200422',
                            'M_p2_200422',
                            'M_p3_200422',
                            'M_p2_200129',
                            'M_p8_200129',
                            'M_p3_190701',
                            'M_p5_190701',
                            'M_p11_190701',
                            'M_p3_190923',
                            'M_p7_190923',
                            'P_p1_190425',
                            'P_p4_190425',
                            'P_p7_190425',
                            'P_p12_190425',
                            'P_p3_181015',
                            'P_p6_181015',
                            'P_p8_181015')) +
  theme(plot.title = element_text(hjust=0.5)) + 
  theme(panel.background = element_blank()) +
  theme_classic() + 
  xlab("") + 
  ylab("Normalized count") + 
  theme(axis.text = element_text(angle = 45, hjust = 1, size = 7)) +
  theme(legend.position = "top") + 
  scale_color_discrete(labels = c("MD_200422", "MD_200129","MD_190701","PD_190923","PD_190425","PD_181015")) +
  theme(legend.title=element_blank()) + 
  ggtitle("CCND1") + 
  theme(plot.title = element_text(hjust = 0.5))  +
  theme(legend.text = element_text(color = "black", size = 5, face = "bold"))


pdf("MET,NRAS,HRAS,E2F1_p.pdf")
grid.arrange(a,b,c,d, nrow = 2, ncol=2)
dev.off()
