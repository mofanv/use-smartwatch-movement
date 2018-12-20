library(data.table)
library(ggplot2)
library(stringr)
WORK_DICTIONARY <- "/Users/fanvincentmo/Documents/master_thesis/"
setwd(WORK_DICTIONARY)
source("4_code/function_summarySE.R")

##########################################
# read slide feature data
error_rate1 <- read.csv("4_results/interaction_feature/slide/Csv_feature/error_rate_Sp1.csv")
error_rate2 <- read.csv("4_results/interaction_feature/slide/Csv_feature/error_rate_Sp2.csv")
error_rate3 <- read.csv("4_results/interaction_feature/slide/Csv_feature/error_rate_Sp3.csv")
error_rate4 <- read.csv("4_results/interaction_feature/slide/Csv_feature/error_rate_Sp4.csv")
error_rate5 <- read.csv("4_results/interaction_feature/slide/Csv_feature/error_rate_Sp5.csv")

error_rate <- rbind(rbind(rbind(rbind(error_rate1,error_rate2),error_rate3),error_rate4),error_rate5)
error_rate$sp <- rep(c('Sp1','Sp2','Sp3','Sp4','Sp5'), each=18)

# F test
error_rate$sp <- as.factor(error_rate$sp)
fit <- aov(mark ~ sp, error_rate)
summary(fit)
Fvalue <- round(summary(fit)[[1]][[4]][1],3)
Prvalue <- round(summary(fit)[[1]][[5]][1],3)
df <- paste0('(',summary(fit)[[1]][[1]][1], ',',summary(fit)[[1]][[1]][2],')')

if(as.numeric(Prvalue) <= 0.05) {markF = '*'}else{markF = ''}
Prvalue <- paste0(Prvalue, markF)

# TukeyHSD
TukeyHSD(fit)
t_temp <- as.data.frame(TukeyHSD(fit)$sp)
t_temp <- name_rows(t_temp)[,-c(1:3)]
t_pvalue <- ''
for(i in 1:nrow(t_temp)){
        if(i == 4 || i == 7){ enter = ')\n' }else{enter = ') '}
        if(t_temp[i,1] <= 0.05) {mark = '*'}else{mark = ''}
        t_pvalue <- paste0(t_pvalue, '(', t_temp[i,2], ': ', round(t_temp[i,1],3), mark, enter)
}
t_pvalue

#draw error bar figure
resultsSE <- summarySE(data=error_rate, measurevar="mark", groupvars="sp")

png(paste0("4_results/interaction_feature/slide/Fig_AOV_feature/0_error_rate.png"), width = 1800, height = 1200, res = 300)
p <- ggplot(resultsSE, aes(x=sp, y=mark, group=1)) +
        geom_point() +
        geom_line() +
        geom_errorbar(aes(ymin=mark-ci,ymax=mark+ci),width=0.1) +
        scale_x_discrete(name=paste0("Movement (F",df,"=",Fvalue,", p=",Prvalue,")\n",t_pvalue)) +
        scale_y_continuous(name="Value") +
        ggtitle('error_rate')
print(p)
dev.off()

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


library(scales)
png(paste0("4_results/interaction_feature/slide/Fig_AOV_feature/0paper_error_rate.png"), width = 1400, height = 800, res = 300)
p <- ggplot(resultsSE, aes(x=sp, y=mark)) +
        geom_line(group =1) +
        geom_errorbar(aes(ymin=mark-ci,ymax=mark+ci),width=0.1) +
        geom_point(size=3, shape=21, fill="white") +
        scale_x_discrete(name=paste0("Movement"),
                         limits=c('Sp1','Sp2','Sp3','Sp4','Sp5'),
                         labels=c('Sp1'='Standing\n1','Sp2'='Strolling\n2','Sp3'='Walking\n3',
                                  'Sp4'='Rushing\n4','Sp5'='Jogging\n5')) +
        scale_y_continuous(name="Error rate", labels=percent) +
        geom_text(aes(x=c(1,2,3,4,5), y=mark+1.7*ci,label=signMark),
                  size = 2.8, position=position_dodge(.5))
        
        


print(p)
dev.off()
