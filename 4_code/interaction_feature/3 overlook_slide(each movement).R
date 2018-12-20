options(digits.secs=3, digits=13)
library(data.table)
library(plotrix)
WORK_DICTIONARY <- "/Users/mofan/Documents/master_thesis"
setwd(WORK_DICTIONARY)

source("4_code/interaction_feature/3-1 read_slide_data.R")
source("4_code/interaction_feature/3-2 clean_slide_data(cor_time).R")
source("4_code/interaction_feature/3-3 visualization_slide.R")
source('4_code/function_summarySE.R')

direction = "left" #right
threshold = c(100,60)

for(Sp in 1:5){
        TXT_FILE_NAME <- read_intac(Sp)
        dat_intac_min <- vector("list", 3)
        time_slide <- vector("list", 3)
        feature_slide <- vector("list", 3)
        
        for(i in 1:length(TXT_FILE_NAME)){
                temp_cleaned = clean_data_function(TXT_FILE_NAME[i],threshold)
                dat_intac_min[[i]] = temp_cleaned[[1]]
                feature_slide[[i]] = temp_cleaned[[3]]
        }
        
        dat_intac <- data.frame()
        dat_feature <- data.frame()
        for(i in 1:length(TXT_FILE_NAME)){
                dat_intac_min[[i]]$no = 10000*i + dat_intac_min[[i]]$no
                dat_intac <- rbind(dat_intac, dat_intac_min[[i]])
                
                feature_slide[[i]]$noperson = i
                feature_slide[[i]]$noslide = 1:nrow(feature_slide[[i]])
                dat_feature <- rbind(dat_feature, feature_slide[[i]])
        }
        
        dat_intac$varX <- as.numeric(as.character(dat_intac$varX))
        dat_intac$varY <- as.numeric(as.character(dat_intac$varY))
        names(dat_intac) = c("x","y","no","mark")
        
        #calculate error rate
        dat_temp = data.frame(mark = dat_feature$mark, noperson = dat_feature$noperson)
        dat_temp$mark[(dat_temp$mark == 2)] = 1
        dat_temp$mark = (dat_temp$mark - 1)*(-1)
        dat_temp <- summarySE(dat_temp, measurevar = 'mark', groupvars = 'noperson')
        dat_temp <- dat_temp[,1:3]
        #write.csv(dat_temp, paste0("4_results/interaction_feature/slide/Csv_feature/","error_rate_Sp",Sp,".csv"))
        #
        
        title = paste0("slide_Sp", Sp, "_", direction)
        if(direction == "left"){ dat_feature_dr = dat_feature[grep(1,dat_feature$mark),]}
        if(direction == "right"){ dat_feature_dr = dat_feature[grep(2,dat_feature$mark),]}
        dat_feature_dr0 <- dat_feature_dr[,-c(13,14)]
        #write.csv(dat_feature_dr0, paste0("4_results/interaction_feature/slide/Csv_feature/","feature_",title,".csv"))
        write.csv(dat_feature_dr, paste0("4_results/interaction_feature/slide/Csv_feature/","featureEND_",title,".csv"))
        
        #write.csv(dat_intac, paste0("4_results/interaction_feature/slide/Csv_000_dataintac/Sp",Sp,".csv"))
        # draw
        p <- visualization(dat_intac, Sp, direction)
        title = paste0(direction,"_slide_Sp", Sp)
        #png(paste0("4_results/interaction_feature/slide/Fig_overlook/", title, ".png"), width = 2000, height = 2000, res = 300)
        #print(p)
        #dev.off()
}