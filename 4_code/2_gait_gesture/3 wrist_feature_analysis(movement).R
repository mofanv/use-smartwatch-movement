WD = '/Users/fanvincentmo/Documents/master_thesis'
setwd(WD)

feature_wrist = read.csv('4_results/gait_gesture/feature_4wrist.csv', header=FALSE)
names(feature_wrist) = c('iperson', 'isp', 'times_wrist','avg_timeUP','avg_timeDOWN', 'avg_accUP', 'avg_accDOWN',
                         'angX_changed', 'angY_changed', 'angZ_changed')
dat = feature_wrist

####################################
## delete out points
idx_nan = which(is.nan(dat$avg_timeUP))
dat = dat[-idx_nan,]

sp = boxplot(dat$avg_timeUP)$out # all time
idxOUT_timeUP = vector()
for (k in (length(sp)-1):length(sp)){
        idxOUT_timeUP = c(idxOUT_timeUP, which(dat$avg_timeUP==sp[k]))
}

sp = sort(boxplot(dat$avg_timeDOWN)$out) # rise time
idxOUT_timeDOWN = vector()
#for (k in (length(sp)-1):length(sp)){
#        idxOUT_rise_time = c(idxOUT_rise_time, which(dat$rise_time==sp[k]))
#}

idxOUT_len = which(dat$times_wrist < 5)

del_idx = sort(c(idxOUT_timeUP,idxOUT_timeDOWN, idxOUT_len))
dat_filter = dat[-del_idx,]

# negative value of angle X Z
idxT = which(dat_filter$angX_changed < 0)
dat_filter$angX_changed[idxT] = -dat_filter$angX_changed[idxT]
idxT = which(dat_filter$angZ_changed < 0)
dat_filter$angZ_changed[idxT] = -dat_filter$angZ_changed[idxT]

###########################################
## analysis
source("4_code/function_summarySE.R")
library(ggplot2)
dat_filter$isp = as.factor(dat_filter$isp)
levels(dat_filter$isp) = c('sp1','sp2','sp3','sp4','sp5')
for(i in 3:10){
        # anova analysis
        nameF <- names(dat_filter)[i]
        dat <- data.frame(vectorY=dat_filter[,i], vectorX=dat_filter[,2])
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
                if(i == 4 || i == 7){ enter = ')\n' }else{enter = ') '}
                if(t_temp[i,1] <= 0.05) {mark = '*'}else{mark = ''}
                t_pvalue <- paste0(t_pvalue, '(', t_temp[i,2], ': ', round(t_temp[i,1],3), mark, enter)
        }
        
        #draw error bar figure
        resultsSE <- summarySE(data=dat, measurevar="vectorY", groupvars="vectorX")
        print(resultsSE)
        
        #png(paste0("4_results/gait_gesture/Fig_AOV_4wrist/", nameF,".png"), width = 1800, height = 1200, res = 300)
        p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                geom_point() +
                geom_line() +
                geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.1) +
                scale_x_discrete(name=paste0("Movement (F",df,"=",Fvalue,", p=",Prvalue,")\n",t_pvalue)) +
                scale_y_continuous(name="Value") +
                ggtitle(paste0(nameF))
        #print(p)
        #dev.off()
        
        nameP = nameF
        if(nameF == 'times_wrist'){nameP = 'Times of flicking wrist'}
        signMark = c('','','','','')
        for(i in 1:nrow(t_temp)){
                loc1 = as.numeric(str_sub(t_temp$.rownames[i],3,3))
                loc2 = as.numeric(str_sub(t_temp$.rownames[i],7,7))
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
        
        png(paste0("4_results/gait_gesture/Fig_AOV_4wrist/0paper_", nameF,".png"), width = 1400, height = 800, res = 300)
        p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                geom_line() +
                geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.1) +
                geom_point(size=3, shape=21, fill="white") +
                scale_x_discrete(name=paste0("Movement"),
                                 limits=c('sp1','sp2','sp3','sp4','sp5'),
                                 labels=c('sp1'='Standing\n1','sp2'='Strolling\n2','sp3'='Walking\n3',
                                          'sp4'='Rushing\n4','sp5'='Jogging\n5')) +
                scale_y_continuous(name=nameP) +
                geom_text(aes(x=c(1,2,3,4,5), y=vectorY+1*ci+2,label=signMark),
                          size = 2.8, position=position_dodge(.5)
                )
        print(p)
        dev.off()
}
###########################################