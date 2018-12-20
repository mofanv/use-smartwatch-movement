library(data.table)
library(ggplot2)
WORK_DICTIONARY <- "/Users/fanvincentmo/Documents/master_thesis/"
setwd(WORK_DICTIONARY)
source("4_code/function_summarySE.R")

##########################################
# read slide feature data
fetsp1_left <- read.csv("4_results/interaction_feature/slide/Csv_feature/feature_slide_Sp1_left.csv")
fetsp2_left <- read.csv("4_results/interaction_feature/slide/Csv_feature/feature_slide_Sp2_left.csv")
fetsp3_left <- read.csv("4_results/interaction_feature/slide/Csv_feature/feature_slide_Sp3_left.csv")
fetsp4_left <- read.csv("4_results/interaction_feature/slide/Csv_feature/feature_slide_Sp4_left.csv")
fetsp5_left <- read.csv("4_results/interaction_feature/slide/Csv_feature/feature_slide_Sp5_left.csv")
fetsp1_right <- read.csv("4_results/interaction_feature/slide/Csv_feature/feature_slide_Sp1_right.csv")
fetsp2_right <- read.csv("4_results/interaction_feature/slide/Csv_feature/feature_slide_Sp2_right.csv")
fetsp3_right <- read.csv("4_results/interaction_feature/slide/Csv_feature/feature_slide_Sp3_right.csv")
fetsp4_right <- read.csv("4_results/interaction_feature/slide/Csv_feature/feature_slide_Sp4_right.csv")
fetsp5_right <- read.csv("4_results/interaction_feature/slide/Csv_feature/feature_slide_Sp5_right.csv")

fetsp1_left$Sp <- "Sp1"; fetsp2_left$Sp <- "Sp2"; fetsp3_left$Sp <- "Sp3"; fetsp4_left$Sp <- "Sp4"; fetsp5_left$Sp <- "Sp5"
fetsp1_left$Dr <- "left"; fetsp2_left$Dr <- "left"; fetsp3_left$Dr <- "left"; fetsp4_left$Dr <- "left"; fetsp5_left$Dr <- "left"
fetsp1_right$Sp <- "Sp1"; fetsp2_right$Sp <- "Sp2"; fetsp3_right$Sp <- "Sp3"; fetsp4_right$Sp <- "Sp4"; fetsp5_right$Sp <- "Sp5"
fetsp1_right$Dr <- "right"; fetsp2_right$Dr <- "right"; fetsp3_right$Dr <- "right"; fetsp4_right$Dr <- "right"; fetsp5_right$Dr <- "right"

fetslide_left <- rbind(rbind(rbind(rbind(fetsp1_left,fetsp2_left),fetsp3_left),fetsp4_left),fetsp5_left)
fetslide_right <- rbind(rbind(rbind(rbind(fetsp1_right,fetsp2_right),fetsp3_right),fetsp4_right),fetsp5_right)
fetslide <- rbind(fetslide_left, fetslide_right)
###########################################

fetslide <- fetslide[-which(is.na(fetslide$meanCur)),]
fetslide[,c(2,3,5,6)] = fetslide[,c(2,3,5,6)] * 3.4798 / 360

# delete NA value
###########################################
# analysis
for(i in 2:13){
        # anova analysis
        nameF <- names(fetslide)[i]
        dat <- data.frame(vectorY=fetslide[,i], vectorX=fetslide[,18])
        fit <- aov(vectorY ~ vectorX, dat)
        print(nameF)
        #print(summary(fit))
        Fvalue <- round(summary(fit)[[1]][[4]][1],3)
        Prvalue <- round(summary(fit)[[1]][[5]][1],3)
        df <- paste0('(',summary(fit)[[1]][[1]][1], ',',summary(fit)[[1]][[1]][2],')')
        
        if(as.numeric(Prvalue) <= 0.05) {markF = '*'}else{markF = ''}
        Prvalue <- paste0(Prvalue, markF)
        
        #draw error bar figure
        resultsSE <- summarySE(data=dat, measurevar="vectorY", groupvars="vectorX")
        print(resultsSE)
        
        png(paste0("4_results/interaction_feature/slide/Fig_AOV_feature/zzz_slide", "_", nameF,".png"), width = 800, height = 800, res = 300)
        p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                geom_point() +
                geom_line() +
                geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.05) +
                scale_x_discrete(name=paste0("Direction of slide\n(F",df,"=",Fvalue,", p=",Prvalue,")")) +
                scale_y_continuous(name="Value") +
                ggtitle(nameF)
        print(p)
        dev.off()
        
        nameP = nameF
        if(nameF == 'angle'){nameP = 'Angle (degree)'}
        if(nameF == 'disALL'){nameP = 'Displacement (cm)'}
        if(nameF == 'Dur'){nameP = 'Duration (ms)'}
        if(nameF == 'Dur'){nameP = 'Duration (ms)'}
        if(nameF == 'stX'){nameP = 'X-axis of beginning points (cm)'}
        if(nameF == 'stY'){nameP = 'Y-axis of beginning points (cm)'}
        if(nameF == 'travelDIS'){nameP = 'Travel distance (cm)'}
        if(nameF == 'S'){nameP = 'Smoothness'}
        if(nameF == 'meanCur'){nameP = 'Smoothness'}
        
        png(paste0("4_results/interaction_feature/slide/Fig_AOV_feature/0paper_zzz_slide", "_", nameF,".png"), width = 700, height = 700, res = 300)
        p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                geom_line() +
                geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.05) +
                geom_point(size=3, shape=21, fill="white") +
                scale_x_discrete(name=paste0("Direction of swiping"),
                                 limits=c('left','right'),
                                 labels=c('left'='Left','right'='Right'))+
                scale_y_continuous(name=nameP)
        print(p)
        dev.off()
}
###########################################
