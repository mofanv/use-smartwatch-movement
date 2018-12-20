WD = '/Users/fanvincentmo/Documents/master_thesis'
setwd(WD)

gait_feature_sta <- read.csv('4_results/finial_gait_feature/step_feature_1_look.csv', header = FALSE)
gait_feature_touch <- read.csv('4_results/finial_gait_feature/step_feature_2_touch.csv', header = FALSE)
gait_feature_wrist <- read.csv('4_results/finial_gait_feature/step_feature_4_wrist.csv', header = FALSE)

namesTable = c('iperson','isp','dis','stepnum','steplong')

names(gait_feature_sta) <- namesTable
names(gait_feature_touch) <- namesTable
names(gait_feature_wrist) <- namesTable

gait_feature_wrist <- gait_feature_wrist[-which(is.na(gait_feature_wrist$stepnum)),]
###############
# test
mean(gait_feature_sta[gait_feature_sta$isp == 2,]$steplong)
mean(gait_feature_sta[gait_feature_sta$isp == 3,]$steplong)
mean(gait_feature_sta[gait_feature_sta$isp == 4,]$steplong)
mean(gait_feature_sta[gait_feature_sta$isp == 5,]$steplong)
#####
gait_feature_sta$mark = 'sta'
gait_feature_touch$mark = 'touch'
gait_feature_wrist$mark = 'wrist'

gait_feature = rbind(rbind(gait_feature_sta,gait_feature_touch),gait_feature_wrist)
gait_feature_sp2 = gait_feature[gait_feature$isp=='2',]
gait_feature_sp3 = gait_feature[gait_feature$isp=='3',]
gait_feature_sp4 = gait_feature[gait_feature$isp=='4',]
gait_feature_sp5 = gait_feature[gait_feature$isp=='5',]
gait_feature$isp = as.factor(gait_feature$isp)
gait_feature$mark = as.factor(gait_feature$mark)

###########################################
## analysis
source("4_code/function_summarySE.R")
library(ggplot2)
library(plyr)

for (control in 1){
        if(control==1){vectorX = gait_feature$isp; control_str='movement'}
        if(control==2){vectorX = gait_feature$mark; control_str='interaction'}
        
        gait_feature$mark = as.factor(gait_feature$mark)
        nameF <- names(gait_feature$isp)
        dat <- data.frame(vectorY=gait_feature$steplong, vectorX=vectorX)
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
        t_temp <- name_rows(t_temp)[,-c(1:3)]
        t_pvalue <- ''
        for(i in 1:nrow(t_temp)){
                if(i == 3){ enter = ')\n' }else{enter = ') '}
                if(t_temp[i,1] <= 0.05) {mark = '*'}else{mark = ''}
                t_pvalue <- paste0(t_pvalue, '(', t_temp[i,2], ': ', round(t_temp[i,1],3), mark, enter)
        }
        
        #draw error bar figure
        resultsSE <- summarySE(data=dat, measurevar="vectorY", groupvars="vectorX")
        print(resultsSE)
        
        png(paste0("4_results/finial_gait_feature/Fig_AOV_step/0paper_",control_str, '_steplong',".png"), width = 1200, height = 800, res = 300)
        
        if(control_str == 'movement'){
                nameP = 'Step length (m)'
                p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                        geom_point() +
                        geom_line() +
                        geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.1) +
                        geom_point(size=3, shape=21, fill="white") +
                        scale_x_discrete(name=paste0("Movement"),
                                         limits=c('2','3','4','5'),
                                         labels=c('2'='Strolling','3'='Walking',
                                                  '4'='Rushing','5'='Jogging')) +
                        scale_y_continuous(name=nameP)
        }
        if(control_str == 'interaction'){
                nameP = 'Step length (m)'
                p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                        geom_point() +
                        geom_line() +
                        geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.1) +
                        geom_point(size=3, shape=21, fill="white") +
                        scale_x_discrete(name=paste0("Interaction"),
                                         limits=c('2','3','4'),
                                         labels=c('2'='Strolling','3'='Walking',
                                                  '4'='Rushing','5'='Jogging')) +
                        scale_y_continuous(name=nameP)
        }
        
        print(p)
        dev.off()
        ###########################################
}
