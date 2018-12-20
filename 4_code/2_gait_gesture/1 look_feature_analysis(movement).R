WD = '/Users/mofan/Documents/master_thesis'
setwd(WD)

feature_look = read.csv('4_results/gait_gesture/feature_1look.csv', header=FALSE)
names(feature_look) = c('iperson', 'isp', 'all_time', 'rise_time', 'fall_time', 'angX_changed', 'angY_changed', 'angZ_changed', 'accxyzUP', 'accxyzDOWN', 'length_new')
dat = feature_look

####################################
## delete out points
sp = boxplot(dat$all_time)$out # all time
idxOUT_all_time = vector()
for (k in 1:length(sp)){
        idxOUT_all_time = c(idxOUT_all_time, which(dat$all_time==sp[k]))
}

sp = sort(boxplot(dat$rise_time)$out) # rise time
idxOUT_rise_time = vector()
for (k in (length(sp)-1):length(sp)){
        idxOUT_rise_time = c(idxOUT_rise_time, which(dat$rise_time==sp[k]))
}

sp = sort(boxplot(dat$fall_time)$out) # fall time
idxOUT_fall_time = vector()
for (k in length(sp)){
        idxOUT_fall_time = c(idxOUT_fall_time, which(dat$fall_time==sp[k]))
}

idxOUT_len = which(dat$length_new > 3)

del_idx = sort(c(idxOUT_all_time,idxOUT_rise_time,idxOUT_fall_time, idxOUT_len))
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
library(plyr)
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
        
        png(paste0("4_results/gait_gesture/Fig_AOV_1look/0paper_", nameF,".png"), width = 1400, height = 800, res = 300)
        p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                geom_line() +
                geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.1) +
                geom_point(size=3, shape=21, fill="white") +
                scale_x_discrete(name=paste0("Movement"),
                                 limits=c('sp1','sp2','sp3','sp4','sp5'),
                                 labels=c('sp1'='Stand','sp2'='Strolling','sp3'='Walking',
                                          'sp4'='Rushing','sp5'='Jogging'))+
                scale_y_continuous(name="Value")
        print(p)
        dev.off()
}
###########################################