data_interaction_function <- function(NAME_FILE_SCREEN, threshold){
        # load the file 'interaction with screen'
        NAME_FILE_SCREEN <- NAME_FILE_SCREEN
        #NAME_FILE_SCREEN <- 'No1_Sp0_click.txt'
        FILE_DICT_SCREEN <- paste0(WORK_DICTIONARY, sep='/',paste0("4_data/aaa_data_324/click/",NAME_FILE_SCREEN))
        dat_intac <- read.csv(FILE_DICT_SCREEN,header = FALSE)[-1,]
        dat_intac0 <- dat_intac
        names(dat_intac) <- c('event','stdx','stdy','prex','prey','pret','lefx','lefy','left','watcht','phonet')
        dat_intac$event <- as.character(dat_intac$event)
        indx <- sapply(dat_intac,is.factor)
        dat_intac[indx] <- lapply(dat_intac[indx], function(x) as.numeric(as.character(x)))
        
        #############################################
        # delete error touch
        location_error <- c()
        for(i in 1:nrow(dat_intac)){
                if((dat_intac$stdx[i]-dat_intac$lefx[i])^2 + (dat_intac$stdy[i]-dat_intac$lefy[i])^2 > threshold){
                        location_error <- c(location_error,i)
                }
        }
        if(length(location_error)>0){dat_intac <- dat_intac[-location_error,]}
        #############################################
        
        # calculate feature
        source("4_code/interaction_feature/1-2-1 calculate_feature.R")
        dat_feature <- intac_feature_function(dat_intac,NAME_FILE_SCREEN)
        
        # explore the data of sensor
        #library(ggplot2)
        #ggplot(data=dat_sensor[,], aes(x=inters,y=angz)) +
        #        geom_line()
        
        # explore the data of interaction
        library(ggplot2)
        library(tidyr)
        dat_intac$no <- c(1:nrow(dat_intac))
        #dat_intac_min <- data.frame(no=dat_intac$no, stdx=dat_intac$stdx, stdy=dat_intac$stdy, 
        #                            lefx=dat_intac$lefx, lefy=dat_intac$lefy)
        dat_intac_min <- rbind(data.frame(no=dat_intac$no, x=dat_intac$stdx, y=dat_intac$stdy, kind="std"),
                               data.frame(no=dat_intac$no, x=dat_intac$lefx, y=dat_intac$lefy, kind="lef"))

        if(length(which(dat_intac_min$x==0))>0){
                dat_intac_min<-dat_intac_min[-which(dat_intac_min$x==0),]
        }
        
        dat_feature[length(dat_feature) + 1] <- length(location_error)/nrow(dat_intac0)

        return(list(dat_intac_min,length(location_error)/nrow(dat_intac0),dat_feature))
        ggplot(dat_intac_min,aes(x=x,y=y,group=no)) +
                geom_line()
        #dev.off()
}

