WORK_DICTIONARY = '/Users/fanvincentmo/Documents/master_thesis'
setwd(WORK_DICTIONARY)
source('4_code/1_gait_click/4-1 click_space(tense).R')
source('4_code/1_gait_click/4-2 tense_data.R')
source('4_code/1_gait_click/4-3 tense_data_more.R')
source('4_code/1_gait_click/4-4 tense_data_more2.R')

library(ggplot2)
library(tidyr)

largestBase = 0
pALL = list()
temp = matrix(nrow=240, ncol=5)

#threshold = 1300
d = 1.5
rpx = 360*(d/2)/3.4798
threshold = rpx^2

for(Sp in 1:5){
        data0 = click_space(Sp, threshold)
        tenseDATA = tense_data(data0)
        tenseDATA = tense_data_more(tenseDATA)
        dat = tense_data_more2(tenseDATA)
        #if(Sp == 1){
        #        largestBase = max(dat$mean_wind)
        #}else{
        #        largest = dat$mean_wind[which(dat$mean_wind == max(dat$mean_wind))] # normalization
        #        dat$mean_wind = (largestBase/largest) * dat$mean_wind
        #}
        #dat = data0
        temp[,Sp] = sort(dat$mean_wind)
        
        wind.dt<-structure(list(Lon = dat$Lon,
                                Lat = dat$Lat,
                                mean_wind = dat$mean_wind,
                                wind_dir = dat$wind_dir),
                           row.names = c(NA, -nrow(dat)),
                           .Names = c("Lon", "Lat", "mean_wind", "wind_dir"),
                           class = c("tbl_df", "tbl", "data.frame"))
        
        str0 = c('Stand','Strolling','Walking','Rushing','Jogging')
        title = paste0(str0[Sp])
        
        p <- ggplot(wind.dt, 
                    aes(x = Lon, 
                        y = -Lat, 
                        fill = mean_wind, 
                        angle = -wind_dir, 
                        radius = mean_wind)) +
                geom_raster() +
                geom_spoke(arrow = arrow(length = unit(.05, 'inches'))) + 
                scale_fill_distiller(palette = "RdYlGn",name='Offset\nDistance',limits=c(0, 25)) +
                coord_equal(expand = 0) +
                xlim(0,355) +
                ylim(-360,0) +
                #theme(legend.position = 'bottom', 
                #      legend.direction = 'horizontal') +
                ggtitle(title)
        png(paste0("4_results/interaction_feature/space/","touch_wind_Sp",Sp,".png"),width = 2000,height = 1950,res = 300)
        print(p)
        dev.off()
        pALL[[Sp]] = p
}

source('4_code/multiplot_function.R')
png(paste0("4_results/interaction_feature/space/","touch_wind_ALL",".png"),width = 10000,height = 1950,res = 300)
print(multiplot(pALL[[1]], pALL[[2]], pALL[[3]], pALL[[4]], pALL[[5]], cols=5))
dev.off()
