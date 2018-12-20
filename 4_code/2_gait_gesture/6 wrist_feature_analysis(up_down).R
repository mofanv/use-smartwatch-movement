WD = '/Users/mofan/Documents/master_thesis'
setwd(WD)

feature_wrist = read.csv('4_results/gait_gesture/feature_4wrist.csv', header=FALSE)
names(feature_wrist) = c('iperson', 'isp', 'times_wrist','avg_timeUP','avg_timeDOWN', 'avg_accUP', 'avg_accDOWN')
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

###########################################
## analysis
source("4_code/function_summarySE.R")
library(ggplot2)
for(i in c('time','acc')){
        if(i == 'time'){
                dat_rise = cbind(dat_filter$avg_timeUP, rep('rise',time=nrow(dat_filter)))
                dat_fall = cbind(dat_filter$avg_timeDOWN, rep('fall',time=nrow(dat_filter)))
                dat = rbind(dat_rise,dat_fall)
        }
        if(i == 'acc'){
                dat_rise = cbind(dat_filter$avg_accUP, rep('rise',time=nrow(dat_filter)))
                dat_fall = cbind(dat_filter$avg_accDOWN, rep('fall',time=nrow(dat_filter)))
                dat = rbind(dat_rise,dat_fall)
        }
        
        # anova analysis
        nameF <- i
        dat <- data.frame(vectorY=dat[,1], vectorX=dat[,2])
        dat$vectorY = as.numeric(as.character(dat$vectorY))
        fit <- t.test(vectorY ~ vectorX, dat)
        Tvalue = paste0('t=', round(fit$statistic,3))
        Pvalue = paste0('p=', round(fit$p.value,3))
        df = paste0('df=', round(fit$parameter,3))
        if(round(fit$p.value,3) <= 0.05) {markF = '*'}else{markF = ''}
        Pvalue <- paste0(Pvalue, markF)
        
        #draw error bar figure
        resultsSE <- summarySE(data=dat, measurevar="vectorY", groupvars="vectorX")
        print(resultsSE)
        
        p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                geom_point() +
                geom_line() +
                geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.1) +
                scale_x_discrete(name=paste0('Phase of Arm\n','(', Tvalue,', ',df,', ',Pvalue,')'),
                                 limits= c("rise","fall"),
                                 labels = c("rise" = "Rise","fall" = "Fall")) +
                scale_y_continuous(name="Value") +
                ggtitle(paste0(nameF))
        png(paste0("4_results/gait_gesture/Fig_AOV_4wrist/", 'z_Phase_Arm_', i,".png"), width = 1200, height = 1000, res = 300)
        print(p)
        dev.off()
        
        p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                geom_line() +
                geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.1) +
                geom_point(size=3, shape=21, fill="white") +
                scale_x_discrete(name='Phase of Wrist Gesture',
                                 limits= c("rise","fall"),
                                 labels = c("rise" = "Wrist forward","fall" = "Wrist back")) +
                scale_y_continuous(name="Value")
        png(paste0("4_results/gait_gesture/Fig_AOV_4wrist/0paper_", 'z_Phase_Arm_', i,".png"), width = 1000, height = 800, res = 300)
        print(p)
        dev.off()
}
###########################################