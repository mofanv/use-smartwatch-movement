library(data.table)
library(ggplot2)
library(ggsignif)

WORK_DICTIONARY <- "/Users/fanvincentmo/Documents/master_thesis/"
setwd(WORK_DICTIONARY)
source("4_code/function_summarySE.R")
load("/Users/fanvincentmo/Documents/master_thesis/4_code/lib_tukey_test_plot/tukeySignificanceLettersFunction.Rdata")

##########################################
# read click feature data
fetsp1 <- read.csv("4_results/interaction_feature/click/feature_click_Sp1.csv")
fetsp2 <- read.csv("4_results/interaction_feature/click/feature_click_Sp2.csv")
fetsp3 <- read.csv("4_results/interaction_feature/click/feature_click_Sp3.csv")
fetsp4 <- read.csv("4_results/interaction_feature/click/feature_click_Sp4.csv")
fetsp5 <- read.csv("4_results/interaction_feature/click/feature_click_Sp5.csv")

##  transfer the unit
##  cm = px*3.4798 / 360 
fetsp1[,5:22] = fetsp1[,5:22] * 3.4798 / 360
fetsp2[,5:22] = fetsp2[,5:22] * 3.4798 / 360
fetsp3[,5:22] = fetsp3[,5:22] * 3.4798 / 360
fetsp4[,5:22] = fetsp4[,5:22] * 3.4798 / 360
fetsp5[,5:22] = fetsp5[,5:22] * 3.4798 / 360

fetsp1$Sp <- "sp1"
fetsp2$Sp <- "sp2"
fetsp3$Sp <- "sp3"
fetsp4$Sp <- "sp4"
fetsp5$Sp <- "sp5"

fetclick <- rbind(rbind(rbind(rbind(fetsp1,fetsp2),fetsp3),fetsp4),fetsp5)
names(fetclick)[23] <- 'error_rate'
###########################################


###########################################
# analysis
for(i in 3:23){
        # anova analysis
        nameF <- names(fetclick)[i]
        dat <- data.frame(vectorY=fetclick[,i], vectorX=fetclick[,24])
        fit <- aov(vectorY ~ vectorX, dat)
        print(nameF)
        #print(summary(fit))
        Fvalue <- round(summary(fit)[[1]][[4]][1],3)
        Prvalue <- round(summary(fit)[[1]][[5]][1],3)
        df <- paste0('(',summary(fit)[[1]][[1]][1], ',',summary(fit)[[1]][[1]][2],')')
        
        if(as.numeric(Prvalue) <= 0.05) {markF = '*'}else{markF = ''}
        Prvalue <- paste0(Prvalue, markF)
        
        # TukeyHSD
        t_temp <- as.data.frame(TukeyHSD(fit)$vectorX)
        t_temp <- plyr::name_rows(t_temp)[,-c(1:3)]
        t_pvalue <- ''
        for(i in 1:nrow(t_temp)){
                if(i == 4 || i == 7){ enter = ')\n' }else{enter = ') '}
                if(t_temp[i,1] <= 0.05) {mark = '*'}else{mark = ''}
                t_pvalue <- paste0(t_pvalue, '(', t_temp[i,2], ': ', round(t_temp[i,1],3), mark, enter)
        }
        
        #draw error bar figure
        resultsSE <- summarySE(data=dat, measurevar="vectorY", groupvars="vectorX")
        print(resultsSE)
        
        #png(paste0("4_results/interaction_feature/click/Fig_AOV_feature/", nameF,".png"), width = 1800, height = 1200, res = 300)
        p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                geom_point() +
                geom_line() +
                geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.1) +
                scale_x_discrete(name=paste0("Movement (F",df,"=",Fvalue,", p=",Prvalue,")\n",t_pvalue)) +
                scale_y_continuous(name="Value") +
                ggtitle(nameF)
        #print(p)
        #dev.off()
        
        if(nameF == 'error_rate'){nameP = 'Error rate'}
        if(nameF == 'slid_dist_avg'){nameP = 'Swiping distance (cm)'}
        if(nameF == 'slid_off_dist_avg'){nameP = 'Deviation of Tapping (cm)'}
        if(nameF == 'off_dist_avg'){nameP = 'Departure distance (cm)'}
        if(nameF == 'press_t_avg'){nameP = 'Press time (ms)'}
        
        signMark = c('','','','','')
        for(i in 1:nrow(t_temp)){
                word1 = strsplit(t_temp$.rownames[i],'-')[[1]][1]
                word2 = strsplit(t_temp$.rownames[i],'-')[[1]][2]
                if(word1 == 'sp1'){loc1 = 1}
                if(word1 == 'sp2'){loc1 = 2}
                if(word1 == 'sp3'){loc1 = 3}
                if(word1 == 'sp4'){loc1 = 4}
                if(word1 == 'sp5'){loc1 = 5}
                if(word2 == 'sp1'){loc2 = 1}
                if(word2 == 'sp2'){loc2 = 2}
                if(word2 == 'sp3'){loc2 = 3}
                if(word2 == 'sp4'){loc2 = 4}
                if(word2 == 'sp5'){loc2 = 5}
                if(0.01 <= t_temp$`p adj`[i] & t_temp$`p adj`[i] < 0.05){
                        signMark[loc1] = paste0(signMark[loc1],"(",as.character(loc2),")")
                        signMark[loc2] = paste0(signMark[loc2],"(",as.character(loc1),")")
                }else if (0.001 <= t_temp$`p adj`[i] & t_temp$`p adj`[i]  < 0.01){
                        signMark[loc1] = paste0(signMark[loc1],"[",as.character(loc2),"]")
                        signMark[loc2] = paste0(signMark[loc2],"[",as.character(loc1),"]")
                }else if (t_temp$`p adj`[i] < 0.001){
                        signMark[loc1] = paste0(signMark[loc1],"{",as.character(loc2),"}")
                        signMark[loc2] = paste0(signMark[loc2],"{",as.character(loc1),"}")
                }
        }
        
        png(paste0("4_results/interaction_feature/click/Fig_AOV_feature/0paper_", nameF,".png"), width = 1200, height = 800, res = 300)
        p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY)) +
                geom_line( group=1) +
                geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.1) +
                geom_point(size=3, shape=21, fill="white") +
                scale_x_discrete(name=paste0("Movement"),
                                 limits=c('sp1','sp2','sp3','sp4','sp5'),
                                 labels=c('sp1'='Standing\n1','sp2'='Strolling\n2','sp3'='Walking\n3',
                                          'sp4'='Rushing\n4','sp5'='Jogging\n5')) +
                geom_text(aes(x=c(1,2,3,4,5), y=vectorY+1.7*ci,label=signMark),
                          size = 2.8, position=position_dodge(.5))
        if(nameF == 'error_rate'){
                p = p + scale_y_continuous(name=nameP, labels=percent)
        }else{
                p = p + scale_y_continuous(name=nameP)
        }
        
        print(p)
        dev.off()
        
}

###########################################