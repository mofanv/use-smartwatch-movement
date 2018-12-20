library(data.table)
WORK_DICTIONARY = '/Users/mofan/Documents/master_thesis'
setwd(WORK_DICTIONARY)
source('4_code/1_gait_click/3-1 read_click_data.R')
source('4_code/function_summarySE.R')

d = 0.75
rpx = 360*(d/2)/3.4798
threshold = rpx^2

for(Sp in 1:5){
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
        dataSTD = data.frame(x = data_xy$x, y = data_xy$y, no = data_xy$mark+10000, kind ='std')
        dataLEF = data.frame(x = data_xy$x_, y = data_xy$y_, no = data_xy$mark+10000, kind ='lef')
        dataSTD$x <- as.numeric(as.character(dataSTD$x))
        dataSTD$y <- as.numeric(as.character(dataSTD$y))
        dataOFF <- rbind(dataSTD, dataLEF)
        nlinetype = nrow(dataOFF)/2
        
        ###########################
        # data ci point
        dataLEF = data.frame(x = data_xy$x_, y = data_xy$y_, no = data_xy$mark+20000, kind ='lef')
        dataX_nci = data.frame(x = data_xy$x_-data_xy$xci, y = data_xy$y_, no = data_xy$mark+20000, kind ='xnci')
        dataX_pci = data.frame(x = data_xy$x_+data_xy$xci, y = data_xy$y_, no = data_xy$mark+20000, kind ='xpci')
        dataX_ci <- rbind(dataX_nci, dataX_pci)
        
        dataY_nci = data.frame(x = data_xy$x_, y = data_xy$y_-data_xy$yci, no = data_xy$mark+30000, kind ='ynci')
        dataY_pci = data.frame(x = data_xy$x_, y = data_xy$y_+data_xy$yci, no = data_xy$mark+30000, kind ='ypci')
        dataY_ci <- rbind(dataY_nci, dataY_pci)
        
        data_point = data.frame(x = data_xy$x, y = data_xy$y, no = data_xy$mark+50000, kind ='point')
        data_point$x <- as.numeric(as.character(data_point$x))
        data_point$y <- as.numeric(as.character(data_point$y))
        data_point <- rbind(data_point,data_point)
        
        #######################
        # circle and plot
        library(ggplot2)
        library(tidyr)
        
        dat_intac <- rbind(rbind(dataOFF,rbind(dataX_ci,dataY_ci)),data_point)
        
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
        dat_intac$no <- as.factor(dat_intac$no)
        
        vec_linetype <- c(rep("dotdash",time=100), rep("solid",time=nlinetype), rep("solid",time=nlinetype*2), rep("blank",time=nlinetype))
        vec_size <- c(rep(0.3,time=100), rep(0.8,time=nlinetype), rep(0.5,time=nlinetype*2), rep(0,time=nlinetype))
        vec_colour <- c(rep('black',time=100), rep('black',time=nlinetype), rep('purple',time=nlinetype*2), rep('yellow',time=nlinetype))
        #vec_shape <- c(rep('.',time=100), rep('.',time=nlinetype), rep('.',time=nlinetype*2), rep('o',time=nlinetype))
        
        str0 = c('Stand','Strolling','Walking','Rushing','Jogging')
        title = paste0(str0[Sp])

        p <- ggplot(dat_intac,aes(x=x,y=y,group=no)) +
                geom_line(aes(linetype = no, size = no, colour = no)) +
                scale_linetype_manual(values=vec_linetype) +
                scale_size_manual(values=vec_size) +
                scale_colour_manual(values=vec_colour) +
                #geom_point(aes(shape = no),size=4) +
                #scale_shape_manual(values=vec_shape) +
                theme(panel.grid.minor.x=element_blank(),
                      panel.grid.major.x=element_blank(),
                      panel.grid.minor.y=element_blank(),
                      panel.grid.major.y=element_blank(),
                      legend.position="none") +
                #ggtitle(" ")
                ggtitle(paste0(title))
        png(paste0("4_results/interaction_feature/space/","touch_space_",title,".png"),width = 2000,height = 1950,res = 300)
        print(p)
        dev.off()
}
