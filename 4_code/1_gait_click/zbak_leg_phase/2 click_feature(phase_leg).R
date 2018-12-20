library(ggplot2)
setwd('/Users/mofan/Documents/master_thesis')
dat_intac <- read.csv('4_results/gait/dataset_click_phase.csv',header = FALSE)

source('4_code/function_summarySE.R')
source('4_code/1_gait_click/1-1 clean_click_data.R')
source('4_code/1_gait_click/1-2 calculate_feature.R')

dat_intac <- clean_click_data(dat_intac, 1500)
dataFea <- calculate_feature(dat_intac)

dataFea <- dataFea[dataFea$error_mark != 1, ]
dataFea <- dataFea[dataFea$leg != 0,]
dataFea <- dataFea[dataFea$phase != 0,]

# i in 6:15
for(i in 6:15){
        nameF <- names(dataFea)[i]
        dat <- data.frame(vectorY=dataFea[,i], leg=dataFea[,1], phase=dataFea[,2])
        fit <- aov(vectorY ~ leg*phase, dat)
        print(nameF)
        print(summary(fit))
        
        # F value, P value
        Fvalue_leg = round(summary(fit)[[1]][[4]][1],3)
        Pvalue_leg = round(summary(fit)[[1]][[5]][1],3)
        df_leg <- paste0('(',summary(fit)[[1]][[1]][1], ',',summary(fit)[[1]][[1]][4],')')
        Fvalue_phase = round(summary(fit)[[1]][[4]][2],3)
        Pvalue_phase = round(summary(fit)[[1]][[5]][2],3)
        df_phase <- paste0('(',summary(fit)[[1]][[1]][2], ',',summary(fit)[[1]][[1]][4],')')
        if(as.numeric(Pvalue_leg) <= 0.05) {markF1 = '*'}else{markF1 = ''}
        Pvalue_leg <- paste0(Pvalue_leg, markF1)
        if(as.numeric(Pvalue_phase) <= 0.05) {markF2 = '*'}else{markF2 = ''}
        Pvalue_phase <- paste0(Pvalue_phase, markF2)
        
        Fvalue_inter = round(summary(fit)[[1]][[4]][3],3)
        Pvalue_inter = round(summary(fit)[[1]][[5]][3],3)
        df_inter <- paste0('(',summary(fit)[[1]][[1]][3], ',',summary(fit)[[1]][[1]][4],')')
        if(as.numeric(Pvalue_inter) <= 0.05) {markF2 = '*'}else{markF2 = ''}
        Pvalue_inter <- paste0(Pvalue_inter, markF2)
        
        title_x <- paste0('Leg\n',
                          'Leg (F', df_leg, '=' ,Fvalue_leg, ', p=', Pvalue_leg,')\n',
                          'Phase (F', df_phase, '=' ,Fvalue_phase, ', p=', Pvalue_phase,')\n',
                          'Interaction (F', df_inter, '=' ,Fvalue_inter, ', p=', Pvalue_inter,')')
        
        #draw error bar figure
        resultsSE <- summarySE(data=dat, measurevar="vectorY", groupvars=c("leg","phase"))
        
        pd <- position_dodge(0.2)
        png(paste0("4_results/gait_click/Fig_AOV_feature/", nameF,".png"), width = 1200, height = 1200, res = 300)
        p <- ggplot(resultsSE, aes(x=leg, y=vectorY, group=phase)) +
                geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),colour="black",width=0.1,position=pd) +
                geom_line(aes(linetype=phase), position=pd,size=1.2) +
                geom_point(aes(shape=phase), position=pd, fill="white", size=2) +
                scale_x_discrete(name=title_x,
                                 labels=c('1' = 'Left','2' = 'Right')) +
                scale_y_continuous(name="Value") +
                scale_shape_manual(values=c(21,24),name='Gait Phase',
                                   labels=c('1' = 'Swing','2' = 'Stance'))  +
                #scale_linetype_manual()  +
                scale_linetype_manual(values=c("solid", "dotted"),name='Gait Phase',
                                      labels=c('1' = 'Swing','2' = 'Stance')) +
                ggtitle(nameF)
        print(p)
        dev.off()
}
