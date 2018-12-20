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

###########################################
## analysis
source("4_code/function_summarySE.R")
library(ggplot2)
for(i in c('time','acc')){
        if(i == 'time'){
                dat_rise = cbind(dat_filter$rise_time, rep('rise',time=nrow(dat_filter)))
                dat_fall = cbind(dat_filter$fall_time, rep('fall',time=nrow(dat_filter)))
                dat = rbind(dat_rise,dat_fall)
        }
        if(i == 'acc'){
                dat_rise = cbind(dat_filter$accxyzUP, rep('rise',time=nrow(dat_filter)))
                dat_fall = cbind(dat_filter$accxyzDOWN, rep('fall',time=nrow(dat_filter)))
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
        png(paste0("4_results/gait_gesture/Fig_AOV_1look/", 'z_Phase_Arm_', i,".png"), width = 1200, height = 1000, res = 300)
        print(p)
        dev.off()
        
        p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                geom_line() +
                geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.1) +
                geom_point(size=3, shape=21, fill="white") +
                scale_x_discrete(name='Phase of Arm',
                                 limits= c("rise","fall"),
                                 labels = c("rise" = "Rise","fall" = "Fall")) +
                scale_y_continuous(name="Value")
        png(paste0("4_results/gait_gesture/Fig_AOV_1look/0paper_", 'z_Phase_Arm_', i,".png"), width = 1000, height = 800, res = 300)
        print(p)
        dev.off()
}
###########################################