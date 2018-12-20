library(ggplot2)
setwd('/Users/mofan/Documents/master_thesis')
dat_intac <- read.csv('4_results/gait/dataset_click_phase.csv',header = FALSE)

source('4_code/function_summarySE.R')
source('4_code/1_gait_click/1-1 clean_click_data.R')
source('4_code/1_gait_click/1-2 calculate_feature.R')

dat_intac <- clean_click_data(dat_intac, 1500)
dataFea <- calculate_feature(dat_intac)

dataFea_leg <- dataFea[dataFea$leg != 0,]
resultSUM_leg <- summarySE(dataFea_leg, measurevar = 'error_mark', groupvars = c('leg'))
resultSUM_leg
fit <- t.test(error_mark ~ leg, dataFea_leg)
Tvalue = paste0('t=', round(fit$statistic,3))
Pvalue = paste0('p=', round(fit$p.value,3))
df = paste0('df=', round(fit$parameter,3))
if(round(fit$p.value,3) <= 0.05) {markF = '*'}else{markF = ''}
Pvalue <- paste0(Pvalue, markF)

p <- ggplot(resultSUM_leg, aes(x=leg, y=error_mark, group=1)) +
        geom_errorbar(aes(ymin=error_mark-ci, ymax=error_mark+ci),width=0.1) +
        geom_point() +
        geom_line() +
        scale_x_discrete(name=paste0('Leg\n','(', Tvalue,', ',df,', ',Pvalue,')'),
                         labels = c("1" = "left","2" = "right")) +
        scale_y_continuous(name="Error rate") +
        ggtitle('Error rate')
png("4_results/gait_click/error_rate_leg.png", width = 1200, height = 1000, res = 300)
print(p)
dev.off()

dataFea_phase <- dataFea[dataFea$phase != 0,]
resultSUM_phase <- summarySE(dataFea_phase, measurevar = 'error_mark', groupvars = 'phase')

fit <- t.test(error_mark ~ phase, dataFea_phase)
Tvalue = paste0('t=', round(fit$statistic,3))
Pvalue = paste0('p=', round(fit$p.value,3))
df = paste0('df=', round(fit$parameter,3))
if(round(fit$p.value,3) <= 0.05) {markF = '*'}else{markF = ''}
Pvalue <- paste0(Pvalue, markF)

p <- ggplot(resultSUM_phase, aes(x=phase, y=error_mark, group=1)) +
        geom_errorbar(aes(ymin=error_mark-ci, ymax=error_mark+ci),width=0.1) +
        geom_point() +
        geom_line() +
        scale_x_discrete(name=paste0('Phase\n','(', Tvalue,', ',df,', ',Pvalue,')'),
                         labels = c("1" = "swing","2" = "stance")) +
        scale_y_continuous(name="Error rate") +
        ggtitle('Error rate')
png("4_results/gait_click/error_rate_phase.png", width = 1200, height = 1000, res = 300)
print(p)
dev.off()
