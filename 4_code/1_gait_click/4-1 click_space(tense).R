click_space <- function(Sp,threshold){
        library(data.table)
        WORK_DICTIONARY = '/Users/fanvincentmo/Documents/master_thesis'
        setwd(WORK_DICTIONARY)
        source('4_code/1_gait_click/3-1 read_click_data.R')
        source('4_code/function_summarySE.R')
        
        #Sp=1
        clickALL <- read_click_data(Sp, threshold)
        
        ###########################
        # proprecess data
        clickALL_std <- clickALL[clickALL$kind == 'std',]
        clickALL_lef <- clickALL[clickALL$kind == 'lef',]
        for(i in 1:nrow(clickALL_std)){
                index_no = which(clickALL_lef$no == clickALL_std$no[i])
                clickALL_std$x_ = clickALL_lef$x
                clickALL_std$y_ = clickALL_lef$y
        }
        clickALL_com <- clickALL_std[,-4]
        
        clickALL_com$xy = paste0(clickALL_com$x,',',clickALL_com$y)
        mean_x <- summarySE(clickALL_com, measurevar = 'x_', groupvars = 'xy')
        mean_y <- summarySE(clickALL_com, measurevar = 'y_', groupvars = 'xy')
        data_xy <- cbind(mean_x,mean_y)
        vec = c(4,5,7,8,10,11)
        data_xy <- data_xy[,-vec]
        
        xysplit <- strsplit(data_xy$xy,',')
        for(i in 1:length(xysplit)){
                data_xy$x[i] <- xysplit[[i]][1]
                data_xy$y[i] <- xysplit[[i]][2]
        }
        names(data_xy) <- c('mark','n','x_','xci','y_','yci','x','y')
        data_xy$mark <- 1:nrow(data_xy)
        
        data_xy <- data_xy[data_xy$n >= 10,] # fliter points
        
        ####################################
        # data offset point
        dat <- data_xy[,-c(1,2,4,6)]
        dat$x <- as.numeric(dat$x); dat$y <- as.numeric(dat$y)
        
        dx = dat$x_ - dat$x
        dy = dat$y_ - dat$y
        dat$mean_wind <- sqrt(dx^2 + dy^2)

        for(i in 1:nrow(dat)){
                if(dx[i] >= 0){ 
                        dat$wind_dir[i] <- atan(dy[i]/dx[i])
                }else{
                        dat$wind_dir[i] <- atan(dy[i]/dx[i]) + pi
                }
        }
        
        #if(dx >= 0 & dy >= 0){ dat$wind_dir <- atan(dy/dx)
        #}else if(dx < 0 & dy > 0){ dat$wind_dir <- atan(dy/dx) + pi
        #}else if(dx < 0 & dy < 0){ dat$wind_dir <- atan(dy/dx) + pi
        #}else if(dx > 0 & dy < 0){ }
        
        dat = dat[,-c(1,2)]
        names(dat) <- c('Lon','Lat','mean_wind','wind_dir')
        
        return(dat)
}
