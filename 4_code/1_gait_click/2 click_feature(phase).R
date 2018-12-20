library(ggplot2)
setwd('/Users/mofan/Documents/master_thesis')
dat_intac <- read.csv('4_results/gait/dataset_click_phase.csv',header = FALSE)

source('4_code/function_summarySE.R')
source('4_code/1_gait_click/1-1 clean_click_data.R')
source('4_code/1_gait_click/1-2 calculate_feature.R')

d = 0.7
rpx = 360*(d/2)/3.4798
threshold = rpx^2

dat_intac <- clean_click_data(dat_intac, threshold)
dataFea <- calculate_feature(dat_intac)

dataFea <- dataFea[dataFea$error_mark != 1, ]
dataFea <- dataFea[dataFea$phase != 0,]

# i in 5:14
for(i in 5:14){
        nameF <- names(dataFea)[i]
        dat <- data.frame(vectorY=dataFea[,i], phase=dataFea[,1])
        fit <- aov(vectorY ~ phase, dat)
        print(nameF)
        #print(summary(fit))
        
        # F value, P value
        Fvalue_phase = round(summary(fit)[[1]][[4]][1],3)
        Pvalue_phase = round(summary(fit)[[1]][[5]][1],3)
        df_phase <- paste0('(',summary(fit)[[1]][[1]][1], ',',summary(fit)[[1]][[1]][2],')')
        if(as.numeric(Pvalue_phase) <= 0.05) {markF2 = '*'}else{markF2 = ''}
        Pvalue_phase <- paste0(Pvalue_phase, markF2)
        
        # TukeyHSD
        t_temp <- as.data.frame(TukeyHSD(fit)$phase)
        t_temp <- name_rows(t_temp)[,-c(1:3)]
        t_pvalue <- ''
        for(i in 1:nrow(t_temp)){
                if(i == 3){ enter = ')\n' }else{enter = ') '}
                if(t_temp[i,1] <= 0.05) {mark = '*'}else{mark = ''}
                t_pvalue <- paste0(t_pvalue, '(', t_temp[i,2], ': ', round(t_temp[i,1],3), mark, enter)
        }
        
        title_x <- paste0('Phase (F', df_phase, '=' ,Fvalue_phase, ', p=', Pvalue_phase,')\n',t_pvalue)
        
        resultSUM_phase <- summarySE(dat, measurevar = 'vectorY', groupvars = 'phase')
        print(resultSUM_phase)
        
        p <- ggplot(resultSUM_phase, aes(x=phase, y=vectorY, group=1)) +
                geom_errorbar(aes(ymin=vectorY-ci, ymax=vectorY+ci),width=0.1) +
                geom_point() +
                geom_line() +
                scale_x_discrete(name=title_x,
                                 labels = c("1" = "Loading Stance","2" = "Terminal Stance",
                                            "3" = "Initial Swing","4" = "Terminal Swing")) +
                scale_y_continuous(name='Value') +
                ggtitle(nameF)
        png(paste0("4_results/gait_click/Fig_AOV_feature/", nameF,".png"), width = 1800, height = 1200, res = 300)
        print(p)
        dev.off()
        
        p <- ggplot(resultSUM_phase, aes(x=phase, y=vectorY, group=1)) +
                geom_errorbar(aes(ymin=vectorY-ci, ymax=vectorY+ci),width=0.1) +
                geom_line() +
                geom_point(size=3, shape=21, fill="white") +
                scale_x_discrete(name='Gait Phase',
                                 labels = c("1" = "Loading Stance","2" = "Terminal Stance",
                                            "3" = "Initial Swing","4" = "Terminal Swing")) +
                scale_y_continuous(name='Value')
        png(paste0("4_results/gait_click/Fig_AOV_feature/0paper_", nameF,".png"), width = 1400, height = 800, res = 300)
        print(p)
        dev.off()
}
