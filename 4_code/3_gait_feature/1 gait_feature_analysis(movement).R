WD = '/Users/fanvincentmo/Documents/master_thesis'
setwd(WD)

gait_feature_sta <- read.csv('4_results/finial_gait_feature/gait_feature_1_look.csv', header = FALSE)
gait_feature_touch <- read.csv('4_results/finial_gait_feature/gait_feature_2_touch.csv', header = FALSE)
gait_feature_wrist <- read.csv('4_results/finial_gait_feature/gait_feature_4_wrist.csv', header = FALSE)

namesTable = c('iperson','isp','steptime','frequency',
               'rmsacc','ampvar','stepvar','stepreg','harmonicr','stepsym')

names(gait_feature_sta) <- namesTable
names(gait_feature_touch) <- namesTable
names(gait_feature_wrist) <- namesTable

gait_feature_sta$mark = 'sta'
gait_feature_touch$mark = 'touch'
gait_feature_wrist$mark = 'wrist'

gait_feature = rbind(rbind(gait_feature_sta,gait_feature_touch),gait_feature_wrist)
gait_feature_sta = gait_feature[gait_feature$mark=='sta',]
gait_feature_touch = gait_feature[gait_feature$mark=='touch',]
gait_feature_wrist = gait_feature[gait_feature$mark=='wrist',]

###########################################
## analysis
source("4_code/function_summarySE.R")
library(ggplot2)
library(plyr)

#for(INT in 1:3){
#        if(INT==1) {gait_feature = gait_feature_sta; INT_str = 'sta'}
#        if(INT==2) {gait_feature = gait_feature_touch; INT_str = 'touch'}
#        if(INT==3) {gait_feature = gait_feature_wrist; INT_str = 'wrist'}
        
        for(i in 3:10){
                # anova analysis
                gait_feature$isp = as.factor(gait_feature$isp)
                levels(gait_feature$isp) = c('sp2','sp3','sp4','sp5')
                nameF <- names(gait_feature)[i]
                dat <- data.frame(vectorY=gait_feature[,i], vectorX=gait_feature[,2])
                fit <- aov(vectorY ~ vectorX, dat)
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
                        if(i == 4 || i == 7){ enter = ')\n' }else{enter = ') '}
                        if(t_temp[i,1] <= 0.05) {mark = '*'}else{mark = ''}
                        t_pvalue <- paste0(t_pvalue, '(', t_temp[i,2], ': ', round(t_temp[i,1],3), mark, enter)
                }
                
                #draw error bar figure
                resultsSE <- summarySE(data=dat, measurevar="vectorY", groupvars="vectorX")
                
                #png(paste0("4_results/finial_gait_feature/Fig_AOV_movement/",INT_str,'_',nameF,".png"), width = 1800, height = 1200, res = 300)
                png(paste0("4_results/finial_gait_feature/Fig_AOV_movement/",nameF,".png"), width = 1800, height = 1200, res = 300)
                p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                        geom_point() +
                        geom_line() +
                        geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.1) +
                        scale_x_discrete(name=paste0("Movement (F",df,"=",Fvalue,", p=",Prvalue,")\n",t_pvalue)) +
                        scale_y_continuous(name="Value") +
                        ggtitle(paste0(nameF))
                print(p)
                dev.off()
                
                print(nameF)
                #print(paste0("Interaction (F",df,"=",Fvalue,", p=",Prvalue,")\n",t_pvalue))
                print(resultsSE)
                
                nameP = nameF
                if(nameF == 'steptime'){nameP = 'Step time (s)'}
                if(nameF == 'stepvar'){nameP = 'Step variability'}
                if(nameF == 'stepsym'){nameP = 'Step symmetry'}
                if(nameF == 'rmsacc'){nameP = 'Gait intensity'}
                if(nameF == 'harmonicr'){nameP = 'Overall gait stability'}
                if(nameF == 'stepreg'){nameP = 'Gait regularity'}
                if(nameF == 'ampvar'){nameP = 'Variability of gait intensity'}
                
                png(paste0("4_results/finial_gait_feature/Fig_AOV_movement/0paper_",nameF,".png"), width = 1200, height = 800, res = 300)
                p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                        geom_line() +
                        geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.1) +
                        geom_point(size=3, shape=21, fill="white") +
                        scale_x_discrete(name=paste0("Movement"),
                                         limits=c('sp2','sp3','sp4','sp5'),
                                         labels=c('sp2'='Strolling','sp3'='Walking',
                                                  'sp4'='Rushing','sp5'='Jogging'))+
                        scale_y_continuous(name=nameP)
                print(p)
                dev.off()
        }
#}
###########################################
