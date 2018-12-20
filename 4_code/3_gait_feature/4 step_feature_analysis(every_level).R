WD = '/Users/fanvincentmo/Documents/master_thesis'
setwd(WD)

gait_feature_sta <- read.csv('4_results/finial_gait_feature/step_feature_1_look.csv', header = FALSE)
gait_feature_touch <- read.csv('4_results/finial_gait_feature/step_feature_2_touch.csv', header = FALSE)
gait_feature_wrist <- read.csv('4_results/finial_gait_feature/step_feature_4_wrist.csv', header = FALSE)

gait_feature_sta_TIME <- read.csv('4_results/finial_gait_feature/gait_feature_1_look.csv', header = FALSE)
gait_feature_touch_TIME <- read.csv('4_results/finial_gait_feature/gait_feature_2_touch.csv', header = FALSE)
gait_feature_wrist_TIME <- read.csv('4_results/finial_gait_feature/gait_feature_4_wrist.csv', header = FALSE)

gait_feature_sta_TIME = gait_feature_sta_TIME[3]
gait_feature_touch_TIME = gait_feature_touch_TIME[3]
gait_feature_wrist_TIME = gait_feature_wrist_TIME[3]

#6,4   23
#7,5   28
#10,3   38
#11,4 43
gait_feature_sta = gait_feature_sta[-43,]
gait_feature_sta = gait_feature_sta[-38,]
gait_feature_sta = gait_feature_sta[-28,]
gait_feature_sta = gait_feature_sta[-23,]
gait_feature_touch = gait_feature_touch[-43,]
gait_feature_touch = gait_feature_touch[-38,]
gait_feature_touch = gait_feature_touch[-28,]
gait_feature_touch = gait_feature_touch[-23,]
gait_feature_wrist = gait_feature_wrist[-43,]
gait_feature_wrist = gait_feature_wrist[-38,]
gait_feature_wrist = gait_feature_wrist[-28,]
gait_feature_wrist = gait_feature_wrist[-23,]


gait_feature_sta = cbind(gait_feature_sta,(gait_feature_sta$V5/gait_feature_sta_TIME))
gait_feature_touch = cbind(gait_feature_touch,(gait_feature_touch$V5/gait_feature_touch_TIME))
gait_feature_wrist = cbind(gait_feature_wrist,(gait_feature_wrist$V5/gait_feature_wrist_TIME))

namesTable = c('iperson','isp','dis','stepnum','steplong','speed')

names(gait_feature_sta) <- namesTable
names(gait_feature_touch) <- namesTable
names(gait_feature_wrist) <- namesTable

gait_feature_wrist <- gait_feature_wrist[-which(is.nan(gait_feature_wrist$stepnum)),]
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
for(ISP in 2:5){
        if(ISP==2) {gait_feature = gait_feature_sp2; ISP_str = 'sp2'; nameMove = 'strolling'}
        if(ISP==3) {gait_feature = gait_feature_sp3; ISP_str = 'sp3'; nameMove = 'walking'}
        if(ISP==4) {gait_feature = gait_feature_sp4; ISP_str = 'sp4'; nameMove = 'rushing'}
        if(ISP==5) {gait_feature = gait_feature_sp5; ISP_str = 'sp5'; nameMove = 'jogging'}

        gait_feature$mark = as.factor(gait_feature$mark)
        dat <- data.frame(vectorY=gait_feature$steplong, vectorX=gait_feature$mark)
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
                if(i == 3){ enter = ')\n' }else{enter = ') '}
                if(t_temp[i,1] <= 0.05) {mark = '*'}else{mark = ''}
                t_pvalue <- paste0(t_pvalue, '(', t_temp[i,2], ': ', round(t_temp[i,1],3), mark, enter)
        }
        t_pvalue
        print(paste0('Interaction'," (F",df,"=",Fvalue,", p=",Prvalue,")\n",t_pvalue))
        
        #draw error bar figure
        resultsSE <- summarySE(data=dat, measurevar="vectorY", groupvars="vectorX")
        
        #png(paste0("4_results/finial_gait_feature/Fig_AOV_step/",ISP_str, '_steplong',".png"), width = 1800, height = 1200, res = 300)
        p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                geom_point() +
                geom_line() +
                geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.1) +
                scale_x_discrete(name=paste0('Interaction'," (F",df,"=",Fvalue,", p=",Prvalue,")\n",t_pvalue)) +
                scale_y_continuous(name="Value") +
                ggtitle(paste0(ISP_str))
        #print(p)
        #dev.off()
        ###########################################
        
        print(ISP)
        #print(paste0("Interaction (F",df,"=",Fvalue,", p=",Prvalue,")\n",t_pvalue))
        print(resultsSE)
        
        signMark = c('','','')
        for(i in 1:nrow(t_temp)){
                word1 = strsplit(t_temp$.rownames[i],'-')[[1]][1]
                word2 = strsplit(t_temp$.rownames[i],'-')[[1]][2]
                if(word1 == 'sta'){loc1 = 1}
                if(word1 == 'touch'){loc1 = 2}
                if(word1 == 'wrist'){loc1 = 3}
                if(word2 == 'sta'){loc2 = 1}
                if(word2 == 'touch'){loc2 = 2}
                if(word2 == 'wrist'){loc2 = 3}
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
        
        png(paste0("4_results/finial_gait_feature/Fig_AOV_step/0paper_",ISP_str, '_steplong',".png"), width = 1200, height = 800, res = 300)
        p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                geom_line() +
                geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.1) +
                geom_point(size=3, shape=21, fill="white") +
                scale_x_discrete(name=paste0("Interaction in ",nameMove),
                                 limits=c('sta','touch','wrist'),
                                 labels=c('sta'='Without\nInteraction\n1','touch'='Touch\nInteraction\n2','wrist'='Wrist\nGesture\n3')) +
                scale_y_continuous(name= "Step length (m)") +
                geom_text(aes(x=c(1,2,3), y=vectorY+ci+0.03,label=signMark),
                          size = 2.8, position=position_dodge(.5))
        print(p)
        dev.off()
}



