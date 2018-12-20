options(digits.secs=3, digits=13)
library(data.table)
library(plotrix)
WORK_DICTIONARY <- "/Users/fanvincentmo/Documents/master_thesis"
setwd(WORK_DICTIONARY)

source("4_code/interaction_feature/1-1 read_click_data.R")
source("4_code/interaction_feature/1-2 clean_click_data.R")

Sp = 5 #12345
k=1
#threshold = 1200
d = 0.75
rpx = 360*(d/2)/3.4798
threshold = rpx^2

TXT_FILE_NAME <- read_intac(Sp)
dat_intac_min <- vector("list", 3)
location_error <- c()
intec_feature <- c()

length(TXT_FILE_NAME)
for(i in 1:length(TXT_FILE_NAME)){
        dat_intac_min[[i]] <- data_interaction_function(TXT_FILE_NAME[i], threshold)[[1]]
        location_error <- c(location_error,data_interaction_function(TXT_FILE_NAME[i], threshold)[[2]])
        intec_feature <- rbind(intec_feature,data_interaction_function(TXT_FILE_NAME[i], threshold)[[3]])
}

dat_intac <- data.frame()
for(i in 1:length(TXT_FILE_NAME)){
        dat_intac_min[[i]]$no = 10000*i + dat_intac_min[[i]]$no
        dat_intac <- rbind(dat_intac, dat_intac_min[[i]])
}

title = paste0("click_Sp",Sp)


intec_feature$NAME_FILE_SCREEN <- substr(intec_feature$NAME_FILE_SCREEN,1,5)
#####write.csv(intec_feature,paste0("/4_data/intecaction_feature/intecaction_feature_",substr(TXT_FILE_NAME[1],5,7),".csv"))
write.csv(intec_feature,paste0("4_results/interaction_feature/click/","feature_",title,".csv"))


library(ggplot2)
library(tidyr)

circleFun <- function(center = c(180,180),diameter = 320, npoints = 100){
        r = diameter / 2
        tt <- seq(0,2*pi,length.out = npoints)
        xx <- center[1] + r * cos(tt)
        yy <- center[2] + r * sin(tt)
        return(data.frame(x = xx, y = yy))
}
dat_cycle <- circleFun()
dat_cycle_0 <- dat_cycle
dat_cycle$no <- 1:100
dat_cycle_0$no <- c(100,1:99)
dat_cycle <- rbind(dat_cycle,dat_cycle_0)
dat_cycle$kind <- "edge"
dat_intac <- rbind(dat_cycle,dat_intac)
dat_intac$y <- -dat_intac$y

error_rate = mean(location_error)
error_rate = round(error_rate,4)

title = paste0("click_Sp",Sp)
png(paste0("4_results/interaction_feature/click/","overlook_",title,".png"),width = 2000,height = 2000,res = 300)
ggplot(dat_intac,aes(x=x,y=y,group=no)) +
        geom_line(size = 0.2) +
        theme(panel.grid.minor.x=element_blank(),
              panel.grid.major.x=element_blank(),
              panel.grid.minor.y=element_blank(),
              panel.grid.major.y=element_blank()) +
        #ggtitle(" ")
        ggtitle(paste0(title,", Error touch rate: ",paste(error_rate*100, sep='', "%")))
dev.off()