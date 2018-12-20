library(ggplot2)
setwd('/Users/mofan/Documents/master_thesis')
dat_intac <- read.csv('4_results/gait/dataset_click_phase.csv',header = FALSE)
error_rate <- read.csv('4_results/gait/error_rate_percent.csv', header = FALSE)

source('4_code/function_summarySE.R')
source('4_code/1_gait_click/1-1 clean_click_data.R')
source('4_code/1_gait_click/1-2 calculate_feature.R')

#threshold = 1200
d = 0.75
rpx = 360*(d/2)/3.4798
threshold = rpx^2

dat_intac <- clean_click_data(dat_intac, threshold)
dataFea <- calculate_feature(dat_intac)

dataFea_phase <- dataFea[dataFea$phase != 0,]

####################################################
#### error rate

resultSUM_phase <- summarySE(dataFea_phase, measurevar = 'error_mark', groupvars = 'phase')
fit <- aov(error_mark ~ phase, dataFea_phase)
print(summary(fit))

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
t_pvalue

title_x <- paste0('Phase (F', df_phase, '=' ,Fvalue_phase, ', p=', Pvalue_phase,')\n',t_pvalue)

p <- ggplot(resultSUM_phase, aes(x=phase, y=error_mark, group=1)) +
        geom_errorbar(aes(ymin=error_mark-ci, ymax=error_mark+ci),width=0.1) +
        geom_line() +
        geom_point(size=3, shape=21, fill="white") +
        scale_x_discrete(name='Gait Phase',
                         labels = c("1" = "Loading\nStance","2" = "Terminal\nStance",
                                    "3" = "Initial\nSwing","4" = "Terminal\nSwing")) +
        scale_y_continuous(name="Error rate")
png("4_results/gait_click/0paper_error_rate_phase.png", width = 1800, height = 1000, res = 300)
print(p)
dev.off()