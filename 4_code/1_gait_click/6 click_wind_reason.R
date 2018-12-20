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


track1 = 10#10
track2 = 8#8
track3 = 30#30

#############################################
# influence of fat finger
Sp = 1
#data0 = click_space(Sp, threshold)
data0$mean_wind = track1
data0$wind_dir = pi/6

tenseDATA = tense_data(data0)
tenseDATA = tense_data_more(tenseDATA)
dat = tense_data_more2(tenseDATA)
dat1 = dat


#############################################
# influence of screen edge (visual impact)
# center : 180 lon; 181.5 lat
pi = 3.1415926

centerLon = 180
centerLat = 181.5
distanceCen = sqrt((dat$Lon - centerLon)^2 + (dat$Lat-centerLat)^2)
angleCen=c(1:length(dat$Lon))
for (i in 1:length(dat$Lon)) {
        if(dat$Lon[i]-centerLon < 0){ # 2
                angleCen[i] = atan((dat$Lat[i]-centerLat)/(dat$Lon[i]-centerLon)) + pi
        }else{angleCen[i] = atan((dat$Lat[i]-centerLat)/(dat$Lon[i]-centerLon))}
}

angleCen[which(is.nan(angleCen))] = 0
dat2 = dat
dat2$mean_wind = track2 * log(((distanceCen/max(distanceCen))*(2*exp(1)-1) + 1))
dat2$wind_dir = angleCen

exp((distanceCen - max(distanceCen))*1.2*exp(1)/max(distanceCen))


#############################################
# influence of screen edge (real edge impact)
# center : 180 lon; 181.5 lat
dat3 = dat
dat3$mean_wind = 0
dat3$wind_dir = 0
distanceCen = sqrt((dat3$Lon-centerLon)^2 + (dat3$Lat-centerLat)^2)
for (i in 1:length(dat3$Lon)) {
        if(distanceCen[i] >40){
                dat3$mean_wind[i] =  track3 * exp((distanceCen[i] - max(distanceCen))*1.2*exp(1)/max(distanceCen))
                if(dat3$Lon[i]-centerLon >= 0){ # 2
                        dat3$wind_dir[i] = atan((dat3$Lat[i]-centerLat)/(dat3$Lon[i]-centerLon)) + pi
                }else{dat3$wind_dir[i] = atan((dat3$Lat[i]-centerLat)/(dat3$Lon[i]-centerLon))}
        }
        if(dat3$Lon[i] > 250 && dat3$Lat[i] > 100){
                dat3$mean_wind[i] = dat3$mean_wind[i] * 1.2
        }
        if(dat3$Lon[i] > 250 && dat3$Lat[i] > 250){
                dat3$mean_wind[i] = dat3$mean_wind[i] * 1.2
        }
}



#############################################
# conbine

dat1_x = dat1$mean_wind * cos(dat1$wind_dir)
dat1_y = dat1$mean_wind * sin(dat1$wind_dir)
dat2_x = dat2$mean_wind * cos(dat2$wind_dir)
dat2_y = dat2$mean_wind * sin(dat2$wind_dir)
dat3_x = dat3$mean_wind * cos(dat3$wind_dir)
dat3_y = dat3$mean_wind * sin(dat3$wind_dir)

dat_x = dat1_x + dat2_x + dat3_x
dat_y = dat1_y + dat2_y + dat3_y
dat$mean_wind = sqrt(dat_x^2 + dat_y^2)

for(i in 1:length(dat_x)){
        if(dat_x[i] < 0){ # 2
                dat$wind_dir[i] = atan(dat_y[i]/dat_x[i]) + pi
        }else{dat$wind_dir[i] = atan(dat_y[i]/dat_x[i])}
}


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
                y = -Lat,  # -Lat
                fill = mean_wind, 
                angle = -wind_dir,  # -wind_dir
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
p


png(paste0("4_results/interaction_feature/space/","touch_wind_reason",Sp,".png"),width = 2000,height = 1950,res = 300)
print(p)
dev.off()
#pALL[[Sp]] = p


#source('4_code/multiplot_function.R')
#png(paste0("4_results/interaction_feature/space/","touch_wind_ALL",".png"),width = 10000,height = 1950,res = 300)
#print(multiplot(pALL[[1]], pALL[[2]], pALL[[3]], pALL[[4]], pALL[[5]], cols=5))
#dev.off()
