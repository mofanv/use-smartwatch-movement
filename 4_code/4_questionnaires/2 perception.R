WD = '/Users/fanvincentmo/Documents/master_thesis'
setwd(WD)
source('4_code/function_summarySE.R')
P <- read.csv('4_data/paper_data_324/subjective_perception.csv')
P_prior <- read.csv('4_data/paper_data_324/subjective_perception_prior.csv')
P = rbind(P, P_prior)

which(is.na(P$a1))
which(is.na(P$a2))
which(is.na(P$a3))
which(is.na(P$a4))
which(is.na(P$a5))
which(is.na(P$a6))
which(is.na(P$b1))
which(is.na(P$b2))
which(is.na(P$b3))
which(is.na(P$b4))
which(is.na(P$c1))
which(is.na(P$c2))
which(is.na(P$c3))
which(is.na(P$c4))
which(is.na(P$c5))
which(is.na(P$c6))
which(is.na(P$c7))
which(is.na(P$c8))



centA = (P$a1 + P$a2 + (6-P$a3) + P$a4 + (6-P$a5) + P$a6 + P$a7) * 100/(5*7)
centB = ((6-P$b1) + (6-P$b2) + P$b3 + (6-P$b4)) * 100/(5*4)
centC = ((6-P$c1) + P$c2 + P$c3 + (6-P$c4) + P$c5 + (6-P$c6) + P$c7 + P$c8) * 100/(5*8)

names(P) = c('personno',names(P)[-1])
P$Ease_of_use = centA
P$Subjective_perception = centB
P$Flow_experience = centC
perception = P[-54,c(1,2,22,23,24)]
perception$personno = as.factor(perception$personno)
perception$con = as.factor(perception$con)

###########################################
## analysis
source("4_code/function_summarySE.R")
library(ggplot2)
library(plyr)

for(i in 3:5){
        # anova analysis
        levels(perception$con) = c('sp1','sp2','sp3','sp4','sp5')
        nameF <- names(perception)[i]
        dat <- data.frame(vectorY=perception[,i], vectorX=perception[,2])
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
        
        png(paste0("4_results/perception/",nameF,".png"), width = 1800, height = 1200, res = 300)
        p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                geom_point() +
                geom_line() +
                geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.1) +
                scale_x_discrete(name=paste0("Movement (F",df,"=",Fvalue,", p=",Prvalue,")\n",t_pvalue)) +
                scale_y_continuous(name="Value") +
                ggtitle(paste0(nameF))
        print(p)
        dev.off()
        
        
        if(nameF == 'Ease_of_use'){nameP = 'Ease of use'}
        if(nameF == 'Flow_experience'){nameP = 'Flow experience'}
        if(nameF == 'Subjective_perception'){nameP = 'Subjective cognitive workload'}
        
        png(paste0("4_results/perception/0paper_",nameF,".png"), width = 1200, height = 800, res = 300)
        p <- ggplot(resultsSE, aes(x=vectorX, y=vectorY, group=1)) +
                geom_line() +
                geom_errorbar(aes(ymin=vectorY-ci,ymax=vectorY+ci),width=0.1) +
                geom_point(size=3, shape=21, fill="white") +
                scale_x_discrete(name=paste0("Movement"),
                                 limits=c('sp1','sp2','sp3','sp4','sp5'),
                                 labels=c('sp1'='Stand','sp2'='Strolling','sp3'='Walking',
                                          'sp4'='Rushing','sp5'='Jogging'))+
                scale_y_continuous(name=nameP)
        print(p)
        dev.off()
}
###########################################

