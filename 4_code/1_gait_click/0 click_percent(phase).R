library(ggplot2)
library(plyr)
library(tidyr)

setwd('/Users/mofan/Documents/master_thesis')
dat_intac <- read.csv('4_results/gait/dataset_click_phase.csv',header = FALSE)
percent <- read.csv('4_results/gait/error_rate_percent.csv', header = FALSE)

names(percent) <- c('no','sp','errall','errkey','1','2','3','4')
percent <- percent[,-c(3,4)]
percent <- gather(data = percent, phase, freq, 3:6)
percent$phase = as.numeric(percent$phase)

source('4_code/function_summarySE.R')
source('4_code/1_gait_click/1-1 clean_click_data.R')
source('4_code/1_gait_click/1-2 calculate_feature.R')

dat_intac <- clean_click_data(dat_intac, 1500)
dataFea <- calculate_feature(dat_intac)

dataFea_phase <- dataFea[dataFea$phase != 0,]

##############################
## Percent of touch
dat_touch_percent <- data.frame(noperson = (dataFea_phase$noperson), sp = (dataFea_phase$sp), 
                                phase = (dataFea_phase$phase))
count_touch <- count(dat_touch_percent)
count_touchALL <- count(dat_touch_percent[,-3])
for(i in 1:nrow(count_touch)){
        index_touch = which((count_touchALL$noperson == count_touch$noperson[i]) & (count_touchALL$sp == count_touch$sp[i]))
        count_touch$freq[i] = count_touch$freq[i] / count_touchALL$freq[index_touch]
}

################################
# Percent of phase
datp = percent
datp$sp = as.factor(datp$sp)
datp$phase = as.factor(datp$phase)
fit = aov(freq~phase, datp)
print(summary(fit))
TukeyHSD(fit)

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

result_percent <- summarySE(datp, measurevar = 'freq', groupvars = c('phase'))
p <- ggplot(result_percent, aes(x=phase, y=freq, group=1)) +
        geom_errorbar(aes(ymin=freq-ci, ymax=freq+ci),width=0.1) +
        geom_line() +
        geom_point(size=3, shape=21, fill="white") +
        scale_x_discrete(name='Gait Phase',
                         labels = c("1" = "Loading\nStance","2" = "Terminal\nStance",
                                    "3" = "Initial\nSwing","4" = "Terminal\nSwing")) +
        scale_y_continuous(name="Phase percent") +
png("4_results/gait_click/0paper_phase_percent.png", width = 1400, height = 800, res = 300)
print(p)
dev.off()



######################################
# abs percent of touch
for(i in 1:nrow(count_touch)){
        index_touch = which((percent$no == count_touch$noperson[i]) & (percent$sp == count_touch$sp[i]) & (percent$phase == count_touch$phase[i]))
        count_touch$absfreq[i] = count_touch$freq[i] / (percent$freq[index_touch]*4)
}
count_touch$phase <- as.factor(as.character(count_touch$phase))

#
fit <- aov(absfreq ~ phase, count_touch)
print(summary(fit))
TukeyHSD(fit)


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

result_percent <- summarySE(count_touch, measurevar = 'absfreq', groupvars = c('phase'))
p <- ggplot(result_percent, aes(x=phase, y=absfreq, group=1)) +
        geom_errorbar(aes(ymin=absfreq-ci, ymax=absfreq+ci),width=0.1) +
        geom_line() +
        geom_point(size=3, shape=21, fill="white") +
        scale_x_discrete(name= 'Gait Phase',
                         labels = c("1" = "Loading\nStance","2" = "Terminal\nStance",
                                    "3" = "Initial\nSwing","4" = "Terminal\nSwing")) +
        scale_y_continuous(name="Touch percent") +
png("4_results/gait_click/0paper_touch_percent_phase.png", width = 1400, height = 800, res = 300)
print(p)
dev.off()
