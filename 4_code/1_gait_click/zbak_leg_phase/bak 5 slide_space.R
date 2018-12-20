library(data.table)
library(ggplot2)
WORK_DICTIONARY <- "/Users/mofan/Documents/master_thesis/"
setwd(WORK_DICTIONARY)
source("4_code/function_summarySE.R")

analysis = "right"

slide_sp1 <- read.csv('4_results/interaction_feature/slide/Csv_000_dataintac/Sp1.csv')
slide_sp2 <- read.csv('4_results/interaction_feature/slide/Csv_000_dataintac/Sp2.csv')
slide_sp3 <- read.csv('4_results/interaction_feature/slide/Csv_000_dataintac/Sp3.csv')
slide_sp4 <- read.csv('4_results/interaction_feature/slide/Csv_000_dataintac/Sp4.csv')
slide_sp5 <- read.csv('4_results/interaction_feature/slide/Csv_000_dataintac/Sp5.csv')

slide1 <- slide_sp1[which(slide_sp1$mark == analysis),-1]
slide2 <- slide_sp2[which(slide_sp2$mark == analysis),-1]
slide3 <- slide_sp3[which(slide_sp3$mark == analysis),-1]
slide4 <- slide_sp4[which(slide_sp4$mark == analysis),-1]
slide5 <- slide_sp5[which(slide_sp5$mark == analysis),-1]
slide1$sp='Sp1'; slide2$sp='Sp2'; slide3$sp='Sp3'; slide4$sp='Sp4'; slide5$sp='Sp5'

slide = rbind(rbind(rbind(rbind(slide1,slide2),slide3),slide4),slide5)

p <- ggplot(slide, aes(x=x, y=-y,group=sp, colour = sp)) +
        #geom_point(size = 0.1) +
        geom_smooth(method = 'loess',size = 0.5) +
        xlim(20,350) +
        ylim(-350,-20)

png(paste0("4_results/interaction_feature/space/","slide_space_",analysis,".png"),width = 2200,height = 1900,res = 300)
print(p)
dev.off()