###########################################
## analysis
for(ISP in 2:6){
        if(ISP==2) {gait_feature = gait_feature_sp2; ISP_str = 'sp2'; nameMove = 'strolling'}
        if(ISP==3) {gait_feature = gait_feature_sp3; ISP_str = 'sp3'; nameMove = 'walking'}
        if(ISP==4) {gait_feature = gait_feature_sp4; ISP_str = 'sp4'; nameMove = 'rushing'}
        if(ISP==5) {gait_feature = gait_feature_sp5; ISP_str = 'sp5'; nameMove = 'jogging'}
        
        gait_feature$mark = as.factor(gait_feature$mark)
        dat <- data.frame(vectorY=gait_feature$speed, vectorX=gait_feature$mark)
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
                if(i == 3){ enter = ')\n' }else{enter = ') '}
                if(t_temp[i,1] <= 0.05) {mark = '*'}else{mark = ''}
                t_pvalue <- paste0(t_pvalue, '(', t_temp[i,2], ': ', round(t_temp[i,1],3), mark, enter)
        }
        t_pvalue
        print(paste0('Interaction'," (F",df,"=",Fvalue,", p=",Prvalue,")\n",t_pvalue))
        
        #draw error bar figure
        resultsSE <- summarySE(data=dat, measurevar="vectorY", groupvars="vectorX")
        
        #png(paste0("4_results/finial_gait_feature/Fig_AOV_step/",ISP_str, '_steplong',".png"), width = 1800, height = 1200, res = 300)
        p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                geom_point() +
                geom_line() +
                geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.1) +
                scale_x_discrete(name=paste0('Interaction'," (F",df,"=",Fvalue,", p=",Prvalue,")\n",t_pvalue)) +
                scale_y_continuous(name="Value") +
                ggtitle(paste0(ISP_str))
        #print(p)
        #dev.off()
        ###########################################
        
        print(ISP)
        #print(paste0("Interaction (F",df,"=",Fvalue,", p=",Prvalue,")\n",t_pvalue))
        print(resultsSE)
        
        signMark = c('','','')
        for(i in 1:nrow(t_temp)){
                word1 = strsplit(t_temp$.rownames[i],'-')[[1]][1]
                word2 = strsplit(t_temp$.rownames[i],'-')[[1]][2]
                if(word1 == 'sta'){loc1 = 1}
                if(word1 == 'touch'){loc1 = 2}
                if(word1 == 'wrist'){loc1 = 3}
                if(word2 == 'sta'){loc2 = 1}
                if(word2 == 'touch'){loc2 = 2}
                if(word2 == 'wrist'){loc2 = 3}
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
        
        png(paste0("4_results/finial_gait_feature/Fig_AOV_step/0paper_",ISP_str, '_speed',".png"), width = 1200, height = 800, res = 300)
        p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                geom_line() +
                geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.1) +
                geom_point(size=3, shape=21, fill="white") +
                scale_x_discrete(name=paste0("Interaction in ",nameMove),
                                 limits=c('sta','touch','wrist'),
                                 labels=c('sta'='Without\nInteraction\n1','touch'='Touch\nInteraction\n2','wrist'='Wrist\nGesture\n3')) +
                scale_y_continuous(name= "Speed (m/s)") +
                geom_text(aes(x=c(1,2,3), y=vectorY+ci+0.04,label=signMark),
                          size = 2.8, position=position_dodge(.5))
        print(p)
        dev.off()
}


mean(gait_feature_sp2$speed)
sd(gait_feature_sp2$speed)

mean(gait_feature_sp3$speed)
sd(gait_feature_sp3$speed)

mean(gait_feature_sp4$speed)
sd(gait_feature_sp4$speed)

mean(gait_feature_sp5$speed)
sd(gait_feature_sp5$speed)
