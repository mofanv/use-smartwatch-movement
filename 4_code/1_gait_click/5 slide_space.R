library(data.table)
library(ggplot2)
library(tidyr)
WORK_DICTIONARY <- "/Users/mofan/Documents/master_thesis/"
setwd(WORK_DICTIONARY)
source("4_code/function_summarySE.R")


for(analysis in c('left','right')){
        ##########################################
        # read slide feature data
        fetsp1_left <- read.csv("4_results/interaction_feature/slide/Csv_feature/featureEND_slide_Sp1_left.csv")
        fetsp2_left <- read.csv("4_results/interaction_feature/slide/Csv_feature/featureEND_slide_Sp2_left.csv")
        fetsp3_left <- read.csv("4_results/interaction_feature/slide/Csv_feature/featureEND_slide_Sp3_left.csv")
        fetsp4_left <- read.csv("4_results/interaction_feature/slide/Csv_feature/featureEND_slide_Sp4_left.csv")
        fetsp5_left <- read.csv("4_results/interaction_feature/slide/Csv_feature/featureEND_slide_Sp5_left.csv")
        fetsp1_right <- read.csv("4_results/interaction_feature/slide/Csv_feature/featureEND_slide_Sp1_right.csv")
        fetsp2_right <- read.csv("4_results/interaction_feature/slide/Csv_feature/featureEND_slide_Sp2_right.csv")
        fetsp3_right <- read.csv("4_results/interaction_feature/slide/Csv_feature/featureEND_slide_Sp3_right.csv")
        fetsp4_right <- read.csv("4_results/interaction_feature/slide/Csv_feature/featureEND_slide_Sp4_right.csv")
        fetsp5_right <- read.csv("4_results/interaction_feature/slide/Csv_feature/featureEND_slide_Sp5_right.csv")
        
        fetsp1_left$Sp <- "Sp1"; fetsp2_left$Sp <- "Sp2"; fetsp3_left$Sp <- "Sp3"; fetsp4_left$Sp <- "Sp4"; fetsp5_left$Sp <- "Sp5"
        fetsp1_left$Dr <- "left"; fetsp2_left$Dr <- "left"; fetsp3_left$Dr <- "left"; fetsp4_left$Dr <- "left"; fetsp5_left$Dr <- "left"
        fetsp1_right$Sp <- "Sp1"; fetsp2_right$Sp <- "Sp2"; fetsp3_right$Sp <- "Sp3"; fetsp4_right$Sp <- "Sp4"; fetsp5_right$Sp <- "Sp5"
        fetsp1_right$Dr <- "right"; fetsp2_right$Dr <- "right"; fetsp3_right$Dr <- "right"; fetsp4_right$Dr <- "right"; fetsp5_right$Dr <- "right"
        
        #######################
        #proprecess
        fetslide_left <- rbind(rbind(rbind(rbind(fetsp1_left,fetsp2_left),fetsp3_left),fetsp4_left),fetsp5_left)
        fetslide_right <- rbind(rbind(rbind(rbind(fetsp1_right,fetsp2_right),fetsp3_right),fetsp4_right),fetsp5_right)
        fetslide <- rbind(fetslide_left, fetslide_right)
        fetslide <- fetslide[-which(is.na(fetslide$meanCur)),]
        
        index = grep(analysis, fetslide$Dr)
        fetslide = fetslide[index,]
        fetslide = fetslide[,-1]
        ###########################
        # calculate result (mean and ci)
        resultLIST = list()
        for(i in 1:(ncol(fetslide)-5)){
                namesF = names(fetslide)[i]
                resultSE = summarySE(fetslide, measurevar = namesF, groupvars = 'Sp')
                resultLIST[[i]] = resultSE
                names(resultLIST)[i] = namesF
        }
        result0 = resultLIST
        datALL = data.frame()
        for(sp in 1:5){
                stX = result0$stX$stX[sp]; stY = result0$stY$stY[sp]
                stX_ci = result0$stX$ci[sp]; stY_ci = result0$stY$ci[sp]
                
                endX = result0$endX$endX[sp]; endY = result0$endY$endY[sp]
                endX_ci = result0$endX$ci[sp]; endY_ci = result0$endY$ci[sp]
                
                x = c(stX, stX-stX_ci, stX+stX_ci, endX, endX-endX_ci, endX+endX_ci)
                y = c(stY, stY-stY_ci, stY+stY_ci, endY, endY-endY_ci, endY+endY_ci)
                group = c(1,2,3,1,2,3)*1000+(sp*10000)
                dat = data.frame(x = x, y = y, no=group)
                dat$no <- as.factor(as.character(dat$no))
                dat$kind <- c("slide",'ci1','ci2',"slide",'ci1','ci2')
                dat$sp <- paste0('Sp',sp)
                datALL = rbind(datALL,dat)
        }
        
        # circle
        circleFun <- function(center = c(180,180),diameter = 320, npoints = 100){
                r = diameter / 2
                tt <- seq(0,2*pi,length.out = npoints)
                xx <- center[1] + r * cos(tt)
                yy <- center[2] + r * sin(tt)
                return(data.frame(x = xx, y = yy))
        }
        dat_cycle <- circleFun()
        dat_cycle_0 <- dat_cycle
        dat_cycle$no <- 1:100
        dat_cycle_0$no <- c(100,1:99)
        dat_cycle <- rbind(dat_cycle,dat_cycle_0)
        dat_cycle$kind <- "edge"
        dat_cycle$sp <- "all"
        dat_intac <- rbind(dat_cycle,datALL)
        dat_intac <- dat_intac[rev(order(dat_intac$kind)),]
        
        
        if(analysis=='left'){analysis='Left'}
        if(analysis=='right'){analysis='Right'}
        
        # simplization
        dat_intac <- dat_intac[!(dat_intac$kind == 'ci1' | dat_intac$kind == 'ci2'),]
        
        p <- ggplot(dat_intac, aes(x=x,y=y,group=no)) +
                geom_line(aes(linetype=kind, size=kind, colour=sp)) +
                #geom_line() +
                scale_linetype_manual(values=c(1,1)) +  # (ci1, ci2, edge, slide)
                scale_size_manual(values=c(0.2,0.8)) +
                scale_colour_manual(values=c('blue','green','orange','pink','red','black'),                
                                    name="Movement",
                                    limits=c('Sp1','Sp2','Sp3','Sp4','Sp5','all'),
                                    labels=c('Sp1'='Stand','Sp2'='Strolling','Sp3'='Walking',
                                             'Sp4'='Rushing','Sp5'='Jogging','all'=' ')) + #(sp1,sp2,sp3,sp4,sp5,edge)
                guides(linetype=FALSE, size=FALSE) +
                xlim(20,350) +
                ylim(250,110) +
                ggtitle(analysis)
        
        png(paste0("4_results/interaction_feature/space/","slide_space_",analysis,".png"),width = 2000,height = 1000,res = 300)
        print(p)
        dev.off()
        
}
