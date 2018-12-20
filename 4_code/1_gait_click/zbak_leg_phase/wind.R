WORK_DICTIONARY = '/Users/mofan/Documents/master_thesis'
source('4_code/1_gait_click/4 click_space(tense).R')
dat = click_space(1)

wind.dt<-structure(list(Lon = dat$Lon,
                        Lat = dat$Lat,
                        mean_wind = dat$mean_wind,
                        wind_dir = dat$wind_dir),
                        row.names = c(NA, -36L), 
                        .Names = c("Lon", "Lat", "mean_wind", "wind_dir"), 
                        class = c("tbl_df", "tbl", "data.frame"))

library(ggplot2)

ggplot(wind.dt, 
       aes(x = Lon, 
           y = -Lat, 
           fill = mean_wind, 
           angle = -wind_dir, 
           radius = mean_wind)) +
        geom_raster() +
        geom_spoke(arrow = arrow(length = unit(.05, 'inches'))) + 
        scale_fill_distiller(palette = "RdYlGn") 
        #coord_equal(expand = 0) + 
        #theme(legend.position = 'bottom', 
        #      legend.direction = 'horizontal')
